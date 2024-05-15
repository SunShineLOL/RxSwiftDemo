//
//  Application.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit
import IQKeyboardManagerSwift

class Application: NSObject {
    static let shared = Application()
    var window: UIWindow?
    var provider: DemoApi = RestApi(provider: RxSwiftDemo.Networking.networking())
    let navigator: Navigator
    
    override init() {
        navigator = Navigator.default
        super.init()
        updateProvider()
        threeKit()
    }
    
    private func updateProvider() {
        let restApi = RestApi(provider: RxSwiftDemo.Networking.networking())
        provider = restApi
    }
    
    private func threeKit() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    ///初始化屏幕
    func presentInitialScreen(in window: UIWindow?) {
        guard let window = window else { return }
        self.window = window
        let vm = HomeViewModel(provider: self.provider)
        if let vc = navigator.get(segue: .home(viewModel: vm)) {
            let homeVC = NavigationController(rootViewController: vc)
            self.window?.rootViewController = homeVC
        }
    }
}
