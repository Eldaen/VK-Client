//
//  FriendsLoader.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit.UIImage
import PromiseKit
import Foundation
import Alamofire

/// Протокол загрузки данных пользователей
protocol UserLoader: Loader {
	
	/// Загружает список друзей
	func loadFriends(completion: @escaping ([FriendsSection]) -> Void)
	
	/// Загружает все фото пользователя
	func loadUserPhotos(for id: String, completion: @escaping ([ApiImage]) -> Void)
	
	/// Запрашивает кол-во друзей пользователя
	func getFriendsCount(completion: @escaping (Int) -> Void)
}

/// Сервис для загрузки данных пользователей из сети
final class UserService: UserLoader {
	
	internal var networkManager: NetworkManager
	internal var cache: ImageCache
	internal var persistence: PersistenceManager
	
	/// Ключ для сохранения данных о просрочке в Userdefaults
	let cacheKey = "usersExpiry"
	
	required init(networkManager: NetworkManager, cache: ImageCache, persistence: PersistenceManager) {
		self.networkManager = networkManager
		self.cache = cache
		self.persistence = persistence
	}
	
	
	private var friendsArray: [UserModel]?
	
	/// Раскидываем друзей по ключам, в зависимости от первой буквы имени
	private func sortFriends(_ array: [UserModel]) -> [Character: [UserModel]] {
		
		var newArray: [Character: [UserModel]] = [:]
		for user in array {
			//проверяем, чтобы строка имени не оказалась пустой
			guard let firstChar = user.name.first else {
				continue
			}
			
			// Если секции с таким ключом нет, то создадим её
			guard var array = newArray[firstChar] else {
				let newValue = [user]
				newArray.updateValue(newValue, forKey: firstChar)
				continue
			}
			
			// Если секция нашлась, то добавим в массив ещё модель
			array.append(user)
			newArray.updateValue(array, forKey: firstChar)
		}
		return newArray
	}
	
	private func formFriendsSections(_ array: [Character: [UserModel]]) -> [FriendsSection] {
		var sectionsArray: [FriendsSection] = []
		for (key, array) in array {
			sectionsArray.append(FriendsSection(key: key, data: array))
		}
		
		//Сортируем секции по алфавиту
		sectionsArray.sort { $0 < $1 }
		
		return sectionsArray
	}
	
	private func formFriendsArray(from array: [UserModel]?) -> [FriendsSection] {
		guard let array = array else {
			return []
		}
		let sorted = sortFriends(array)
		return formFriendsSections(sorted)
	}
	
	
	/// Загружает список друзей
	func loadFriends(completion: @escaping ([FriendsSection]) -> Void) {
		if checkExpiry(key: cacheKey) {
			var friends: [UserModel] = []
			
			persistence.read(UserModel.self) { result in
				friends = Array(result)
			}
			
			if !friends.isEmpty {
				let sections = formFriendsArray(from: friends)
				completion(sections)
				return
			}
		}
		
		getUrl()
			.then(on: DispatchQueue.global(), getData(_:))
			.then(getParsedData(_:))
			.then(getFriends(_:))
			.done(on: DispatchQueue.main) { sections in
				self.setExpiry(key: self.cacheKey, time: 10 * 60)
				completion(sections)
			}.catch { error in
				print(error)
			}
	}
	
	/// Запрашивает кол-во друзей пользователя
	func getFriendsCount(completion: @escaping (Int) -> Void) {
		networkManager.request(method: .friendsGet,
							   httpMethod: .get,
							   params: [:]) { (result: Swift.Result<FriendsCountMainResponse, Error>) in
			switch result {
			case .success(let friendsResponse):
				completion(friendsResponse.response.count)
			case .failure(let error):
				debugPrint("Error: \(error.localizedDescription)")
			}
		}
	}
	
	/// Загружает все фото пользователя
	func loadUserPhotos(for id: String, completion: @escaping ([ApiImage]) -> Void) {
		let params = [
			"owner_id" : id,
			"count": "50",
		]
		networkManager.request(method: .photosGetAll,
							   httpMethod: .get,
							   params: params) { (result: Swift.Result<UserImagesMainResponse, Error>) in
			switch result {
			case .success(let imagesResponse):
				let imagesModels = imagesResponse.response.items
				completion(imagesModels)
			case .failure(_):
				break
			}
		}
	}
}

// MARK: Private methods for Promises
private extension UserService {
	
	/// Возможные ошибки в промисах загрузки друзей
	enum LoadingErrors: Error {
		case noToken
		case incorrectUrl
		case noData
		case failedToDecode
	}
	
	/// Подготавливает URL для загрузки друзей
	/// - Returns: Promise с URL для загрузки друзей текущего пользователя
	func getUrl() -> Promise<URL> {
		var queryItems = [URLQueryItem]()
		
		guard let token = Session.instance.token else {
			return Promise { resolver in
				resolver.reject(LoadingErrors.noToken)
			}
		}
		
		let params = [
			"order" : "name",
			"fields" : "photo_100",
		]
		
		// добавляем общие для всех параметры
		queryItems.append(URLQueryItem(name: "access_token", value: token))
		queryItems.append(URLQueryItem(name: "v", value: "5.131"))
		
		for (param, value) in params {
			queryItems.append(URLQueryItem(name: param, value: value))
		}
		
		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = "api.vk.com"
		urlComponents.path = "/method/friends.get"
		urlComponents.queryItems = queryItems
		
		return Promise { resolver in
			guard let url = urlComponents.url else {
				resolver.reject(LoadingErrors.incorrectUrl)
				return
			}
			resolver.fulfill(url)
		}
	}
	
	/// Загружает данные по предоставленному URL
	/// - Returns: Promise с Data
	func getData(_ url: URL) -> Promise<Data> {
		return Promise { resolver in
			URLSession.shared.dataTask(with: url) { (data, ResponseCacher, error) in
				guard let data = data else {
					resolver.reject(LoadingErrors.noData)
					return
				}
				resolver.fulfill(data)
			}.resume()
		}
	}
	
	func getParsedData(_ data: Data) -> Promise<[UserModel]> {
		
		return Promise { resolver in
			do {
				let friends = try JSONDecoder().decode(VkFriendsMainResponse.self, from: data).response.items
				resolver.fulfill(friends)
			} catch {
				resolver.reject(LoadingErrors.failedToDecode)
			}
		}
	}
	
	func getFriends(_ models: [UserModel]) -> Promise<[FriendsSection]> {
		
		// Поленился делать ещё один промис для записи в БД, пусть будет тут
		self.persistence.create(models) { _ in }
		
		return Promise { resolver in
			let sections = formFriendsArray(from: models)
			resolver.fulfill(sections)
		}
	}
}
