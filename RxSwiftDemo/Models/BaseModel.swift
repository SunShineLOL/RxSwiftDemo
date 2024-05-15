//
//  BaseModel.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit

class BaseModel<T: Codable>: Codable {
    var msg: String?
    var code: Int?
    var data: T?
}
