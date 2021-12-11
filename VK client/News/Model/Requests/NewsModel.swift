//
//  NewsModel.swift
//  VK client
//
//  Created by Денис Сизов on 09.12.2021.
//

/// Модель новости из ответа АПИ
struct NewsModel: Codable {
	let sourceID, date, postId: Int
	let postType, text: String?
	let likes: LikesModel?
	let views: Views?
	let type: String
	let photos: Photos?
	let attachments: [AttachmentsModel]?

	enum CodingKeys: String, CodingKey {
		case sourceID = "source_id"
		case date
		case postType = "post_type"
		case postId = "post_id"
		case text
		case attachments
		case likes
		case views
		case type
		case photos
	}
}

/// Модель для получения кол-ва просмотров
struct Views: Codable {
	let count: Int
}


