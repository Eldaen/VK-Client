//
//  FriendsViewModelTests.swift
//  VKclientTests
//
//  Created by Денис Сизов on 24.01.2022.
//

import XCTest
@testable import VK_client

class FriendsViewModelTests: XCTestCase {
	
	var model: FriendsViewModel!

    override func setUpWithError() throws {
		model = FriendsViewModel(
			loader: demoUserService(networkManager: NetworkManager(),
									 cache: ImageCacheService(),
									 persistence: RealmService()
									)
		)
    }

    override func tearDownWithError() throws {
		model = nil
    }
	
	/// Тестирует СonfigureFriends метод
	func testConfigureFriendsCell() throws {
		//Given
		let cell = FriendsTableViewCell()
		let user = UserModel()
		user.name = "Vasia"
		user.image = "vasia"
		let image = UIImage(named: user.image)
		let section = FriendsSection(key: "V", data: [user])
		model.filteredData = [section]
		let indexPath = IndexPath(row: 0, section: 0)
		
		//When
		model.configureCell(cell: cell, indexPath: indexPath)
		
		//Then
		XCTAssertEqual(cell.getFriendName(), user.name)
		XCTAssertEqual(cell.getImage(), image)
	}
	
	/// Тестирует ConfigureFriends с плохим IndexPath
	func testConfigureFriendsCellBadIndexPath() throws {
		//Given
		let cell = FriendsTableViewCell()
		let user = UserModel()
		user.name = "Vasia"
		user.image = "vasia"
		let image = UIImage(named: user.image)
		let section = FriendsSection(key: "V", data: [user])
		model.filteredData = [section]
		let indexPath = IndexPath(row: 1, section: 1)
		
		//When
		model.configureCell(cell: cell, indexPath: indexPath)
		
		//Then
		XCTAssertNotEqual(cell.getFriendName(), user.name)
		XCTAssertNotEqual(cell.getImage(), image)
	}

	/// Тестирует загрузку друзей
	func testFetchFriends() throws {
		//Given
		let validatorExpectation = expectation(description: #function)
		
		//When
		model.fetchFriends { validatorExpectation.fulfill() }
		
		//Then
		waitForExpectations(timeout: 1.0) { error in
			if error != nil {
				XCTFail()
			}
			
			XCTAssertFalse(self.model.friends.isEmpty)
			XCTAssertFalse(self.model.filteredData.isEmpty)
		}
	}
	
	/// Тестирует поиск по друзьям
	func testSearchCorrectData() throws {
		//Given
		let user1 = UserModel()
		user1.name = "Vasia"
		user1.image = "vasia"
		let section1 = FriendsSection(key: "V", data: [user1])
		
		let user2 = UserModel()
		user2.name = "Misha"
		user2.image = "misha"
		let section2 = FriendsSection(key: "M", data: [user2])
		
		let user3 = UserModel()
		user3.name = "Petia"
		user3.image = "petia"
		
		let user4 = UserModel()
		user4.name = "Penia"
		user4.image = "dima"
		
		let section3 = FriendsSection(key: "P", data: [user3, user4])

		
		model.friends = [section1, section2, section3]
		let searchQuery = "ia"
		let validatorExpectation = expectation(description: #function)
		
		//When
		model.search(searchQuery) {
			validatorExpectation.fulfill()
		}
		
		//Then
		waitForExpectations(timeout: 1.0) { error in
			if error != nil {
				XCTFail()
			}
			
			XCTAssertEqual(self.model.filteredData.count, 2)
			XCTAssertEqual(self.model.filteredData[0], section1)
			XCTAssertEqual(self.model.filteredData[1], section3)
			XCTAssertEqual(self.model.filteredData[1].data.count, 2)
			XCTAssertEqual(self.model.filteredData[0].data.first?.name, user1.name)
			XCTAssertEqual(self.model.filteredData[1].data.first?.name, user3.name)
		}
	}
	
	/// Тестирует поиск по друзьям c пустым запросом
	func testSearchEmptyData() throws {
		//Given
		let user1 = UserModel()
		user1.name = "Vasia"
		user1.image = "vasia"
		let section1 = FriendsSection(key: "V", data: [user1])
		
		let user2 = UserModel()
		user2.name = "Misha"
		user2.image = "misha"
		let section2 = FriendsSection(key: "M", data: [user2])
		
		let user3 = UserModel()
		user3.name = "Petia"
		user3.image = "petia"
		let section3 = FriendsSection(key: "P", data: [user3])
		
		model.friends = [section1, section2, section3]
		let searchQuery = ""
		let validatorExpectation = expectation(description: #function)
		
		//When
		model.search(searchQuery) {
			validatorExpectation.fulfill()
		}
		
		//Then
		waitForExpectations(timeout: 1.0) { error in
			if error != nil {
				XCTFail()
			}
			
			XCTAssertEqual(self.model.filteredData, self.model.friends)
		}
	}
	
	func testCancelSearch() {
		//Given
		let user1 = UserModel()
		user1.name = "Vasia"
		user1.image = "vasia"
		let section1 = FriendsSection(key: "V", data: [user1])
		
		let user2 = UserModel()
		user2.name = "Misha"
		user2.image = "misha"
		let section2 = FriendsSection(key: "M", data: [user2])
		
		let user3 = UserModel()
		user3.name = "Petia"
		user3.image = "petia"
		let section3 = FriendsSection(key: "P", data: [user3])
		
		model.friends = [section1, section2, section3]
		let validatorExpectation = expectation(description: #function)
		
		//When
		model.cancelSearch { validatorExpectation.fulfill() }
		
		//Then
		waitForExpectations(timeout: 1.0) { error in
			if error != nil {
				XCTFail()
			}
			
			XCTAssertEqual(self.model.filteredData, self.model.friends)
		}
	}
}
