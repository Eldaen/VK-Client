//
//  GetDataOperation.swift.swift
//  VK client
//
//  Created by Денис Сизов on 28.12.2021.
//

import Foundation
import Alamofire

/// Операция по работе с сетью для GroupsService
class GroupsDataOperation: AsyncOperation {
	
	/// Методы для доступа к API
	enum apiMethods: String {
		case groupsGet = "/method/groups.get"
		case groupsSearch = "/method/groups.search"
		case groupsJoin = "/method/groups.join"
		case groupsLeave = "/method/groups.leave"
	}
	
	/// host для отправки запроса
	private let host = "https://api.vk.com"
	
	/// Alamofire request
	private var request: DataRequest
	
	/// Метод для API
	private var method: apiMethods
	
	/// Параметры для запроса
	private var params: Parameters
	
	/// Полученная после запроса Data
	var data: Data?
	
	init(method: apiMethods, params: Parameters) {
		self.method = method
		self.params = params
		
		if let token = Session.instance.token {
			self.params.updateValue(token, forKey: "access_token")
			self.params.updateValue("5.131", forKey: "v")
		}
		
		let url = host + method.rawValue
		request = AF.request(url, parameters: self.params).validate()
	}
	
	override func main() {
		request.responseData(queue: DispatchQueue.global()) { [weak self] response in
			self?.data = response.data
			self?.state = .finished
		}
	}
	
	override func cancel() {
		request.cancel()
		super.cancel()
	}
}
