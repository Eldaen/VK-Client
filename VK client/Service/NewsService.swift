//
//  NewsLoader.swift
//  VK-Client
//
//  Created by Денис Сизов on 23.10.2021.
//

import UIKit

// Возвращаем какой-то массив данных, тут могла бы быть подгрузка из API
class NewsService {
    static func iNeedNews() -> [NewsTableViewCellModel] {
        return [NewsTableViewCellModel(user: UserModel(name: "Vasia", image: "vasia", storedImages: []),
                                       postDate: "1.1.1970",
                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
                                       newsImageNames: ["vasia", "dima", "misha", "petia", "misha", "petia"]),
                NewsTableViewCellModel(user: UserModel(name: "Petia", image: "petia", storedImages: []),
                                       postDate: "1.2.1970",
                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
                                       newsImageNames: ["vasia", "dima", "misha"]),
                NewsTableViewCellModel(user: UserModel(name: "Petia", image: "petia", storedImages: []),
                                       postDate: "1.3.1970",
                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
                                       newsImageNames: ["vasia"]),
                NewsTableViewCellModel(user: UserModel(name: "Petia", image: "petia", storedImages: []),
                                       postDate: "1.4.1970",
                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
                                       newsImageNames: ["vasia"]),
                NewsTableViewCellModel(user: UserModel(name: "Petia", image: "petia", storedImages: []),
                                       postDate: "1.5.1970",
                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
                                       newsImageNames: ["vasia"]),
                NewsTableViewCellModel(user: UserModel(name: "Petia", image: "petia", storedImages: []),
                                       postDate: "1.6.1970",
                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
                                       newsImageNames: ["vasia"]),
                NewsTableViewCellModel(user: UserModel(name: "Petia", image: "petia", storedImages: []),
                                       postDate: "1.7.1970",
                                       postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus dapibus leo id ex lacinia dapibus. Quisque nunc quam, mollis vel. ",
                                       newsImageNames: ["vasia", "dima", "misha"]),
        ]
    }
}

