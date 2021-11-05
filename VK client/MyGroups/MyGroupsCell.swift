//
//  MyGroupsCell.swift
//  test-gu
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

/// Ячейка группы для контроллера MyGroupsController
class MyGroupsCell: UITableViewCell {
    
	/// Название группы
	var groupName: UILabel = {
		let label = UILabel()
		return label
	}()
	
	/// Логотип группы
	var groupImage: UIImageView = {
		let image = UIImageView()
		return image
	}()
    
	/// Конфигурируем ячейку для отображения группы
    func configure(name: String, image: UIImage?) {
        groupName.text = name
        groupImage.image = image
    }
}
