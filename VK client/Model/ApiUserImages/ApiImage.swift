//
//  ApiImage.swift
//  VK client
//
//  Created by Денис Сизов on 19.11.2021.
//

/// Модель картинки пользователя
struct ApiImage: Codable {
	let sizes: [Sizes]
}
