//
//  View.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit

public class View: UIView {
    
    lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: nil)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
        return tap
    }()
    
    lazy var stackView: StackView = {
        let view = StackView()
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return view
    }()
    
    convenience init(width: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        snp.makeConstraints { (make) in
            make.width.equalTo(width).priority(999)
        }
    }
    
    convenience init(height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        snp.makeConstraints { (make) in
            make.height.equalTo(height).priority(999)
        }
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
        self.layer.masksToBounds = true
        updateUI()
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
    
    func getCenter() -> CGPoint {
        return convert(center, from: superview)
    }
}

extension UIView {
    
    var inset: CGFloat {
        return 10
    }
    
    //    var tap: UITapGestureRecognizer {
    //        let tap = UITapGestureRecognizer(target: self, action: nil)
    //        tap.setValue("tap", forKey: "userTap")
    //        DLog("添加手势:\(tap.value(forKey: "userTap") ?? "")")
    //        self.isUserInteractionEnabled = true
    //        self.addGestureRecognizer(tap)
    //        return tap
    //    }
    
    public func setPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        self.setContentHuggingPriority(priority, for: axis)
        self.setContentCompressionResistancePriority(priority, for: axis)
    }
}

