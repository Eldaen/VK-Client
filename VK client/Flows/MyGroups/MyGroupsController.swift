//
//  MyGroupsController.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

/// Протокол Делегат для добавления группы в список моих групп
protocol MyGroupsDelegate: AnyObject {
	func groupDidSelect (name: String, id: Int)
}

/// Контроллер списка групп, в которых состоит пользователь
final class MyGroupsController: MyCustomUIViewController {
    
	/// Вью модель контроллера MyGroups
	private var viewModel: MyGroupsViewModelType
	
	private var myGroupsView: MyGroupsView {
		guard let view = self.view as? MyGroupsView else { return MyGroupsView() }
		return view
	}
	
	// MARK: - Init
	init(model: MyGroupsViewModelType) {
		self.viewModel = model
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
// MARK: - View controller life cycle
	
	override func loadView() {
		super.loadView()
		self.view = MyGroupsView()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		myGroupsView.searchBar.delegate = self
		
		configureNavigation()
		setupTableView()
		
		myGroupsView.spinner.startAnimating()
		
		viewModel.fetchGroups { [weak self] in
			self?.myGroupsView.spinner.stopAnimating()
			self?.myGroupsView.tableView.reloadData()
		}
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MyGroupsController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return viewModel.filteredGroups.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: MyGroupsCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
		viewModel.configureCell(cell: cell, index: indexPath.row)
		return cell
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			guard let cell = tableView.cellForRow(at: indexPath) as? MyGroupsCell,
				  let id = cell.id else {
				return
			}
			
			viewModel.leaveGroup(id: id, index: indexPath.row) { [weak self] result in
				if result == true {
					self?.myGroupsView.tableView.deleteRows(at: [indexPath], with: .fade)
					self?.viewModel.fetchGroups { }
				} else {
					self?.showLeavingError()
				}
			}
		}
	}
	
	func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
		return "Покинуть"
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		myGroupsView.tableView.deselectRow(at: indexPath, animated: true)
	}
}

// MARK: - Nav bar configuration
private extension MyGroupsController {
	
	// Конфигурируем Нав Бар
	func configureNavigation() {
		self.title = "Мои группы"
		
		let add = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(addGroup)
		)
		add.tintColor = .black
		navigationItem.rightBarButtonItem = add
	}
	
	// Конфигурируем ячейку
	func setupTableView() {
		myGroupsView.tableView.register(registerClass: MyGroupsCell.self)
		myGroupsView.tableView.dataSource = self
		myGroupsView.tableView.delegate = self
	}
	
	/// Запускает переход на экран со всеми группами
	@objc func addGroup() {
		let searchGroupsController = SearchGroupsController(model: Assembly.instance.searchGroupsViewModel)
		searchGroupsController.delegate = self
		navigationController?.pushViewController(searchGroupsController, animated: false)
	}
	
	/// Отображение ошибки о том, что не удалось выйти из группы
	func showLeavingError() {
		let alert = UIAlertController(title: "Ошибка",
									  message: "Не получилось выйти из группы", preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
}

// MARK: - Delegate for SearchGroupsController
extension MyGroupsController: MyGroupsDelegate {

	/// Запускает обновление списка групп он изменился
	func groupDidSelect(name: String, id: Int) {
		viewModel.addFirebaseUser(name: name, id: id)
		viewModel.fetchGroups() { [weak self] in
			self?.myGroupsView.tableView.reloadData()
		}
	}
}

// MARK: - UISearchBarDelegate
extension MyGroupsController: UISearchBarDelegate {
	
	/// Основной метод, который осуществляет поиск
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchBar.showsCancelButton = true
		viewModel.search(searchText) { [weak self] in
			self?.myGroupsView.tableView.reloadData()
		}
	}
	
	/// Отменяет поиск
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.showsCancelButton = false
		searchBar.text = nil
		searchBar.resignFirstResponder()
		
		viewModel.cancelSearch() { [weak self] in
			self?.myGroupsView.tableView.reloadData()
		}
	}
}
