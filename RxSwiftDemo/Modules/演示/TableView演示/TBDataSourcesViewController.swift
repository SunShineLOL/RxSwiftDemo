//
//  TBDataSourcesViewController.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SwifterSwift

class TBDataSourcesViewController: TableViewController {
    
    override var tableViewStyle: UITableView.Style {
        return .grouped
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func makeUI() {
        super.makeUI()
        self.tableView.register(cellWithClass: TBDataCell.self)
        self.tableView.register(cellWithClass: HomeCell.self)
        self.tableView.estimatedRowHeight = 50
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? TBDataSourcesViewModel else {
            return
        }
        let modelSelected = self.tableView.rx.modelSelected(TBDataCellViewModel.self).asDriver()
        let input = TBDataSourcesViewModel.Input(modelSelected: modelSelected)
        let output = viewModel.transform(input: input)
        
        output.modelSelected.drive(onNext: {[weak self] model in
            self?.navigator.show(segue: .tbDataSources(ViewModel: TBDataSourcesViewModel(style: model.style.value, provider: viewModel.provider)), sender: self)
        }).disposed(by: rx.disposeBag)
        
        // 分组视图
        let dataSources = RxTableViewSectionedDelegateReloadDataSource<TBDataSection> { (dataSources, tableView, indexPath, cellModel) -> UITableViewCell in
            let section = dataSources.sectionModels[indexPath.section]
            switch section.model.type.value {
            case .header:
                let cell = tableView.dequeueReusableCell(withClass: TBDataCell.self)
                cell.bindViewModel(cellModel)
                return cell
            case .content:
                let cell = tableView.dequeueReusableCell(withClass: TBDataCell.self)
                cell.bindViewModel(cellModel)
                return cell
            case .footer:
                let cell = tableView.dequeueReusableCell(withClass: TBDataCell.self)
                cell.bindViewModel(cellModel)
                return cell
            }
        } configureHeaderView: { (dataSources, tableView, sectionIndex, section) -> UIView in
            let label = Label()
            label.text = "SectionHeaderView\(sectionIndex)"
            return label
        } configureHeaderViewHeight: { (dataSources, tableView, sectionIndex, section) -> CGFloat in
            return 40
        } configureFooterView: { (dataSources, tableView, sectionIndex, section) -> UIView in
            let label = Label()
            label.text = "SectionFooterView\(sectionIndex)"
            return label
        } configureFooterViewHeight: { (dataSources, tableView, sectionIndex, section) -> CGFloat in
            return 40
        }
        
        self.tableView.delegate = dataSources
        output.sections.drive(self.tableView.rx.items(dataSource: dataSources)).disposed(by: rx.disposeBag)
        
    }
}
