//
//  MyCustomUIViewController.swift
//  VK client
//
//  Created by Денис Сизов on 28.11.2021.
//

import UIKit

/// Базовый класс для вью контроллеров внутри таб контроллера
class MyCustomUIViewController: UIViewController {
	
	/// Делегат для перезапуска приложения
	weak var restartDelegate: RestartDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		addLogoutButton()
	}
}

// MARK: - Private methods
private extension MyCustomUIViewController {
	
	/// Выходит из демо режима или разлогинивает пользователя
	@objc func logout() {
		
		// Создаём контроллер
		let alter = UIAlertController(title: "Выход",
									  message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
		
		let actionYes = UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
			self?.restartDelegate?.restart()
		}
		
		let actionCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
		
		alter.addAction(actionYes)
		alter.addAction(actionCancel)
		
		present(alter, animated: true, completion: nil)
	}
	
	/// Добавляет кнопку Logout в Navigation Bar
	func addLogoutButton() {
		let logout = UIBarButtonItem(
			title: "Logout",
			style: .plain,
			target: self,
			action: #selector(logout)
		)
		logout.tintColor = .black
		navigationItem.leftBarButtonItem = logout
	}
}
