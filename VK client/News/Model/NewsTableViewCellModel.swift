//
//  NewsTableViewCellModel.swift
//  test-gu
//
//  Created by Денис Сизов on 25.10.2021.
//

import UIKit

struct NewsTableViewCellModel {
    var user: UserModel
    var postDate: String
    var postText: String
    var newsImageNames: [String]
    var collection: [NewsCollectionViewCellModel] = [] // у каждой table view должен быть массив ячеек коллекции для отображения картинок
    
    init(user: UserModel, postDate: String, postText: String, newsImageNames: [String]) {
        self.user = user
        self.postDate = postDate
        self.postText = postText
        self.newsImageNames = newsImageNames
        
        // создаём массив моделей коллекций и создаём им картинки из имён
        for newsImage in newsImageNames {
            guard let image = UIImage(named: newsImage) else { continue }
            self.collection.append(NewsCollectionViewCellModel(image: image))
        }
    }
}
