//
//  User.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

/// Модель пользователя
struct UserModel: Codable {
    let name: String
    let image: String
	//let uiImage: UIImage
    //var storedImages: [UIImage] = []
	
	/// Перечисление соответствия полям в АПИ к полям в нашей модели
	enum CodingKeys: String, CodingKey {
		case name = "first_name"
		case image = "photo_50"
	}
    
//    init(name: String, image: String, storedImages: [String]) {
//        self.name = name
//        self.image = image
//
//        uiImage = UIImage(named: image) ?? UIImage()
//
//        // Собираем массив фоток юзера из имён фоток
//        for storedImage in storedImages {
//            guard let image = UIImage(named: storedImage) else { continue }
//            self.storedImages.append(image)
//        }
//    }
}
