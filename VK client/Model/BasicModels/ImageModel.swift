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
class ImageModel {
	var url: String = ""
	var image: UIImage = UIImage()
}
