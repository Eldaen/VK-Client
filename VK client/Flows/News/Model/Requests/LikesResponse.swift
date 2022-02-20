//
//  LikesResponse.swift
//  VK client
//
//  Created by Денис Сизов on 13.12.2021.
//

struct LikesResponse: Codable {
	let response: LikesCount
}

struct LikesCount: Codable {
	let likes: Int
}
