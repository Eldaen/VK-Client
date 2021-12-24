//
//  demoNewsTableViewCellModel.swift
//  VK client
//
//  Created by Денис Сизов on 14.12.2021.
//

import UIKit.UIImage

struct demoNewsTableViewCellModel: Codable, NewsTableViewCellModelType {
	var source: NewsSourceProtocol = UserModel()
	var likesModel: LikesModel? = nil
	var views: Views? = nil
	var postID: Int = 0
	var postDate: String = "0"
	var postText: String = "Text"
	var newsImageModels: [Sizes] = []
	var collection: [UIImage] = []
	var link: Link?
	
	enum CodingKeys: String, CodingKey {
		case likesModel
		case views
		case postDate
		case postText
		case newsImageModels
	}
}
