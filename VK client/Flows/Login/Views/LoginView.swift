//
//  LoginView.swift
//  VK client
//
//  Created by Денис Сизов on 21.02.2022.
//

import UIKit

/// Вью для LoginController
final class LoginView: UIView {
	
	// MARK: - Subviews
	
	public let scrollView: UIScrollView = {
		let scrollView = UIScrollView(frame: .zero)
		scrollView.backgroundColor = UIColor.systemTeal
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		return scrollView
	}()
	
	public let cloudView: CloudView = {
		let cloudView = CloudView()
		cloudView.translatesAutoresizingMaskIntoConstraints = false
		return cloudView
	}()
	
	public let appName: UILabel = {
		let label = UILabel()
		label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
		label.textColor = .black
		label.text = "VK Client"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	public let loginLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.seventeen
		label.textColor = .black
		label.text = "Login"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	public let passwordLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.seventeen
		label.textColor = .black
		label.text = "Password"
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	public let loginInput: UITextField = {
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
	
	public let passwordInput: UITextField = {
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
	
	public let loginButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Войти", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .tintColor
		button.layer.cornerRadius = 8
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	// MARK: - Init
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.configureUI()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.configureUI()
	}
	
	// MARK: - UI
	
	/// Конфигурирует вью
	private func configureUI() {
		addSubviews()
		setupConstraints()
	}
	
	/// Добавляет сабвью
	func addSubviews() {
		self.addSubview(scrollView)
		scrollView.addSubview(cloudView)
		scrollView.addSubview(appName)
		scrollView.addSubview(loginLabel)
		scrollView.addSubview(passwordLabel)
		scrollView.addSubview(loginInput)
		scrollView.addSubview(passwordInput)
		scrollView.addSubview(loginButton)
	}
	
	/// Устанавливает констрекнты для наших сабвью
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			scrollView.topAnchor.constraint(equalTo: self.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			
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
