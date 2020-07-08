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
    var avatar: [UIImage?]
}

func loadUsersData(amount: Int) -> [User] {
    var users: [User] = []
    for _ in 1...amount {
        users.append(User(name: LoremIpsum.name(), avatar: [LoremIpsum.placeholderImage(from: .placeKitten, with: CGSize(width: Int.random(in: 200...400), height: Int.random(in: 200...400)))]))
    }
    return users
}
