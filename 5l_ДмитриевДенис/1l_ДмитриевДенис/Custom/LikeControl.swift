//
//  LikeView.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 26.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

@IBDesignable class LikeControl: UIControl {
    
    @IBInspectable var status: Bool = false {
        didSet {
            update()
        }
    }
    
    @IBInspectable var likes: Int = 99 {
        didSet {
            update()
        }
    }
    
    @IBInspectable var size: CGFloat = 8 {
        didSet {
            update()
        }
    }
    
    @IBInspectable var activeColor: UIColor = .red {
        didSet {
            update()
        }
    }
    
    @IBInspectable var unactiveColor: UIColor = .gray {
        didSet {
            update()
        }
    }
    
    
    lazy var button: UIButton = {
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
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        button.contentMode = contentMode
//        button.sizeToFit()
    }
    
    func setup() {
        addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            button.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            button.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func update() {
        button.setTitle(String(likes), for: .normal)
        if !status {
            button.tintColor = unactiveColor
            button.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            button.tintColor = activeColor
            button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        button.setTitleColor(button.tintColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: size)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
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
