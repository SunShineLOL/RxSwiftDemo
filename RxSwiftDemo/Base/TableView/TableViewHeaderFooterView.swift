//
//  TableViewHeaderFooterView.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit
import RxCocoa
import RxSwift

class TableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    lazy var stackView: StackView = {
        let view = StackView()
        view.alignment = .fill
        view.spacing = 0
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    func makeUI() {
        //plan 模式下的分组视图会有默认背景颜色 赋值 backgroundView 可设置成透明
        self.backgroundView = View()
    }
    
    
    
}
