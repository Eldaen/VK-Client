//
//  FriendCollectionController.swift
//  test-gu
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

final class FriendProfileViewController: UIViewController {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var friendsCount: UILabel!
    @IBOutlet weak var photosCount: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var friend: UserModel!
    let identifier = "PhotoCollectionViewCell"
    
    // данные для галлереи
    let cellsCount: CGFloat = 3.0
    let cellsOffset: CGFloat = 2.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // задаём коллекции, что она тут будет данные получать и обрабатывать жесты
        collectionView.delegate = self
        collectionView.dataSource = self

        // заполняем статичные данные
        userAvatar.image = friend.uiImage
        photosCount.text = String(friend.storedImages.count)
        
        // регистрируем новую ячейку
        collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
}

// MARK: UICollectionViewDataSource

extension FriendProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friend.storedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.photoView.image = friend.storedImages[indexPath.item]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let frameCV = collectionView.frame

        let cellWidth = frameCV.width / cellsCount
        let cellHeight = cellWidth

        // считаем размеры ячеек с учётом отступов, чтобы всё ровненько было
        let spacing = ( cellsCount + 1 ) * cellsOffset / cellsCount
        return CGSize(width: cellWidth - spacing, height: cellHeight - ( cellsOffset * 2) )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "FullscreenViewController") as? FullscreenViewController else {
            return
        }
        
        vc.photos = friend.storedImages
        vc.selectedPhoto = indexPath.item
        
        // переход на подробный просмотр
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

