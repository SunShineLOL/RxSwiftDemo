//
//  BindView.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SwifterSwift

class BindView: View {

    lazy var textField: UITextField = {
        let view = UITextField()
        view.snp.makeConstraints { make in
            make.height.equalTo(45)
        }
        view.addPaddingLeft(5)
        view.layerCornerRadius = 4
        view.layerBorderColor = .black
        view.layerBorderWidth = 1
        view.textColor = .black
        return view
    }()
    
    lazy var showLabel: Label = {
        let view = Label()
        view.textColor = .red
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = .boldSystemFont(ofSize: 20)
        return view
    }()
    
    lazy var addBtn: Button = {
        let view = Button()
        view.backgroundColor = .blue
        view.layerCornerRadius = 4
        view.setTitle("+1", for: .normal)
        return view
    }()
    
    lazy var fieldStackView: StackView = {
        let view = StackView()
        view.axis = .vertical
        view.addArrangedSubviews([StackView(60), 
                                  showLabel,
                                  textField,
                                  StackView(),
                                  addBtn,
                                  StackView(150)])
        view.spacing = 20
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    override func makeUI() {
        super.makeUI()
        self.stackView.addArrangedSubviews([fieldStackView, StackView()])
        self.stackView.snp.remakeConstraints { make in
            //make.edges.equalTo(20)
            make.top.left.equalTo(20)
            make.right.bottom.equalTo(-20)
        }
    }

}
