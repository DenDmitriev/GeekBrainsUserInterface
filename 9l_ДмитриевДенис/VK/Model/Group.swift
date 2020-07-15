//
//  Groups.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import LoremIpsum

struct Group {
    var title: String?
    var avatar: UIImage?
}

func loadGroupData(amount: Int) -> [Group] {
    
    print(#function)
    
    var gropus: [Group] = []
    
    for _ in 1...amount {
        gropus.append(Group(title: LoremIpsum.word()?.capitalized, avatar: LoremIpsum.placeholderImage(from: .placeKitten, with: CGSize(width: 100, height: 100))))
    }
    return gropus
}
