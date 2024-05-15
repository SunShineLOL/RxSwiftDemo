//
//  TBTableStyle.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import Foundation

enum TBTableStyle {
    case cell
    case section
    
    var title: String {
        switch self {
        case .cell: "常规Cell"
        case .section: "分组Cell"
        }
    }
}
