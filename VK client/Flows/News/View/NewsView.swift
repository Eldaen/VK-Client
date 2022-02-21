//
//  NewsView.swift
//  VK client
//
//  Created by Денис Сизов on 21.02.2022.
//

import UIKit

/// Вью для News Controller
final class NewsView: UIView {
	
	// MARK: Subviews
	
	public let tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .white
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.showsVerticalScrollIndicator = false
		return tableView
	}()
	
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
		setupSpinner()
	}
	
	/// Добавляет сабвью
	func addSubviews() {
		self.addSubview(tableView)
		self.addSubview(spinner)
	}
	
	/// Конфигурирует спиннер загрузки
	func setupSpinner() {
		spinner.center = self.center
	}
}
