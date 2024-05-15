//
//  UIApplication+Extension.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit

extension UIApplication {
    ///兼容9.0以上版本
    func openToUrl(_ url:URL?) {
        if #available(iOS 10.0, *){
            if let url = url, UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }else{
            if let url = url, UIApplication.shared.canOpenURL(url){
                UIApplication.shared.openURL(url)
            }
        }
    }
}
