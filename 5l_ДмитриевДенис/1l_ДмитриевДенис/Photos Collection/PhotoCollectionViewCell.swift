//
//  PhotoCollectionViewCell.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    
    
    func set(photo: UIImage) {
        photoImage.image = photo
        blurEffectView.layer.cornerRadius = blurEffectView.frame.height/2
    }
}
