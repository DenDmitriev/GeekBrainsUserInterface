//
//  Post.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 01.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import LoremIpsum

struct Post {
    var user: User?
    var text: String?
    var image: UIImage?
}

func loadPostsData(amount: Int) -> [Post] {
    var posts: [Post] = []
    for _ in 1...amount {
        posts.append(Post(user: User(name: LoremIpsum.name(), avatar: [loadImage(width: 50, height: 50)]),
        text: LoremIpsum.paragraph(),
        image: loadImage(width: Int.random(in: 300...500), height: Int.random(in: 200...400))))
    }
    return posts
}

func loadImage(width: Int, height: Int) -> UIImage {
    return LoremIpsum.placeholderImage(from: .loremPixel, with: CGSize(width: width, height: height))
}
