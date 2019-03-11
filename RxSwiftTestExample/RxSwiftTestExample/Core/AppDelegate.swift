//
//  AppDelegate.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 11/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import UIKit
import Sniffer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //네트워킹 패킷분석 Lib등록
        Sniffer.register()
       self.rootViewController()
        return true
    }

}


extension AppDelegate {
    private func rootViewController() {
        self.window = {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .white
            window.makeKeyAndVisible()
            return window
        }()
    }
}

