//
//  ModuleApi.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import Foundation
import Moya
import SwifterSwift

enum ModuleApi {
    case requestHomeList(page: Int)
}

extension ModuleApi: Moya.TargetType {
    var baseURL: URL {
        return "https://gitee.com".url!
    }
    
    var path: String {
        switch self {
        case .requestHomeList(_ ): "/home"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .requestHomeList(_ ): .post
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
        return .requestPlain
    }
    
    /// 参数编码方式(这里使用URL的默认方式)
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var headers: [String : String]? {
        var header:[String:String] = [:]
        header["Accept"] = "application/json"
        // 设置contentType 否则服务端无法解析参数
        header["Content-Type"] = "application/x-www-form-urlencoded"
        return header
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .requestHomeList(let page):
            params["page"] = page
        }
        return params
    }
    
}
