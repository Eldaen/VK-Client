//
//  LikesModel.swift
//  VK client
//
//  Created by Денис Сизов on 09.12.2021.
//

/// Модель для получения ответа из АПИ про лайки
struct LikesModel: Codable {
	let canLike, count, userLikes, canPublish: Int

	enum CodingKeys: String, CodingKey {
		case canLike = "can_like"
		case count
		case userLikes = "user_likes"
		case canPublish = "can_publish"
	}
}
