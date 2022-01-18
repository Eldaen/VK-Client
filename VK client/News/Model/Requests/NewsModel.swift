//
//  NewsModel.swift
//  VK client
//
//  Created by Денис Сизов on 09.12.2021.
//

/// Модель новости из ответа АПИ
struct NewsModel: Codable {
	let sourceID, date: Int
	let postId: Int?
	let postType, text: String?
	let likes: LikesModel?
	let comments: CommentsModel?
	let reposts: RepostsModel?
	let views: Views?
	let type: String
	let photos: Photos?
	let attachments: [AttachmentsModel]?
	var shortText: String? {
		get {
			guard let text = text else { return nil }
			guard text.count >= 200 else { return nil }
			
			let shortText = text.prefix(200)
			return String(shortText + "...")
		}
	}

	enum CodingKeys: String, CodingKey {
		case sourceID = "source_id"
		case date
		case postType = "post_type"
		case postId = "post_id"
		case text
		case attachments
		case likes
		case comments
		case reposts
		case views
		case type
		case photos
	}
}

/// Модель для получения кол-ва просмотров
struct Views: Codable {
	let count: Int
}

struct CommentsModel: Codable {
	let count: Int
}

struct RepostsModel: Codable {
	let count: Int
}


