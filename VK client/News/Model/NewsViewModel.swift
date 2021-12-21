//
//  NewsViewModel.swift
//  VK client
//
//  Created by Денис Сизов on 25.11.2021.
//

import UIKit

/// Протокол ViewModel для контроллера новостей
protocol NewsViewModelType {
	
	/// Массив моделей ячейки новостей
	var news: [NewsTableViewCellModelType] { get }
	
	/// Источник данных для отображения новостей
	var loader: NewsLoader { get }
	
	/// Конфигурирует ячейку новости данными, которые получили из сервиса
	func configureCell(cell: UITableViewCell, index: Int, type: NewsController.NewsCells)
	
	/// Скачиваем из сети список новостей для пользователя
	func fetchNews(completion: @escaping () -> Void)
	
	/// Ставит лайк текущей новости
	func setLike(post postId: Int, owner ownerId: Int, completion: @escaping (Int) -> Void)
	
	/// Отменяет лайк текущей новости
	func removeLike(post postId: Int, owner ownerId: Int, completion: @escaping (Int) -> Void)
}

/// ВьюМодель новости, заполняет ячейки данными и получает их от менеджера
final class NewsViewModel: NewsViewModelType {

	var news: [NewsTableViewCellModelType] = []
	var loader: NewsLoader
	
	init(loader: NewsLoader){
		self.loader = loader
	}
	
	func configureCell(cell: UITableViewCell, index: Int, type: NewsController.NewsCells) {
		
		switch type {
		case .author:
			guard let authorCell = cell as? NewsAuthorCellType else { return }
			authorCell.configure(with: news[index])
			
			loadPorfileImage(profile: news[index].source) { image in
				authorCell.updateProfileImage(with: image)
			}
		case .text:
			guard let textCell = cell as? NewsTextCellType else { return }
			textCell.configure(with: news[index])
		case .collection:
			guard let collectionCell = cell as? NewCollectionCellType else { return }
			collectionCell.configure(with: news[index])
			
			loadImages(array: news[index].newsImageModels) { images in
				collectionCell.updateCollection(with: images)
			}
		case .footer:
			guard var footerCell = cell as? NewsFooterCellType else { return }
			footerCell.configure(with: news[index])
			footerCell.likesResponder = self
		}
	}
	
	func fetchNews(completion: @escaping () -> Void) {
		loader.loadNews { [weak self] news in
			self?.news = news
			completion()
		}
	}
	
	func loadImages(array: [Sizes], completion: @escaping ([UIImage]) -> Void) {
		var images = [UIImage]()
		let imageGroup = DispatchGroup()
		
		// Создаём группу по загрузке всех картинок новости
		DispatchQueue.global().async(group: imageGroup) { [weak self] in
			for imageName in array {
				imageGroup.enter()
				self?.loader.loadImage(url: imageName.url) { image in
					images.append(image)
					imageGroup.leave()
				}
			}
		}
		
		imageGroup.notify(queue: DispatchQueue.main) {
			completion(images)
		}
	}
	
	/// Загружает картинку профиля создателя новости
	func loadPorfileImage(profile: NewsSourceProtocol, completion: @escaping (UIImage) -> Void) {
		let url = profile.image
		
		loader.loadImage(url: url) { image in
			completion(image)
		}
	}
	
	/// Отправляет запрос на лайк
	func setLike(post postId: Int, owner ownerId: Int, completion: @escaping (Int) -> Void) {
		loader.setLike(for: postId, owner: ownerId) { result in
			completion(result)
		}
	}
	
	/// Отправляет запрос на отмену лайка
	func removeLike(post postId: Int, owner ownerId: Int, completion: @escaping (Int) -> Void) {
		loader.removeLike(for: postId, owner: ownerId) { result in
			completion(result)
		}
	}
}
