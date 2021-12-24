//
//  Sizes.swift
//  VK client
//
//  Created by Денис Сизов on 19.11.2021.
//

/// Возможные варианты размеров картинки пользователя
struct Sizes: Codable {
	let url: String
	let type: String
	let height: Int
	let width: Int
}
