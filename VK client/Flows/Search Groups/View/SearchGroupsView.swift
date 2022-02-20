//
//  SearchGroupsView.swift
//  VK client
//
//  Created by Денис Сизов on 20.02.2022.
//

import UIKit

/// Вью для SearchGroupsController
final class SearchGroupsView: UIView {
	
	// MARK: - Subviews
	
	/// Вью поиска
	public let searchBar: UISearchBar = {
		let searchBar = UISearchBar()
		searchBar.frame = .zero
		searchBar.searchBarStyle = UISearchBar.Style.default
		searchBar.isTranslucent = false
		searchBar.sizeToFit()
		return searchBar
	}()
	
	/// Таблица для найденных групп
	public let tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = .white
		return tableView
	}()
	
	/// Индикатор загрузки
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
	
	/// Конфигурирует UI
	private func configureUI () {
		addSubviews()
		setupSpinner()
		setupConstraints()
		setupTableView()
	}
	
	/// Добавляет сабвью на основную вью
	private func addSubviews() {
		self.addSubview(tableView)
		tableView.tableHeaderView = searchBar
	}
	
	/// Задаёт констрейнты таблице
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: self.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
		])
	}
	
	/// Конфигурирует спиннер загрузки
	private func setupSpinner() {
		spinner.center = self.center
	}
	
	private func setupTableView() {
		tableView.rowHeight = 80
	}
}
