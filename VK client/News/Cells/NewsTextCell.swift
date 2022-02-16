//
//  NewsTextCell.swift
//  VK client
//
//  Created by Денис Сизов on 20.12.2021.
//

import UIKit

/// Протокол типа ячейки с текстом для NewsController
protocol NewsTextCellType {
	
	/// Конфигурирует ячейку данными для отображения
	func configure (with model: NewsTableViewCellModelType)
}

/// Ячейка для отображения новостей пользователя в контроллере NewsController
final class NewsTextCell: UITableViewCell, NewsTextCellType {
	
	private let postText: UILabel = {
		let text = UILabel()
		text.translatesAutoresizingMaskIntoConstraints = false
		text.lineBreakMode = .byWordWrapping
		text.numberOfLines = 0
		text.font = UIFont.fourteen
		text.textColor = .black
		return text
	}()
	
	private let button: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("показать полностью", for: .normal)
		button.setTitleColor(.blue, for: .normal)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()

	/// Модель новости, которую отображаем
	private var model: NewsTableViewCellModelType?
	
	/// Полный текст поста
	private var fullText: String?
	
	/// Укороченная версия текста поста
	private var shortText: String?
	
	private var shortTextState: Bool = false
	
	/// Делегат для обновления высоты ячейки текста
	var delegate: ShowMoreDelegate?
	
	/// IndexPath ячейки в таблице
	var indexPath: IndexPath = IndexPath()
	
	/// Конфигурирует ячейку NewsTableViewCell
	/// - Parameters:
	///   - model: Модель новости, которую нужно отобразить
	func configure (with model: NewsTableViewCellModelType) {
		setupCell()
		setupConstraints()
		updateCellData(with: model)
		self.model = model
		
		selectionStyle = .none
	}
	
	override func prepareForReuse() {
		shortText = nil
		fullText = nil
		shortTextState = false
		button.removeFromSuperview()
	}
}

// MARK: - Private methods
private extension NewsTextCell {
	
	func setupConstraints() {
		let bottomAnchor = postText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
		bottomAnchor.priority = .init(rawValue: 999)
		
		NSLayoutConstraint.activate([
			postText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			postText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			postText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			bottomAnchor,
		])
	}
	
	func setupCell() {
		contentView.addSubview(postText)
	}
	
	/// обновляет данные ячейки
	func updateCellData(with model: NewsTableViewCellModelType) {
		fullText = model.postText
		
		if let shortText = model.shortText {
			self.shortText = shortText
			
			showShortText()
			addShowMore()
			return
		}

		showFullText()
	}
	
	/// Добавляет кнопку ReadMore после текстового поля
	func addShowMore() {
		contentView.addSubview(button)
		button.addTarget(self, action: #selector(toggleText), for: .touchUpInside)
		
		NSLayoutConstraint.activate([
			button.topAnchor.constraint(equalTo: postText.bottomAnchor, constant: 10),
			button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
			button.heightAnchor.constraint(equalToConstant: 14),
		])
	}
	
	/// Переключает режим отображения текста поста
	@objc func toggleText() {
		if shortTextState == true {
			showFullText()
			button.setTitle("показать меньше", for: .normal)
		} else {
			showShortText()
			button.setTitle("показать полностью", for: .normal)
		}
		delegate?.updateTextHeight(indexPath: indexPath)
	}
	
	/// Отображает весь текст поста
	func showFullText() {
		postText.text = fullText
		shortTextState = false
	}
	
	/// Отображает укороченный текст поста
	func showShortText() {
		postText.text = shortText
		shortTextState = true
	}
}
