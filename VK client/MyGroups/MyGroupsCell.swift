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
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	/// Логотип группы
	lazy var groupImage: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		image.contentMode = .scaleAspectFit
		return image
	}()
    
	/// Конфигурируем ячейку для отображения группы
    func configure(name: String, image: UIImage?) {
        groupName.text = name
        groupImage.image = image
		
		self.contentView.addSubview(groupName)
		self.contentView.addSubview(groupImage)
		
		NSLayoutConstraint.activate([
			groupName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			groupName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 10),
			
			groupImage.leadingAnchor.constraint(equalTo: groupName.trailingAnchor, constant: 20),
			groupImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			groupImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			groupImage.widthAnchor.constraint(equalToConstant: 58),
			groupImage.heightAnchor.constraint(equalTo: groupImage.widthAnchor, multiplier: 1.0),
		])
    }
}
