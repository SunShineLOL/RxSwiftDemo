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

class TBDataSourcesViewController: TableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func makeUI() {
        super.makeUI()
        
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
        
        let dataSources = RxTableViewSectionedReloadDataSource<TBDataSection> { (dataSources, tableView, indexPath, cellModel) -> UITableViewCell in
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
        }
        output.sections.drive(self.tableView.rx.items(dataSource: dataSources)).disposed(by: rx.disposeBag)
        
    }
}
