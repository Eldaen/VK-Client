//
//  FullscreenViewController.swift
//  VK-Client
//
//  Created by Денис Сизов on 29.10.2021.
//

import UIKit

// TODO: - Надо бы галерею в отдельный модуль вынести, а то что-то она в контроллере...

/// Класс для отображения карусели полноэкранного просмотра фотографий
final class FullscreenViewController: UIViewController {
	
	private let galleryView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	private let progressView: UIProgressView = {
		let progressView = UIProgressView()
		progressView.translatesAutoresizingMaskIntoConstraints = false
		progressView.tintColor = .black
		return progressView
	}()
	
	lazy private var progress = Progress(totalUnitCount: Int64(photoViews.count))
	
	/// Сервис по загрузке данных
	private var loader: UserLoader
	
	/// Массив картинок пользователя
	private var storedImages: [String] = []
	
	/// Массив моделей картинок, которые нужно отобразить в галерее
	var photoModels: [UserImages] = []
	
	/// Массив вью для картинок
	private var photoViews: [UIImageView] = []
	
	/// Номер фото, по которому кликнули и нужно на него в галерее поставить фокус
	var selectedPhoto: Int = 0
	
	// Создаём три переменные, которые будут отвечать за то, что мы видим на экране и с чем взаимодействуем
	private var leftImageView: UIImageView!
	private var middleImageView: UIImageView!
	private var rightImageView: UIImageView!
	
	// UIViewPropertyAnimator, задаём доступные нам жесты
	private var swipeToRight: UIViewPropertyAnimator!
	private var swipeToLeft: UIViewPropertyAnimator!
	
	// MARK: - Init
	init(loader: UserLoader) {
		self.loader = loader
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View controller life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		self.title = "Галерея"
		
		// Получаем ссылки на изображения нужного размера
		storedImages = loader.sortImage(by: .x, from: photoModels)
		
		// создаём вьюхи с картинками
		createImageViews()
		
		// выставляем progress bar на нужное значение
		self.updateProgress()
		
		setupViews()
		setupConstraints()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// регистрируем распознаватель жестов
		let gestPan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
		view.addGestureRecognizer(gestPan)
		
		setImage()
		startAnimate()
	}
	
	// чистим вьюхи, чтобы не накладывались
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		galleryView.subviews.forEach({ $0.removeFromSuperview() }) // проходится по всем сабвью этой вьюхи и удаляет её из родителя
	}
}

// MARK: - Private methods
extension FullscreenViewController {
	
	// конфигурируем отображение
	func setImage(){
		var indexPhotoLeft = selectedPhoto - 1
		let indexPhotoMid = selectedPhoto
		var indexPhotoRight = selectedPhoto + 1
		
		// делаем круговую прокрутку, чтобы если левый индекс меньше 0, то его ставит последним
		if indexPhotoLeft < 0 {
			indexPhotoLeft = storedImages.count - 1
			
		}
		if indexPhotoRight > storedImages.count - 1 {
			indexPhotoRight = 0
		}
		
		// запускаем загрузку картинок
		loadImages(array: [indexPhotoLeft, indexPhotoMid, indexPhotoRight])
		
		// чистим вьюхи, т.к. мы постоянно добавляем новые
		galleryView.subviews.forEach({ $0.removeFromSuperview() })
		
		// Присваиваем видимым картинкам нужные вьюхи
		leftImageView = photoViews[indexPhotoLeft]
		middleImageView = photoViews[indexPhotoMid]
		rightImageView = photoViews[indexPhotoRight]
		
		galleryView.addSubview(leftImageView)
		galleryView.addSubview(middleImageView)
		galleryView.addSubview(rightImageView)
		
		// чистим констрейнты
		leftImageView.translatesAutoresizingMaskIntoConstraints = false
		middleImageView.translatesAutoresizingMaskIntoConstraints = false
		rightImageView.translatesAutoresizingMaskIntoConstraints = false
		
		// пишем свои
		NSLayoutConstraint.activate([
			middleImageView.leadingAnchor.constraint(equalTo: galleryView.leadingAnchor, constant: 30),
			middleImageView.trailingAnchor.constraint(equalTo: galleryView.trailingAnchor, constant: -30),
			middleImageView.heightAnchor.constraint(equalTo: middleImageView.widthAnchor, multiplier: 1),
			middleImageView.centerYAnchor.constraint(equalTo: galleryView.centerYAnchor),
			
			leftImageView.trailingAnchor.constraint(equalTo: galleryView.leadingAnchor, constant: 10), // выступает на 10 из-за левого края экрана
			leftImageView.centerYAnchor.constraint(equalTo: galleryView.centerYAnchor),
			leftImageView.heightAnchor.constraint(equalTo: middleImageView.heightAnchor),
			leftImageView.widthAnchor.constraint(equalTo: middleImageView.widthAnchor),
			
			rightImageView.leadingAnchor.constraint(equalTo: galleryView.trailingAnchor, constant: -10), // выступает на 10 из-за правого края экрана
			rightImageView.centerYAnchor.constraint(equalTo: galleryView.centerYAnchor),
			rightImageView.heightAnchor.constraint(equalTo: middleImageView.heightAnchor),
			rightImageView.widthAnchor.constraint(equalTo: middleImageView.widthAnchor),
		])
		
		middleImageView.layer.cornerRadius = 8
		rightImageView.layer.cornerRadius = 8
		leftImageView.layer.cornerRadius = 8
		
		middleImageView.clipsToBounds = true
		rightImageView.clipsToBounds = true
		leftImageView.clipsToBounds = true
		
		// изначально уменьшаем картинки, чтобы их потом можно было увеличить, СGAffineTransform имеет св-во .identity и можно вернуть к оригиналу
		let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
		
		self.middleImageView.transform = scale
		self.rightImageView.transform = scale
		self.leftImageView.transform = scale
		
	}
	
	// тут мы сначала ставим нужные картинки и потом включаем анимацию увеличения до оригинала
	func startAnimate(){
		setImage()
		UIView.animate(
			withDuration: 1,
			delay: 0,
			options: [],
			animations: { [unowned self] in
				self.middleImageView.transform = .identity
				self.rightImageView.transform = .identity
				self.leftImageView.transform = .identity
			})
	}
	
	/// Обработчик жестов смахивания и перелистывания
	@objc func onPan(_ recognizer: UIPanGestureRecognizer) {
		switch recognizer.state {
		case .began:
			swipeToRight = UIViewPropertyAnimator(
				duration: 0.5,
				curve: .easeInOut,
				animations: {
					UIView.animate(
						withDuration: 0.01,
						animations: { [unowned self] in
							let scale = CGAffineTransform(scaleX: 0.8, y: 0.8) // уменьшаем
							let translation = CGAffineTransform(translationX: self.galleryView.bounds.maxX - 30, y: 0) // направо до края экрана - 30, у нас так констрэйнты заданы
							let transform = scale.concatenating(translation) // объединяем анимации в группу, чтобы задать сразу всем картинкам
							
							self.middleImageView.transform = transform
							self.rightImageView.transform = transform
							self.leftImageView.transform = transform
						}, completion: { [unowned self] _ in
							self.selectedPhoto -= 1
							if self.selectedPhoto < 0 {
								self.selectedPhoto = self.storedImages.count - 1
							}
							self.updateProgress()
							self.startAnimate()
						})
				})
			swipeToLeft = UIViewPropertyAnimator(
				duration: 0.3,
				curve: .easeInOut,
				animations: {
					UIView.animate(
						withDuration: 0.01,
						animations: { [unowned self] in
							let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
							let translation = CGAffineTransform(translationX: -self.galleryView.bounds.maxX + 30, y: 0)
							let transform = scale.concatenating(translation)
							
							self.middleImageView.transform = transform
							self.rightImageView.transform = transform
							self.leftImageView.transform = transform
						}, completion: { [unowned self] _ in
							self.selectedPhoto += 1
							if self.selectedPhoto > self.storedImages.count - 1 {
								self.selectedPhoto = 0
							}
							self.updateProgress()
							self.startAnimate()
						})
				})
		case .changed:
			let translationX = recognizer.translation(in: self.view).x
			if translationX > 0 {
				swipeToRight.fractionComplete = abs(translationX)/100 // fractionComplete это про завершенность анимации от 0 до 1, можно плавно делать анимацию в зависимости от жеста
			} else {
				swipeToLeft.fractionComplete = abs(translationX)/100
			}

		case .ended:
			swipeToRight.continueAnimation(withTimingParameters: nil, durationFactor: 0)
			swipeToLeft.continueAnimation(withTimingParameters: nil, durationFactor: 0)
		default:
			return
		}
	}
	
	//  создаём массив вьюх с картинками для галлереи
	func createImageViews() {
		for _ in storedImages {
			let view = UIImageView()
			view.contentMode = .scaleAspectFit
			
			photoViews.append(view)
		}
	}
	
	func updateProgress() {
		self.progress.completedUnitCount = Int64(selectedPhoto + 1)
		self.progressView.setProgress(Float(self.progress.fractionCompleted), animated: true)
	}
	
	func setupConstraints() {
		NSLayoutConstraint.activate([
			galleryView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
			galleryView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			galleryView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			galleryView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 40),
			
			progressView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
			progressView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			progressView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
		])
	}
	
	func setupViews() {
		
		// создадим вьюхи для отображения
		leftImageView = UIImageView()
		middleImageView = UIImageView()
		rightImageView = UIImageView()
		
		view.addSubview(galleryView)
		view.addSubview(progressView)
	}
	
	/// Загружаем картинки
	func loadImages(array: [Int]) {
		for index in array {
			loader.loadImage(url: storedImages[index]) { [weak self] image in
				self?.photoViews[index].image = image
				self?.photoViews[index].layoutIfNeeded()
			}
		}
	}
}
