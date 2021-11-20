//
//  SearchGroupsController.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

final class SearchGroupsController: UIViewController {
	
	private let searchBar: UISearchBar = {
		let searchBar = UISearchBar()
		searchBar.frame = .zero
		searchBar.searchBarStyle = UISearchBar.Style.default
		searchBar.isTranslucent = false
		searchBar.sizeToFit()
		return searchBar
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .orange
		return tableView
	}()
	
	/// Делегат для добавления групп в список моих групп
	weak var delegate: MyGroupsDelegate?
	
	/// Загрузчик данных и обработчик запросов
	private var loader = GroupsService()
    
	private var groups: [GroupModel] = []
    lazy private var filteredGroups = groups

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
		setupTableView()
		setupConstraints()
		loadGroups()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchGroupsController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filteredGroups.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGroupsCell",
													   for: indexPath) as? SearchGroupsCell
		else {
			return UITableViewCell()
		}
		
		let name = filteredGroups[indexPath.row].name
		let image = filteredGroups[indexPath.row].image
		let id = filteredGroups[indexPath.row].id
		let isMember = filteredGroups[indexPath.row].isMember
		
		//Конфигурируем и возвращаем готовую ячейку
		cell.configure(name: name, image: UIImage(), id: id, isMember: isMember)
		
		// Ставим картинку на загрузку
		loader.loadImage(url: image) { image in
			DispatchQueue.main.async {
				cell.updateImage(with: image)
			}
		}
		
		return cell
	}
	
	/// По нажатию на ячейку группы, делает переход назад на список моих групп и через делегат передаёт выбранную группу
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? SearchGroupsCell,
			  let id = cell.id,
			  let isMember = cell.isMember else {
			return
		}
		
		// Если уже член группы, то вступать по клику не нужно
		if isMember == 1 {
			navigationController?.popViewController(animated: true)
			return
		}
	
		loader.joinGroup(id: id) { [weak self] result in
			if result == 1 {
				self?.delegate?.groupDidSelect()
				self?.navigationController?.popViewController(animated: true)
			}
		}
	}
}

// MARK: - UISearchBarDelegate
extension SearchGroupsController: UISearchBarDelegate {
	
	/// Основной метод, который осуществляет поиск
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
        // не случай повторных поисков
        filteredGroups = []
        
		loader.searchGroups(with: searchText) { [weak self] groups in
			DispatchQueue.main.async {
				self?.groups = groups
				self?.filteredGroups = groups
				self?.tableView.reloadData()
			}
		}
		
        // Перезагружаем данные
        self.tableView.reloadData()
    }
}

// MARK: - Private methods
private extension SearchGroupsController {
	
	/// Задаём констрейнты таблице
	func setupConstraints() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
		])
	}
	
	/// Конфигурируем ячейку
	func setupTableView() {
		tableView.frame = self.view.bounds
		tableView.rowHeight = 80
		tableView.register(SearchGroupsCell.self, forCellReuseIdentifier: "SearchGroupsCell")
		tableView.dataSource = self
		tableView.delegate = self
		
		self.view.addSubview(tableView)
		tableView.tableHeaderView = searchBar
	}
	
	// загружает текущий список групп
	func loadGroups() {
		loader.searchGroups(with: " ") { [weak self] groups in
			DispatchQueue.main.async {
				self?.groups = groups
				self?.filteredGroups = groups
				self?.tableView.reloadData()
			}
		}
	}
}
