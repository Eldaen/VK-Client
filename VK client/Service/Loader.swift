//
//  Loader.swift
//  VK client
//
//  Created by Денис Сизов on 19.11.2021.
//

import UIKit

/// Базовый класс для всех лоадеров
class Loader {
	
	/// Класс для загрузки данных из сети
	let networkManager = NetworkManager()
	
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
}
