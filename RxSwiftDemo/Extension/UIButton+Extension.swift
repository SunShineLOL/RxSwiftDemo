//
//  UIButton+Extension.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit

//按钮背景颜色
extension UIButton{
    func setBackgroundColor(color: UIColor?, for state: UIControl.State){
        self.setBackgroundImage(color?.colorImage(), for: state)
    }
}

/**
 UIButton图像文字同时存在时---图像相对于文字的位置
 
 - top:    图像在上
 - left:   图像在左
 - right:  图像在右
 - bottom: 图像在下
 */
/// 图片位置
enum ButtonInsetsStyle {
         /// - top:    图像在上
    case top,
         /// - left:   图像在左
         left,
         /// - right:  图像在右
         right,
         /// - bottom: 图像在下
         bottom
}

extension UIButton {
    func imagePosition(at style: ButtonInsetsStyle, space: CGFloat) {
        guard let imageV = imageView else { return }
        guard let titleL = titleLabel else { return }
        
        let btnWidth = self.width
        //let btnHeight = self.height
        //获取图像的宽和高
        let imageWidth = imageV.frame.size.width
        let imageHeight = imageV.frame.size.height
        //获取文字的宽和高
        var labelWidth  = titleL.intrinsicContentSize.width
        let labelHeight = titleL.intrinsicContentSize.height
        
        labelWidth = labelWidth + imageWidth > btnWidth ? btnWidth - space - imageWidth : labelWidth
        
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        //UIButton同时有图像和文字的正常状态---左图像右文字，间距为0
        switch style {
        case .left:
            //正常状态--只不过加了个间距
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space * 0.5, bottom: 0, right: space * 0.5)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space * 0.5, bottom: 0, right: -space * 0.5)
            self.contentEdgeInsets.left = space * 0.5
            self.contentEdgeInsets.right = space * 0.5
        case .right:
            //切换位置--左文字右图像
            //图像：UIEdgeInsets的left是相对于UIButton的左边移动了labelWidth + space * 0.5，right相对于label的左边移动了-labelWidth - space * 0.5
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + space * 0.5, bottom: 0, right: -labelWidth - space * 0.5)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space * 0.5, bottom: 0, right: imageWidth + space * 0.5)
            self.contentEdgeInsets.left = space * 0.5
            self.contentEdgeInsets.right = space * 0.5
        case .top:
            //切换位置--上图像下文字
            /**使图片和文字水平居中显示
             *文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
             *图片距离右边框距离减少图片的宽度，其它不边
             */
            imageEdgeInsets = UIEdgeInsets(top: -(labelHeight + space), left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: imageHeight + space, left:  -imageWidth, bottom:0, right: 0)
            
            self.contentEdgeInsets.top = space * 0.5
            self.contentEdgeInsets.bottom = space * 0.5
            
        case .bottom:
            //切换位置--下图像上文字
            /**使图片和文字水平居中显示
             *文字的中心位置向左移动了imageWidth * 0.5，向上移动了labelHeight*0.5+space*0.5
             */
            imageEdgeInsets = UIEdgeInsets(top: labelHeight + space, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -(imageHeight + space), left:  -imageWidth, bottom:0, right: 0)
            //            imageEdgeInsets = UIEdgeInsets(top: imageHeight * 0.5 + space * 0.5, left: labelWidth * 0.5, bottom: -imageHeight * 0.5 - space * 0.5, right: -labelWidth * 0.5)
            //            labelEdgeInsets = UIEdgeInsets(top: -labelHeight * 0.5 - space * 0.5, left: -imageWidth * 0.5, bottom: labelHeight * 0.5 + space * 0.5, right: imageWidth * 0.5)
            self.contentEdgeInsets.top = space * 0.5
            self.contentEdgeInsets.bottom = space * 0.5
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}

extension UIButton {
    func adjustsImageTitlePosition(type: ButtonInsetsStyle = .top, spacing: CGFloat = 6.0) {
        switch type {
        case .top:
            guard let imageSize = self.imageView?.image?.size,
                let text = self.titleLabel?.text,
                let font = self.titleLabel?.font else {
                    return
            }
            
            self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
            
            let labelString = NSString(string: text)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
            
            let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
            self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
        default:
            break
        }
    }
}

