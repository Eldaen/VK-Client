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
	
	enum CodingKeys: String, CodingKey {
		case name
		case image = "photo_50"
	}
}
