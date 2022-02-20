//
//  demoGroupService.swift
//  VK client
//
//  Created by Денис Сизов on 26.11.2021.
//

import UIKit.UIImage

class demoGroupService: GroupsLoader {
	
	var groups: [GroupModel] = []
	
	var networkManager: NetworkManagerInterface
	var cache: ImageCache
	var persistence: PersistenceManager
	
	required init(networkManager: NetworkManagerInterface, cache: ImageCache, persistence: PersistenceManager) {
		self.networkManager = networkManager
		self.cache = cache
		self.persistence = persistence
	}
	
	func loadGroups(completion: @escaping ([GroupModel]) -> Void) {

		// читаем файлик ./groups.json
		if let filepath = Bundle.main.path(forResource: "groups", ofType: "json") {
			do {
				let contents = try Data(contentsOf: URL(fileURLWithPath: filepath))
				let decodedData = try JSONDecoder().decode([GroupModel].self, from: contents)
				groups = decodedData
				completion(decodedData)
			} catch {
				print(error)
			}
		}
	}
	
	func searchGroups(with query: String, completion: @escaping ([GroupModel]) -> Void) {
		var filteredGroups: [GroupModel] = []

		// Если строка поиска пустая, то показываем все группы
		if query == "" {
			filteredGroups = groups
			completion(filteredGroups)
		} else {
			for group in groups {
				if group.name.lowercased().contains(query.lowercased()) {
					filteredGroups.append(group)
				}
			}
			completion(filteredGroups)
		}
	}
	
	func joinGroup(id: Int, completion: @escaping (Int) -> Void) {
		completion(1)
	}
	
	func leaveGroup(id: Int, completion: @escaping (Int) -> Void) {
		completion(1)
	}
	

	
	func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
		guard let image = UIImage(named: url) else {
			return
		}
		completion(image)
	}
	
	/// Вытаскивает из моделей картинок URL-ы картинок нужного размера
	func sortImage(by sizeType: String, from array: [ApiImage]) -> [String] {
		var imageLinks: [String] = []
		
		// выбираем из вариантов картинок картинки типа X
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
