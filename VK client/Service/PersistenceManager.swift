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
	
	/// Добавляет записи в БД
	func createMany<T: Object>(_ object: [T], completion: @escaping (Result<Bool, Error>) -> Void)
	
	/// Читает запись из БД
	func read<T: Object>(_ object: T, key: String, completion: @escaping (Result<[T], Error>) -> Void)
	
	/// Обновляет запись в БД
	func update<T: Object>(_ object: T, completion: @escaping (Result<Bool, Error>) -> Void)
	
	/// Удаляет запись из БД
	func deleteOne<T: Object>(_ object: T, key: String, completion: @escaping (Result<Bool, Error>) -> Void)
	
	func deleteAllByType<T: Object>(_ object: T, completion: @escaping (Result<Bool, Error>) -> Void)
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
		do {
			realm.beginWrite()
			realm.add(object)
			try realm.commitWrite()
			completion(.success(true))
		} catch {
			completion(.failure(error))
		}
	}
	
	func createMany<T: Object>(_ objects: [T], completion: @escaping (Result<Bool, Error>) -> Void) {
		do {
			realm.beginWrite()
			realm.add(objects)
			try realm.commitWrite()
			completion(.success(true))
		} catch {
			completion(.failure(error))
		}
	}
	
	func read<T: Object>(_ object: T, key: String = "", completion: @escaping (Result<[T], Error>) -> Void) {
		
		var objects: [T] = []
		
		if object.objectSchema.primaryKeyProperty == nil {
			let result = realm.objects(T.self)
			objects = Array(result)
		} else {
			if let result = realm.object(ofType: T.self, forPrimaryKey: key) {
				objects.append(result)
			}
		}
		
		completion(.success(objects))
	}
	
	func update<T: Object>(_ object: T, completion: @escaping (Result<Bool, Error>) -> Void) {
		
		if object.objectSchema.primaryKeyProperty == nil {
			completion(.failure(errors.noPrimaryKeys("This model does not have a primary key")))
		}
		
		do {
			realm.beginWrite()
			realm.add(object, update: .modified)
			try realm.commitWrite()
			completion(.success(true))
		} catch {
			completion(.failure(error))
		}
	}
	
	func deleteOne<T: Object>(_ object: T, key: String, completion: @escaping (Result<Bool, Error>) -> Void) {
		
		guard let object = realm.objects(T.self).filter("code = %@", key).first else {
			completion(.failure(errors.noRealmObject("There is no such object")))
			return
		}
		
		do {
			realm.beginWrite()
			realm.delete(object)
			try realm.commitWrite()
			completion(.success(true))
		} catch {
			completion(.failure(error))
		}
	}
	
	func deleteAllByType<T: Object>(_ object: T, completion: @escaping (Result<Bool, Error>) -> Void) {
		let oldData = realm.objects(T.self)
		
		do {
			realm.beginWrite()
			realm.delete(oldData)
			try realm.commitWrite()
			completion(.success(true))
		} catch {
			completion(.failure(error))
		}
	}
}
