//
//  User.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import LoremIpsum

struct User {
    var name: String?
    var avatar: [UIImage]
}

fileprivate func loadImages(count: Int) -> [UIImage] {
    return (1...count).map { _ in
        LoremIpsum.placeholderImage(from: .loremPixel, with: CGSize(width: Int.random(in: 300...600), height: Int.random(in: 300...600)))
    }
}

func loadUsersData(amount: Int) -> [User] {
    var users: [User] = []
    for _ in 1...amount {
        users.append(User(
            name: LoremIpsum.name(),
            avatar: loadImages(count: 5)))
    }
    return users
}

