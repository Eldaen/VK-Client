//
//  FriendCell.swift
//  test-gu
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendImage: AvatarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // конфигурируем ячейку
    func configure(name: String, image: UIImage) {
        friendName.text = name
        friendImage.image = image
        animate()
    }
    
    // запускаем анимацию ячейки при появлении
    func animate() {
        self.friendImage.alpha = 0
        self.frame.origin.x += 200
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.15,
                       options: [],
                       animations: {
            self.friendImage.alpha = 1
        })
        
        UIView.animate(withDuration: 0.7,
                       delay: 0.1,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
            self.frame.origin.x = 0
        })
    }

}
