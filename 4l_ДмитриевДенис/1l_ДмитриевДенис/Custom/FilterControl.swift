//
//  FilterControl.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 27.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class FilterControl: UIControl {
    
    var alphabet = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ".map { String($0) }

    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
    var char: String? = nil {
        didSet {
            self.sendActions(for: .touchUpInside)
        }
    }
    
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
        stackView.frame = bounds
    }
    
    private func setup() {
        
        for char in alphabet {
            let button = UIButton(type: .system)
            button.setTitle(char, for: .normal)
            button.addTarget(self, action: #selector(selectChar(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
    }
    
    @objc func selectChar(_ sender: UIButton) {
        let index = buttons.firstIndex(of: sender)
        let char = alphabet[index!]
        self.char = char
    }
    
    func update() {
        buttons = []
        setup()
    }

}
