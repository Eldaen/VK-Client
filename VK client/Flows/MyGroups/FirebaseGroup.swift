//
//  FirebaseGroup.swift
//  VK client
//
//  Created by Денис Сизов on 07.12.2021.
//

import Firebase

/// Модель группы для работы с Firebase
class FirebaseGroup {

	let name: String
	let id: Int
	let ref: DatabaseReference?

	init(name: String, id: Int) {
		self.ref = nil
		self.id = id
		self.name = name
	}

	init?(snapshot: DataSnapshot) {
		guard
			let value = snapshot.value as? [String: Any],
			let id = value["id"] as? Int,
			let name = value["name"] as? String
		else {
			return nil
		}
		self.ref = snapshot.ref
		self.id = id
		self.name = name
	}

	func toAnyObject() -> [String: Any] {
		return [
			"name": name,
			"id": id
		]
	}
}
