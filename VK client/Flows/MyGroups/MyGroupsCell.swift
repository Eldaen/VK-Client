//
//  MyGroupsCell.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

/// Ячейка группы для контроллера MyGroupsController
final class MyGroupsCell: UITableViewCell {
	
	/// ID группы, которую сейчас отображает ячейка
	var id: Int?
    
	/// Название группы
	let groupName: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	/// Логотип группы
	let groupImage: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		image.contentMode = .scaleAspectFit
		return image
	}()
	
	/// Меняет картинку, используется для замены после подгрузки из сети
	func setImage(with image: UIImage) {
		groupImage.image = image
		self.layoutIfNeeded()
	}
    
	/// Конфигурируем ячейку для отображения группы
	func configure(name: String, image: UIImage?, id: Int) {
        groupName.text = name
        groupImage.image = image
		self.id = id
		
		contentView.addSubview(groupName)
		contentView.addSubview(groupImage)
		
		setupConstaints()
		animate()
    }
	
	private func setupConstaints() {
		NSLayoutConstraint.activate([
			groupName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			groupName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			
			groupImage.leadingAnchor.constraint(equalTo: groupName.trailingAnchor, constant: 20),
			groupImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			groupImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			groupImage.widthAnchor.constraint(equalToConstant: 58),
			groupImage.heightAnchor.constraint(equalTo: groupImage.widthAnchor, multiplier: 1.0),
		])
	}
	
	/// Запуск анимацию ячейки
	func animate() {
		self.groupImage.alpha = 0
		self.groupName.alpha = 0
		
		UIView.animate(withDuration: 0.3,
					   delay: 0,
					   options: [],
					   animations: {
			self.groupImage.alpha = 1
			self.groupName.alpha = 1
		})
	}
}
