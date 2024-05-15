//
//  ViewModel.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx


protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class ViewModel: NSObject {
    
    var provider: DemoApi
    
    var page = 1
    
    let loading = ActivityIndicator()
    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()
    
    let error = ErrorTracker()
    let parsedError = PublishSubject<ApiError>()
    
    init(provider: DemoApi) {
        self.provider = provider
        super.init()
        
        error.asObservable().map {[weak self] (error) -> ApiError? in
            self?.asApiError(error: error)
        }.filterNil().bind(to: parsedError).disposed(by: rx.disposeBag)
            
        error.asDriver().drive(onNext: { (error) in
            DLog("\(error)")
        }).disposed(by: rx.disposeBag)
        
    }
    
    func asApiError(error: Error) -> ApiError? {
        if let error = error as? ApiError {
            return error
        }
        do {
            let moyaError = error as? MoyaError
            //authError
            if var errorResponse = try moyaError?.response?.map(BaseModel<String>.self){
                
                if errorResponse.code == 301 {
                    //token过期 登录失效
                    DLog("token过期:\(errorResponse.msg ?? "") code:\(errorResponse.code ?? -1)")
                    return ApiError.authError(baseModel: errorResponse)
                }else if errorResponse.code == 402{
                    //其他设备登录
                    DLog("账户在其他设备登录:\(errorResponse.msg ?? "") code:\(errorResponse.code ?? -1)")
                    return ApiError.extrusionError(baseModel: errorResponse)
                }
                let request = moyaError?.response?.request
                DLog("----------网络请求错误----------\n url:\(request?.url?.absoluteString ?? "未知")\n parameter:\(request?.httpBody?.string(encoding: .utf8) ?? "未知")\n httpMethod:\(request?.httpMethod ?? "未知")\n headerFields:\(request?.allHTTPHeaderFields ?? [:])\n code:\(errorResponse.code ?? -1)\n msg:\(errorResponse.msg ?? "")\n------------- end -------------")
                return ApiError.serverError(baseModel: errorResponse)
            }
        } catch {
            DLog(error)
        }
        return nil
    }
    
    deinit {
        DLog("\(type(of: self)): Deinited ✅")
        #if DEBUG
        DLog("RxSwift resources count: \(RxSwift.Resources.total)")
        #endif
    }
}
