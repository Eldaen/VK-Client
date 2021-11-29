//
//  PersistenceManager.swift
//  VK client
//
//  Created by Денис Сизов on 29.11.2021.
//

import RealmSwift

/// Протокол менеджера по взаимодействию с БД, реализует СRUD
protocol PersistenceManager {
	
	/// Добавляет запись в БД
	func create<T: Object>(_ object: T, completion: @escaping (Bool) -> Void)
	
	/// Читает запись из БД
	func read()
	
	/// Обновляет запись в БД
	func update()
	
	/// Удаляет запись из БД
	func delete()
}

/// Cервис по работе с Realm
final class RealmService: PersistenceManager {
	
	/// Объект хранилища
	var realm: Realm?
	
	init() {
		createContainer()
	}
	
	func create<T: Object>(_ object: T, completion: @escaping (Bool) -> Void) {
		guard let realm = realm else {
			completion(false)
			return
		}
	
		do {
			realm.add(object)
			try realm.commitWrite()
			completion(true)
		} catch {
			print(error)
			completion(false)
		}
	}
	
	func read() {
		
	}
	
	func update() {
		
	}
	
	func delete() {
		
	}
}

// MARK: Private methods
private extension RealmService {
	
	/// Cоздаёт контейнер Realm
	func createContainer() {
		do {
			let realm = try Realm()
			self.realm = realm
		} catch {
			return
		}
	}
}
