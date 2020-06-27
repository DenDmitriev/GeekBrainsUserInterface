//
//  ViewAvatar.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 25.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

@IBDesignable class  AvatarView: UIView {
    
    @IBInspectable var shadowColor: UIColor = .black
   
    @IBInspectable var blurSize: CGFloat = 16.0

    @IBInspectable var shift: CGFloat = 4.0
    
    @IBInspectable var shadowAlphaPercent: CGFloat = 50
    
    @IBInspectable var image: UIImage = UIImage(named: "Майкл Фассбендер")! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let width: CGFloat = self.frame.width
        let height: CGFloat = self.frame.height
        
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        view.layer.masksToBounds = false
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOpacity = Float(shadowAlphaPercent/100)
        view.layer.shadowRadius = blurSize
        view.layer.shadowOffset = CGSize(width: 0, height: shift)

        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        image.image = self.image
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = image.frame.height/2
        image.layer.masksToBounds = true
        
        view.addSubview(image)
        addSubview(view)
        
    }
    

}

