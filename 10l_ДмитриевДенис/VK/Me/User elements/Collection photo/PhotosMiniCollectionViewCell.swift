//
//  PhotosMiniCollectionViewCell.swift
//  VK
//
//  Created by Denis Dmitriev on 13.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class PhotosMiniCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
    }
    
    func set(image: UIImage) {
        imageView.image = image
    }

}
