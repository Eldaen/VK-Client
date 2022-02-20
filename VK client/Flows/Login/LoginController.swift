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
	
	private let scrollView: UIScrollView = {
		let scrollView = UIScrollView(frame: .zero)
		scrollView.backgroundColor = UIColor.systemTeal
		return scrollView
	}()
	
	private let cloudView: CloudView = {
		let cloudView = CloudView()
		cloudView.translatesAutoresizingMaskIntoConstraints = false
		return cloudView
	}()
	
	private let appName: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
		label.textColor = .black
		label.text = "VK Client"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let loginLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.seventeen
		label.textColor = .black
		label.text = "Login"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let passwordLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.seventeen
		label.textColor = .black
		label.text = "Password"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private let loginInput: UITextField = {
		let textField = UITextField()
		textField.layer.cornerRadius = 8
		textField.font = UIFont.fourteen
		textField.textColor = .black
		textField.backgroundColor = .white
		textField.textAlignment = .center
		textField.text = "login@test.com"
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	private let passwordInput: UITextField = {
		let textField = UITextField()
		textField.layer.cornerRadius = 8
		textField.font = UIFont.fourteen
		textField.textColor = .black
		textField.backgroundColor = .white
		textField.textAlignment = .center
		textField.text = "password"
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	private let loginButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Войти", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .tintColor
		button.layer.cornerRadius = 8
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	/// Контроллер, на который перекинет при успешной авторизации
	private let nextController: UITabBarController = CustomTabBarController()
	
	// MARK: - ViewController life cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
		navigationController?.isNavigationBarHidden = true
		
		
		// Жест нажатия на пустое место, чтобы скрывать клавиатуру
		let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
		
		// Присваиваем его UIScrollVIew
		scrollView.addGestureRecognizer(hideKeyboardGesture)
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
		if let login = loginInput.text, let password = passwordInput.text {
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
		self.scrollView.contentInset = contentInsets
		scrollView.scrollIndicatorInsets = contentInsets
	}
	
	///Когда клавиатура исчезает
	@objc private func keyboardWillBeHidden(notification: Notification) {
		
		// Устанавливаем отступ внизу UIScrollView, равный 0
		let contentInsets = UIEdgeInsets.zero
		scrollView.contentInset = contentInsets
	}
	
	/// Прячем клаву, когда нажали на пустое место
	@objc private func hideKeyboard() {
		self.scrollView.endEditing(true)
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
		
		// если не задать frame, то не отрисовывается О_о
		scrollView.frame = self.view.bounds
		loginButton.addTarget(self, action: #selector(checkLogin), for: .touchUpInside)
		
		view.addSubview(scrollView)
		scrollView.addSubview(cloudView)
		scrollView.addSubview(appName)
		scrollView.addSubview(loginLabel)
		scrollView.addSubview(passwordLabel)
		scrollView.addSubview(loginInput)
		scrollView.addSubview(passwordInput)
		scrollView.addSubview(loginButton)
	}
	
	func setupConstraints() {
		NSLayoutConstraint.activate([
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			
			cloudView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			cloudView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 60),
			cloudView.widthAnchor.constraint(equalToConstant: 120),
			cloudView.heightAnchor.constraint(equalToConstant: 70),
			
			appName.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 140),
			appName.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 87),
			appName.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			
			loginLabel.topAnchor.constraint(equalTo: appName.bottomAnchor, constant: 80),
			loginLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			
			loginInput.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 15),
			loginInput.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			loginInput.widthAnchor.constraint(equalToConstant: 120),
			loginInput.heightAnchor.constraint(equalToConstant: 30),
			
			passwordLabel.topAnchor.constraint(equalTo: loginInput.bottomAnchor, constant: 40),
			passwordLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			
			passwordInput.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 15),
			passwordInput.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			passwordInput.widthAnchor.constraint(equalToConstant: 120),
			passwordInput.heightAnchor.constraint(equalToConstant: 30),
			
			loginButton.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: 50),
			loginButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 200),
			loginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			loginButton.widthAnchor.constraint(equalToConstant: 65),
		])
	}
}