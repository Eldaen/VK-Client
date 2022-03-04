//
//  NetworkLoggingProxy.swift
//  VK client
//
//  Created by Денис Сизов on 16.02.2022.
//

import Foundation

/// Прокси для NetworkManager, который логгирует в консоль все запросы
final class NetworkLoggingProxy: NetworkManagerInterface {
	
	/// Cам NetworkManager
	let networkManager: NetworkManagerInterface
	
	init(networkManager: NetworkManagerInterface) {
		self.networkManager = networkManager
	}
	
	func request<T>(method: apiMethods, httpMethod: httpMethods, params: [String : String], completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
		print("Requesting data using \(method) method with \(params)")
		
		networkManager.request(method: method, httpMethod: httpMethod, params: params) { data in
			completion(data)
		}
	}
	
	func loadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
		print("Loading image from: \(url)")
		
		networkManager.loadImage(url: url) { data in
			completion(data)
		}
	}
}
