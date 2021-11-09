//
//  User.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

// Делаем самые простые модели, т.к. они нам чисто показать данные, а потом можно их и переделать.
struct UserModel {
    let name: String
    let image: String
    let uiImage: UIImage
    var storedImages: [UIImage] = []
    
    init(name: String, image: String, storedImages: [String]) {
        self.name = name
        self.image = image
        
        uiImage = UIImage(named: image) ?? UIImage()
        
        // Собираем массив фоток юзера из имён фоток
        for storedImage in storedImages {
            guard let image = UIImage(named: storedImage) else { continue }
            self.storedImages.append(image)
        }
    }
}
