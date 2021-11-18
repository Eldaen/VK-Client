//
//  GroupsLoader.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//


// Возвращаем какой-то массив данных, тут могла бы быть подгрузка из API
class GroupsService {
	
	/// Класс для отправки запросов к API
	let networkManager = NetworkManager()
	
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
}
