//
//  UserSection.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 12/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import RxDataSources

enum UserSection {
    case searchUserSection([UserSectionItems])
}

enum UserSectionItems {
     case searchUser(UserItems)
}


extension UserSection: SectionModelType {
    typealias Item = UserSectionItems
    
    var items: [Item] {
        switch self {
        case .searchUserSection(let items):
            return items
        }
    }
    
    init(original: UserSection, items: [Item]) {
        switch original {
        case .searchUserSection:
            self = .searchUserSection(items)
        }
    }
}
