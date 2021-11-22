//
//  NewsController.swift
//  VK-Client
//
//  Created by Денис Сизов on 23.10.2021.
//

import UIKit

/// Контроллер новостей пользователя
final class NewsController: UIViewController {
    
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .white
		tableView.translatesAutoresizingMaskIntoConstraints = false
		return tableView
	}()
	
    private let news = NewsService.iNeedNews()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.reloadData()
    }
}

extension NewsController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return news.count // одна секция - одна новость
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return 1
	}
	
	// отрисовываем ячейки
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell else {
			return UITableViewCell()
		}
		
		// конфигурируем ячейку
		cell.configure(with: news[indexPath.section])
		
		return cell
	}
	
	// Добавляем футер с лайк контролом
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		//Создаём кастомную вьюху заголовка
		let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
		
		let likeControl = LikeControl(frame: CGRect(x: 5, y: 0, width: 50, height: 20))
		likeControl.tintColor = .red
		
		let views = UILabel(frame: CGRect(x: footer.frame.size.width - 50, y: 0, width: 50, height: 20))
		views.text = "42"
		views.font = UIFont.systemFont(ofSize: 18)
		
		footer.addSubview(likeControl)
		footer.addSubview(views)
		
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
}


