//
//  NewsModel.swift
//  VK client
//
//  Created by Денис Сизов on 09.12.2021.
//

/// Модель новости из ответа АПИ
struct NewsModel: Codable {
	let sourceID, date: Int
	let postType, text: String?
	let likes: LikesModel?
	let views: Views?
	let type: String
	let photos: Photos?
	let attachments: [Attachment]?

	enum CodingKeys: String, CodingKey {
		case sourceID = "source_id"
		case date
		case postType = "post_type"
		case text
		case attachments
		case likes, views
		case type
		case photos
	}
}

/// Модель для получения кол-ва просмотров
struct Views: Codable {
	let count: Int
}

/// Модель для получения описания приложения к посту
struct Attachment: Codable {
	let type: String
	let link: Link?
	let photo: UserImages?
}

/// Модель для получения данных приложения к посту типа CСЫЛКА
struct Link: Codable {
	let url: String
	let title, linkDescription: String
	let caption: String?
	let photo: UserImages?

	enum CodingKeys: String, CodingKey {
		case url, title
		case caption
		case linkDescription = "description"
		case photo
	}
}
