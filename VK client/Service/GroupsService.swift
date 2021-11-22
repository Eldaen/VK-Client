//
//  GroupsLoader.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

protocol GroupsLoader: Loader {
	func loadGroups(completion: @escaping ([GroupModel]) -> Void)
	func searchGroups(with query: String, completion: @escaping ([GroupModel]) -> Void)
	func joinGroup(id: Int, completion: @escaping (Int) -> Void)
	func leaveGroup(id: Int, completion: @escaping (Int) -> Void)
}


// Возвращаем какой-то массив данных, тут могла бы быть подгрузка из API
class GroupsService: GroupsLoader {
	
	internal var networkManager: NetworkManager
	
	required init(networkManager: NetworkManager) {
		self.networkManager = networkManager
	}
	
	/// Загружает список групп пользователя
	func loadGroups(completion: @escaping ([GroupModel]) -> Void) {
		let params = [
			"order" : "name",
			"extended" : "1",
		]
		
		networkManager.request(method: .groupsGet,
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
							   httpMethod: .get,
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
							   httpMethod: .get,
							   params: params) { (result: Result<BoolResponse, Error>) in
			switch result {
			case .success(let response):
				completion(response.response)
			case .failure(let error):
				debugPrint("Error: \(error.localizedDescription)")
			}
		}
	}
}
