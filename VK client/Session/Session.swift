//
//  Session.swift
//  VK client
//
//  Created by Денис Сизов on 12.11.2021.
//
import Foundation
import WebKit

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
	
	func clean() {
		HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
		print("[WebCacheCleaner] All cookies deleted")
		
		WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
			records.forEach { record in
				WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
				print("[WebCacheCleaner] Record \(record) deleted")
			}
		}
	}
}
