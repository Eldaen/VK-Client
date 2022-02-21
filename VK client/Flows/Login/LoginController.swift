//
//  ViewController.swift
//  VK-Client
//
//  Created by Денис Сизов on 04.10.2021.
//

import UIKit
import FirebaseAuth

/// Entry point controller, responsible for the user Authorization
final class LoginController: UIViewController {
	
	private var loginView: LoginView {
		guard let view = self.view as? LoginView else { return LoginView() }
		return view
	}
	
	/// Контроллер, на который перекинет при успешной авторизации
	private let nextController: UITabBarController = CustomTabBarController()
	
	// MARK: - ViewController life cycle
	
	override func loadView() {
		super.loadView()
		self.view = LoginView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		navigationController?.isNavigationBarHidden = true
		
		
		// Жест нажатия на пустое место, чтобы скрывать клавиатуру
		let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
		
		// Присваиваем его UIScrollVIew
		loginView.scrollView.addGestureRecognizer(hideKeyboardGesture)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Подписываемся на два уведомления: одно приходит при появлении клавиатуры
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
		
		// Второе — когда она пропадает
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	
	// MARK: - Authorization methods
	@objc func checkLogin() {
		if let login = loginView.loginInput.text, let password = loginView.passwordInput.text {
			loginUser(with: login, password: password)
		}
	}
	
	/// Проверяем данные для авторизации
	private func loginUser(with email: String, password: String) {
		Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
			if error != nil {
				self?.showLoginError()
				return
			}
			if let controller = self?.nextController {
				self?.navigationController?.pushViewController(controller, animated: true)
			}
		}
	}
	
	/// Отображение ошибки авторизации
	func showLoginError() {
		// Создаём контроллер
		let alter = UIAlertController(title: "Ошибка",
									  message: "Введены не верные данные пользователя", preferredStyle: .alert)
		
		// Создаем кнопку для UIAlertController
		let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		
		// Добавляем кнопку на UIAlertController
		alter.addAction(action)
		
		// Показываем UIAlertController
		present(alter, animated: true, completion: nil)
	}
	
	// MARK: - Keyboard methods
	
	/// Клавиатура появилась
	@objc private func keyboardWasShown(notification: Notification) {
		
		// Получаем размер клавиатуры
		let info = notification.userInfo! as NSDictionary
		let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
		let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
		
		// Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
		loginView.scrollView.contentInset = contentInsets
		loginView.scrollView.scrollIndicatorInsets = contentInsets
	}
	
	///Когда клавиатура исчезает
	@objc private func keyboardWillBeHidden(notification: Notification) {
		
		// Устанавливаем отступ внизу UIScrollView, равный 0
		let contentInsets = UIEdgeInsets.zero
		loginView.scrollView.contentInset = contentInsets
	}
	
	/// Прячем клаву, когда нажали на пустое место
	@objc private func hideKeyboard() {
		loginView.scrollView.endEditing(true)
	}
}

// MARK: - UISCrollViewDelegate
extension LoginController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		scrollView.contentOffset.x = 0.0
	}
}

// MARK: - Private setup methods
private extension LoginController {
	
	func setupViews() {
		loginView.loginButton.addTarget(self, action: #selector(checkLogin), for: .touchUpInside)
		loginView.loginInput.delegate = self
		loginView.passwordInput.delegate = self
	}
}

// MARK: - UITextFieldDelegate

extension LoginController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
