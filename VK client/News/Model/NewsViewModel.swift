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
	
	/// Дата последней новости
	var lastDate: Double? { get }
	
	/// Конфигурирует ячейку новости данными, которые получили из сервиса
	func configureCell(cell: UITableViewCell, index: Int, type: NewsController.NewsCells)
	
	/// Скачиваем из сети список новостей для пользователя
	func fetchNews(refresh: Bool, completion: @escaping (_ indexSet: IndexSet?) -> Void)
	
	/// Ставит лайк текущей новости
	func setLike(post postId: Int, owner ownerId: Int, completion: @escaping (Int) -> Void)
	
	/// Отменяет лайк текущей новости
	func removeLike(post postId: Int, owner ownerId: Int, completion: @escaping (Int) -> Void)
}

/// ВьюМодель новости, заполняет ячейки данными и получает их от менеджера
final class NewsViewModel: NewsViewModelType {

	var news: [NewsTableViewCellModelType] = []
	var loader: NewsLoader
	var lastDate: Double?
	
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
		case .link:
			guard let linkCell = cell as? NewsLinkCellType else { return }
			linkCell.configure(with: news[index])
		}
	}
	
	func fetchNews(refresh: Bool, completion: @escaping (_ indexSet: IndexSet?) -> Void) {
		if refresh {
			lastDate = news.first?.date
		} else {
			lastDate = nil
		}
		loader.loadNews(startTime: lastDate) { [weak self] news in
			if refresh {
				if let newsCount = self?.news.count {
					self?.news.insert(contentsOf: news, at: 0)
					
					let indexSet = IndexSet(integersIn: newsCount..<newsCount + news.count)
					completion(indexSet)
					return
				}
			} else {
				self?.news = news
			}
			completion(nil)
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
