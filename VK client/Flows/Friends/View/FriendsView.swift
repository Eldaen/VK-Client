//
//  FriendsView.swift
//  VK client
//
//  Created by Денис Сизов on 21.02.2022.
//

import UIKit

/// Вью для контроллера FriendsViewController
final class FriendsView: UIView {
	// MARK: - Subviews
	
	/// Строка поиска
	public let searchBar: UISearchBar = {
		let searchBar = UISearchBar()
		searchBar.frame = .zero
		searchBar.searchBarStyle = UISearchBar.Style.default
		searchBar.isTranslucent = false
		searchBar.placeholder = "Искать"
		searchBar.sizeToFit()
		return searchBar
	}()
	
	/// Таблица для отображения друзей
	public let tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = .white
		return tableView
	}()
	
	/// Инликатор загрузки
	public let spinner: UIActivityIndicatorView = {
		let spinner = UIActivityIndicatorView(style: .medium)
		spinner.color = .black
		return spinner
	}()
	
	// MARK: - Init
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.configureUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.configureUI()
	}
	
	// MARK: - UI
	
	/// Конфигурирует вью
	private func configureUI() {
		addSubviews()
		setupTableView()
		setupSpinner()
		setupConstraints()
	}
	
	/// Конфигурирует таблицу
	private func setupTableView() {
		tableView.rowHeight = 70
		tableView.showsVerticalScrollIndicator = false
		tableView.sectionHeaderTopPadding = 0
		tableView.sectionIndexColor = .black
	}
	
	/// Конфигурирует спиннер загрузки
	func setupSpinner() {
		spinner.center = self.center
	}
	
	/// Добавляет сабвью на основную вью
	private func addSubviews() {
		self.addSubview(tableView)
		self.addSubview(spinner)
		tableView.tableHeaderView = searchBar
	}
	
	/// Задаёт констрейнты таблице
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: self.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: self.rightAnchor)
		])
	}
}
