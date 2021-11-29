//
//  demoUserService.swift
//  VK client
//
//  Created by Денис Сизов on 26.11.2021.
//

import UIKit.UIImage

class demoUserService: UserLoader {
	
	var networkManager: NetworkManager
	var cache: ImageCache
	
	required init(networkManager: NetworkManager, cache: ImageCache) {
		self.networkManager = networkManager
		self.cache = cache
	}
	
	var friends: [UserModel] = []
	
	func loadFriends(completion: @escaping ([FriendsSection]) -> Void) {
		
		// читаем файлик ./friends.json
		if let filepath = Bundle.main.path(forResource: "friends", ofType: "json") {
			do {
				let contents = try Data(contentsOf: URL(fileURLWithPath: filepath))
				let decodedData = try JSONDecoder().decode([UserModel].self, from: contents)
				friends = decodedData
			} catch {
				print(error)
			}
		}
		
		let sortedArray = sortFriends(friends)
		let sectionsArray = formFriendsSections(sortedArray)
		completion(sectionsArray)
	}
	
	func loadUserPhotos(for id: String, completion: @escaping ([UserImages]) -> Void) {
		let images = [
			UserImages(sizes: [
				Sizes(url: "vasia", type: .x),
				Sizes(url: "vasia", type: .m)
			]),
			UserImages(sizes: [
				Sizes(url: "vasia", type: .x),
				Sizes(url: "vasia", type: .m)
			]),
			UserImages(sizes: [
				Sizes(url: "vasia", type: .x),
				Sizes(url: "vasia", type: .m)
			]),
			UserImages(sizes: [
				Sizes(url: "vasia", type: .x),
				Sizes(url: "vasia", type: .m)
			]),
			UserImages(sizes: [
				Sizes(url: "vasia", type: .x),
				Sizes(url: "vasia", type: .m)
			]),
			UserImages(sizes: [
				Sizes(url: "vasia", type: .x),
				Sizes(url: "vasia", type: .m)
			]),
			UserImages(sizes: [
				Sizes(url: "vasia", type: .x),
				Sizes(url: "vasia", type: .m)
			]),
			UserImages(sizes: [
				Sizes(url: "vasia", type: .x),
				Sizes(url: "vasia", type: .m)
			]),
			UserImages(sizes: [
				Sizes(url: "vasia", type: .x),
				Sizes(url: "vasia", type: .m)
			]),
			UserImages(sizes: [
				Sizes(url: "vasia", type: .x),
				Sizes(url: "vasia", type: .m)
			]),
			UserImages(sizes: [
				Sizes(url: "vasia", type: .x),
				Sizes(url: "vasia", type: .m)
			]),
			UserImages(sizes: [
				Sizes(url: "vasia", type: .x),
				Sizes(url: "vasia", type: .m)
			]),
			UserImages(sizes: [
				Sizes(url: "vasia", type: .x),
				Sizes(url: "vasia", type: .m)
			]),
		]
		completion(images)
	}
	
	func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
		guard let image = UIImage(named: url) else {
			return
		}
		completion(image)
	}
	
	/// Вытаскивает из моделей картинок URL-ы картинок нужного размера
	func sortImage(by sizeType: Sizes.TypeEnum, from array: [UserImages]) -> [String] {
		var imageLinks: [String] = []
		
		for model in array {
			for size in model.sizes {
				if size.type == sizeType {
					imageLinks.append(size.url)
				}
			}
		}
		return imageLinks
	}
	
	// Раскидываем друзей по ключам, в зависимости от первой буквы имени
	func sortFriends(_ array: [UserModel]) -> [Character: [UserModel]] {
		
		var newArray: [Character: [UserModel]] = [:]
		for user in array {
			//проверяем, чтобы строка имени не оказалась пустой
			guard let firstChar = user.name.first else {
				continue
			}

			// Если секции с таким ключом нет, то создадим её
			guard var array = newArray[firstChar] else {
				let newValue = [user]
				newArray.updateValue(newValue, forKey: firstChar)
				continue
			}
			
			// Если секция нашлась, то добавим в массив ещё модель
			array.append(user)
			newArray.updateValue(array, forKey: firstChar)
		}
		return newArray
	}
	
	func formFriendsSections(_ array: [Character: [UserModel]]) -> [FriendsSection] {
		var sectionsArray: [FriendsSection] = []
		for (key, array) in array {
			sectionsArray.append(FriendsSection(key: key, data: array))
		}
		
		//Сортируем секции по алфавиту
		sectionsArray.sort { $0 < $1 }
		
		return sectionsArray
	}
}
