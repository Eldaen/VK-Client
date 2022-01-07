//
//  GroupsCompletionOperation.swift
//  VK client
//
//  Created by Денис Сизов on 28.12.2021.
//

import Foundation

final class GroupsCompletionOperation: Operation {
	
	private(set) var success: Bool = false
	
	private(set) var groups: [GroupModel] = []
	
	/// Блок кода, который нужно выполнить при успешном парсинге данных групп
	private var completion: ([GroupModel]) -> Void
	
	init(_ completion: @escaping ([GroupModel]) -> Void) {
		self.completion = completion
	}
	
	override func main() {
		guard let parsedData = dependencies.first as? GroupsDataParseOperation else {
			return
		}
		
		if let groups = parsedData.outputData?.response.items {
			success = true
			self.groups = groups
			completion(groups)
		} else {
			print("Did not parse anything")
		}
	}
}
