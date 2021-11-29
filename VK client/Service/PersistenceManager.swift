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
	func create<T: Object>(_ object: T, completion: @escaping (Result<Bool, Error>) -> Void)
	
	/// Читает запись из БД
	func read<T: Object>(_ object: T, completion: @escaping (Result<[T], Error>) -> Void)
	
	/// Обновляет запись в БД
	func update<T: Object>(_ object: T, completion: @escaping (Result<Bool, Error>) -> Void)
	
	/// Удаляет запись из БД
	func delete()
}

/// Cервис по работе с Realm
final class RealmService: PersistenceManager {
	
	enum errors: Error {
		case noRealmObject(String)
		case noPrimaryKeys(String)
	}
	
	/// Объект хранилища
	var realm: Realm
	
	init() {
		do {
			let realm = try Realm()
			self.realm = realm
		} catch {
			fatalError("Can't create Realm object")
		}
	}
	
	func create<T: Object>(_ object: T, completion: @escaping (Result<Bool, Error>) -> Void) {
	
		DispatchQueue.main.async { [weak self] in
			do {
				self?.realm.add(object)
				try self?.realm.commitWrite()
				completion(.success(true))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	func read<T: Object>(_ object: T, completion: @escaping (Result<[T], Error>) -> Void) {
		
		let result = realm.objects(T.self)
		let objects = Array(result)
		
		completion(.success(objects))
	}
	
	func update<T: Object>(_ object: T, completion: @escaping (Result<Bool, Error>) -> Void) {
		
		if object.objectSchema.primaryKeyProperty == nil {
				completion(.failure(errors.noPrimaryKeys("This model does not have a primary key")))
		}
	
		DispatchQueue.main.async { [weak self] in
			do {
				self?.realm.add(object, update: .modified)
				try self?.realm.commitWrite()
				completion(.success(true))
			} catch {
				completion(.failure(error))
			}
		}
	}
	
	func delete() {
		
	}
}
