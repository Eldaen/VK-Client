//
//  ViewController.swift
//  test-gu
//
//  Created by Денис Сизов on 04.10.2021.
//

import UIKit

/// Entry point controller, responsible for the user Authorization
final class LoginController: UIViewController {
    
//    @IBAction func logginButtonAction(_ sender: Any) {
//
//    }
	
	private var scrollView: UIScrollView = {
		let scrollView = UIScrollView(frame: .zero)
		scrollView.backgroundColor = UIColor.systemTeal
		return scrollView
	}()
	
	private lazy var appName: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
		label.textColor = .black
		label.text = "VK Client"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var loginLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 17)
		label.textColor = .black
		label.text = "Login"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var passwordLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 17)
		label.textColor = .black
		label.text = "Password"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var loginInput: UITextField = {
		let textField = UITextField()
		textField.layer.cornerRadius = 8
		textField.font = UIFont.systemFont(ofSize: 14)
		textField.textColor = .black
		textField.backgroundColor = .white
		textField.textAlignment = .center
		textField.text = "login"
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	private lazy var passwordInput: UITextField = {
		let textField = UITextField()
		textField.layer.cornerRadius = 8
		textField.font = UIFont.systemFont(ofSize: 14)
		textField.textColor = .black
		textField.backgroundColor = .white
		textField.textAlignment = .center
		textField.text = "password"
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}()
	
	private lazy var loginButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Войти", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .tintColor
		button.layer.cornerRadius = 8
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	lazy private var nextController: UITabBarController = CustomTabBarController()
	
	
	// MARK: - Setting Views
	private func setupViews() {
		
		// если не задать frame, то не отрисовывается О_о
		scrollView.frame = self.view.bounds
		loginButton.addTarget(self, action: #selector(checkLogin), for: .touchUpInside)
		
		view.addSubview(scrollView)
		scrollView.addSubview(appName)
		scrollView.addSubview(loginLabel)
		scrollView.addSubview(passwordLabel)
		scrollView.addSubview(loginInput)
		scrollView.addSubview(passwordInput)
		scrollView.addSubview(loginButton)
	}
	
	// MARK: - Setting Constraints
	private func setupConstraints() {
		NSLayoutConstraint.activate([
		  scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
		  scrollView.topAnchor.constraint(equalTo: view.topAnchor),
		  scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		  scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

		  appName.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 120),
		  appName.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 87),
		  appName.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

		  loginLabel.topAnchor.constraint(equalTo: appName.bottomAnchor, constant: 100),
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
    
    
    // MARK: ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
		setupConstraints()
        
        // Жест нажатия на пустое место, чтобы скрывать клавиатуру
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // Присваиваем его UIScrollVIew
        scrollView.addGestureRecognizer(hideKeyboardGesture)
        showCloud() // отрисуем облачко
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
    
    @objc func checkLogin() {
        // Проверяем данные
        let checkResult = checkUserData()
        
        // Если данные не верны, покажем ошибку
        if !checkResult {
            showLoginError()
        }
		
		self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    
    /// Проверяем данные для авторизации
	func checkUserData() -> Bool {
		guard
			let login = loginInput.text,
			let pass = passwordInput.text else {
				return false
			}
        
        if login == "login" && pass == "password" {
            return true
        } else {
            return false
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
    
    /// Рисуем облачко
    func showCloud() {
        let cloudView = CloudView()
        view.addSubview(cloudView)
		cloudView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			cloudView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			cloudView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
			cloudView.widthAnchor.constraint(equalToConstant: 120),
			cloudView.heightAnchor.constraint(equalToConstant: 70)
		])
    }
    
    /// Клавиатура появилась
    @objc func keyboardWasShown(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    ///Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
    }
    
    /// Прячем клаву, когда нажали на пустое место
    @objc func hideKeyboard() {
        self.scrollView.endEditing(true)
    }
}

// MARK: UISCrollViewDelegate
extension LoginController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0.0
    }
}

