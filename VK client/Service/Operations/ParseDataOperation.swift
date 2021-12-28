//
//  ParseDataOperation.swift
//  VK client
//
//  Created by Денис Сизов on 28.12.2021.
//

import Foundation

/// Операция парсинга данных из JSON в модель
class GroupsDataParseOperation: Operation {
	
	private(set) var outputData: GroupsMyMainResponse?
	private let decoder = JSONDecoder()
	
	override func main() {
		guard let getDataOperation = dependencies.first(where: { $0 is GroupsDataOperation }) as? GroupsDataOperation,
			  let data = getDataOperation.data else {
				  print("Data not loaded")
				  return
			  }
		
		do {
			let groups = try decoder.decode(GroupsMyMainResponse.self, from: data)
			outputData = groups
		} catch {
			print("Failed to decode")
		}
	}
}
