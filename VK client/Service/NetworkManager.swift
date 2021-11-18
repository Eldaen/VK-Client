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

/// Возможные http методы
enum httpMethods: String {
	case get = "GET"
	case post = "POST"
}

/// Возможные ошибки
enum ManagerErrors: Error {
	case invalidResponse
	case invalidStatusCode(Int)
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
	
	/// Запрашивает данные по заданным параметрам. Возвращает либо результат Generic типа, либо ошибку
	func request<T: Decodable>(method: apiMethods,
							   httpMethod: httpMethods,
							   params: [String: String],
							   completion: @escaping (Result<T, Error>) -> Void
	){
		
		/// Возвращаем разультат через клоужер в основую очередь
		let completionOnMain: (Result<T, Error>) -> Void = { result in
			DispatchQueue.main.async {
				completion(result)
			}
		}
		
		guard let token = Session.instance.token else {
			return
		}
		
		// Конфигурируем URL
		let url = configureUrl(token: token, method: method, httpMethod: httpMethod, params: params)
		
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue
		
		session.dataTask(with: url) { [weak self] (data, response, error) in
			
			guard let strongSelf = self else { return }
			guard let data = data else { return }
			
			do {
				let decodedData = try strongSelf.decoder.decode(T.self, from: data)
				return completionOnMain(.success(decodedData))
			} catch {
				completionOnMain(.failure(error))
			}
			
		}.resume()
	}
	
	func configureUrl(token: String,
					  method: apiMethods,
					  httpMethod: httpMethods,
					  params: [String: String]) -> URL {
	
		
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
			fatalError("URL is invalid")
		}
		
		return url
	}
}
