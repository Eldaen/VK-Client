//
//  FriendsCountResponse.swift
//  VK client
//
//  Created by Денис Сизов on 16.12.2021.
//

/// Cтруктура стандартного ответа API Вконтакте по запросу друзей
struct FriendsCountResponse: Codable {
	let count: Int
	let items: [Int]
}
