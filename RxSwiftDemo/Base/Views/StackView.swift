//
//  StackView.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit

class StackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    convenience init(_ height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        snp.makeConstraints { (make) in
            make.height.equalTo(height).priority(999)
        }
    }
    
    convenience init(width: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        snp.makeConstraints { (make) in
            make.width.equalTo(width).priority(999)
        }
    }
    
    func makeUI() {
        spacing = inset
        axis = .vertical
        // self.distribution = .fill
        self.translatesAutoresizingMaskIntoConstraints = false
        updateUI()
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
}
