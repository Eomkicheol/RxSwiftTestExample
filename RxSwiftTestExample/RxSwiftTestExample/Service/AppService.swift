//
//  AppService.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 11/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import SystemConfiguration

import RxSwift
import Moya
import Sniffer
import Alamofire

class DefaultAlamofireManager: Alamofire.SessionManager {
    static var sharedManager: DefaultAlamofireManager = {
        let configureation = URLSessionConfiguration.default
        Sniffer.enable(in: configureation)
        configureation.timeoutIntervalForRequest = 20
        configureation.timeoutIntervalForResource = 20
        configureation.requestCachePolicy = URLRequest.CachePolicy.useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configureation)
    }()
}


class AppService: AppServiceType {
    
    //싱글톤
    static let sharedInstance = AppService()
    
    static var shared: AppService {
        return sharedInstance
    }
    
    private let provider: MoyaProvider<AppAPI> = {
        let provider = MoyaProvider<AppAPI>(endpointClosure: MoyaProvider.defaultEndpointMapping,
                                            requestClosure: MoyaProvider<AppAPI>.defaultRequestMapping,
                                            stubClosure: MoyaProvider.neverStub,
                                            callbackQueue: nil,
                                            manager: DefaultAlamofireManager.sharedManager,
                                            plugins: [],
                                            trackInflights: false)
        return provider
    }()
    
    func requestResponse(_ api: AppAPI) -> Observable<Response> {
        return provider.rx
            .request(api)
            .asObservable()
            .flatMap({ value -> Observable<Response> in
                guard value.statusCode >= 200, value.statusCode < 300  else { return Observable.error(AppAPIError.message) }
                return Observable.create({ observer -> Disposable in
                    observer.onNext(value)
                    observer.onCompleted()
                    return Disposables.create()
                })
            })
    }
    
    
}
