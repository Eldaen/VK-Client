//
//  NewsTableViewCellModel.swift
//  VK-Client
//
//  Created by Денис Сизов on 25.10.2021.
//

import UIKit

struct NewsTableViewCellModel: NewsTableViewCellModelType {
    var source: NewsSourceProtocol
	var likesModel: LikesModel?
	var views: Views?
	var postID: Int
    var postDate: String
    var postText: String
    var newsImageModels: [Sizes]
    var collection: [UIImage] = [] // у каждой table view должен быть массив ячеек коллекции для отображения картинок
    
	init(
		source: NewsSourceProtocol, postDate: String,
		postText: String,
		newsImageModels: [Sizes],
		postId: Int,
		likesModel: LikesModel? = nil,
		views: Views? = nil
	) {
        self.source = source
        self.postDate = postDate
        self.postText = postText
		self.postID = postId
        self.newsImageModels = newsImageModels
		self.likesModel = likesModel
		self.views = views
    }
}
