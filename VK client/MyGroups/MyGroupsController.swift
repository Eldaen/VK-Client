//
//  MyGroupsController.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

/// Протокол Делегат для добавления группы в список моих групп
protocol MyGroupsDelegate: AnyObject {
	func groupDidSelect ()
}

/// Контроллер списка групп, в которых состоит пользователь
final class MyGroupsController: UIViewController {
    
	/// Список групп, в которых состоит пользователь
    private var myGroups = [GroupModel]()
	
	lazy private var filteredGroups = myGroups
	
	/// Сервис по загрузке данных группv
	private let loader = GroupsService()
	
	/// Таблица с ячейками групп, в которых состоит пользователь
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .orange
		return tableView
	}()
	
	private let searchBar: UISearchBar = {
		let searchBar = UISearchBar()
		searchBar.frame = .zero
		searchBar.searchBarStyle = UISearchBar.Style.default
		searchBar.isTranslucent = false
		searchBar.sizeToFit()
		return searchBar
	}()

	
// MARK: - View controller life cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		searchBar.delegate = self
		
		configureNavigation()
		setupTableView()
		setupConstraints()
		loadGroups()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MyGroupsController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return filteredGroups.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as? MyGroupsCell else {
			return UITableViewCell()
		}

		let name = filteredGroups[indexPath.row].name
		let image = filteredGroups[indexPath.row].image
		let id = filteredGroups[indexPath.row].id
		
		//Конфигурируем и возвращаем готовую ячейку
		cell.configure(name: name, image: UIImage(), id: id)
		
		// Ставим картинку на загрузку
		loader.loadImage(url: image) { image in
			DispatchQueue.main.async {
				cell.updateImage(with: image)
			}
		}

		return cell
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			guard let cell = tableView.cellForRow(at: indexPath) as? MyGroupsCell,
				  let id = cell.id else {
				return
			}
			
			loader.leaveGroup(id: id) { [weak self] result in
				if result == 1 {
					DispatchQueue.main.async {
						self?.myGroups.remove(at: indexPath.row)
						self?.filteredGroups.remove(at: indexPath.row)
						self?.tableView.deleteRows(at: [indexPath], with: .fade)
					}
				}
			}
		}
	}
}

// MARK: - Nav bar configuration
private extension MyGroupsController {
	
	// Конфигурируем Нав Бар
	private func configureNavigation() {
		self.title = "Мои группы"
		
		let add = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addGroup)
		)
		add.tintColor = .white
		navigationItem.rightBarButtonItem = add
		
		let logout = UIBarButtonItem(
			title: "Logout",
			style: .plain,
			target: self,
			action: #selector(logout)
		)
		logout.tintColor = .white
		navigationItem.leftBarButtonItem = logout
	}
	
	// Конфигурируем ячейку
	private func setupTableView() {
		tableView.frame = self.view.bounds
		tableView.rowHeight = 80
		tableView.register(MyGroupsCell.self, forCellReuseIdentifier: "MyGroupsCell")
		tableView.dataSource = self
		tableView.delegate = self
		tableView.tableHeaderView = searchBar
		
		self.view.addSubview(tableView)
		
	}
	
	// Задаём констрейнты таблице
	func setupConstraints() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
		])
	}
	
	// Загружает текущий список групп
	func loadGroups() {
		loader.loadGroups() { [weak self] groups in
			DispatchQueue.main.async {
				self?.myGroups = groups
				self?.filteredGroups = groups
				self?.tableView.reloadData()
			}
		}
	}
	
	/// Запускает переход на экран со всеми группами
	@objc func addGroup() {
		let searchGroupsController = SearchGroupsController()
		searchGroupsController.delegate = self
		navigationController?.pushViewController(searchGroupsController, animated: true)
	}
	
	// Делаем pop контроллера
	@objc func logout() {
		navigationController?.pushViewController(LoginController(), animated: true)
	}
}

// MARK: - Delegate for SearchGroupsController
extension MyGroupsController: MyGroupsDelegate {

	/// Принимает выбранную группу в контроллере моих групп и добавляет её в список
	func groupDidSelect() {
		DispatchQueue.main.async { [weak self] in
			self?.loadGroups()
		}
	}
}

// MARK: - UISearchBarDelegate
extension MyGroupsController: UISearchBarDelegate {
	
	/// Основной метод, который осуществляет поиск
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		// не случай повторных поисков
		filteredGroups = []
		
		// Если строка поиска пустая, то показываем все группы
		if searchText == "" {
			filteredGroups = myGroups
		} else {
			
			//По сравнению с друзьями, тут вообще всё просто. Если в именни группы есть нужный текст, то добавляем в фильтр
			for group in myGroups {
				if group.name.lowercased().contains(searchText.lowercased()) {
					filteredGroups.append(group)
				}
			}
		}
		
		// Перезагружаем данные
		self.tableView.reloadData()
	}
}
