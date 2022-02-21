//
//  FriendsViewController.swift
//  VK-Client
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

/// Отображает список всех пользователей
final class FriendsViewController: MyCustomUIViewController {
	
	private var friendsView: FriendsView {
		guard let view = self.view as? FriendsView else { return FriendsView() }
		return view
	}
	
	/// Вью модель контроллера Friends
	private var viewModel: FriendsViewModelType
	
	/// Ячейки, которые нужно анимировать при появлении
	private var cellsForAnimate: [FriendsTableViewCell] = []
	
	/// Фото профиля
	var profileImage: UIImage?
	
	// Вынес сюда closure анимации, чтобы 2 раза не повторять код.
	private func searchBarAnimationClosure () -> () -> Void {
		
		return { [weak self] in
			guard let scopeView = self?.friendsView.searchBar.searchTextField.leftView else { return }
			guard let placeholderLabel = self?.friendsView.searchBar.textField?.value(forKey: "placeholderLabel")
					as? UILabel else {
				return
			}
			
			UIView.animate(withDuration: 0.3,
						   animations: { [weak self] in
				guard let self = self else { return }
				
				scopeView.frame = CGRect(x: self.friendsView.searchBar.frame.width / 2 - 15,
										 y: scopeView.frame.origin.y,
										 width: scopeView.frame.width,
										 height: scopeView.frame.height)
				
				let xPosition = placeholderLabel.frame.origin.x
				
				if xPosition > 20 {
					placeholderLabel.frame.origin.x -= 20
				}
				self.friendsView.searchBar.layoutSubviews()
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
	
	override func loadView() {
		super.loadView()
		self.view = FriendsView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
		
		friendsView.spinner.startAnimating()
		
		viewModel.fetchFriends { [weak self] in
			self?.friendsView.spinner.stopAnimating()
			self?.friendsView.tableView.reloadData()
		}
	}
}

// MARK: UISearchBarDelegate
extension FriendsViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		viewModel.search(searchText) { [weak self] in
			self?.friendsView.tableView.reloadData()
		}
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		self.friendsView.searchBar.showsCancelButton = true // показыть кнопку Cancel
		
		let cBtn = searchBar.value(forKey: "cancelButton") as! UIButton
		cBtn.backgroundColor = .red
		cBtn.setTitleColor(.white, for: .normal)
		
		UIView.animate(withDuration: 0.3,
					   animations: { [weak self] in
			guard let self = self else { return }
			
			// двигаем кнопку cancel
			cBtn.frame = CGRect(x: cBtn.frame.origin.x - 50,
								y: cBtn.frame.origin.y,
								width: cBtn.frame.width,
								height: cBtn.frame.height
			)
			
			// анимируем запуск поиска. -1 чтобы пошла анимация, тогда лупа плавно откатывается О_о
			self.friendsView.searchBar.frame = CGRect(x: self.friendsView.searchBar.frame.origin.x,
										  y: self.friendsView.searchBar.frame.origin.y,
										  width: self.friendsView.searchBar.frame.size.width - 1,
										  height: self.friendsView.searchBar.frame.size.height
			)
			
			self.friendsView.searchBar.layoutSubviews()
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
		
		viewModel.cancelSearch() { [weak self] in
			self?.friendsView.tableView.reloadData()
		}
	}
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
	
	// настройка хедера ячеек и добавление букв в него
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return getHeader(for: section)
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.defaultReuseIdentifier,
													for: indexPath) as? FriendsTableViewCell {
			cell.animate()
		}
	}
	
	func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if let cell = tableView.dequeueReusableCell(withIdentifier: FriendsTableViewCell.defaultReuseIdentifier,
													for: indexPath) as? FriendsTableViewCell {
			cell.animate()
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.filteredData.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.filteredData[section].data.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let section = viewModel.friends[section]
		return String(section.key)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: FriendsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
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
		
		self.friendsView.tableView.deselectRow(at: indexPath, animated: true)
		self.navigationController?.pushViewController(profileController, animated: true)
	}
	
	private func getHeader(for section: Int) -> UIView {
		let header = UIView()
		header.backgroundColor = .lightGray.withAlphaComponent(0.5)
		
		let leter: UILabel = UILabel(frame: CGRect(x: 30, y: 5, width: 20, height: 20))
		leter.textColor = UIColor.black.withAlphaComponent(0.5)
		leter.text = String(viewModel.filteredData[section].key)
		leter.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
	
		header.addSubview(leter)
		return header
	}
}

// MARK: - Private methods
private extension FriendsViewController {
	
	/// Конфигурирует TableView
	func setupTableView() {
		friendsView.tableView.register(registerClass: FriendsTableViewCell.self)
		friendsView.tableView.dataSource = self
		friendsView.tableView.delegate = self
		friendsView.searchBar.delegate = self
	}
}
