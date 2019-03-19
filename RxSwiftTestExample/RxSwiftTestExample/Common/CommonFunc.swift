//
//  CommonFunc.swift
//  RxSwiftTestExample
//
//  Created by 엄기철 on 11/03/2019.
//  Copyright © 2019 Hanzo. All rights reserved.
//

import Foundation


func DebugLog(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    #if DEBUGE
    let fileName = file.split(separator: "/").last ?? ""
    let funcName = function.split(separator: "(").first ?? ""
    print("😱 [\(fileName)] \(funcName) (\(line)): \(message)")
    #endif
}

func ErrorLog(_ message: Any, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
    #if DEBUGE
    let fileName = file.split(separator: "/").last ?? ""
    let funcName = function.split(separator: "(").first ?? ""
    print("🥵 [\(fileName)] \(funcName) (\(line)): \(message)")
    #endif
}
