//
//  GroupsLoader.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit.UIImage

/// Протокол загрузки данных групп
protocol GroupsLoader: Loader {
	
	/// Загружает список групп пользователя
	func loadGroups(completion: @escaping ([GroupModel]) -> Void)
	
	/// Ищет группы, подходящие под текстовый запрос
	func searchGroups(with query: String, completion: @escaping ([GroupModel]) -> Void)
	
	/// Запрос на вступление в группу по id
	func joinGroup(id: Int, completion: @escaping (Int) -> Void)
	
	/// Запрос на вступление в группу по id
	func leaveGroup(id: Int, completion: @escaping (Int) -> Void)
}

/// Сервис загрузки данных для групп из сети
final class GroupsService: GroupsLoader {
	
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
				self?.persistence.delete(GroupModel.self) { _ in }
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
							   params: params) {[weak self] (result: Result<BoolResponse, Error>) in
			switch result {
			case .success(let response):
				
				// Нужно перекачать данные групп, сбросим кэш
				if let cacheKey = self?.cacheKey {
					self?.dropCache(key: cacheKey)
				}
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
							   params: params) { [weak self] (result: Result<BoolResponse, Error>) in
			switch result {
			case .success(let response):
				self?.persistence.delete(GroupModel.self, keyValue: "\(id)") { _ in }
				
				// Нужно перекачать данные групп, сбросим кэш
				if let cacheKey = self?.cacheKey {
					self?.dropCache(key: cacheKey)
				}
				
				completion(response.response)
			case .failure(let error):
				debugPrint("Error: \(error.localizedDescription)")
			}
		}
	}
}
