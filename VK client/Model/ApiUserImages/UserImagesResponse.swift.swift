//
//  UserImagesResponse.swift.swift
//  VK client
//
//  Created by Денис Сизов on 19.11.2021.
//

/// Cтруктура стандартного ответа API Вконтакте по запросу фото пользователя по id
struct UserImagesResponse: Codable {
	let count: Int
	let items: [ApiImage]
}
