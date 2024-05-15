//
//  HomeCell.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit

class HomeCell: TableViewCell {

    lazy var titleLabel: Label = {
        let view = Label()
        view.textColor = .black
        return view
    }()
    
    override func makeUI() {
        super.makeUI()
        // 横向布局
        self.stackView.axis = .horizontal
        // 将label添加到布局上， 并添加右边的占位视图
        self.stackView.addArrangedSubviews([titleLabel, StackView()])
    }
    
    func bindViewModel(model: HomeCellViewModel) {
        model.name.drive(self.titleLabel.rx.text).disposed(by: self.disposeBag)
    }

}
