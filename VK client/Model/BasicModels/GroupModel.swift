//
//  Group.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import RealmSwift

/// Модель группы Вконтакте
class GroupModel: Codable {
	@objc dynamic var name: String
	@objc dynamic var image: String
	@objc dynamic var id: Int
	@objc dynamic var isMember: Int
	
	enum CodingKeys: String, CodingKey {
		case name
		case id
		case image = "photo_50"
		case isMember = "is_member"
	}
}
