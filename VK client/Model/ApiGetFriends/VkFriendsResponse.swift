//
//  VkResponse.swift
//  VK client
//
//  Created by Денис Сизов on 18.11.2021.
//

import Foundation

/// Cтруктура стандартного ответа API Вконтакте по запросу друзей
struct VkFriendsResponse: Codable {
	let count: Int
	let items: [UserModel]
}
