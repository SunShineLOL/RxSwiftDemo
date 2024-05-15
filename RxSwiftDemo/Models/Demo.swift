//
//  Demo.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit

enum DemoType: Int, Codable {
    // Two-way binding operator
    case fieldBind
    // tableView
    case table
    
    var title: String {
        switch self {
        case .fieldBind: "Field双向绑定"
        case .table: "RxDataSources 数据演示"
        }
    }
}

class Demo: Codable {
    var type: DemoType?
    internal init(type: DemoType?) {
        self.type = type
    }
}
