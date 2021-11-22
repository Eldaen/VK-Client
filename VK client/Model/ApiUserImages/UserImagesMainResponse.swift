//
//  UserImagesMainResponse.swift
//  VK client
//
//  Created by Денис Сизов on 19.11.2021.
//

/// Входной ответ из АПИ вконтакте по запросу картинок пользователя по id
struct UserImagesMainResponse: Codable {
	var response: UserImagesResponse
}
