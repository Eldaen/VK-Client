//
//  FriendsViewController.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

/// Отображает список всех пользователей
final class FriendsViewController: MyCustomUIViewController {
	
	private let searchBar: UISearchBar = {
		let searchBar = UISearchBar()
		searchBar.frame = .zero
		searchBar.searchBarStyle = UISearchBar.Style.default
		searchBar.isTranslucent = false
		searchBar.placeholder = "Искать"
		searchBar.sizeToFit()
		return searchBar
	}()
	
	private let tableView: UITableView = {
		let tableView = UITableView()
		tableView.backgroundColor = .white
		return tableView
	}()
	
	/// Вью модель контроллера Friends
	private var viewModel: FriendsViewModelType
	
	/// Ячейки, которые нужно анимировать при появлении
	private var cellsForAnimate: [FriendsTableViewCell] = []
	
	/// Фото профиля
	var profileImage: UIImage?
	
	// Вынес сюда closure анимации, чтобы 2 раза не повторять код.
	private func searchBarAnimationClosure () -> () -> Void {
		
		return {
			guard let scopeView = self.searchBar.searchTextField.leftView else { return }
			guard let placeholderLabel = self.searchBar.textField?.value(forKey: "placeholderLabel") as? UILabel else {
				return
			}
			
			UIView.animate(withDuration: 0.3,
						   animations: {
				scopeView.frame = CGRect(x: self.searchBar.frame.width / 2 - 15,
										 y: scopeView.frame.origin.y,
										 width: scopeView.frame.width,
										 height: scopeView.frame.height)
				
				let xPosition = placeholderLabel.frame.origin.x
				
				if xPosition > 20 {
					placeholderLabel.frame.origin.x -= 20
				}
				self.searchBar.layoutSubviews()
			})
		}
	}
	
	// MARK: - Init
	
	init(model: FriendsViewModelType) {
		self.viewModel = model
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View controller life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		setupConstraints()
		
		viewModel.fetchFriends { [weak self] in
			self?.tableView.reloadData()
		}
	}
}

// MARK: UISearchBarDelegate
extension FriendsViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		viewModel.search(searchText) {
			self.tableView.reloadData()
		}
	}
	
	// отмена поиска (через кнопку Cancel)
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		self.searchBar.showsCancelButton = true // показыть кнопку Cancel
		
		let cBtn = searchBar.value(forKey: "cancelButton") as! UIButton
		cBtn.backgroundColor = .red
		cBtn.setTitleColor(.white, for: .normal)
		
		UIView.animate(withDuration: 0.3,
					   animations: {
			
			// двигаем кнопку cancel
			cBtn.frame = CGRect(x: cBtn.frame.origin.x - 50,
								y: cBtn.frame.origin.y,
								width: cBtn.frame.width,
								height: cBtn.frame.height
			)
			
			// анимируем запуск поиска. -1 чтобы пошла анимация, тогда лупа плавно откатывается О_о
			self.searchBar.frame = CGRect(x: self.searchBar.frame.origin.x,
										  y: self.searchBar.frame.origin.y,
										  width: self.searchBar.frame.size.width - 1,
										  height: self.searchBar.frame.size.height
			)
			
			self.searchBar.layoutSubviews()
		})
		
		
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		
		// Анимацию возвращения в исходное положение после нажатия cancel пришлось положить в completion, а то что-то шло не так
		UIView.animate(withDuration: 0.2,
					   animations: {
			searchBar.showsCancelButton = false // скрыть кнопку Cancel
			searchBar.text = nil
			searchBar.resignFirstResponder() // скрыть клавиатуру
			
		}, completion: { _ in
			let closure = self.searchBarAnimationClosure()
			closure()
		})
		
		viewModel.cancelSearch() {
			self.tableView.reloadData()
		}
	}
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
	
	// настройка хедера ячеек и добавление букв в него
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		//Создаём кастомную вьюху заголовка
		let header = UIView()
		header.backgroundColor = .lightGray.withAlphaComponent(0.5)
		
		let leter: UILabel = UILabel(frame: CGRect(x: 30, y: 5, width: 20, height: 20))
		leter.textColor = UIColor.black.withAlphaComponent(0.5)  // прозрачность только надписи
		leter.text = String(viewModel.filteredData[section].key) // В зависимости от номера секции - даём ей разные названия из массива имён секций
		leter.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
		header.addSubview(leter)
		
		return header
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell",
													for: indexPath) as? FriendsTableViewCell {
			cell.animate()
		}
	}
	
	func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell",
													for: indexPath) as? FriendsTableViewCell {
			cell.animate()
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		// Кол-во секций
		return viewModel.filteredData.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Кол-во рядов в секции
		return viewModel.filteredData[section].data.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let section = viewModel.friends[section]
		
		return String(section.key)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell",
													   for: indexPath) as? FriendsTableViewCell else {
			return UITableViewCell()
		}
		
		viewModel.configureCell(cell: cell, indexPath: indexPath)
		cellsForAnimate.append(cell)
		
		return cell
	}
	
	/// Создаёт массив заголовков секций, по одной букве, с которой начинаются имена друзей
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return viewModel.lettersOfNames
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? FriendsTableViewCell else {
			return
		}
		
		let section = viewModel.filteredData[indexPath.section]
		
		let profileController = FriendProfileViewController(
			model: Assembly.instance.getFriendProfileViewModel(
				friend: section.data[indexPath.row],
				loader: viewModel.loader,
				profileImage: cell.getImage()
			)
		)
		
		self.tableView.deselectRow(at: indexPath, animated: true)
		self.navigationController?.pushViewController(profileController, animated: true)
	}
}

// MARK: - Private methods
private extension FriendsViewController {
	
	/// Конфигурируем TableView
	func setupTableView() {
		tableView.frame = self.view.bounds
		tableView.rowHeight = 70
		tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: "FriendsTableViewCell")
		tableView.showsVerticalScrollIndicator = false
		tableView.sectionHeaderTopPadding = 0
		tableView.sectionIndexColor = .black
		tableView.dataSource = self
		tableView.delegate = self
		self.view.addSubview(tableView)
		
		searchBar.delegate = self
		tableView.tableHeaderView = searchBar
	}
	
	/// Задаём констрейнты таблице
	func setupConstraints() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
		])
	}
}
