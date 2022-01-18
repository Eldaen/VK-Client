//
//  demoNewsService.swift
//  VK client
//
//  Created by Денис Сизов on 09.12.2021.
//

//
//  NewsLoader.swift
//  VK-Client
//
//  Created by Денис Сизов on 23.10.2021.
//

import UIKit

// Возвращаем какой-то массив данных, тут могла бы быть подгрузка из API
final class demoNewsService: NewsLoader {
	var networkManager: NetworkManager
	var cache: ImageCache
	var persistence: PersistenceManager
	
	func setLike(for id: Int, owner: Int, completion: @escaping (Int) -> Void) {
	}
	
	func removeLike(for id: Int, owner: Int, completion: @escaping (Int) -> Void) {
	}
	
	func loadNews(startTime: Double?, startFrom: String?, completion: @escaping ([NewsTableViewCellModelType], String) -> Void) {
		if let filepath = Bundle.main.path(forResource: "news", ofType: "json") {
			do {
				let contents = try Data(contentsOf: URL(fileURLWithPath: filepath))
				let decodedData = try JSONDecoder().decode([demoNewsTableViewCellModel].self, from: contents)
				
				var news: [demoNewsTableViewCellModel] = []
				
				for data in decodedData {
					var model = data
					model.source.name = "Cизов Денис"
					model.source.image = "petia"
					news.append(model)
				}
				
				completion(news, "")
			} catch {
				print("Demo error: \(error)")
			}
		}
	}
	
	func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
		guard let image = UIImage(named: url) else {
			return
		}
		completion(image)
	}
	
	func sortImage(by sizeType: String, from array: [ApiImage]) -> [String] {
		[]
	}
	
	init(networkManager: NetworkManager, cache: ImageCache, persistence: PersistenceManager) {
		self.networkManager = networkManager
		self.cache = cache
		self.persistence = persistence
	}
}


