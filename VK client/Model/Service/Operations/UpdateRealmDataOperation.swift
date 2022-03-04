//
//  UpdateRealmDataOperation.swift
//  VK client
//
//  Created by Денис Сизов on 28.12.2021.
//

import Foundation

/// Операция обновления Реалма с новыми данными групп
final class UpdateRealmDataOperation: Operation {
	
	/// Менеджер управления БД
	private var persistence: PersistenceManager
	
	/// Хэндлер для кэша
	private var cacheHandler: Loader
	
	/// Ключ кэша
	private var cacheKey: String
	
	init(manager persistence: PersistenceManager, cacheHandler: Loader, cacheKey: String) {
		self.persistence = persistence
		self.cacheHandler = cacheHandler
		self.cacheKey = cacheKey
	}
	
	override func main() {
		guard let completionOperation = dependencies.first as? GroupsCompletionOperation else {
			return
		}
		
		if completionOperation.success == true {
			let items = completionOperation.groups
			persistence.delete(GroupModel.self) { _ in }
			persistence.create(items) { _ in }
			cacheHandler.setExpiry(key: cacheKey, time: 10 * 60)
		} else {
			print("Did not succeed to parse the data")
		}
	}
}
