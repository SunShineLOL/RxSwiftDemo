//
//  BindViewModel.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit
import RxSwift
import RxCocoa
import SwifterSwift

class BindViewModel: ViewModel, ViewModelType {
    struct Input {
        let addBtnTrigger: Driver<Void>
    }
    
    struct Output {
        let fieldValue: BehaviorRelay<String>
        let title: Driver<String>
    }
    
    let value = BehaviorRelay<String>(value: "0")
    
    func transform(input: Input) -> Output {
        input.addBtnTrigger.map {[weak self] in
            let oldValue = self?.value.value
            if let intValue = oldValue?.int {
                return (intValue + 1).string
            } else {
                return (oldValue ?? "") + "1"
            }
            
        }.drive(self.value).disposed(by: rx.disposeBag)
        let title = Driver<String>.just("双向绑定")
        let value = value
        return Output(fieldValue: value, title: title)
    }
}
