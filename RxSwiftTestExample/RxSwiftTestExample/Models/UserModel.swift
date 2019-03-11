//
//  UserModel.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 11/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import Foundation


struct UserModel: Codable {
    var totalCount: Int = 0
    var incompleteResults: Bool = false
    var items: [UserItems] = []
    
    
    enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
    }
}


struct UserItems: Codable {
    var login: String = ""
    var id: Int = 0
    var avatarUrl: String = ""
    var score: Double = 0.0
    var organizationsUrl: String = ""
    
    enum CodingKeys: String, CodingKey {
        case login, id, score
        case avatarUrl = "avatar_url"
        case organizationsUrl = "organizations_url"
    }
}
