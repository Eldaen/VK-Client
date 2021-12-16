//
//  FriendCollectionImageModel.swift.swift
//  VK client
//
//  Created by Денис Сизов on 16.12.2021.
//

/// Модель картинки пользователя для галереи профиля
final class FriendCollectionImageModel: Hashable {
	
	/// Cсылка на картинку
	let url: String
	
	static func == (lhs: FriendCollectionImageModel, rhs: FriendCollectionImageModel) -> Bool {
		lhs.url == rhs.url
	}
	
	func hash(into hasher: inout Hasher) {
	  hasher.combine(url)
	}
	
	init(image: String) {
		url = image
	}
}
