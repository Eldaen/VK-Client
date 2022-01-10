//
//  Loader.swift
//  VK client
//
//  Created by Денис Сизов on 19.11.2021.
//

import UIKit
import CryptoKit

/// Протокол лоадера данных
protocol Loader {
	
	/// Переменная, хранящая в себе Networkmanager, он у нас один и других не будет, так что без протокола
	var networkManager: NetworkManager { get set }
	
	/// Кэш сервис
	var cache: ImageCache { get set }
	
	/// Сервис для работы с БД
	var persistence: PersistenceManager { get set }
	
	/// Загружает картинку и возвращает её, если получилось
	func loadImage(url: String, completion: @escaping (UIImage) -> Void)
	
	/// Вытаскивает из моделей картинок URL-ы картинок нужного размера
	func sortImage(by sizeType: String, from array: [ApiImage]) -> [String]
	
	init(networkManager: NetworkManager, cache: ImageCache, persistence: PersistenceManager)
}

// MARK: - Common methods
extension Loader {
	
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
	
	
	/// Загружает и возвращаетк артинку из файловой системы по имени, если нашлась
	func loadImageFromDiskWith(imageName: String) -> UIImage? {
		
		let imageName = SHA256.hash(data: Data(imageName.utf8)).description
		let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
		
		let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
		let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
		
		if let dirPath = paths.first {
			let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(imageName)
			let image = UIImage(contentsOfFile: imageUrl.path)
			return image
		}
		
		return nil
	}
	
	/// Проверяет, свежие ли данные, true - всё хорошо
	func checkExpiry(key: String) -> Bool {
		let expiryDate = UserDefaults.standard.string(forKey: key) ?? "0"
		let currentDate = String(Date.init().timeIntervalSince1970)
		
		if expiryDate > currentDate {
			return true
		} else {
			return false
		}
	}
	
	/// Записывает дату просрочки кэша
	func setExpiry(key: String, time: Double) {
		let date = (Date.init() + time).timeIntervalSince1970
		UserDefaults.standard.set(String(date), forKey: key)
	}
	
	/// Сбрасывает кэш, дата просрочки будет 0
	func dropCache(key: String) {
		UserDefaults.standard.set("0", forKey: key)
	}
	
	/// Загружает картинку и возвращает её, если получилось
	func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
		guard let imageUrl = URL(string: url) else { return }
		
		// если есть в кэше, то грузить не нужно
		if let image = cache[imageUrl] {
			completion(image)
			return
		}
		
		// Проверим наличие в файлах
		if let image = loadImageFromDiskWith(imageName: imageUrl.absoluteString) {
			completion(image)
			return
		}
		
		// Если нигде нет, то грузим
		networkManager.loadImage(url: imageUrl) { result in
			switch result {
			case .success(let data):
				guard let image = UIImage(data: data) else {
					return
				}
				
				// Если пришлось загружать, то добавим в кэш
				cache[imageUrl] = image
				
				// И в файлы сохраним
				DispatchQueue.global(qos: .background).async {
					saveImage(imageName: imageUrl.absoluteString, image: image)
				}
				
				completion(image)
			case .failure(let error):
				debugPrint("Error: \(error.localizedDescription)")
			}
		}
	}
	
	/// Вытаскивает из моделей картинок URL-ы картинок нужного размера
	func sortImage(by sizeType: String, from array: [ApiImage]) -> [String] {
		var imageLinks: [String] = []
		
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
