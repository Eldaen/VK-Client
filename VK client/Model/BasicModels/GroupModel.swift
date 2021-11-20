//
//  Group.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import Foundation

/// Модель группы Вконтакте
struct GroupModel: Codable {
    let name: String
    let image: String
	let id: Int
	let isMember: Int
	
	enum CodingKeys: String, CodingKey {
		case name
		case id
		case image = "photo_50"
		case isMember = "is_member"
	}
}
