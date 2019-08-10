//
//  Profile.swift
//  MovieBest
//
//  Created by Amr fawzy on 8/10/19.
//  Copyright © 2019 Amr fawzy. All rights reserved
//

import Foundation

struct Profile: Codable {
    let avatar: Avatar?
    let id: Int?
    let name: String?
    let username: String?
}

struct Avatar: Codable {
    let gravatar: Gravatar?
}

struct Gravatar: Codable {
    let hash: String?
}
