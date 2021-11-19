//
//  FriendsLoader.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

// Возвращаем какой-то массив данных, тут могла бы быть подгрузка из API
class UserService: Loader {
    
	var friendsArray: [UserModel]?
	
    /// Раскидываем друзей по ключам, в зависимости от первой буквы имени
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
	
	func formFriendsArray(from array: [UserModel]?) -> [FriendsSection] {
		guard let array = array else {
			return []
		}
		let sorted = sortFriends(array)
		return formFriendsSections(sorted)
	}
	
	
	/// Загружает список друзей
	func loadFriends(completion: @escaping ([FriendsSection]) -> Void) {
		let params = [
			"order" : "name",
			"fields" : "photo_50",
		]
		
		networkManager.request(method: .friendsGet,
							   httpMethod: .get,
							   params: params) { [weak self] (result: Result<Response, Error>) in
			switch result {
			case .success(let friendsResponse):
				guard let sections = self?.formFriendsArray(from: friendsResponse.response.items) else {
					return
				}
				completion(sections)
			case .failure(let error):
				debugPrint("Error: \(error.localizedDescription)")
			}
		}
	}
	
//	/// Загружает все фото пользователя
//	func loadUserPhotos(for id: String) {
//		let params = [
//			"owner_id" : id,
//		]
//		networkManager.request(method: .photosGetAll, httpMethod: .get, params: params)
//	}
}
