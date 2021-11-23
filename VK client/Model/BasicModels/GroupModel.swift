//
//  Group.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import RealmSwift

/// Модель группы Вконтакте
class GroupModel: Codable {
	@objc dynamic let name: String
	@objc dynamic let image: String
	@objc dynamic let id: Int
	@objc dynamic let isMember: Int
	
	enum CodingKeys: String, CodingKey {
		case name
		case id
		case image = "photo_50"
		case isMember = "is_member"
	}
}
