//
//  Session.swift
//  VK client
//
//  Created by Денис Сизов on 12.11.2021.
//

/// Класс для хранения данных авторизации, Singleton
final class Session {
	
	/// Токен авторизации
	var token: String?
	
	/// ID пользователя, под которым авторизовались
	var userID: Int?
	
	///  Инстанс синглтона Session
	static let instance = Session()
	
	private init() {}
	
	/// Сохраняет данные авторизации пользователя
	func loginUser(with token: String, userId: Int) {
		self.token = token
		self.userID = userId
	}
}
