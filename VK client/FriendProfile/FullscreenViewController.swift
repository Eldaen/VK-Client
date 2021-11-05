//
//  FullscreenViewController.swift
//  test-gu
//
//  Created by Денис Сизов on 29.10.2021.
//

import UIKit

final class FullscreenViewController: UIViewController {
    
    @IBOutlet weak var galleryView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    lazy var progress = Progress(totalUnitCount: Int64(photoViews.count))
    // точно передаём номер фото, на которое кликнули
    //var indexPath: Int!
    
    // Должно приходить от контроллера со всеми фото
    var photos: [UIImage] = []
    var photoViews:[UIImageView] = []
    
    var selectedPhoto = 0
    
    // Создаём три переменные, которые будут отвечать за то, что мы видим на экране и с чем взаимодействуем
    private var leftImageView: UIImageView!
    private var middleImageView: UIImageView!
    private var rightImageView: UIImageView!

    // UIViewPropertyAnimator, задаём доступные нам жесты
    var swipeToRight: UIViewPropertyAnimator!
    var swipeToLeft: UIViewPropertyAnimator!
    
    //  создаём массив вьюх с картинками для галлереи
    func createImageViews() {
        for photo in photos {
            let view = UIImageView()
            view.image = photo
            view.contentMode = .scaleAspectFit
            
            photoViews.append(view)
        }
    }
    
    func updateProgress() {
        self.progressView.setProgress(Float(self.progress.fractionCompleted), animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // создаём вьюхи с картинками
        createImageViews()
        
        //selectedPhoto = indexPath
        self.progress.completedUnitCount = Int64(selectedPhoto + 1)
        
        // создадим вьюхи для отображения
        leftImageView = UIImageView()
        middleImageView = UIImageView()
        rightImageView = UIImageView()
        
        self.updateProgress()
        
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

    // конфигурируем отображение
    func setImage(){
        var indexPhotoLeft = selectedPhoto - 1
        let indexPhotoMid = selectedPhoto
        var indexPhotoRight = selectedPhoto + 1

        // делаем круговую прокрутку, чтобы если левый индекс меньше 0, то его ставит последним
        if indexPhotoLeft < 0 {
            indexPhotoLeft = photoViews.count - 1

        }
        if indexPhotoRight > photoViews.count - 1 {
            indexPhotoRight = 0
        }
        
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

    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            swipeToRight = UIViewPropertyAnimator(
                duration: 0.3,
                curve: .easeInOut,
                animations: {
                    UIView.animate(
                        withDuration: 0.01,
                        delay: 0,
                        options: [],
                        animations: { [unowned self] in
                            let scale = CGAffineTransform(scaleX: 0.8, y: 0.8) // уменьшаем
                            let translation = CGAffineTransform(translationX: self.galleryView.bounds.maxX - 30, y: 0) // направо до края экрана - 30, у нас так констрэйнты заданы
                            let transform = scale.concatenating(translation) // объединяем анимации в группу, чтобы задать сразу всем картинкам
                            
                            self.middleImageView.transform = transform
                            self.rightImageView.transform = transform
                            self.leftImageView.transform = transform
                        })
                })
            swipeToLeft = UIViewPropertyAnimator(
                duration: 0.3,
                curve: .easeInOut,
                animations: {
                    UIView.animate(
                        withDuration: 0.01,
                        delay: 0,
                        options: [],
                        animations: { [unowned self] in
                            let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
                            let translation = CGAffineTransform(translationX: -self.galleryView.bounds.maxX + 30, y: 0)
                            let transform = scale.concatenating(translation)
                            
                            self.middleImageView.transform = transform
                            self.rightImageView.transform = transform
                            self.leftImageView.transform = transform
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
            
            let translationX = recognizer.translation(in: self.view).x
            if translationX > 0 { // если жест это свайп направо
                swipeToRight.fractionComplete = abs(translationX)/100
                if swipeToRight.fractionComplete < 0.5 { // Если анимация не закончена на половину
                    swipeToRight.pauseAnimation() // тормозим анимацию
                    
                    swipeToRight.addAnimations { // возвращаем картинку на место
                        self.middleImageView.transform = .identity
                        self.rightImageView.transform = .identity
                        self.leftImageView.transform = .identity
                    }
                    
                    swipeToRight.continueAnimation(withTimingParameters: nil, durationFactor: 0) // запускаем анимацию
                    return
                }
                
                // по завершению, обновляем индекс выбранной фотки
                self.selectedPhoto -= 1
                self.progress.completedUnitCount -= 1
                if self.selectedPhoto < 0 {
                    self.selectedPhoto = self.photos.count - 1
                    self.progress.completedUnitCount = Int64(self.photos.count)
                }
                
                swipeToRight.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                
            } else { // если налево, то тут тоже самое, но наоборот
                swipeToLeft.fractionComplete = abs(translationX)/100
                if swipeToLeft.fractionComplete < 0.5 {
                    swipeToLeft.pauseAnimation()
                    
                    swipeToLeft.addAnimations {
                        self.middleImageView.transform = .identity
                        self.rightImageView.transform = .identity
                        self.leftImageView.transform = .identity
                    }
                    
                    swipeToLeft.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                    
                    return
                }
                
                // меняем картинку как выбранную, только если жест окончен
                self.selectedPhoto += 1
                self.progress.completedUnitCount += 1
                if self.selectedPhoto > self.photos.count - 1 {
                    self.selectedPhoto = 0
                    self.progress.completedUnitCount = 1
                }
                swipeToLeft.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
            
            // запускаем анимацию + выставление картинок по концу жеста в любом случае
            self.updateProgress()
            self.startAnimate()
            
        default:
            return
        }
    }
}
