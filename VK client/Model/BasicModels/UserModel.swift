//
//  User.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//


/// Модель пользователя
struct UserModel: Codable {
    let name: String
    let image: String
	let id: Int
	
	/// Перечисление соответствия полям в АПИ к полям в нашей модели
	enum CodingKeys: String, CodingKey {
		case name = "first_name"
		case image = "photo_100"
		case id
	}
}
