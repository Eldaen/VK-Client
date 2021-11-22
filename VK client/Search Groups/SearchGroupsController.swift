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
	
	/// Загрузчик данных и обработчик запросов
	private var loader: GroupsLoader
    
	private var groups: [GroupModel] = []
    lazy private var filteredGroups = groups
	
	// MARK: - Init
	init(loader: GroupsLoader) {
		self.loader = loader
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
		loadGroups()
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
		let id = filteredGroups[indexPath.row].id
		let isMember = filteredGroups[indexPath.row].isMember
		
		//Конфигурируем и возвращаем готовую ячейку
		cell.configure(name: name, image: UIImage(), id: id, isMember: isMember)
		
		// Ставим картинку на загрузку
		loader.loadImage(url: image) { image in
			DispatchQueue.main.async {
				cell.setImage(with: image)
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
			showJoiningError()
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
		
		var query = searchText
		
		// Если отправить запрос с пустой строкой поиска, то оно не будет искать, так что ищем с пробелом
		if query == "" {
			query = " "
		}
        
		loader.searchGroups(with: query) { [weak self] groups in
			DispatchQueue.main.async {
				self?.groups = groups
				self?.filteredGroups = groups
				self?.tableView.reloadData()
			}
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
	
	// загружает текущий список групп
	func loadGroups() {
		loader.searchGroups(with: " ") { [weak self] groups in
			self?.groups = groups
			self?.filteredGroups = groups
			self?.tableView.reloadData()
		}
	}
	
	/// Отображение ошибки о том, что уже состоит в группе
	private func showJoiningError() {
		// Создаём контроллер
		let alter = UIAlertController(title: "Ошибка",
									  message: "Вы уже состоите в этой группе", preferredStyle: .alert)
		
		// Создаем кнопку для UIAlertController
		let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		
		// Добавляем кнопку на UIAlertController
		alter.addAction(action)
		
		// Показываем UIAlertController
		present(alter, animated: true, completion: nil)
	}
}
