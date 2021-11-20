//
//  BoolResponse.swift
//  VK client
//
//  Created by Денис Сизов on 20.11.2021.
//

import Foundation

/// Ответ, который подразумевает булевый response, но не true/false, а 1/0
struct BoolResponse: Codable {
	var response: Int
}
