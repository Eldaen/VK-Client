//
//  demoGroupService.swift
//  VK client
//
//  Created by Денис Сизов on 26.11.2021.
//

import UIKit.UIImage

class demoGroupService: GroupsLoader {
	
	var networkManager: NetworkManager
	var cache: ImageCache
	
	required init(networkManager: NetworkManager, cache: ImageCache) {
		self.networkManager = networkManager
		self.cache = cache
	}
	
	func loadGroups(completion: @escaping ([GroupModel]) -> Void) {
		
	}
	
	func searchGroups(with query: String, completion: @escaping ([GroupModel]) -> Void) {
		
	}
	
	func joinGroup(id: Int, completion: @escaping (Int) -> Void) {
		
	}
	
	func leaveGroup(id: Int, completion: @escaping (Int) -> Void) {
		
	}
	

	
	func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
		guard let image = UIImage(named: url) else {
			return
		}
		completion(image)
	}
	
	/// Вытаскивает из моделей картинок URL-ы картинок нужного размера
	func sortImage(by sizeType: Sizes.TypeEnum, from array: [UserImages]) -> [String] {
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
