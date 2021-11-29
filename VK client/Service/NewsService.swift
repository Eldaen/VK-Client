//
//  NewsLoader.swift
//  VK-Client
//
//  Created by Денис Сизов on 23.10.2021.
//

import UIKit

// Возвращаем какой-то массив данных, тут могла бы быть подгрузка из API
final class NewsService {
    static func iNeedNews() -> [NewsTableViewCellModel] {
<<<<<<< HEAD
		
		var friends: [UserModel] = []
		
		if let filepath = Bundle.main.path(forResource: "friends", ofType: "json") {
			do {
				let contents = try Data(contentsOf: URL(fileURLWithPath: filepath))
				let decodedData = try JSONDecoder().decode([UserModel].self, from: contents)
				friends = decodedData
			} catch {
				print(error)
			}
		}
		
		return [NewsTableViewCellModel(user: friends[0],
                                       postDate: "1.1.1970",
                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
                                       newsImageNames: ["vasia", "dima", "misha", "petia", "misha", "petia"]),
                NewsTableViewCellModel(user: friends[1],
                                       postDate: "1.2.1970",
                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
                                       newsImageNames: ["vasia", "dima", "misha"]),
                NewsTableViewCellModel(user: friends[2],
                                       postDate: "1.3.1970",
                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
                                       newsImageNames: ["vasia"]),
                NewsTableViewCellModel(user: friends[3],
                                       postDate: "1.4.1970",
                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
                                       newsImageNames: ["vasia"]),
                NewsTableViewCellModel(user: friends[4],
                                       postDate: "1.5.1970",
                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
                                       newsImageNames: ["vasia"]),
                NewsTableViewCellModel(user: friends[5],
                                       postDate: "1.6.1970",
                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
                                       newsImageNames: ["vasia"]),
                NewsTableViewCellModel(user: friends[6],
                                       postDate: "1.7.1970",
                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
                                       newsImageNames: ["vasia", "dima", "misha"]),
        ]
=======
//		return [NewsTableViewCellModel(user: UserModel(name: "Vasia", image: "vasia", id: 0),
//                                       postDate: "1.1.1970",
//                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
//                                       newsImageNames: ["vasia", "dima", "misha", "petia", "misha", "petia"]),
//                NewsTableViewCellModel(user: UserModel(name: "Petia", image: "petia", id: 0),
//                                       postDate: "1.2.1970",
//                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
//                                       newsImageNames: ["vasia", "dima", "misha"]),
//                NewsTableViewCellModel(user: UserModel(name: "Petia", image: "petia", id: 0),
//                                       postDate: "1.3.1970",
//                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
//                                       newsImageNames: ["vasia"]),
//                NewsTableViewCellModel(user: UserModel(name: "Petia", image: "petia", id: 0),
//                                       postDate: "1.4.1970",
//                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
//                                       newsImageNames: ["vasia"]),
//                NewsTableViewCellModel(user: UserModel(name: "Petia", image: "petia", id: 0),
//                                       postDate: "1.5.1970",
//                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
//                                       newsImageNames: ["vasia"]),
//                NewsTableViewCellModel(user: UserModel(name: "Petia", image: "petia", id: 0),
//                                       postDate: "1.6.1970",
//                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
//                                       newsImageNames: ["vasia"]),
//                NewsTableViewCellModel(user: UserModel(name: "Petia", image: "petia", id: 0),
//                                       postDate: "1.7.1970",
//                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
//                                       newsImageNames: ["vasia", "dima", "misha"]),
//        ]
		return []
>>>>>>> lesson6
    }
}

