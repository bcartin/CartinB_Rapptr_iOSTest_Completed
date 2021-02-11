//
//  Message.swift
//  iOSTest
//
//  Created by Bernie Cartin on 2/11/21.
//  Copyright © 2021 D&ATechnologies. All rights reserved.
//

import Foundation

struct Message: Codable {
    let uid: String
    let name: String
    let avatarUrl: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case uid = "user_id"
        case name = "name"
        case avatarUrl = "avatar_url"
        case message = "message"
    }
}

struct ChatData: Codable {
    let messages: [Message]
    
    enum CodingKeys: String, CodingKey {
        case messages = "data"
    }
}
