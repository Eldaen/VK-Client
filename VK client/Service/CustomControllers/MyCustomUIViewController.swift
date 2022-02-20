//
//  MyCustomUIViewController.swift
//  VK client
//
//  Created by Денис Сизов on 28.11.2021.
//

import UIKit
import RealmSwift

class MyCustomUIViewController: UIViewController {
	
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
			self?.routeToEntry()
		}
		
		let actionCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
		
		alter.addAction(actionYes)
		alter.addAction(actionCancel)
		
		present(alter, animated: true, completion: nil)
	}
	
	/// Осуществляет навигацию в точку входа
	func routeToEntry() {
		let loginController = VKLoginController()
		let navigationController = UINavigationController(rootViewController: loginController)
		navigationController.modalPresentationStyle = .fullScreen
		
		if Assembly.instance.getDemoMode() == true {
			Assembly.instance.setDemoMode(false)
		}
		
		Session.instance.clean()
		self.present(navigationController, animated: true, completion: nil)
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
