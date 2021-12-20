//
//  NewsFooterCell.swift
//  VK client
//
//  Created by Денис Сизов on 20.12.2021.
//

import UIKit

/// Протокол ячейки футера новости для NewsController
protocol NewsFooterCellType {
	
	/// Конфигурирует ячейку данными для отображения
	func configure (with model: NewsTableViewCellModelType)
	
	/// Обработчик лайков
	var likesResponder: NewsViewModelType? { get set }
}

/// Ячейка для отображения новостей пользователя в контроллере NewsController
final class NewsFooterCell: UITableViewCell, NewsFooterCellType {

	private let footerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let footerHorizontalStack: UIStackView = {
		let stack = UIStackView()
		stack.axis = .horizontal
		stack.distribution = .equalSpacing
		stack.contentMode = .center
		stack.translatesAutoresizingMaskIntoConstraints = false
		return stack
	}()
	
	private let likesControl: LikeControl = {
		let likeControl = LikeControl(frame: .zero)
		likeControl.tintColor = .red
		return likeControl
	}()
	
	private let viewsLabel: UILabel = {
		let views = UILabel()
		views.font = UIFont.systemFont(ofSize: 14)
		return views
	}()

	/// Модель новости, которую отображаем
	private var model: NewsTableViewCellModelType?
	
	/// Вью модель
	var likesResponder: NewsViewModelType?
	
	/// Конфигурирует ячейку NewsTableViewCell
	/// - Parameters:
	///   - model: Модель новости, которую нужно отобразить
	func configure (with model: NewsTableViewCellModelType) {
		setupCell()
		setupFooter()
		setupConstraints()
		updateCellData(with: model)
		self.model = model
		
		selectionStyle = .none
		likesControl.setLikesResponder(responder: self)
	}
}

// MARK: - Private methods
private extension NewsFooterCell {
	
	func setupConstraints() {
		
		NSLayoutConstraint.activate([
			footerView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
			footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			footerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			footerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			footerView.heightAnchor.constraint(equalToConstant: 30),
			
			footerHorizontalStack.widthAnchor.constraint(equalTo: footerView.widthAnchor),
		])
	}
	
	func setupCell() {
		contentView.addSubview(footerView)
	}
	
	/// Конфигурируем футер
	func setupFooter() {
		footerHorizontalStack.addArrangedSubview(likesControl)
		footerHorizontalStack.addArrangedSubview(viewsLabel)
		footerView.addSubview(footerHorizontalStack)
	}
	
	/// обновляет данные ячейки
	func updateCellData(with model: NewsTableViewCellModelType) {
		likesControl.setLikes(with: model.likesModel?.count ?? 0)
		viewsLabel.text = "🔍 \(model.views?.count ?? 0)"
	}
}

// MARK: - CanLike protocol extension

extension NewsFooterCell: CanLike {
	
	///  Отправляет запрос на лайк поста
	func setLike() {
		if let id = model?.postID,
		   let ownerId = model?.source.id {
			likesResponder?.setLike(post: id, owner: ownerId) { [weak self] result in
				self?.likesControl.setLikes(with: result)
			}
		}
	}
	
	/// Отправляет запрос на отмену лайка
	func removeLike() {
		if let id = model?.postID,
		   let ownerId = model?.source.id {
			likesResponder?.setLike(post: id, owner: ownerId) { [weak self] result in
				self?.likesControl.setLikes(with: result)
			}
		}
	}
}
