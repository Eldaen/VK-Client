//
//  FriendsProfileViewModel.swift
//  VK client
//
//  Created by Денис Сизов on 26.11.2021.
//

import UIKit.UIImage

/// Протокол вью модели для FriendsProfile
protocol FriendsProfileViewModelType {
	
	/// Модель друга, чей профиль загружаем
	var friend: UserModel { get set }
	
	/// Картинка профиля
	var profileImage: UIImage { get set }
	
	/// Ссылки на картинки пользователя
	var storedImages: [String] { get }
	
	/// Загруженные модели картинок
	var storedModels: [UserImages] { get }
	
	/// Сервис по загрузке данных пользователя
	var loader: UserLoader { get }
	
	/// Конфигурируем ячейку изображения
	func configureCell(cell: PhotoCollectionViewCell, indexPath: IndexPath)
	
	/// Загружает картинки
	func fetchPhotos(completion: @escaping () -> Void)
	
	init(friend: UserModel, loader: UserLoader, profileImage image: UIImage)
}

final class FriendsProfileViewModel: FriendsProfileViewModelType {
	var friend: UserModel
	var profileImage: UIImage
	var storedImages: [String] = []
	var storedModels: [UserImages] = []
	var loader: UserLoader
	
	init(friend: UserModel, loader: UserLoader, profileImage image: UIImage){
		self.friend = friend
		self.loader = loader
		self.profileImage = image
	}
	
	func configureCell(cell: PhotoCollectionViewCell, indexPath: IndexPath) {
		loader.loadImage(url: storedImages[indexPath.item]) { image in
			cell.configure(with: image)
		}
	}
	
	func fetchPhotos(completion: @escaping () -> Void) {
		loader.loadUserPhotos(for: String(friend.id)) { [weak self] images in
			self?.storedModels = images
			
			if let imagesLinks = self?.loader.sortImage(by: "m", from: images) {
				self?.storedImages = imagesLinks
			}
			completion()
		}
	}
}
