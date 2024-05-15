//
//  TBDataSection.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit
import RxCocoa
import RxDataSources

typealias TBDataSection = SectionModel<TBDataSectionModel, TBDataCellViewModel>

enum TBDataSectionType {
    case header
    case content
    case footer
    
    var title: String {
        switch self {
        case .header:
            "分组1-Header"
        case .content:
            "分组2-Content"
        case .footer:
            "分组3=Footer"
        }
    }
}

extension TBDataSection {
    
    
}

class TBDataSectionModel {
    let name: Driver<String>
    let isSelected: BehaviorRelay<Bool>
    let type: BehaviorRelay<TBDataSectionType>
    init(type: TBDataSectionType) {
        self.type = BehaviorRelay(value: type)
        self.name = Driver.just(type.title)
        self.isSelected = BehaviorRelay(value: false)
    }
}
