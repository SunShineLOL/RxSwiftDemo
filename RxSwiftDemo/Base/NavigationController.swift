//
//  NavigationController.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit
import Hero

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.heroConfig()
        self.titleTextAttributes()
    }
    
    func heroConfig() {
        hero.isEnabled = true
        hero.modalAnimationType = .autoReverse(presenting: .push(direction: .up))
        hero.navigationAnimationType = .autoReverse(presenting: .push(direction: .left))
    }
    
}

extension UINavigationController {
    
    /// 设置导航栏标题颜色/字体 兼容 iOS15 Inline Title text attributes. If the font or color are unspecified, appropriate defaults are supplied.
    func titleTextAttributes(_ textAttr: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor.black])  {
        //navigationBar字体颜色设置
        if #available(iOS 13.0, *) {
            let app = navigationBar.standardAppearance
            app.titleTextAttributes = textAttr
            navigationBar.standardAppearance = app
            navigationBar.scrollEdgeAppearance = app
            if let color = textAttr[NSAttributedString.Key.foregroundColor] as? UIColor {
                self.navigationBar.barTintColor = color
            }
        }else{
            //navigationBar字体颜色设置
            //self.navigationBar.barTintColor = .black
            //FIXME: iOS 12 设置标题颜色不生效
            self.navigationBar.titleTextAttributes = textAttr
            
        }
    }
    
    ///清空导航栏
    func clearBg(){
        self.navigationBar.isTranslucent = true
        if #available(iOS 13.0, *) {
            let app = navigationBar.standardAppearance
            app.configureWithTransparentBackground()
            app.backgroundImage = nil
            app.backgroundColor = nil
            app.shadowImage = nil
            app.shadowColor = nil
            navigationBar.standardAppearance = app
            navigationBar.scrollEdgeAppearance = app
        }else{
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.backgroundColor = UIColor.clear
        }
    }
    
    var navigationBackgroundColor: UIColor? {
        get {
            if #available(iOS 13.0, *) {
                return navigationBar.standardAppearance.backgroundColor
            }else{
                return navigationBar.backgroundColor
            }
        }
        set {
            if #available(iOS 13.0, *) {
                navigationBar.standardAppearance.backgroundColor = newValue
            }else{
                return navigationBar.backgroundColor = newValue
            }
        }
    }
}
