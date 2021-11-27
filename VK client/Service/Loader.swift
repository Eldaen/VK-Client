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
	
	/// Кэш сервис
	var cache: ImageCache {get set}
	
	/// Загружает картинку и возвращает её, если получилось
	func loadImage(url: String, completion: @escaping (UIImage) -> Void)
	
	/// Вытаскивает из моделей картинок URL-ы картинок нужного размера
	func sortImage(by sizeType: Sizes.TypeEnum, from array: [UserImages]) -> [String]
	
	init(networkManager: NetworkManager, cache: ImageCache)
}
