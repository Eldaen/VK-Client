//
//  GroupsLoader.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//


// Возвращаем какой-то массив данных, тут могла бы быть подгрузка из API
class GroupsService: Loader {
	
    static func iNeedGroups() -> [GroupModel] {
        return [GroupModel(name: "В душе пираты", image: "pepe-pirate"),
                GroupModel(name: "Дворник это призвание", image: "pepe-yard-keeper"),
                GroupModel(name: "Лайфхаки из Тиктока", image: "pepe-dunno"),
                GroupModel(name: "Годнота", image: "pepe-like"),
        ]
    }
	
//	/// Загружает список текущих групп пользователя
//	func loadUserGroups() {
//		let params = [
//			"order" : "name",
//			"extended" : "1",
//		]
//		networkManager.request(method: .groupsGet, httpMethod: .get, params: params)
//	}
//	
//	/// Загружает группы, содержащие в имени строку query
//	func searchForGroups(by query: String) {
//		let params = [
//			"q" : query,
//		]
//		networkManager.request(method: .groupsGet, httpMethod: .get, params: params)
//	}
	
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
}
