//
//  TBDataCellViewModel.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit
import RxCocoa
import SwifterSwift

class TBDataCellViewModel: NSObject {
    let title: Driver<String>
    let style: BehaviorRelay<TBTableStyle>
    let isSelected: BehaviorRelay<Bool>
    init(style: TBTableStyle) {
        self.title = Driver.just(style.title)
        self.style = BehaviorRelay(value: style)
        self.isSelected = BehaviorRelay(value: false)
    }
}
