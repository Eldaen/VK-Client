//
//  GalleryViewModel.swift
//  VK client
//
//  Created by Денис Сизов on 26.11.2021.
//

import UIKit.UIImage

/// Протокол вью модели для Gallery контроллера
protocol GalleryType {
	
	/// Загруженные модели картинок
	var photoModels: [ApiImage] { get }
	
	var selectedPhoto: Int { get set }
	
	/// Ссылки на картинки пользователя
	var storedImages: [String] { get }
	
	/// Массив вью для картинок
	var photoViews: [UIImageView] { get }
	
	/// Сервис по загрузке данных пользователя
	var loader: UserLoader { get }
	
	/// Загружает картинки
	func fetchPhotos(array: [Int])
	
	/// Cоздаёт массив вью картинок
	func createImageViews()
	
	/// Получает ссылки на картинки нужного размера
	func getStoredImages(size: String)
	
	init(loader: UserLoader, selectedPhoto: Int, images: [ApiImage])
}

/// Вью модель для Gallery контроллера
final class GalleryViewModel: GalleryType {
	var photoModels: [ApiImage] = []
	var storedImages: [String] = []
	var photoViews: [UIImageView] = []
	var loader: UserLoader
	var selectedPhoto: Int = 0
	
	init(loader: UserLoader, selectedPhoto: Int, images: [ApiImage]){
		self.loader = loader
		self.selectedPhoto = selectedPhoto
		self.photoModels = images
	}
	
	func fetchPhotos(array: [Int]) {
		for index in array {
			loader.loadImage(url: storedImages[index]) { [weak self] image in
				self?.photoViews[index].image = image
				self?.photoViews[index].layoutIfNeeded()
			}
		}
	}
	
	func createImageViews() {
		for _ in storedImages {
			let view = UIImageView()
			view.contentMode = .scaleAspectFit
			
			photoViews.append(view)
		}
	}
	
	func getStoredImages(size: String) {
		storedImages = loader.sortImage(by: size, from: photoModels)
	}
}
