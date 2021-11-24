//
//  ImageCache.swift
//  VK client
//
//  Created by Денис Сизов on 24.11.2021.
//

import UIKit

/// Протокол для класса, который будет кэшировать изображения по URL
protocol ImageCache: AnyObject {
	
	/// возарщает изображение по URL
	func getImage(for url: URL) -> UIImage?
	
	// Cохраняет изображение по URL
	func saveImage(_ image: UIImage?, for url: URL)
	
	// Удаляет изображение из кэша
	func deleteImage(for url: URL)
	
	// Чистит кэш
	func сlearCache()
	
	// Пусть будет сабскрипт для доступа, хочется попробовать
	subscript(_ url: URL) -> UIImage? { get set }
}
