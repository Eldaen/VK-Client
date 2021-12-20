//
//  NewsAuthorCell.swift
//  VK client
//
//  Created by Денис Сизов on 20.12.2021.
//

import UIKit

/// Протокол ячейки автора новости для NewsController
protocol AuthorCellType {
	
	/// Конфигурирует ячейку данными для отображения
	func configure (with model: NewsTableViewCellModelType)
	
	/// Обновляет аватарку автора
	func updateProfileImage(with image: UIImage)
}

/// Ячейка для отображения новостей пользователя в контроллере NewsController
final class NewsAuthorCell: UITableViewCell, AuthorCellType {

	private let userImage: UIImageView = {
		let image = UIImageView()
		image.translatesAutoresizingMaskIntoConstraints = false
		return image
	}()
	
	private let userName: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 17)
		label.textColor = .black
		return label
	}()
	
	private let postDate: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 14)
		label.textColor = .black
		return label
	}()
	
	/// Массив картинок для отображения
	private var collection: [UIImage] = []
	
	/// Стандартная высота ячейки коллекции
	private var standard: NSLayoutConstraint?
	
	/// Ячейка коллекции, если картинок нет
	private var empty: NSLayoutConstraint?
	
	/// Модель новости, которую отображаем
	private var model: NewsTableViewCellModelType?
	
	/// Конфигурирует ячейку
	/// - Parameters:
	///   - model: Модель новости, которую нужно отобразить
	func configure (with model: NewsTableViewCellModelType) {
		setupCell()
		setupConstraints()
		updateCellData(with: model)
		self.model = model
		
		selectionStyle = .none
	}
	
	/// Устанавливает картинку профиля, после того как она загрузится
	func updateProfileImage(with image: UIImage) {
		userImage.image = image
		userImage.layoutIfNeeded()
		userImage.layer.cornerRadius = userImage.frame.size.width / 2
		userImage.layer.masksToBounds = true
	}
}

// MARK: - Private methods
private extension NewsAuthorCell {
	
	func setupConstraints() {
		
		NSLayoutConstraint.activate([
			userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			userImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			userImage.widthAnchor.constraint(equalToConstant: 60),
			userImage.heightAnchor.constraint(equalToConstant: 60),
			
			userName.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
			userName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
			userName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			
			postDate.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
			postDate.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 10),
		])
	}
	
	func setupCell() {
		contentView.addSubview(userImage)
		contentView.addSubview(userName)
		contentView.addSubview(postDate)
	}
	
	/// обновляет данные ячейки
	func updateCellData(with model: NewsTableViewCellModelType) {
		userImage.image = UIImage(named: model.source.image)
		userName.text = model.source.name
		postDate.text = model.postDate
	}
}
