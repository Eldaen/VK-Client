//
//  FullscreenViewController.swift
//  VK-Client
//
//  Created by Денис Сизов on 29.10.2021.
//

import UIKit

// TODO: - Надо бы галерею в отдельный модуль вынести, а то что-то она в контроллере застряла с былых времён

/// Класс для отображения карусели полноэкранного просмотра фотографий
final class GalleryViewController: UIViewController {
	
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
	
	lazy private var progress = Progress(totalUnitCount: Int64(viewModel.photoViews.count))
	
	/// Вью модель для галереи
	var viewModel: GalleryType
	
	
	// Создаём три переменные, которые будут отвечать за то, что мы видим на экране и с чем взаимодействуем
	private var leftImageView: UIImageView!
	private var middleImageView: UIImageView!
	private var rightImageView: UIImageView!
	
	// UIViewPropertyAnimator, задаём доступные нам жесты
	private var swipeToRight: UIViewPropertyAnimator!
	private var swipeToLeft: UIViewPropertyAnimator!
	
	// MARK: - Init
	init(model: GalleryType) {
		self.viewModel = model
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
		
		//Получаем ссылки на картинки нужного размера
		viewModel.getStoredImages(size: "x")
		
		// создаём вьюхи с картинками
		viewModel.createImageViews()
		
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
extension GalleryViewController {
	
	// конфигурируем отображение
	func setImage(){
		var indexPhotoLeft = viewModel.selectedPhoto - 1
		let indexPhotoMid = viewModel.selectedPhoto
		var indexPhotoRight = viewModel.selectedPhoto + 1
		
		// делаем круговую прокрутку, чтобы если левый индекс меньше 0, то его ставит последним
		if indexPhotoLeft < 0 {
			indexPhotoLeft = viewModel.storedImages.count - 1
			
		}
		if indexPhotoRight > viewModel.storedImages.count - 1 {
			indexPhotoRight = 0
		}
		
		// запускаем загрузку картинок
		viewModel.fetchPhotos(array: [indexPhotoLeft, indexPhotoMid, indexPhotoRight])
		
		// чистим вьюхи, т.к. мы постоянно добавляем новые
		galleryView.subviews.forEach({ $0.removeFromSuperview() })
		
		// Присваиваем видимым картинкам нужные вьюхи
		leftImageView = viewModel.photoViews[indexPhotoLeft]
		middleImageView = viewModel.photoViews[indexPhotoMid]
		rightImageView = viewModel.photoViews[indexPhotoRight]
		
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
							self.viewModel.selectedPhoto -= 1
							if self.viewModel.selectedPhoto < 0 {
								self.viewModel.selectedPhoto = self.viewModel.storedImages.count - 1
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
							self.viewModel.selectedPhoto += 1
							if self.viewModel.selectedPhoto > self.viewModel.storedImages.count - 1 {
								self.viewModel.selectedPhoto = 0
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
	
	func updateProgress() {
		self.progress.completedUnitCount = Int64(viewModel.selectedPhoto + 1)
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
}
