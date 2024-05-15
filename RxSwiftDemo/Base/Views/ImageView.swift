//
//  ImageView.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit

class ImageView: UIImageView {
    
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
            make.width.equalTo(width)
        }
    }
    
    convenience init(height: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
    }
    
    override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        makeUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    func makeUI() {
        self.layer.masksToBounds = true
        self.contentMode = .scaleAspectFit
        updateUI()
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
}
