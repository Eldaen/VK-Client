//
//  NetworkManager.swift
//  VK client
//
//  Created by Денис Сизов on 16.11.2021.
//

import Foundation

/// Перечисление используемых нами методов из АПИ
// TODO: - вынести такие методы отдельно в классы, из которых будут запросы
enum apiMethods: String {
	case friendsGet = "/method/friends.get"
	case usersGet = "/method/users.get"
	case photosGetAll = "/method/photos.getAll"
	case groupsGet = "/method/groups.get"
	case groupsSearch = "/method/groups.search"
}

enum httpMethods: String {
	case get = "GET"
	case post = "POST"
}

/// Класс, управляющий запросами в сеть
class NetworkManager {
	
	private let session: URLSession = {
		let config = URLSessionConfiguration.default
		let session = URLSession(configuration: config)
		return session
	}()
	
	/// Декордер JSON, который используем для парсинга ответов
	let decoder = JSONDecoder()
	
	// Cтандартные данные
	private let scheme = "https"
	private let host = "api.vk.com"

	func request(method: apiMethods, httpMethod: httpMethods, params: [String: String]) {
		
		guard let token = Session.instance.token else {
			return
		}
		
		var queryItems = [URLQueryItem]()
		
		// добавляем общие для всех параметры
		queryItems.append(URLQueryItem(name: "access_token", value: token))
		queryItems.append(URLQueryItem(name: "v", value: "5.131"))
		
		for (param, value) in params {
			queryItems.append(URLQueryItem(name: param, value: value))
		}
		
		var urlComponents = URLComponents()
		urlComponents.scheme = scheme
		urlComponents.host = host
		urlComponents.path = method.rawValue
		urlComponents.queryItems = queryItems
		
		guard let url = urlComponents.url else {
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue
		
		session.dataTask(with: url) { (data, response, error) in
			
			if error == nil, let parseData = data {
				let json = try? JSONSerialization.jsonObject(with: parseData,
															 options: JSONSerialization.ReadingOptions.allowFragments
				)
				print(json)
			} else {
				
			}
			
		}.resume()
	}
}
