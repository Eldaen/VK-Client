//
//  VKLoginController.swift
//  VK client
//
//  Created by Денис Сизов on 16.11.2021.
//

import WebKit
import UIKit

/// Контроллер для авторизации через Webview Вконтакте
final class VKLoginController: UIViewController {
	
	private let vkWebView: WKWebView = {
		let webConfiguration = WKWebViewConfiguration()
		let view = WKWebView(frame: .zero, configuration: webConfiguration)
		return view
	}()
	
	private let demoButton: UIButton = {
		var configuration = UIButton.Configuration.filled()
		configuration.title = "Demo режим"
		configuration.titlePadding = 10
		configuration.titleAlignment = .center
		configuration.baseBackgroundColor = .orange
		let button = UIButton(configuration: configuration, primaryAction: nil)
		
		button.setTitleColor(.black, for: .normal)
		button.layer.cornerRadius = 8
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	/// Сервис конфигурации приложения
	var appModeManager: AppModeManager?
	
	/// Контроллер, на который перекинет при успешной авторизации
	var nextController: UITabBarController?
	
	// MARK: - Init
	
	init(nextController: UITabBarController, appModeManager: AppModeManager) {
		self.nextController = nextController
		self.appModeManager = appModeManager
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View controller life cycle
	
	override func loadView() {
		self.view = vkWebView
	}
	
	override func viewDidLoad() {
		navigationController?.isNavigationBarHidden = true
		configureWebView()
		configureDemoButton()
		setupConstraints()
		removeCookies()
		loadAuth()
	}
}

// MARK: - WKNavigationDelegate
extension VKLoginController: WKNavigationDelegate {
	func configureWebView() {
		vkWebView.navigationDelegate = self
	}
	
	/// Перехватывает ответы сервера при переходе, можно отменить при необходимости.
	func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
				 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
		
		// проверяем, что ответ существует и путь не пустой
		guard let url = navigationResponse.response.url,
			  url.path == "/blank.html",
			  let fragment = url.fragment
		else {
			decisionHandler(.allow)
			return
		}
		
		let params = fragment
			.components(separatedBy: "&")
			.map { $0.components(separatedBy: "=") }
			.reduce([String: String]()) { result, param in
				var dict = result
				let key = param[0]
				let value = param[1]
				dict[key] = value
				return dict
			}
		
		// Сохраняем данные авторизации, если она успешна и всё нужное есть
		if let token = params["access_token"], let userId = params["user_id"], let id = Int(userId),
		   let nextController = nextController {
			
			Session.instance.loginUser(with: token, userId: id)
			appModeManager?.setDemoMode(false, nextController: nextController)
			self.navigationController?.pushViewController(nextController, animated: true)
		}
		
		decisionHandler(.cancel)
	}
}

// MARK: - Private methods
private extension VKLoginController {
	func setupConstraints() {
		NSLayoutConstraint.activate([
			demoButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40),
			demoButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
		])
	}
	
	func removeCookies(){
		let cookieJar = HTTPCookieStorage.shared

		for cookie in cookieJar.cookies! {
			cookieJar.deleteCookie(cookie)
		}
	}
	
	func loadAuth() {
		var urlComponents = URLComponents()
		urlComponents.scheme = "https"
		urlComponents.host = "oauth.vk.com"
		urlComponents.path = "/authorize"
		urlComponents.queryItems = [
			URLQueryItem(name: "client_id", value: "8002318"),
			URLQueryItem(name: "display", value: "mobile"),
			URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
			URLQueryItem(name: "scope", value: "friends, photos, wall, groups"),
			URLQueryItem(name: "response_type", value: "token"),
			URLQueryItem(name: "v", value: "5.131")
		]
		
		let request = URLRequest(url: urlComponents.url!)
		//
		
		vkWebView.load(request)
	}
	
	func configureDemoButton() {
		self.view.addSubview(demoButton)
		demoButton.addTarget(self, action: #selector(demoOn), for: .touchUpInside)
	}
	
	@objc func demoOn () {
		guard let nextController = nextController else { return }
		
		appModeManager?.setDemoMode(true, nextController: nextController)
		let demoLogin = LoginController()
		demoLogin.nextVC = nextController
		self.navigationController?.pushViewController(demoLogin, animated: true)
	}
}
