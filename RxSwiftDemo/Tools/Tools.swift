//
//  Tools.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit
import RxSwift
import CommonCrypto
import MobileCoreServices
import Photos
import Contacts

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

///判断是否是iPhone
let kIsPhone = Bool(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone)

///判断是否是iPad
let kIsPad = Bool(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)

///判断是否是iPhone X
let kIsPhoneX = Bool(kScreenWidth >= 375.0 && kScreenHeight >= 812.0 && kIsPhone)

///导航条的高度
let kNavigationHeight = CGFloat(kIsPhoneX ? 88 : 64)

///状态栏高度
let kStatusBarHeight = CGFloat(kIsPhoneX ? 44 : 20)

///tabbar高度
let kTabBarHeight = CGFloat(kIsPhoneX ? (49 + 34) : 49)

///顶部安全区域远离高度
let kTopSafeHeight = CGFloat(kIsPhoneX ? 44 : 0)

///底部安全区域远离高度
let kBottomSafeHeight = CGFloat(kIsPhoneX ? 34 : 0)

///上传图片时的暂存目录
let kUploadImagesPath = NSHomeDirectory().appending("/Documents/UploadImages")

struct Tools {
    
}

extension Tools {
    ///删除所有上传时的/Documents/UploadImages/图片缓存
    static func removeUploadImages(){
        let filemanager = FileManager.default
        if !filemanager.isExecutableFile(atPath: kUploadImagesPath) {
            //文件夹不存在 忽略后续操作
            return
        }
        if filemanager.isDeletableFile(atPath: kUploadImagesPath){//判断文件夹是否可删除
            //删除文件夹
            do{
                try filemanager.removeItem(atPath: kUploadImagesPath)
                DLog("上传缓存文件夹删除完成✅")
            }catch{
                DLog("文件夹删除失败\(error)")
            }
        }
    }

}

extension Tools {
    //阿拉伯数字 1 转 一
    static func intIntoString(number: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.numberStyle = NumberFormatter.Style(rawValue: UInt(CFNumberFormatterRoundingMode.roundHalfDown.rawValue))!
        return formatter.string(from: NSNumber(value: number))
    }
}

func logResourcesCount() {
    #if DEBUG
    DLog("RxSwift resources count: \(RxSwift.Resources.total)")
    #endif
}

//MARK: -根据传入的size等比例缩放 return size 默认比例为 scaleW w/h 1.0
func sizeScale(w: CGFloat = 375.0, _ h: CGFloat = 0 , scale: CGFloat = scaleW) -> CGSize {
    return CGSize(width: Int(scaleW * w), height: Int(scale * h))//kScreenWidth / CGFloat(375) * w * h / w)
}

//当前屏幕宽分辨率相对于iphone6(375)的比例
let scaleW = kScreenWidth / CGFloat(375)

//当前屏幕高分辨率相对于iphone6(667)的比例
let scaleH = kScreenHeight / CGFloat(667)

///根据传入参数返回当前屏幕宽分辨率相对于iphone6(375)的宽度
func FW(_ w: CGFloat ) -> CGFloat {
    return scaleW * w
}

///根据传入参数返回当前屏幕高度分辨率相对于iphone6(667)的高度
func FH(_ h: CGFloat ) -> CGFloat {
    return scaleH * h
}

/// 直接给String扩展方法 计算MD5
extension String {
    func kcMd5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
}

/** 随机产生字符串
 parameters:
 - number 字符串长度
 - digital 是否包含数字
 - capital 是否包含大写
 - lowercase 是否包含小写
 */
func kcGetRandomString(_ digital:Bool!,_ capital:Bool!,_ lowercase:Bool!) -> String{
    var number = arc4random() % 4 + 6;
    if number < 1 || number>10{
        number = 6
    }
    
    var strArray:Array<String> = Array()
    for _ in 0...INT64_MAX {
        let a:Int = Int(arc4random() % 122)
        let c:Character = Character(UnicodeScalar(a)!)
        //包含数字
        if digital {
            if a > 47 && a < 58{
                strArray.append(String.init(c))
            }
        }
        //大写字母
        if capital {
            if a > 64 && a < 92 {
                strArray.append(String.init(c))
            }
        }
        //小写字母
        if lowercase {
            if a > 96 && a < 123 {
                strArray.append(String.init(c))
            }
        }
        if strArray.count == number{
            break
        }
    }
    let str:String = strArray.joined(separator: "")
    return str;
}

//MARK: -获取当前时间 20190423125901
func kGetNowDate() -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    formatter.dateFormat = "yyyyMMddHHmmss"//设置时间格式；hh——>12小时制， HH———>24小时制
    //设置时区
    let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
    formatter.timeZone = timeZone
    let dateNow = Date()//当前的时间
    //当前时间戳
    let tmpDate = formatter.string(from: dateNow)
    return tmpDate
    
}
//MARK: -根据后缀获取对应的Mime-Type
func kMimeType(pathExtension: String) -> String {
    if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                       pathExtension as NSString,
                                                       nil)?.takeRetainedValue() {
        if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
            .takeRetainedValue() {
            return mimetype as String
        }
    }
    //文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
    return "application/octet-stream"
}
//MARK: -数组转json
func kcGetJSONStringFromArray(array:[Any]) -> String {
    
    guard JSONSerialization.isValidJSONObject(array)   else {
        DLog("无法解析出JSONString")
        return ""
    }
    
    let data : Data! = try? JSONSerialization.data(withJSONObject: array, options: []) as Data?
    let JSONString = String(data:data as Data,encoding: String.Encoding.utf8)
    return JSONString! as String
    
}
//MARK: -字典转json
func kcGetJSONStringFromDictionary(dictionary:[String :Any]?) -> String?{
    guard JSONSerialization.isValidJSONObject(dictionary as Any)   else {
        DLog("无法解析出JSONString")
        return nil
    }
    do {
        let data : Data = try JSONSerialization.data(withJSONObject: dictionary!, options: [])
        let JSONString = String(data:data as Data,encoding: String.Encoding.utf8)
        return JSONString! as String
    } catch {
        DLog("json解析失败")
    }
    return nil
    
}

// 以图片中心为中心，以最小边为边长，裁剪正方形图片
//func kcCropSquareImage(data: Data) -> Data {
//    if let image = UIImage.init(data: data) {
//        return kcCropSquareImage(image: image)
//    }
//    return data
//}
//MARK: -以图片中心为中心，以最小边为边长，裁剪正方形图片
func kcCropSquareImage(image: UIImage) -> UIImage? {
    let sourceImageRef = image.cgImage
    let _imageWidth = image.size.width * image.scale
    let _imageHeight = image.size.height * image.scale
    let _width = _imageWidth > _imageHeight ? _imageHeight : _imageWidth
    let _offsetX = (_imageWidth - _width) / 2
    let _offsetY = (_imageHeight - _width) / 2;
    let rect = CGRect(x: _offsetX, y: _offsetY, width: _width, height: _width)
    let newImageRef = sourceImageRef?.cropping(to: rect)
    if let iref = newImageRef{
        let newimage = UIImage.init(cgImage: iref)
        return newimage
        
    }
    return nil
}

//MARK: -用于字典的合并，接收的参数是一个键值对时，就可以添加到原有的字典中，并且对原有字典的重复值进行覆盖为新值，不重复则保留
extension Dictionary {
    mutating func merge<S>(_ other: S)
        where S: Sequence, S.Iterator.Element == (key: Key, value: Value){
            for (k ,v) in other {
                self[k] = v
            }
    }
}

//MARK: -保存图片到系统相册
func seveImgToPhoto(img: UIImage?){
    guard let img = img else {
        return
    }
    PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAsset(from: img)
    }) { (b, error) in
        
    }
}


//MARK: - 获取IP
public func GetIPAddresses() -> String {
    var addresses = [String]()
    var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {
        var ptr = ifaddr
        while (ptr != nil) {
            let flags = Int32(ptr!.pointee.ifa_flags)
            var addr = ptr!.pointee.ifa_addr.pointee
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        if let address = String(validatingUTF8:hostname) {
                            addresses.append(address)
                        }
                    }
                }
            }
            ptr = ptr!.pointee.ifa_next
        }
        freeifaddrs(ifaddr)
    }
    return addresses.first ?? ""
}
