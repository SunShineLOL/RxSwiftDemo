//
//  Reachability.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import Foundation
import RxSwift
import Reachability

// An observable that completes when the app gets online (possibly completes immediately).
func connectedToInternet() -> Observable<Bool> {
    return ReachabilityManager.shared.reach
}

var isWifi: Bool {
    return ReachabilityManager.shared.isWifi
}

private class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()
    
    fileprivate let reachability = try! Reachability()
    
    let reachSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var reach: Observable<Bool> {
        return reachSubject.asObservable()
    }
    
    var isWifi: Bool {
        return reachability.connection == .wifi
    }
    
    override init() {
        super.init()
        
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                self.reachSubject.onNext(true)
            }
        }
        
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                self.reachSubject.onNext(false)
            }
        }
        //Reachability.NetworkReachable
        
        
        do {
            try reachability.startNotifier()
            reachSubject.onNext(reachability.connection != .unavailable)
        } catch {
            print("Unable to start notifier")
        }
    }
}
