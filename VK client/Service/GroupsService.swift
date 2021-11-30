//
//  GroupsLoader.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit.UIImage

protocol GroupsLoader: Loader {
	func loadGroups(completion: @escaping ([GroupModel]) -> Void)
	func searchGroups(with query: String, completion: @escaping ([GroupModel]) -> Void)
	func joinGroup(id: Int, completion: @escaping (Int) -> Void)
	func leaveGroup(id: Int, completion: @escaping (Int) -> Void)
}


// Сервис загрузки данных для групп из сети
class GroupsService: GroupsLoader {
	
	internal var networkManager: NetworkManager
	internal var cache: ImageCache
	internal var persistence: PersistenceManager
	
	/// Ключ для сохранения данных о просрочке в Userdefaults
	let cacheKey = "groupsExpiry"
	
	required init(networkManager: NetworkManager, cache: ImageCache, persistence: PersistenceManager) {
		self.networkManager = networkManager
		self.cache = cache
		self.persistence = persistence
	}
	
	/// Загружает список групп пользователя
	func loadGroups(completion: @escaping ([GroupModel]) -> Void) {
		let params = [
			"order" : "name",
			"extended" : "1",
		]
		
		if checkExpiry(key: cacheKey) {
			var groups: [GroupModel] = []

			persistence.read(GroupModel.self) { result in
				groups = Array(result)
			}

			if !groups.isEmpty {
				completion(groups)
				return
			}
		}
		
		networkManager.request(method: .groupsGet,
							   httpMethod: .get,
							   params: params) { [weak self] (result: Result<GroupsMyMainResponse, Error>) in
			switch result {
			case .success(let groupsResponse):
				let items = groupsResponse.response.items
				self?.persistence.create(items) { _ in }
				
				// Ставим дату просрочки данных
				if let cacheKey = self?.cacheKey {
					self?.setExpiry(key: cacheKey, time: 10 * 60)
				}
				
				completion(groupsResponse.response.items)
			case .failure(let error):
				debugPrint("Error: \(error.localizedDescription)")
			}
		}
	}
	
	/// Ищет группы, подходящие под текстовый запрос
	func searchGroups(with query: String, completion: @escaping ([GroupModel]) -> Void) {
		let params = [
			"order" : "name",
			"extended" : "1",
			"q" : "\(query)",
			"count" : "40"
		]
		
		networkManager.request(method: .groupsSearch,
							   httpMethod: .get,
							   params: params) { (result: Result<GroupsMyMainResponse, Error>) in
			switch result {
			case .success(let groupsResponse):
				completion(groupsResponse.response.items)
			case .failure(let error):
				debugPrint("Error: \(error.localizedDescription)")
			}
		}
	}
	
	/// Запрос на вступление в группу по id
	func joinGroup(id: Int, completion: @escaping (Int) -> Void) {
		let params = [
			"group_id" : "\(id)",
			"extended" : "1",
		]
		
		networkManager.request(method: .groupsJoin,
							   httpMethod: .post,
							   params: params) { (result: Result<BoolResponse, Error>) in
			switch result {
			case .success(let response):
				completion(response.response)
			case .failure(let error):
				debugPrint("Error: \(error.localizedDescription)")
			}
		}
	}
	
	/// Запрос на вступление в группу по id
	func leaveGroup(id: Int, completion: @escaping (Int) -> Void) {
		let params = [
			"group_id" : "\(id)",
			"extended" : "1",
		]
		
		networkManager.request(method: .groupsLeave,
							   httpMethod: .post,
							   params: params) { (result: Result<BoolResponse, Error>) in
			switch result {
			case .success(let response):
				completion(response.response)
			case .failure(let error):
				debugPrint("Error: \(error.localizedDescription)")
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
			return
		}
		
		// Проверим наличие в файлах
		if let image = loadImageFromDiskWith(imageName: imageUrl.absoluteString) {
			completion(image)
			return
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
