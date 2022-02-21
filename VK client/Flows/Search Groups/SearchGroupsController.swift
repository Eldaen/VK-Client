//
//  SearchGroupsController.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

final class SearchGroupsController: UIViewController {
	
	private var groupsView: SearchGroupsView {
		guard let view = self.view as? SearchGroupsView else { return SearchGroupsView() }
		return view
	}
	
	/// Делегат для добавления групп в список моих групп
	weak var delegate: MyGroupsDelegate?
	
	/// Вью модель
	var viewModel: SearchGroupsViewModelType
	
	// MARK: - Init
	init(model: SearchGroupsViewModelType) {
		self.viewModel = model
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View controller life cycle
	
	override func loadView() {
		super.loadView()
		self.view = SearchGroupsView()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		groupsView.searchBar.delegate = self
		setupTableView()
		
		groupsView.spinner.startAnimating()
		
		viewModel.fetchGroups { [weak self] in
			self?.groupsView.spinner.stopAnimating()
			self?.groupsView.tableView.reloadData()
		}
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchGroupsController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.filteredGroups.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: SearchGroupsCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
		viewModel.configureCell(cell: cell, index: indexPath.row)
		return cell
	}
	
	/// По нажатию на ячейку группы, делает переход назад на список моих групп и через делегат передаёт выбранную группу
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? SearchGroupsCell,
			  let id = cell.id,
			  let name = cell.name else {
			return
		}
		
		viewModel.joinGroup(id: id, index: indexPath.row) { [weak self] result in
			if result == true {
				self?.delegate?.groupDidSelect(name: name, id: id)
				self?.navigationController?.popViewController(animated: true)
			} else {
				self?.showJoiningError()
			}
			self?.groupsView.tableView.deselectRow(at: indexPath, animated: true)
		}
	}
}

// MARK: - UISearchBarDelegate
extension SearchGroupsController: UISearchBarDelegate {
	
	/// Основной метод, который осуществляет поиск
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchBar.showsCancelButton = true
		viewModel.search(searchText) { [weak self] in
			self?.groupsView.tableView.reloadData()
		}
    }
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.showsCancelButton = false
		searchBar.text = nil
		searchBar.resignFirstResponder() // скрыть клавиатуру
		
		viewModel.cancelSearch() { [weak self] in
			self?.groupsView.tableView.reloadData()
		}
	}
}

// MARK: - Private methods
private extension SearchGroupsController {
	
	/// Конфигурируем ячейку
	func setupTableView() {
		groupsView.tableView.register(registerClass: SearchGroupsCell.self)
		groupsView.tableView.dataSource = self
		groupsView.tableView.delegate = self
	}
	
	/// Отображение ошибки о том, что уже состоит в группе
	func showJoiningError() {
		// Создаём контроллер
		let alert = UIAlertController(title: "Ошибка",
									  message: "Не получилось вступить", preferredStyle: .alert)
		
		// Создаем кнопку для UIAlertController
		let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		
		// Добавляем кнопку на UIAlertController
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
}
