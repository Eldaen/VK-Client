//
//  MyGroupsCell.swift
//  VK Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

/// Ячейка группы для контроллера MyGroupsController
class MyGroupsCell: UITableViewCell {
    
	/// Название группы
	lazy var groupName: UILabel = {
		let label = UILabel()
		return label
	}()
	
	/// Логотип группы
	lazy var groupImage: UIImageView = {
		let image = UIImageView()
		return image
	}()
    
	/// Конфигурируем ячейку для отображения группы
    func configure(name: String, image: UIImage?) {
        groupName.text = name
        groupImage.image = image
		
		self.contentView.addSubview(groupName)
		self.contentView.addSubview(groupImage)
		
		NSLayoutConstraint.activate([
			groupName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			groupName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			
			groupImage.leadingAnchor.constraint(equalTo: groupName.trailingAnchor, constant: 20),
			groupImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			groupImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			groupImage.widthAnchor.constraint(equalToConstant: 58),
			groupImage.heightAnchor.constraint(equalTo: groupImage.widthAnchor, multiplier: 1.0),
		])
    }
}
