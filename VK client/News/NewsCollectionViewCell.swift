//
//  NewsCollectionViewCell.swift
//  VK-Client
//
//  Created by Денис Сизов on 23.10.2021.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    
    func configure(with image: UIImage) {
        newsImage.image = image
    }

}
