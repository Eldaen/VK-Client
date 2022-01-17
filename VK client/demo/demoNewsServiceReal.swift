//
//  demoNewsServiceReal.swift
//  VK client
//
//  Created by Денис Сизов on 14.01.2022.
//

import UIKit

// Сервис для загрузки новостей из JSON файла по примеру АПИ вконтакте
final class demoNewsServiceReal: NewsLoader {
	var networkManager: NetworkManager
	var cache: ImageCache
	var persistence: PersistenceManager
	
	func setLike(for id: Int, owner: Int, completion: @escaping (Int) -> Void) {
	}
	
	func removeLike(for id: Int, owner: Int, completion: @escaping (Int) -> Void) {
	}
	
	func loadNews(startTime: Double?, completion: @escaping ([NewsTableViewCellModelType]) -> Void) {
		
		if let filepath = Bundle.main.path(forResource: "realNews", ofType: "json") {
			do {
				let contents = try Data(contentsOf: URL(fileURLWithPath: filepath))
				let decodedData = try JSONDecoder().decode(NewsMainResponse.self, from: contents)
				let news = configureAnswer(decodedData)
				completion(news)
			} catch {
				print("Demo error: \(error)")
			}
		}
	}
	
	/// Загружает картинку и возвращает её, если получилось
	func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
		guard let imageUrl = URL(string: url) else { return }
		
		// если есть в кэше, то грузить не нужно
		if let image = cache[imageUrl] {
			completion(image)
			return
		}
		
		// Если нигде нет, то грузим и кешируем
		networkManager.loadImage(url: imageUrl) { [weak self] result in
			switch result {
			case .success(let data):
				guard let image = UIImage(data: data) else {
					return
				}
				
				self?.cache[imageUrl] = image
				completion(image)
			case .failure(let error):
				debugPrint("Error: \(error.localizedDescription)")
			}
		}
	}
	
	func sortImage(by sizeType: String, from array: [ApiImage]) -> [String] {
		[]
	}
	
	init(networkManager: NetworkManager, cache: ImageCache, persistence: PersistenceManager) {
		self.networkManager = networkManager
		self.cache = cache
		self.persistence = persistence
	}
}

// MARK: - Private methods
private extension demoNewsServiceReal {
	
	/// Cобирает ответ сервера в массив нужных моделей
	/// - Returns: Массив моделей ячеек таблицы новостей
	func configureAnswer(_ newsResponse: NewsMainResponse) -> [NewsTableViewCellModel] {
		let items = newsResponse.response.items
		let groups = newsResponse.response.groups
		let users = newsResponse.response.profiles
		var news: [NewsTableViewCellModel] = []
		var source: NewsSourceProtocol = UserModel()
		var link: Link? = nil
		
		for post in items {
			if post.postType == nil {
				continue
			}
			
			let date = getDate(post.date)
			let sourceId = post.sourceID
			let text = post.text
			let shortText = post.shortText
			let views = post.views
			let postId = post.postId
			
			source = getSource(groups: groups, users: users, sourceId: sourceId)
			let imageLinksArray = getImages(post: post)
			if let postLink = checkForLinks(post.attachments) {
				link = postLink
			} else {
				link = nil
			}
			 
			let newsModel = NewsTableViewCellModel(
				source: source,
				postDate: date.description,
				date: Double(post.date),
				postText: text ?? "",
				shortText: shortText,
				newsImageModels: imageLinksArray,
				postId: postId ?? 0,
				likesModel: post.likes,
				views: views,
				link: link
			)
			news.append(newsModel)
		}
		return news
	}
	
	/// Возвращаем красивую дату cтрокой из unixtime
	func getDate(_ date: Int) -> String {
		let date = Date(timeIntervalSince1970: Double(date))
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ru_RU")
		dateFormatter.timeStyle = DateFormatter.Style.short
		dateFormatter.dateStyle = DateFormatter.Style.medium
		dateFormatter.timeZone = .current
		let localDate = dateFormatter.string(from: date)
		return localDate
	}
	
	/// Возвращает модель источника новости
	func getSource(groups: [GroupModel], users: [UserModel], sourceId: Int) -> NewsSourceProtocol {
		if sourceId < 0 {
			for group in groups {
				if group.id == sourceId.magnitude || group.id == sourceId {
					let source = group
					source.id = -source.id
					return source
				}
			}
		} else {
			for user in users {
				if user.id == sourceId {
					return user
				}
			}
		}
		return UserModel()
	}
	
	/// Вытаскивает из модели нужные ссылки на картинки
	func getImages(post: NewsModel) -> [Sizes] {
		// Вытаскиваем нужные картинки
		var imageLinksArray: [Sizes]? = []
		
		// Превью, если видео
		var videoImages: [Sizes] = []
		
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
				
				if let video = attachment.video {
					if let photo = video.firstFrame?.first,
					   let photo = video.photo?.last {
						let size = Sizes(url: photo.url, type: "z", height: photo.height, width: photo.width)
						videoImages.append(size)
					}
				}
			}
			
			imageLinksArray = sortImage(by: "z", from: images)
			
			if let imagesArray = imageLinksArray {
				if imagesArray.isEmpty {
					imageLinksArray = videoImages
				}
			}
			
		}
		return imageLinksArray ?? [Sizes]()
	}
	
	/// Проверяет массив AttachmentsModel на наличие ссылок
	func checkForLinks(_ array: [AttachmentsModel]?) -> Link? {
		guard let array = array else { return nil }
		
		for attach in array {
			if let link = attach.link {
				return link
			}
		}
		
		return nil
	}
	
	/// Вытаскивает из моделей картинок URL-ы картинок нужного размера
	func sortImage(by sizeType: String, from array: [ApiImage]) -> [Sizes] {
		var sizes: [Sizes] = []
		
		for model in array {
			for size in model.sizes {
				if size.type == sizeType {
					sizes.append(size)
				}
			}
		}
		
		if sizes.isEmpty {
			let types = ["z", "k", "l", "x", "m"]
			
		outerLoop: for type in types {
			for model in array {
				for size in model.sizes {
					if size.type == type {
						sizes.append(size)
						break outerLoop
					}
				}
			}
		}
		}
		return sizes
	}
}


