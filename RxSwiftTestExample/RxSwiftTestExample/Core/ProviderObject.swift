//
//  ProviderObject.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 11/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import UIKit

enum ProviderObject {
    case userSearch
}


extension ProviderObject {
    var viewController: UIViewController {
        switch self {
        case .userSearch:
            let viewModel: UserSearchViewModel = UserSearchViewModel()
            let viewController: UserSearchViewController = UserSearchViewController(viewBinder: viewModel)
            let navigationController: BaseNavigationController = BaseNavigationController(rootViewController: viewController)
            return navigationController
        }
    }
}
