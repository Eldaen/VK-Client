//
//  FirebaseUser.swift
//  VK client
//
//  Created by Денис Сизов on 07.12.2021.
//

import Firebase

/// Модель пользователя для работы с Firebase
class FirebaseUser {

	let id: Int
	var groups: [FirebaseGroup] = []
	let ref: DatabaseReference?
	var toFireBase: [String: Any] {
		return groups.map {
			$0.toAnyObject() // превращает все группы в массивы
		}.reduce([:]) { // бежим по всем массивам, стартовая точка у нас пустой массив
			$0.merging($1) { (current, _) in current } // сооединяем все массивы в один
		}
	}

	init(id: Int) {
		self.id = id
		self.ref = nil
		self.groups = []
	}

	init?(snapshot: DataSnapshot) {
		guard
			let value = snapshot.value as? [String: Any],
			let id = value["id"] as? Int,
			let groups = value["groups"] as? [FirebaseGroup]
		else {
			return nil
		}
		self.ref = snapshot.ref
		self.id = id
		self.groups = groups
	}

	func toAnyObject() -> [String: Any] {
		return [
			"id": id,
			"groups": toFireBase
		]
	}
}
