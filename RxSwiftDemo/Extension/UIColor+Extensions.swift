//
//  UIColor+Extensions.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit

//text
extension UIColor {
    struct Text {
        static var content: UIColor {
            return UIColor.blue
        }
        
        static var line: UIColor {
            return .colorF6F7F8
        }
        
        static var title: UIColor {
            return .color2B2D2C
        }
        
        static var disabled: UIColor {
            return .colorFAFAFA
        }
        
        static var placeholder: UIColor {
            return .colorA6B1C2
        }
    }
}

//view
extension UIColor {
    struct View {
        ///主色调
        static var main: UIColor {
            return .color78A8FE
        }
        
        ///主背景色调 浅浅蓝色
        static var mainBg: UIColor {
            return .colorF2F7FF
        }
        
        /// 主色黄色
        static var yellow: UIColor {
            return .colorFFB65D
        }
        
        ///浅蓝色
        static var bg1: UIColor {
            return .colorF1F6FF
        }
        
        /// 淡蓝色
        static var bg2: UIColor {
            return .colorCEDFFF
        }
    }
}
// MARK: 项目中常用color
extension UIColor {
    
    ///用于导航栏、价格等重要文字信息，搜素栏目及标签栏底色、标题颜色，重要文本等；
    static var color2B2D2C: UIColor {
        return UIColor.init(hexString: "#2B2D2C") ?? .black
    }
    
    /// 普通文本颜色
    static var color545558: UIColor {
        return UIColor.init(hexString: "#545558") ?? .black
    }
    
    /// 提醒文本颜色
    static var colorA6B1C2: UIColor {
        return UIColor.init(hexString: "#A6B1C2") ?? .black
    }
    
    /// 提醒文本颜色
    static var colorD4D6DA: UIColor {
        return UIColor.init(hexString: "#D4D6DA") ?? .black
    }
    
    /// 标签信息icon,分割线颜色 次级文本颜色
    static var colorFAFAFA: UIColor {
        return UIColor.init(hexString: "#FAFAFA") ?? .black
    }
    
    /// 标签信息icon,分割线颜色 次级文本颜色
    static var colorF6F7F8: UIColor {
        return UIColor.init(hexString: "#F6F7F8") ?? .black
    }
    
    //MARK: 色系
    /// 主色系
    static var color78A8FE: UIColor {
        return UIColor.init(hexString: "#78A8FE") ?? .black
    }
    
    /// 辅色系橙色
    static var colorFFB65D: UIColor {
        return UIColor.init(hexString: "#FFB65D") ?? .black
    }
    
    /// 辅色系深蓝黑
    static var color092D5D: UIColor {
        return UIColor.init(hexString: "#092D5D") ?? .black
    }
    
    /// 辅色系蓝黑
    static var color5B78A0: UIColor {
        return UIColor.init(hexString: "#5B78A0") ?? .black
    }
    
    /// 辅色系浅蓝黑
    static var colorB7C4D7: UIColor {
        return UIColor.init(hexString: "#B7C4D7") ?? .black
    }
    
    //MARKl: 背景色
    /// 主级背景浮层 浅浅蓝色
    static var colorF2F7FF: UIColor {
        return UIColor.init(hexString: "#F2F7FF") ?? .black
    }
    
    /// 次级背景浮层 浅蓝色
    static var colorF1F6FF: UIColor {
        return UIColor.init(hexString: "#F1F6FF") ?? .black
    }
    
    /// 次级背景浮层 蓝色
    static var colorCEDFFF: UIColor {
        return UIColor.init(hexString: "#CEDFFF") ?? .black
    }
    
}

//MARK: -> 随机颜色
extension UIColor {
    //传递颜色，size返回image
    func colorImage(viewSize: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(self.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image
    }
}

//MARK: -> 根据文本has值生成 color
extension UIColor {
    /// 根据文字生成color
    static func strColor(str: String?) -> UIColor? {
        if let str = str {
            return UIColor.init(hexString: ColorHash().hex(str))
        }
        return nil
    }
}

extension String {
    /// 根据文字内容生成颜色
    var colorText: UIColor? {
        return UIColor.init(hexString: ColorHash().hex(self))
    }
}

