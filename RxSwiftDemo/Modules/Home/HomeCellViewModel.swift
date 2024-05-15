//
//  HomeCellViewModel.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit
import RxCocoa

class HomeCellViewModel: NSObject {
    let name: Driver<String>
    let type: BehaviorRelay<DemoType?>
    init(demo: Demo) {
        self.name = Driver.just(demo.type?.title ?? "")
        self.type = BehaviorRelay(value: demo.type)
    }
}
