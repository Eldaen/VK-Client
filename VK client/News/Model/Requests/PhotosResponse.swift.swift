//
//  PhotosResponse.swift.swift
//  VK client
//
//  Created by Денис Сизов on 09.12.2021.
//

/// Ответ АПИ про фото у новости
struct Photos: Codable {
	let count: Int
	let items: [UserImages]
}
