//
//  FriendsLoader.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

// Возвращаем какой-то массив данных, тут могла бы быть подгрузка из API
class UserService {
	
	/// Класс для отправки запросов к API
	let networkManager = NetworkManager()
    
    // Можно было бы сразу отсортировать тестовые данные как надо, но я что-то решил сделать сотировалки, чтобы потом не переделывать, если будет подгрузка
    static var friends = [UserModel(name: "Vasia", image: "vasia", storedImages: ["vasia", "petia", "misha", "dima", "pepe-dunno", "pepe-like", "pepe-pirate", "pepe-yard-keeper"]),
                          UserModel(name: "Petia", image: "petia", storedImages: []),
                          UserModel(name: "Dima", image: "dima", storedImages: []),
                          UserModel(name: "Andrey", image: "misha", storedImages: ["vasia", "petia", "misha", "dima", "pepe-dunno", "pepe-like", "pepe-pirate", "pepe-yard-keeper"]),
                          UserModel(name: "Bob", image: "petia", storedImages: []),
                          UserModel(name: "Coby", image: "dima", storedImages: []),
                          UserModel(name: "Misha", image: "misha", storedImages: []),
                          UserModel(name: "Nick", image: "petia", storedImages: []),
                          UserModel(name: "Kane", image: "dima", storedImages: []),
                          UserModel(name: "Stepan", image: "misha", storedImages: []),
                          UserModel(name: "Kira", image: "petia", storedImages: []),
                          UserModel(name: "James", image: "dima", storedImages: []),
                          UserModel(name: "Walter", image: "misha", storedImages: []),
                          UserModel(name: "Oprah", image: "petia", storedImages: []),
                          UserModel(name: "Vitalik", image: "dima", storedImages: []),
                          UserModel(name: "Harold", image: "misha", storedImages: []),
    ]
    
    static func iNeedFriends() -> [FriendsSection] {
        let sortedArray = sortFriends(friends)
        let sectionsArray = formFriendsSections(sortedArray)
        return sectionsArray
    }
    
    // Раскидываем друзей по ключам, в зависимости от первой буквы имени
    static func sortFriends(_ array: [UserModel]) -> [Character: [UserModel]] {
        
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
    
    static func formFriendsSections(_ array: [Character: [UserModel]]) -> [FriendsSection] {
        var sectionsArray: [FriendsSection] = []
        for (key, array) in array {
            sectionsArray.append(FriendsSection(key: key, data: array))
        }
        
        //Сортируем секции по алфавиту
        sectionsArray.sort { $0 < $1 }
        
        return sectionsArray
    }
	
	
	/// Загружает список друзей
	func loadFriends() {
		let params = [
			"order" : "name",
			"fields" : "photo_50",
		]
		networkManager.request(method: .friendsGet, httpMethod: .get, params: params)
	}
	
	/// Загружает все фото пользователя
	func loadUserPhotos(for id: String) {
		let params = [
			"owner_id" : id,
		]
		networkManager.request(method: .photosGetAll, httpMethod: .get, params: params)
	}
}
