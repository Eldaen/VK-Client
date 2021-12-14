//
//  NewsTableViewCellModelType.swift
//  VK client
//
//  Created by Денис Сизов on 13.12.2021.
//

import UIKit.UIImage

/// Протокол модели табличной ячейки новостей
protocol NewsTableViewCellModelType {
	var source: NewsSourceProtocol { get }
	var likesModel: LikesModel? { get }
	var views: Views? { get }
	var postID: Int { get }
	var postDate: String { get }
	var postText: String { get }
	var newsImageNames: [String] { get }
	var collection: [UIImage] { get }
}
