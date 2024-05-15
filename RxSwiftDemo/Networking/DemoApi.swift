//
//  DemoApi.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import Foundation
import RxSwift

protocol DemoApi {
    func requestHomeList(page: Int) -> Single<[Demo]>
}
