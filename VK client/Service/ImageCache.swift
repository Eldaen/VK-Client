//
//  ImageCache.swift
//  VK client
//
//  Created by Денис Сизов on 24.11.2021.
//

import UIKit
import CryptoKit

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
	
	/// Время жизни картинок в кеше
	let expiryTime: TimeInterval

	init(countLimit: Int = 40, expiryTime: TimeInterval = 2 * 60 * 60) {
		self.countLimit = countLimit
		self.expiryTime = expiryTime
	}
	
	/// Загружает и возвращаетк артинку из файловой системы по имени, если нашлась
	func loadImageFromDiskWith(imageName: String) -> UIImage? {
		
		let imageName = SHA256.hash(data: Data(imageName.utf8)).description
		let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
		
		let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
		let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
		
		if let dirPath = paths.first,
		   let info = try? FileManager.default.attributesOfItem(atPath: dirPath),
		   let modificationDate = info[FileAttributeKey.modificationDate] as? Date {
			let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(imageName)
			let lifeTime = Date().timeIntervalSince(modificationDate)
			
			guard lifeTime <= expiryTime else {
				return nil
			}
			
			let image = UIImage(contentsOfFile: imageUrl.path)
			return image
		}
		
		return nil
	}
	
	/// Сохраняет картинку в файловую систему и удаляет текущую, если она есть с таким названием
	func saveImage(imageName: String, image: UIImage) {
		
		guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
		
		let fileName = SHA256.hash(data: Data(imageName.utf8)).description
		let fileURL = cachesDirectory.appendingPathComponent(fileName)
		
		guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
			return
		}
		
		//Если файл есть, то удаляем
		if FileManager.default.fileExists(atPath: fileURL.path) {
			try? FileManager.default.removeItem(atPath: fileURL.path)
		}
		
		// Пробуем записать, если не получилось, то ничего страшного
		do {
			try data.write(to: fileURL)
		} catch {
			print(error)
		}
	}
}

//MARK: - ImageCache
extension ImageCacheService: ImageCache {
	
	func getImage(for url: URL) -> UIImage? {
		if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
			return image
		} else if let image = loadImageFromDiskWith(imageName: url.absoluteString){
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
		
		DispatchQueue.global(qos: .background).async { [weak self] in
			self?.saveImage(imageName: url.absoluteString, image: image)
		}
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
