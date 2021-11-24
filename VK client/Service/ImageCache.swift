//
//  ImageCache.swift
//  VK client
//
//  Created by Денис Сизов on 24.11.2021.
//

import UIKit

/// Протокол для класса, который будет кэшировать изображения по URL
protocol ImageCache: AnyObject {
	
	/// Возвращает изображение по URL
	func getImage(for url: URL) -> UIImage?
	
	/// Cохраняет изображение по URL
	func saveImage(_ image: UIImage?, for url: URL)
	
	/// Удаляет изображение из кэша
	func deleteImage(for url: URL)
	
	/// Чистит кэш
	func сlearCache()
	
	// Пусть будет сабскрипт для доступа, хочется попробовать
	subscript(_ url: URL) -> UIImage? { get set }
}

/// Класс для кэширования изображений после загрузки
final class ImageCacheService {
	
	/// Объект NSCache для хранения изображений, в стандартных настройках будет хранить до 40 картинок
	private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
		let cache = NSCache<AnyObject, AnyObject>()
		cache.countLimit = countLimit
		return cache
	}()
	
	/// Максимальное кол-во хранимых изображений, в стандартных настройках - 40
	let countLimit: Int

	init(countLimit: Int = 40) {
		self.countLimit = countLimit
	}
}

//MARK: - ImageCache
extension ImageCacheService: ImageCache {
	
	func getImage(for url: URL) -> UIImage? {
		if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
			return image
		} else {
			return nil
		}
	}
	
	func saveImage(_ image: UIImage?, for url: URL) {
		guard let image = image else {
			return deleteImage(for: url)
		}
		
		imageCache.setObject(image as AnyObject, forKey: url as AnyObject)
	}
	
	func deleteImage(for url: URL) {
		imageCache.removeObject(forKey: url as AnyObject)
	}
	
	func сlearCache() {
		imageCache.removeAllObjects()
	}
	
	subscript(_ url: URL) -> UIImage? {
		get {
			return getImage(for: url)
		}
		set {
			return saveImage(newValue, for: url)
		}
	}
}
