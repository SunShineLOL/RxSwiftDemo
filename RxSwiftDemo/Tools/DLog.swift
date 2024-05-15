//
//  DLog.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import Foundation

//MARK: -自定义LOGO
func DLog<T>(_ message:T, file:String = #file, funcName:String = #function, lineNum:Int = #line) {
    #if DEBUG
    print("DLogo:\(funcName) \(lineNum):\n\(message)");
    #endif
}
