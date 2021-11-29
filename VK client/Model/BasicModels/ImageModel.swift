//
//  ImageModel.swift
//  VK client
//
//  Created by Денис Сизов on 29.11.2021.
//

import RealmSwift
import UIKit.UIImage

/// Модель картинки, нужна чтобы кэшировать в БД
class ImageModel: Object {
	@objc dynamic var url: URL
	@objc dynamic var image: UIImage
	
	init(url: URL, image: UIImage) {
		self.url = url
		self.image = image
	}
}
