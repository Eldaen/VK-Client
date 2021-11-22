//
//  GroupsMyResponse.swift.swift
//  VK client
//
//  Created by Денис Сизов on 20.11.2021.
//

/// Cтруктура стандартного ответа API Вконтакте по запросу групп пользователя
struct GroupsMyResponse: Codable {
	let count: Int
	let items: [GroupModel]
}
