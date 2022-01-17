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
	var date: Double
    var postText: String
	var shortText: String?
    var newsImageModels: [Sizes]
    var collection: [UIImage] = [] // у каждой table view должен быть массив ячеек коллекции для отображения картинок
	var link: Link?
    
	init(
		source: NewsSourceProtocol,
		postDate: String,
		date: Double,
		postText: String,
		shortText: String?,
		newsImageModels: [Sizes],
		postId: Int,
		likesModel: LikesModel? = nil,
		views: Views? = nil,
		link: Link? = nil
	) {
        self.source = source
        self.postDate = postDate
		self.date = date
        self.postText = postText
		self.shortText = shortText
		self.postID = postId
        self.newsImageModels = newsImageModels
		self.likesModel = likesModel
		self.views = views
		self.link = link
    }
}
