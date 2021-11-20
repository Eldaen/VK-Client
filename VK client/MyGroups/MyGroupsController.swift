//
//  MyGroupsController.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

/// Контроллер списка групп, в которых состоит пользователь
final class MyGroupsController: UIViewController {
    
	/// Список групп, в которых состоит пользователь
    private var myGroups = [GroupModel]()
	
	/// Сервис по загрузке данных группv
	private let loader = GroupsService()
	
	/// Таблица с ячейками групп, в которых состоит пользователь
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .orange
		return tableView
	}()

	
// MARK: - View controller life cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		configureNavigation()
		setupTableView()
		setupConstraints()
		
		loader.loadGroups() { [weak self] groups in
			DispatchQueue.main.async {
				self?.myGroups = groups
				self?.tableView.reloadData()
			}
		}
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MyGroupsController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return myGroups.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as? MyGroupsCell else {
			return UITableViewCell()
		}

		let name = myGroups[indexPath.row].name
		let image = myGroups[indexPath.row].image
		
		//Конфигурируем и возвращаем готовую ячейку
		cell.configure(name: name, image: UIImage())
		
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
			myGroups.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
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
	
	/// Запускает переход на экран со всеми группами
	@objc func addGroup() {
		let searchGroupsController = SearchGroupsController()
		navigationController?.pushViewController(searchGroupsController, animated: true)
	}
	
	// Делаем pop контроллера
	@objc func logout() {
		navigationController?.pushViewController(LoginController(), animated: true)
	}
}
