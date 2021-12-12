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
		tableView.backgroundColor = .white
		return tableView
	}()
	
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
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
		setupTableView()
		setupConstraints()
		
		viewModel.fetchGroups { [weak self] in
			self?.tableView.reloadData()
		}
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchGroupsController: UITableViewDataSource, UITableViewDelegate {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.filteredGroups.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGroupsCell",
													   for: indexPath) as? SearchGroupsCell
		else {
			return UITableViewCell()
		}
		
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
			self?.tableView.deselectRow(at: indexPath, animated: true)
		}
	}
}

// MARK: - UISearchBarDelegate
extension SearchGroupsController: UISearchBarDelegate {
	
	/// Основной метод, который осуществляет поиск
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		viewModel.search(searchText) {
			self.tableView.reloadData()
		}
    }
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		viewModel.cancelSearch() {
			self.tableView.reloadData()
		}
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
