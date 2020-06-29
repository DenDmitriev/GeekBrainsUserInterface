//
//  LikeView.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 26.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

@IBDesignable class LikeControl: UIControl {
    
    @IBInspectable var status: Bool = false
    @IBInspectable var likes: Int = 99
    @IBInspectable var activeColor: UIColor = .red
    @IBInspectable var unactiveColor: UIColor = .gray
    
    private var button: UIButton {
        let width = frame.width/2
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: frame.height))
        if !status {
            button.tintColor = unactiveColor
            button.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            button.tintColor = activeColor
            button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        button.setTitle(String(likes), for: .normal)
        button.addTarget(self, action: #selector(like), for:.touchUpInside)
        button.setTitleColor(button.tintColor, for: .normal)
        button.contentMode = .scaleAspectFit
        button.center = CGPoint(x: frame.width/2, y: frame.height/2)
        return button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(button)
    }
    
    
    @objc func like(_ sender: UIButton) {
        print(#function)
        if !status {
            likes += 1
            sender.tintColor = activeColor
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likes -= 1
            sender.tintColor = unactiveColor
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        sender.setTitle(String(likes), for: .normal)
        sender.setTitleColor(sender.tintColor, for: .normal)
        status = !status
    }
    
}
