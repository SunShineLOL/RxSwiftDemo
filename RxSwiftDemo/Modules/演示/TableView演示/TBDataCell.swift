//
//  TBDataCell.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit
import RxSwift
import SnapKit
import SwifterSwift

class TBDataCell: TableViewCell {
    
    lazy var selectedBtn: Button = {
        let view = Button()
        view.snp.remakeConstraints({$0.size.equalTo(30)})
        view.setImage(UIImage(resource: .unselectIcon), for: .normal)
        view.setImage(UIImage(resource: .selectIcon), for: .selected)
        return view
    }()
    
    lazy var name: Label = {
        let view = Label()
        view.textColor = .black
        return view
    }()
    
    override func makeUI() {
        super.makeUI()
        self.stackView.axis = .horizontal
        self.stackView.addArrangedSubviews([name, StackView(), selectedBtn])
    }
    
    func bindViewModel(_ model: TBDataCellViewModel) {
        model.title.drive(self.name.rx.text).disposed(by: rx.disposeBag)
        model.isSelected.bind(to: self.selectedBtn.rx.isSelected).disposed(by: rx.disposeBag)
    }
}
