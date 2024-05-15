//
//  HomeViewController.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

class HomeViewController: TableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func makeUI() {
        super.makeUI()
        self.tableView.register(cellWithClass: HomeCell.self)
        self.tableView.estimatedRowHeight = 50
        // 禁用刷新
        self.tableView.headRefreshControl = nil
        self.tableView.footRefreshControl = nil
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? HomeViewModel else {
            return
        }
        // cell 点击事件
        let modelSelected = self.tableView.rx.modelSelected(HomeCellViewModel.self).asDriver()
        // 输入
        let input = HomeViewModel.Input(modelSelected: modelSelected)
        // viewModel接收输入处理后输出
        let output = viewModel.transform(input: input)
        
        // bind title to navigation item title
        output.title.drive(self.navigationItem.rx.title).disposed(by: rx.disposeBag)
        
        // bind model to tableView
        output.items.drive(self.tableView.rx.items(cellIdentifier: HomeCell.ReuserIdentifier, cellType: HomeCell.self)) { index, model, cell in
            // bind model to cell
            cell.bindViewModel(model: model)
        }.disposed(by: rx.disposeBag)
        
        // cell touch event
        output.modelSelected.drive(onNext: { [weak self] scene in
            self?.navigator.show(segue: scene, sender: self)
        }).disposed(by: rx.disposeBag)
        
        // bind loading
        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        // bind error
        viewModel.parsedError.bind(to: error).disposed(by: rx.disposeBag)
    }
    
    
}
