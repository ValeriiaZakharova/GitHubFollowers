//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 18.02.2021.
//

import Foundation

struct Follower: Codable, Hashable {
    var login: String
    var avatarUrl: String

    ///example to conform hashable only for some object
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(login)
//    }
}
