//
//  Loader.swift
//  VK client
//
//  Created by Денис Сизов on 19.11.2021.
//

import UIKit

/// Протокол лоадера данных
protocol Loader {
	
	/// Переменная, хранящая в себе Networkmanager, он у нас один и других не будет, так что без протокола
	var networkManager: NetworkManager {get set}
	
	init(networkManager: NetworkManager)
}

/// Базовый класс для всех лоадеров
extension Loader {
	
	/// Загружает картинку и возвращает её, если получилось
	func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
		guard let url = URL(string: url) else { return }
		
		networkManager.loadImage(url: url) { result in
			switch result {
			case .success(let data):
				guard let image = UIImage(data: data) else {
					return
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
