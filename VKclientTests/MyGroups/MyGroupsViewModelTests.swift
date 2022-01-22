//
//  MyGroupsViewModelTests.swift
//  VKclientTests
//
//  Created by Денис Сизов on 22.01.2022.
//

import XCTest
@testable import VK_client

class MyGroupsViewModelTests: XCTestCase {
	
	var model: MyGroupsViewModel!
	
	override func setUpWithError() throws {
		model = MyGroupsViewModel(
			loader: demoGroupService(networkManager: NetworkManager(),
									 cache: ImageCacheService(),
									 persistence: RealmService()
									)
		)
	}
	
	override func tearDownWithError() throws {
		model = nil
	}
	
	func testFetchGroups() throws {
		
		//Given
		let validatorExpectation = expectation(description: #function)
		
		//When
		model.fetchGroups { validatorExpectation.fulfill() }
		
		//Then
		
		waitForExpectations(timeout: 1.0) { error in
			if error != nil {
				XCTFail()
			}
			
			XCTAssertFalse(self.model.groups.isEmpty)
			XCTAssertFalse(self.model.filteredGroups.isEmpty)
		}
		
	}
	
}
