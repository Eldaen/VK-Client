//
//  MyGroupsCell.swift
//  test-gu
//
//  Created by Денис Сизов on 13.10.2021.
//

import UIKit

class MyGroupsCell: UITableViewCell {
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(name: String, image: UIImage?) {
        groupName.text = name
        groupImage.image = image
    }

}
