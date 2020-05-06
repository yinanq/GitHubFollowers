//
//  Followers.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 3/22/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import Foundation

struct Follower: Codable, Hashable {
    var login:  String
    var avatar_url: String
}
