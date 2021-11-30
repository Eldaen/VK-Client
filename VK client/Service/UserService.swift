//
//  FriendsLoader.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit.UIImage

protocol UserLoader: Loader {
	func loadFriends(completion: @escaping ([FriendsSection]) -> Void)
	func loadUserPhotos(for id: String, completion: @escaping ([UserImages]) -> Void)
}


// Серивс для загрузки данных пользователей из сети
class UserService: UserLoader {
	
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
		let params = [
			"order" : "name",
			"fields" : "photo_100",
		]
		
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

		
		networkManager.request(method: .friendsGet,
							   httpMethod: .get,
							   params: params) { [weak self] (result: Result<VkFriendsMainResponse, Error>) in
			switch result {
			case .success(let friendsResponse):
				let friends = friendsResponse.response.items
				self?.persistence.create(friends) { _ in }
				
				guard let sections = self?.formFriendsArray(from: friends) else {
					return
				}
				
				// Ставим дату просрочки данных
				if let cacheKey = self?.cacheKey {
					self?.setExpiry(key: cacheKey, time: 10 * 60)
				}
				
				completion(sections)
			case .failure(let error):
				debugPrint("Error: \(error.localizedDescription)")
			}
		}
	}
	
	/// Загружает все фото пользователя
	func loadUserPhotos(for id: String, completion: @escaping ([UserImages]) -> Void) {
		let params = [
			"owner_id" : id,
			"count": "40",
		]
		networkManager.request(method: .photosGetAll,
							   httpMethod: .get,
							   params: params) { (result: Result<UserImagesMainResponse, Error>) in
			switch result {
			case .success(let imagesResponse):
				let imagesModels = imagesResponse.response.items
				completion(imagesModels)
			case .failure(_):
				break
			}
		}
	}
	
	// MARK: - Пришлось устроить дублирование кода из-за Демо режима.
	// До него всё было в экстеншне протокола Loader, но в демо не получается заменить эти функции, так что так
	
	/// Загружает картинку и возвращает её, если получилось
	func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
		guard let imageUrl = URL(string: url) else { return }
		
		// если есть в кэше, то грузить не нужно
		if let image = cache[imageUrl] {
			completion(image)
		}
		
		// Проверим наличие в файлах
		if let image = loadImageFromDiskWith(imageName: imageUrl.absoluteString) {
			completion(image)
		}
		
		// Если нигде нет, то грузим
		networkManager.loadImage(url: imageUrl) { [weak self] result in
			switch result {
			case .success(let data):
				guard let image = UIImage(data: data) else {
					return
				}
				
				// Если пришлось загружать, то добавим в кэш
				self?.cache[imageUrl] = image
				
				// И в файлы сохраним
				DispatchQueue.global(qos: .background).async {
					self?.saveImage(imageName: imageUrl.absoluteString, image: image)
				}
				
				completion(image)
			case .failure(let error):
				debugPrint("Error: \(error.localizedDescription)")
			}
		}
	}
	
	/// Вытаскивает из моделей картинок URL-ы картинок нужного размера
	func sortImage(by sizeType: Sizes.TypeEnum, from array: [UserImages]) -> [String] {
		var imageLinks: [String] = []
		
		for model in array {
			for size in model.sizes {
				if size.type == sizeType {
					imageLinks.append(size.url)
				}
			}
		}
		return imageLinks
	}
}
