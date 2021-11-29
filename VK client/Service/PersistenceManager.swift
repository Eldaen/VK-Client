//
//  PersistenceManager.swift
//  VK client
//
//  Created by Денис Сизов on 29.11.2021.
//

/// Протокол менеджера по взаимодействию с БД
protocol PersistenceManager {
	func read()
	func load()
	func clear()
}

/// Cервис по работе с Realm
final class RealmService: PersistenceManager {
	func read() {
		<#code#>
	}
	
	func load() {
		<#code#>
	}
	
	func clear() {
		<#code#>
	}
	
	
}
