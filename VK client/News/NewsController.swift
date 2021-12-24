//
//  NewsController.swift
//  VK-Client
//
//  Created by Денис Сизов on 23.10.2021.
//

import UIKit

/// Контроллер новостей пользователя
final class NewsController: MyCustomUIViewController {
	
	/// Типы ячеек, из которых состоит секция новости
	enum NewsCells {
		case author
		case text
		case collection
		case footer
		case link
	}
	
	/// Количество ячеек в секции новости
	private let cellsCount: Int = 4
	
	/// Количество ячеек в секции новости, если есть ссылка
	private let cellsWithLink: Int = 5
    
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .white
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()
	
	private let spinner: UIActivityIndicatorView = {
		let spinner = UIActivityIndicatorView(style: .medium)
		spinner.color = .black
		return spinner
	}()
	
	private var viewModel: NewsViewModelType
	
	init(model: NewsViewModelType) {
		viewModel = model
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
// MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.reloadData()
		tableView.separatorStyle = .none
		
		setupSpinner()
		spinner.startAnimating()
		
		viewModel.fetchNews { [weak self] in
			self?.spinner.stopAnimating()
			self?.tableView.reloadData()
		}
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension NewsController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.news.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if checkLink(for: section) {
			return cellsWithLink
		} else {
			return cellsCount
		}
	}
	
	// отрисовываем ячейки
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell = UITableViewCell()
		guard let type = getCellType(for: indexPath) else { return UITableViewCell () }
		
		switch type {
		case .author:
			guard let authorCell = tableView.dequeueReusableCell(withIdentifier: NewsAuthorCell.reuseIdentifier,
																 for: indexPath) as? NewsAuthorCell else {
				return UITableViewCell()
			}
			cell = authorCell
		case .text:
			guard let textCell = tableView.dequeueReusableCell(withIdentifier: NewsTextCell.reuseIdentifier,
															   for: indexPath) as? NewsTextCell else {
				return UITableViewCell()
			}
			cell = textCell
		case .collection:
			guard let collectionCell = tableView.dequeueReusableCell(withIdentifier: NewsCollectionCell.reuseIdentifier,
																	 for: indexPath) as? NewsCollectionCell else {
				return UITableViewCell()
			}
			cell = collectionCell
		case .footer:
			guard let footerCell = tableView.dequeueReusableCell(withIdentifier: NewsFooterCell.reuseIdentifier,
																 for: indexPath) as? NewsFooterCell else {
				return UITableViewCell()
			}
			cell = footerCell
		case .link:
			guard let linkCell = tableView.dequeueReusableCell(withIdentifier: NewsLinkCell.reuseIdentifier,
															   for: indexPath) as? NewsLinkCell else {
				return UITableViewCell()
			}
			cell = linkCell
		}
		
		// конфигурируем ячейку
		viewModel.configureCell(cell: cell, index: indexPath.section, type: type)
		
		return cell
	}
	
	// добавляем заголовок, чтобы визуально разграничить новости
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		//Создаём кастомную вьюху заголовка
		let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 5))
		header.backgroundColor = .gray
		
		return header
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.item == 2 {
			if let height = viewModel.news[indexPath.section].newsImageModels.first?.height,
			   let width = viewModel.news[indexPath.section].newsImageModels.first?.width {
				let aspectRatio = Double(height) / Double(width)
				return tableView.bounds.width * CGFloat(aspectRatio)
			} else {
				return UITableView.automaticDimension
			}
		} else {
			return UITableView.automaticDimension
		}
	}
	
	// правим высоту хэдера со стандартной до нужной
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		5
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.tableView.deselectRow(at: indexPath, animated: true)
	}
}

// MARK: - Private methods
private extension NewsController {
	
	/// Конфигурируем TableView
	func setupTableView() {
		tableView.frame = self.view.bounds
		
		tableView.register(NewsAuthorCell.self, forCellReuseIdentifier: NewsAuthorCell.reuseIdentifier)
		tableView.register(NewsTextCell.self, forCellReuseIdentifier: NewsTextCell.reuseIdentifier)
		tableView.register(NewsCollectionCell.self, forCellReuseIdentifier: NewsCollectionCell.reuseIdentifier)
		tableView.register(NewsFooterCell.self, forCellReuseIdentifier: NewsFooterCell.reuseIdentifier)
		tableView.register(NewsLinkCell.self, forCellReuseIdentifier: NewsLinkCell.reuseIdentifier)
		tableView.showsVerticalScrollIndicator = false
		tableView.dataSource = self
		tableView.delegate = self
		
		self.view.addSubview(tableView)
	}
	
	/// Конфигурирует спиннер загрузки
	func setupSpinner() {
		self.view.addSubview(spinner)
		spinner.center = self.view.center
	}
	
	/// Проверяет наличие ссылки в новости
	func checkLink(for section: Int) -> Bool {
		return (viewModel.news[section].link) != nil
	}
	
	func getCellType(for item: IndexPath) -> NewsCells? {
		switch item.item {
		case 0:
			return .author
		case 1:
			return .text
		case 2:
			return .collection
		case 3:
			if checkLink(for: item.section) {
				return .link
			} else {
				return .footer
			}
		case 4:
			return .footer
		default:
			print("Some News Table view issue")
			return nil
		}
	}
}


