//
//  MyGroupsController.swift
//  test-gu
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

/// Контроллер списка групп, в которых состоит пользователь
final class MyGroupsController: UIViewController {
    
	/// Список групп, в которых состоит пользователь
    var myGroups = [GroupModel]()
	
	private var tableView: UITableView = {
		let tableView = UITableView(frame: .zero)
		tableView.backgroundColor = .orange
		return tableView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Задаём название экрана для TabBarViewController-a
		self.title = "Мои группы"
		
		// регистрируем ячейку и обозначаем MyGroupsController как dataSource и delegate для нашей таблицы
		tableView.frame = self.view.bounds
		tableView.register(MyGroupsCell.self, forCellReuseIdentifier: "MyGroupsCell")
		tableView.dataSource = self
		tableView.delegate = self
		
		self.view.addSubview(tableView)
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
	
	func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}

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


	// Override to support editing the table view.
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			myGroups.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
}
