//
//  PostTableViewCell.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 01.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import LoremIpsum

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: AvatarView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var stackViewUser: UIStackView!
    
    @IBOutlet weak var postTextLable: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var likeControl: LikeButton!
    @IBOutlet weak var commentControl: LikeButton!
    @IBOutlet weak var repostControl: LikeButton!
    @IBOutlet weak var viewControl: LikeButton!
    @IBOutlet weak var stacViewControl: UIStackView!
    
    @IBOutlet weak var view: UIView!
    
    var height: CGFloat?
    
    func set(post: Post) {
        avatarImageView.image = post.user!.avatar.first ?? UIImage(named: "vk_logo")
        nameLabel.text = post.user?.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        datelabel.text = dateFormatter.string(for: LoremIpsum.date())
        
        postTextLable.text = post.text
        postImageView.image = post.image
        
        likeControl.count = Int.random(in: 0...100)
        commentControl.count = Int.random(in: 0...100)
        viewControl.count = Int.random(in: 0...100)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.separator.cgColor
        view.layer.borderWidth = 0.32
        height = frame.height
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
}
