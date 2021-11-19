//
//  FriendCell.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
	
	/// Имя друга
	private let friendName: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 17)
		label.textColor = .black
		return label
	}()
    
	/// Вью для аватарки пользователя
	private let friendImage: AvatarView = {
		let avatar = AvatarView()
		avatar.translatesAutoresizingMaskIntoConstraints = false
		return avatar
	}()
    
    /// Функция конфигурации ячейки перед использованием
    func configure(name: String, image: UIImage) {
        friendName.text = name
        friendImage.image = image
		
		contentView.addSubview(friendName)
		contentView.addSubview(friendImage)
		
		setupConstaints()
        animate()
    }
	
	/// Меняет картинку, используется для замены после подгрузки из сети
	func updateImage(with image: UIImage) {
		friendImage.image = image
		self.layoutIfNeeded()
	}
    
    /// Запуск анимации ячейки
    func animate() {
        self.friendImage.alpha = 0
        self.frame.origin.x += 200
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.15,
                       options: [],
                       animations: {
            self.friendImage.alpha = 1
        })
        
        UIView.animate(withDuration: 0.7,
                       delay: 0.1,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
            self.frame.origin.x = 0
        })
    }
	
	private func setupConstaints() {
		NSLayoutConstraint.activate([
			friendName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			friendName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			
			friendImage.leadingAnchor.constraint(equalTo: friendName.trailingAnchor, constant: 20),
			friendImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			friendImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			friendImage.widthAnchor.constraint(equalToConstant: 60),
			friendImage.heightAnchor.constraint(equalTo: friendImage.widthAnchor, multiplier: 1.0),
		])
	}
}
