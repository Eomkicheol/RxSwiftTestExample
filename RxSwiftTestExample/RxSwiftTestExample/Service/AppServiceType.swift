//
//  AppServiceType.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 11/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import RxSwift
import Moya

protocol AppServiceType {
    func requestResponse(_ api: AppAPI) -> Observable<Response>
}
