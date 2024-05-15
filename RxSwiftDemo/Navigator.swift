//
//  Navigator.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import Foundation
import UIKit
import SafariServices
import Hero

protocol Navigatable {
    var navigator: Navigator! { get set }
}

class Navigator {
    static var `default` = Navigator()
    
    // MARK: - segues list, all app scenes
    enum Scene {
        case home(viewModel: HomeViewModel)
        case bind(ViewModel: BindViewModel)
        case tbDataSources(ViewModel: TBDataSourcesViewModel)
        //Web
        case safari(URL)
        case safariController(URL)
        case webController(_ url: URL?,_ title: String?, _ isShowEmpty: Bool? = true)
    }
    
    enum Transition {
        case root(in: UIWindow)
        case navigation(type: HeroDefaultAnimationType)
        case customModal(type: HeroDefaultAnimationType)
        case modal
        case detail
        case alert
        case custom
        case system
    }
    
    // MARK: - get a single VC
    func get(segue: Scene) -> UIViewController? {
        switch segue {
        case .home(let viewModel): return HomeViewController(viewModel: viewModel, navigator: self)
        case .bind(let viewModel): return BindViewController(viewModel: viewModel, navigator: self)
        case .tbDataSources(let viewModel): return TBDataSourcesViewController(viewModel: viewModel, navigator: self)
            
            //Web
        case .safari(let url):
            UIApplication.shared.openToUrl(url)
            return nil
            
        case .safariController(let url):
            let vc = SFSafariViewController(url: url)
            return vc
            
        case .webController(let url, let title, let isShowEmpty):
            let vc = WebViewController(viewModel: nil, navigator: self, isShowEmpty: isShowEmpty)
            vc.load(url: url, title: title)
            return vc
        }
    }
    
    func pop(sender: UIViewController?, toRoot: Bool = false) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: true)
        } else {
            sender?.navigationController?.popViewController()
        }
    }
    
    func dismiss(sender: UIViewController?) {
        sender?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - invoke a single segue
    func show(segue: Scene, sender: UIViewController?, transition: Transition = .navigation(type: .push(direction: .left))) {
        if let target = get(segue: segue) {
            show(target: target, sender: sender, transition: transition)
        }
    }
    
    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        switch transition {
        case .root(in: let window):
            //transitionFlipFromLeft
            window.rootViewController = target
            //            UIView.transition(with: window, duration: 0.35, options: .transitionCrossDissolve, animations: {
            //                window.rootViewController = target
            //            }, completion: nil)
            return
        case .custom: return
        default: break
        }
        
        guard let sender = sender else {
            fatalError("You need to pass in a sender for .navigation or .modal transitions")
        }
        
        if let nav = sender as? UINavigationController {
            //push root controller on navigation stack
            nav.pushViewController(target, animated: false)
            return
        }
        
        switch transition {
        case .navigation(let type):
            if let nav = sender.navigationController {
                // push controller to navigation stack
                nav.hero.navigationAnimationType = .autoReverse(presenting: type)
                nav.pushViewController(target, animated: true)
            }
        case .customModal(let type):
            // present modally with custom animation
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                nav.hero.modalAnimationType = .autoReverse(presenting: type)
                nav.modalPresentationStyle = .fullScreen
                sender.present(nav, animated: true, completion: nil)
            }
        case .modal:
            // present modally
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                nav.modalPresentationStyle = .fullScreen
                sender.present(nav, animated: true, completion: nil)
            }
        case .detail:
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                sender.showDetailViewController(nav, sender: nil)
            }
        case .alert:
            DispatchQueue.main.async {
                target.modalPresentationStyle = .fullScreen
                sender.present(target, animated: true, completion: nil)
            }
        case .system:
            if let nav = sender.navigationController {
                // push controller to navigation stack
                nav.pushViewController(target, animated: true)
            }
        default: break
        }
    }
}

