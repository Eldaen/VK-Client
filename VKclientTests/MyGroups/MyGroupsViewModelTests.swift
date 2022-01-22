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
	
	/// Проверим факт загрузки групп после запроса
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
	
	/// Если искать пустую строчку, то покажет все группы, передадим 3 группы и проверим кол-во найденных
	func testSearchWithEmptyQuery() throws {
		
		//Given
		model.groups = [GroupModel(), GroupModel(), GroupModel()]
		let validatorExpectation = expectation(description: #function)
		
		//When
		model.search("") { validatorExpectation.fulfill() }
		
		//Then
		waitForExpectations(timeout: 1.0) { error in
			if error != nil {
				XCTFail()
			}
			
			XCTAssertEqual(self.model.filteredGroups, self.model.groups)
			XCTAssertEqual(self.model.filteredGroups.count, 3)
		}
	}
	
	func testSearchWithValues() throws {
		
		//Given
		let group1 = GroupModel()
		group1.name = "Программисты"
		
		let group2 = GroupModel()
		group2.name = "Дизайнеры"
		
		let group3 = GroupModel()
		group3.name = "Майнеры"
		
		let queryString = "еры"
		
		model.groups = [group1, group2, group3]
		let validatorExpectation = expectation(description: #function)
		
		//When
		model.search(queryString) { validatorExpectation.fulfill() }
		
		//Then
		waitForExpectations(timeout: 1.0) { error in
			if error != nil {
				XCTFail()
			}
			
			XCTAssertEqual(self.model.filteredGroups.count, 2)
			XCTAssertEqual(self.model.filteredGroups, [group2, group3])
			XCTAssertNotEqual(self.model.filteredGroups, [group3, group2])
		}
	}
	
	func testCancelSearch() throws {
		
		//Given
		model.groups = [GroupModel(), GroupModel(), GroupModel()]
		let validatorExpectation = expectation(description: #function)
		
		//When
		model.cancelSearch { validatorExpectation.fulfill() }
		
		//Then
		waitForExpectations(timeout: 1.0) { error in
			if error != nil {
				XCTFail()
			}
			
			XCTAssertEqual(self.model.filteredGroups, self.model.groups)
		}
	}
	
}
