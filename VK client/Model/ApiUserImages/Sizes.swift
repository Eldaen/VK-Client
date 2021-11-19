//
//  Sizes.swift
//  VK client
//
//  Created by Денис Сизов on 19.11.2021.
//

import Foundation

/// Возможные варианты размеров картинки пользователя
struct Sizes: Codable {
	let url: String
	let type: TypeEnum
	
	enum TypeEnum: String, Codable {
		case m = "m"
		case o = "o"
		case p = "p"
		case q = "q"
		case r = "r"
		case s = "s"
		case w = "w"
		case x = "x"
		case y = "y"
		case z = "z"
	}
}
