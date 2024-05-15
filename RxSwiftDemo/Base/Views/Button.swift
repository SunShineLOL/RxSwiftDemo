//
//  Button.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SwifterSwift

class Button: UIButton {
    
    ///  调整布局样式时的间距(isInsetsAdjust = true 有效)
    var space: CGFloat = 0
    
    ///图片位置 图片文字布局样式(isInsetsAdjust = true 有效)
    var insetsStyle: ButtonInsetsStyle = .left
    
    ///是否调整按钮布局(控制 space,insetsStyle是否生效)
    var isInsetsAdjust: Bool = false
    
    override var isSelected: Bool{
        didSet {
            if isSelected {
                if let color = borderSelectedColor {
                    self.layer.borderColor = color.cgColor
                }
            }else{
                if let color = borderNormalColor {
                    self.layer.borderColor = color.cgColor
                }
            }
        }
    }
    
    private var borderSelectedColor: UIColor?
    
    private var borderNormalColor: UIColor?
    
    
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
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.font = .systemFont(ofSize: 16)
        setTitleColor(.white, for: .normal)
        layerCornerRadius = 4
        
        snp.makeConstraints { (make) in
            make.height.equalTo(44)
        }
        
        updateUI()
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isInsetsAdjust {
            self.imagePosition(at: self.insetsStyle, space: space)
            
        }
    }
    
}

extension Button {
    
    func borderColor(_ color: UIColor?, for state: UIControl.State) {
        switch state {
        case .normal:
            borderNormalColor = color
            self.layer.borderColor = color?.cgColor
        case .selected:
            borderSelectedColor = color
            //ohter state...
        default:
            break
        }
    }
}

//MARK: -> 带角标的button
class BadgeView: View {
    lazy var badge: Label = {
        let view = Label()
        view.textAlignment = .center
        view.backgroundColor = UIColor.init(hexString: "#FE5E49")
        view.textColor = .white
        view.font = .systemFont(ofSize: 9)
        view.textInsets = UIEdgeInsets(horizontal: 6, vertical: 2)
        view.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(view.snp.height)
        }
        view.layerCornerRadius = 6.5
        return view
    }()
    
    lazy var bgView: View = {
        let view = View()
        view.layerCornerRadius = 5
        view.backgroundColor = UIColor.init(hexString: "#F8FBFF")
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.size.equalTo(30)
        }
        return view
    }()
    
    lazy var btn: Button = {
        let view = Button()
        view.snp.remakeConstraints { (make) in
            make.height.equalTo(75)
        }
        //button按钮布局
        view.isInsetsAdjust = true
        view.space = 8
        view.insetsStyle = .top
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bgView.center = btn.imageView?.center ?? .zero
        self.badge.center = CGPoint(x: self.bgView.center.x + self.bgView.width / 2 - 2, y: self.bgView.center.y - self.bgView.height / 2)
    }
    override func makeUI() {
        super.makeUI()
        self.sendSubviewToBack(self.bgView)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.setTitleColor(UIColor.init(hexString: "#2B2D2C"), for: .normal)
        self.stackView.addArrangedSubview(btn)
        self.addSubview(badge)
        self.bringSubviewToFront(badge)
        self.stackView.alignment = .fill
        badge.rx.observe(String.self, "text").map { (str) -> Bool in
            if let num = str?.int, num > 0 {
                return false
            }
            return true
        }.bind(to: badge.rx.isHidden).disposed(by: rx.disposeBag)
    }
}

