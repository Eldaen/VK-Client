//
//  User.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import RealmSwift

/// Модель пользователя
class UserModel: Object, Codable {
	@objc dynamic var name: String = ""
	@objc dynamic var image: String = ""
	@objc dynamic var id: Int = 0
	
	/// Перечисление соответствия полям в АПИ к полям в нашей модели
	enum CodingKeys: String, CodingKey {
		case name = "first_name"
		case image = "photo_100"
		case id
	}
	
	override static func primaryKey() -> String? {
		return "id"
	}
	
	override static func indexedProperties() -> [String] {
		return ["name", "image"]
	}
}
