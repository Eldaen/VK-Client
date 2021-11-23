//
//  User.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import RealmSwift

/// Модель пользователя
class UserModel: Codable {
    @objc dynamic let name: String
	@objc dynamic let image: String
	@objc dynamic let id: Int
	
	/// Перечисление соответствия полям в АПИ к полям в нашей модели
	enum CodingKeys: String, CodingKey {
		case name = "first_name"
		case image = "photo_100"
		case id
	}
}
