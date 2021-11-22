//
//  GroupsMyMainResponse.swift
//  VK client
//
//  Created by Денис Сизов on 20.11.2021.
//

/// Входной ответ из АПИ вконтакте по запросу групп пользователя
struct GroupsMyMainResponse: Codable {
	var response: GroupsMyResponse
}
