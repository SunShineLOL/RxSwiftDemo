//
//  Label.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit
import SwifterSwift

class Label: UILabel {
    
    lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: nil)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
        return tap
    }()
    
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    func makeUI() {
        layer.masksToBounds = true
        numberOfLines = 1
        textColor = .black
        //        cornerRadius = Configs.BaseDimensions.cornerRadius
        updateUI()
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
}

extension Label {
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }
    
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }
    
    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }
    
    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
}


extension Label {
    /// 创建一条分割线 color: 分割线颜色，axis:方向  —（横向）| （纵向），num:宽度或者高度
    static func line(color: UIColor? = UIColor.Text.line, axis: NSLayoutConstraint.Axis = .vertical, num: Float = 1) -> Label{
        let view = Label()
        view.backgroundColor = color
        view.snp.makeConstraints { (make) in
            if axis == .vertical {
                make.height.equalTo(num)
            }else{
                make.width.equalTo(num)
            }
        }
        return view
    }
}

extension Label {
    static func colorLabel(_ size: CGSize = CGSize(width: 30, height: 30)) -> Label {
        let label = Label()
        label.rx.observe(String.self, "text").map({UIColor.strColor(str: $0) ?? .black}).bind(to: label.rx.textColor).disposed(by: label.rx.disposeBag)
        label.textAlignment = .center
        label.layerCornerRadius = 5
        label.backgroundColor = UIColor.init(hexString: "#F8FBFF")
        label.font = .systemFont(ofSize: 15)
        label.snp.remakeConstraints { (make) in
            make.size.equalTo(size).priority(999)
        }
        return label
    }
}

