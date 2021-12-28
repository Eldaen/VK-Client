//
//  GroupsCompletionOperation.swift
//  VK client
//
//  Created by Денис Сизов on 28.12.2021.
//

import Foundation

class GroupsCompletionOperation: Operation {
	var completion: ([GroupModel]) -> Void
	
	init(_ completion: @escaping ([GroupModel]) -> Void) {
		self.completion = completion
	}
	
	override func main() {
		guard let parsedData = dependencies.first as? GroupsDataParseOperation else {
			return
		}
		
		if let groups = parsedData.outputData?.response.items {
			completion(groups)
		} else {
			print("Did not parse anything")
		}
	}
}
