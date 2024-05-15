//
//  RestApi.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import Foundation
import Moya
import RxSwift

typealias MoyaError = Moya.MoyaError

enum ApiError: Error {
    case serverError(baseModel: BaseModel<String>)
    /// 身份认证错误(token过期)
    case authError(baseModel: BaseModel<String>)
    /// 其他设备登录(被挤下线)
    case extrusionError(baseModel: BaseModel<String>)
    /// 其他错误
    case otherError(msg: String?, code: Int?, error: Error?)
}
extension ApiError{
    var isAuthError: Bool {
        get{
            switch self {
            case .authError: return true
            default: return false
            }
        }
    }
    
    var code: Int{
        get{
            switch self {
            case .authError(let baseModel): return baseModel.code ?? -1
            case .serverError(let baseModel): return baseModel.code ?? 301
            case .extrusionError(let baseModel): return baseModel.code ?? 402
            case .otherError(_, let code, _): return code ?? -1
            }
        }
    }
    
    var msg:String{
        get{
            switch self {
            case .authError(let baseModel): return baseModel.msg ?? "未知错误"
            case .serverError(let baseModel): return baseModel.msg ?? "登录信息失效"
            case .extrusionError(let baseModel): return baseModel.msg ?? "登录信息失效"
            case .otherError(let msg, _, _): return msg ?? "未知错误"
            }
        }
    }
}

enum UploadImageEvent{
    case progress(index:Int, p: Double)
    case error(error:Error)
    case complete(urls:[String])
}

extension ApiError:LocalizedError{
    public var errorDescription: String? {
        switch self {
        case .serverError(baseModel: let model):
            return model.msg ?? "未知错误"
        case .authError(baseModel: let model):
            return model.msg ?? "登录信息失效"
        case .extrusionError(baseModel: let model)://账户在其他设备登录
            return model.msg ?? "登录信息失效"
        case .otherError(let msg, _, _):
            return msg ?? "未知错误"
        }
    }
}
extension ApiError:CustomNSError{
    /// The domain of the error.
    //    public static var errorDomain: String { get }
    //
    //    /// The error code within the given domain.
    //    public var errorCode: Int { get }
    //
    //    /// The user-info dictionary.
    //    public var errorUserInfo: [String : Any] { get }
}

class RestApi: DemoApi {
    
    let provider: RxSwiftDemo.Networking
    
    init(provider: RxSwiftDemo.Networking) {
        self.provider = provider
    }
}

extension RestApi {
    
    func requestHomeList(page: Int) -> Single<[Demo]> {
        return requestModelObject(.requestHomeList(page: page), type: [Demo].self)
    }
    
    
}

//MARK: 发送请求并解析数据->模型
extension RestApi {
    ///请求返回 -> json
    private func request(_ target: ModuleApi) -> Single<Any> {
        return provider.request(target)
            .mapJSON()
            .observe(on: MainScheduler.instance)
            .asSingle()
    }
    
    ///请求没有映射
    private func requestWithoutMapping(_ target: ModuleApi) -> Single<Moya.Response> {
        return provider.request(target)
            .observe(on: MainScheduler.instance)
            .asSingle()
    }
    
    ///请求返回模型 ->T
    private func requestObject<T: Codable>(_ target: ModuleApi, type: T.Type, dataKey: String? = nil) -> Single<T> {
        return provider.request(target).mapModel(T.self, dataKey: dataKey).observe(on: MainScheduler.instance)
            .asSingle()
    }
    
    ///请求返回ModelObjet<T>模型 解析成 ->T
    private func requestModelObject<T: Codable>(_ target: ModuleApi, type: T.Type, dataKey: String? = nil) -> Single<T> {
        return provider.request(target)
            .mapModel(BaseModel<T>.self, dataKey: dataKey)
            .filter({$0.data != nil})// TODO: 数据解析异常的时候是否抛出异常
            .map({$0.data!})
            .observe(on: MainScheduler.instance)
            .asSingle()
    }
}
//MARK: 解析常规请求json数据
extension Observable where Element == Response {
    
    func mapModel<T: Codable>(_ type: T.Type, dataKey: String? = nil) -> Observable<T> {
        return self.map({ (response) in
            /*
             返回json 数据结构为 {"msg":"","code":"0","data":{"orderId": "123"}}
             我们只想要取出 "123" 又不想单独去创建一个模型
             这时候指定尝试使用指定key取出value，再赋值给jsonObject to Data -> {"msg":"","code":"0","data":"123"}
             可以直接用T = String.self解析而不用再去创建模型
             */
            var data = response.data
            if let key = dataKey, var json = try? data.jsonObject() as? [String: Any] {
                if let tempData = json["data"] as? [String: Any] {
                    json["data"] = tempData[key]
                    if let d = json.jsonData() {
                        data = d
                    }
                }
            }
            let decoder = JSONDecoder()
            guard let baseModel = try? decoder.decode(BaseModel<String>.self, from: data) else {
                throw ApiError.otherError(msg: "数据解析异常", code: -1, error: nil)
            }
            
            guard let otherModel = try? decoder.decode(T.self, from: data) else {
                do{//捕获解析异常
                    _ = try decoder.decode(T.self, from: data)
                }catch{
                    DLog("❌❌❌解析错误:\(error)")
                }
                throw ApiError.otherError(msg: "数据解析异常", code: -1, error: nil)
            }
            guard baseModel.code == 200 || baseModel.code == 0 else {
                throw MoyaError.underlying(NSError(domain: baseModel.msg ?? "未知错误", code: baseModel.code ?? -1, userInfo: ["model": otherModel]), response)
            }
            return otherModel
        })
    }
}
