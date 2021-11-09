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
    
    private var groups = GroupsLoader.iNeedGroups()
    lazy private var filteredGroups = groups
	
	/// Делегат для добавления групп в список моих групп
	weak var delegate: MyGroupsController?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
		setupTableView()
		setupConstraints()
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
		
		//Конфигурируем и возвращаем готовую ячейку
		cell.configure(name: name, image: UIImage(named: image))
		
		return cell
	}
	
	/// По нажатию на ячейку группы, делает переход назад на список моих групп и через делегат передаёт выбранную группу
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let group = filteredGroups[indexPath.row]
		delegate?.groupDidSelect(group)
		navigationController?.popViewController(animated: true)
	}
}

// MARK: - UISearchBarDelegate
extension SearchGroupsController: UISearchBarDelegate {
	
	/// Основной метод, который осуществляет поиск
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
        // не случай повторных поисков
        filteredGroups = []
        
        // Если строка поиска пустая, то показываем все группы
        if searchText == "" {
            filteredGroups = groups
        } else {
			
            //По сравнению с друзьями, тут вообще всё просто. Если в именни группы есть нужный текст, то добавляем в фильтр
            for group in groups {
                if group.name.lowercased().contains(searchText.lowercased()) {
                    filteredGroups.append(group)
                }
            }
        }
		
        // Перезагружаем данные
        self.tableView.reloadData()
    }
}

// MARK: - Private methods
extension SearchGroupsController {
	
	/// Задаём констрейнты таблице
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
		])
	}
	
	/// Конфигурируем ячейку
	private func setupTableView() {
		tableView.frame = self.view.bounds
		tableView.rowHeight = 80
		tableView.register(SearchGroupsCell.self, forCellReuseIdentifier: "SearchGroupsCell")
		tableView.dataSource = self
		tableView.delegate = self
		
		self.view.addSubview(tableView)
		tableView.tableHeaderView = searchBar
	}
}
