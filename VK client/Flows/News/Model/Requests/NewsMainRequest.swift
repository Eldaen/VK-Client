//
//  NewsMainRequest.swift
//  VK client
//
//  Created by Денис Сизов on 09.12.2021.
//

/// Основной ответ от АПИ при запросе новостей
struct NewsMainResponse: Codable {
	let response: NewsContentsResponse
}

struct NewsContentsResponse: Codable {
	let items: [NewsModel]
	let profiles: [UserModel]
	let groups: [GroupModel]
	let nextFrom: String?

	enum CodingKeys: String, CodingKey {
		case items, profiles, groups
		case nextFrom = "next_from"
	}
}
