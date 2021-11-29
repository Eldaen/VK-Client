//
//  ImageModel.swift
//  VK client
//
//  Created by Денис Сизов on 29.11.2021.
//

import RealmSwift
import UIKit.UIImage
import UIKit

/// Модель картинки, нужна чтобы кэшировать в БД
class ImageModel: Object {
	@objc dynamic var url: String = ""
	@objc dynamic var image: UIImage = UIImage()
	
	override static func primaryKey() -> String? {
		return "url"
	}
	
	override static func indexedProperties() -> [String] {
		return ["url"]
	}
}
