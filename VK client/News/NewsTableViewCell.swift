//
//  NewsCell.swift
//  test-gu
//
//  Created by Денис Сизов on 23.10.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    var collection: [NewsCollectionViewCellModel] = []
    

    
    
    /// Конфигурирует ячейку NewsTableViewCell
    /// - Parameters:
    ///   - model: Модель новости, которую нужно отобразить
    func configure (with model: NewsTableViewCellModel) {
        userImage.image = model.user.uiImage
        userName.text = model.user.name
        self.postDate.text = model.postDate
        postText.text = model.postText
        
        updateCellWith(collection: model.collection)
    }
    
}

// MARK: collection view extension

extension NewsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // обновляет данные для коллекции
    func updateCellWith(collection: [NewsCollectionViewCellModel]) {
        self.collection = collection
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collection.count > 4 {
            return 4
        } else {
            return collection.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as? NewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // TODO: надо это куда-то в модель перенести
        // если есть больше 4х картинок, то нужно показать что их больше
        // для этого сделаем полупрозрачную вьюху, положем её поверх картинки и ещё текст добавим
//        if indexPath.row == 3 && collection.count > 4 {
//            let frameCV = collectionView.frame
//            let cellSize = CGRect(x: 0, y: 0, width: frameCV.width / 2,
//                              height: frameCV.height / 2)
//            
//            let newView = UIView(frame: cellSize)
//            newView.backgroundColor = .white.withAlphaComponent(0.8)
//
//            let extraImagesCount = UILabel(frame: cellSize)
//            extraImagesCount.textAlignment = .center
//            extraImagesCount.text = "+" + String( collection.count - 3 )
//            extraImagesCount.font = UIFont.boldSystemFont(ofSize: 48.0)
//            extraImagesCount.textColor = .black
//
//            cell.newsImage.addSubview(newView)
//            newView.addSubview(extraImagesCount)
//        }
        
        // находим нужную модель ячейки коллекции в массиве collection и потом в нашу новую ячейку коллекции передаэм готовую картинку
        let collectionCell = collection[indexPath.row]
        cell.configure(with: collectionCell.image)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }

}
