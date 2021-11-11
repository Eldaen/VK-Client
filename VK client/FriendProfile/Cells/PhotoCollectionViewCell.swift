//
//  PhotoCollectionViewCell.swift
//  VK-Client
//
//  Created by Денис Сизов on 29.10.2021.
//

import UIKit

/// Ячейка для коллекции профиля пользователя
final class PhotoCollectionViewCell: UICollectionViewCell {
	
	/// Основная вью с картинкой
	private let photoView: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		image.contentMode = .scaleAspectFit
		return image
	}()
	
	/// Конфигурирует ячейку
	func configure(with image: UIImage) {
		contentView.addSubview(photoView)
		photoView.image = image
		setupConstraints()
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
			photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
		])
	}
}
