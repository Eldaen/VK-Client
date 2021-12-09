//
//  NewsLoader.swift
//  VK-Client
//
//  Created by Денис Сизов on 23.10.2021.
//

import UIKit

/// Протокол загрузки данных новостей
protocol NewsLoader: Loader {
	
	/// Загружает список групп пользователя
	func loadNews(completion: @escaping ([NewsTableViewCellModel]) -> Void)
	
}

/// Сервис по загрузке данных новостей из сети
final class NewsService: NewsLoader {
	
	var networkManager: NetworkManager
	var cache: ImageCache
	var persistence: PersistenceManager
	
	init(networkManager: NetworkManager, cache: ImageCache, persistence: PersistenceManager) {
		self.networkManager = networkManager
		self.cache = cache
		self.persistence = persistence
	}
	
	func loadNews(completion: @escaping ([NewsTableViewCellModel]) -> Void) {
		let params = [
			"filters" : "posts",
			"return_banned" : "0",
			"max_photos" : "4",
		]
		
		networkManager.request(method: .newsGet,
							   httpMethod: .get,
							   params: params) { [weak self] (result: Result<NewsMainResponse, Error>) in
			switch result {
			case .success(let newsResponse):
				if let news = self?.configureAnswer(newsResponse) {
					completion(news)
				}
			case .failure(let error):
				debugPrint("Error: \(error.localizedDescription)")
			}
		}
	}
	
	// MARK: - Пришлось устроить дублирование кода из-за Демо режима.
	// До него всё было в экстеншне протокола Loader, но в демо не получается заменить эти функции, так что так
	
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
		networkManager.loadImage(url: imageUrl) { [weak self] result in
			switch result {
			case .success(let data):
				guard let image = UIImage(data: data) else {
					return
				}
				
				// Если пришлось загружать, то добавим в кэш
				self?.cache[imageUrl] = image
				
				// И в файлы сохраним
				DispatchQueue.global(qos: .background).async {
					self?.saveImage(imageName: imageUrl.absoluteString, image: image)
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
		
	mainLoop: for model in array {
			let types = ["z", "k", "l", "x", "m"]
			
			for size in model.sizes {
				if size.type == sizeType {
					imageLinks.append(size.url)
					break mainLoop
				}
			}
			
		outerLoop: for type in types {
			for size in model.sizes {
				if size.type == type {
					imageLinks.append(size.url)
					break outerLoop
				}
			}
		}
		}
		
		return imageLinks
	}
}

// MARK: - Private methods

private extension NewsService {
	
	/// Cобирает ответ сервера в массив нужных моделей
	/// - Returns: Массив моделей ячеек таблицы новостей
	func configureAnswer(_ newsResponse: NewsMainResponse) -> [NewsTableViewCellModel] {
		let items = newsResponse.response.items
		let groups = newsResponse.response.groups
		let users = newsResponse.response.profiles
		var news: [NewsTableViewCellModel] = []
		var source: NewsSourceProtocol = UserModel()
		
		for post in items {
			if post.postType == nil {
				continue
			}
			
			let date = Date(timeIntervalSince1970: Double(post.date))
			let sourceID = post.sourceID
			let text = post.text
			
			// Выясняем, от группы или от пользователя новость
			if sourceID < 0 {
				for group in groups {
					if group.id == sourceID.magnitude {
						source = group
					}
				}
			} else {
				for user in users {
					if user.id == sourceID {
						source = user
					}
				}
			}
			
			// Вытаскиваем нужные картинки
			var imageLinksArray: [String]? = []
			
			// Если есть фото, то нам нужны фото
			if let images = post.photos?.items {
				imageLinksArray = sortImage(by: "z", from: images)
			}
			
			// Если есть прикреплённые фото, то их тоже достанем
			if let attachments = post.attachments {
				var images = [ApiImage]()
				
				for attachment in attachments {
					if let image = attachment.photo {
						images.append(image)
					}
					
					if let link = attachment.link {
						if let photo = link.photo {
							images.append(photo)
						}
					}
				}
			
				imageLinksArray = sortImage(by: "z", from: images)
			}
			
			let newsModel = NewsTableViewCellModel(
				source: source,
				postDate: date.description,
				postText: text ?? "",
				newsImageNames: imageLinksArray ?? [],
				likesModel: post.likes
			)
			news.append(newsModel)
		}
		return news
	}
}

