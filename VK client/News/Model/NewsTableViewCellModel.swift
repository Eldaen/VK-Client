//
//  NewsTableViewCellModel.swift
//  VK-Client
//
//  Created by Денис Сизов on 25.10.2021.
//

import UIKit

struct NewsTableViewCellModel {
    var source: NewsSourceProtocol
	var likesModel: LikesModel?
	var views: Views?
    var postDate: String
    var postText: String
    var newsImageNames: [String]
    var collection: [UIImage] = [] // у каждой table view должен быть массив ячеек коллекции для отображения картинок
    
	init(
		source: NewsSourceProtocol, postDate: String,
		postText: String,
		newsImageNames: [String],
		likesModel: LikesModel? = nil,
		views: Views? = nil
	) {
        self.source = source
        self.postDate = postDate
        self.postText = postText
        self.newsImageNames = newsImageNames
		self.likesModel = likesModel
		self.views = views
    }
}
