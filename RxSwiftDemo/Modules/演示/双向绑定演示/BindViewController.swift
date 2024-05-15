//
//  BindViewController.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit

class BindViewController: ViewController {

    lazy var bindView: BindView = {
        let view = BindView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func makeUI() {
        super.makeUI()
        self.stackView.addArrangedSubview(bindView)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? BindViewModel else {
            return
        }
        let input = BindViewModel.Input(addBtnTrigger: self.bindView.addBtn.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        // 标题
        output.title.drive(self.navigationItem.rx.title).disposed(by: rx.disposeBag)
        // 双向绑定 value <-> field
        (self.bindView.textField.rx.textInput <-> output.fieldValue).disposed(by: rx.disposeBag)
        // bind to showLabel text
        output.fieldValue.bind(to: self.bindView.showLabel.rx.text).disposed(by: rx.disposeBag)
        
    }

}
