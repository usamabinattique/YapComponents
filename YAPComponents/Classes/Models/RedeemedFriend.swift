//
//  RedeemedFriend.swift
//  YAP
//
//  Created by Zain on 25/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

struct RedeemedFriend: Codable {
    let name: String
    let imageURL: String
}

extension RedeemedFriend {
    static var mocked: RedeemedFriend {
        return RedeemedFriend(name: "John Doe", imageURL: "")
    }
}
