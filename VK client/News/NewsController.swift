//
//  NewsController.swift
//  VK-Client
//
//  Created by Денис Сизов on 23.10.2021.
//

import UIKit

/// Контроллер новостей пользователя
final class NewsController: MyCustomUIViewController {
    
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .white
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
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
		
		viewModel.fetchNews { [weak self] in
			self?.tableView.reloadData()
		}
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension NewsController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.news.count // одна секция - одна новость
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	// отрисовываем ячейки
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell else {
			return UITableViewCell()
		}
		
		// конфигурируем ячейку
		viewModel.configureCell(cell: cell, index: indexPath.section)
		
		return cell
	}
	
	// Добавляем футер с лайк контролом
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		let footer = getFooter(for: section)
		return footer
	}
	
	// добавляем заголовок, чтобы визуально разграничить новости
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		//Создаём кастомную вьюху заголовка
		let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 5))
		header.backgroundColor = .gray
		
		return header
	}
	
	// правим высоту хэдера со стандартной до нужной
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		5
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		20
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
		
		tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
		tableView.showsVerticalScrollIndicator = false
		tableView.dataSource = self
		tableView.delegate = self
		
		self.view.addSubview(tableView)
	}
	
	/// Возвращает футер для новости
	func getFooter(for section: Int) -> UIView {
		
		let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
		
		let likeControl = LikeControl(frame: CGRect(x: 5, y: 0, width: 100, height: 20))
		likeControl.tintColor = .red
		
		let likes = viewModel.news[section].likesModel?.count
		likeControl.setLikes(with: likes ?? 0)
		
		let views = UILabel(frame: CGRect(x: footer.frame.size.width - 50, y: 0, width: 50, height: 20))
		views.font = UIFont.systemFont(ofSize: 18)
		
		let viewCount = viewModel.news[section].views?.count
		views.text =  "\(viewCount ?? 0)"
		
		footer.addSubview(likeControl)
		footer.addSubview(views)
		
		return footer
	}
}


