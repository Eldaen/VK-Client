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
	
	/// Таблица с ячейками групп, в которых состоит пользователь
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .orange
		return tableView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		configureNavigation()
		setupTableView()
		setupConstraints()
    }
    // Это метод, который принимает unwind seague из SearchGroups при клике на группу
//    @IBAction func addGroup(segue: UIStoryboardSegue) {
//        // Проверяем идентификатор, чтобы убедиться, что это нужный переход
//        if segue.identifier == "addGroup" {
//            // Получаем ссылку на контроллер, с которого осуществлен переход
//            guard let searchGroupsController = segue.source as? SearchGroupsController else {
//                return
//            }
//
//            // Получаем название группы + Картинку и кладём в myGroups для последующей отрисовки
//            if let indexPath = searchGroupsController.tableView.indexPathForSelectedRow {
//                let group = searchGroupsController.groups[indexPath.row]
//
//                // Если такой группы ещё нет, то добавляем
//                if !myGroups.contains(group) {
//                    myGroups.append(group)
//                    tableView.reloadData()
//                }
//            }
//        }
//    }
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
		cell.configure(name: name, image: UIImage(named: image))

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
		searchGroupsController.delegate = self
		navigationController?.pushViewController(searchGroupsController, animated: true)
	}
	
	// Делаем pop контроллера
	@objc func logout() {
		navigationController?.pushViewController(LoginController(), animated: true)
	}
}

// MARK: - Delegate for SearchGroupsController
extension MyGroupsController {
	
	/// Принимает выбранную группу в контроллере моих групп и добавляет её в список
	func groupDidSelect (_ group: GroupModel) {
		if !myGroups.contains(group) {
			myGroups.append(group)
			tableView.reloadData()
		}
	}
}
