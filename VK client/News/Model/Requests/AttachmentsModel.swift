//
//  AttachmentsModel.swift
//  VK client
//
//  Created by Денис Сизов on 10.12.2021.
//

/// Модель для получения описания приложения к посту
struct AttachmentsModel: Codable {
	let type: String
	let link: Link?
	let photo: ApiImage?
	let video: Video?
}

/// Модель для получения данных приложения к посту типа CСЫЛКА
struct Link: Codable {
	let url: String
	let title, linkDescription: String
	let caption: String?
	let photo: ApiImage?

	enum CodingKeys: String, CodingKey {
		case url, title
		case caption
		case linkDescription = "description"
		case photo
	}
}

/// Модель для доступа к приложению  к посту вида Видео
struct Video: Codable {
	let photo: [VideoPreview]?
	
	enum CodingKeys: String, CodingKey {
		case photo = "first_frame"
	}
}

/// Модель картинки превью для приложения вида Видео
struct VideoPreview: Codable {
	let url: String
}
