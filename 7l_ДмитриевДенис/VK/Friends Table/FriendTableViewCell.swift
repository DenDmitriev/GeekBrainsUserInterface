//
//  FriendTableViewCell.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: AvatarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(name: String, avatar: UIImage) {
        
        nameLabel.text = name
        avatarImage.image = avatar
        
        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
