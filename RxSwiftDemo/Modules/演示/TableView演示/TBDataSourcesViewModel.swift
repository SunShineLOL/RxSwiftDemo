//
//  TBDataSourcesViewModel.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit
import RxSwift
import RxCocoa

class TBDataSourcesViewModel: ViewModel, ViewModelType {
    struct Input {
        let modelSelected: Driver<TBDataCellViewModel>
    }
    
    struct Output {
        let items: Driver<[TBDataCellViewModel]>
        let sections: Driver<[TBDataSection]>
        let modelSelected: Driver<TBDataCellViewModel>
    }
    let style: BehaviorRelay<TBTableStyle>
    
    init(style: TBTableStyle = .cell, provider: any DemoApi) {
        self.style = BehaviorRelay(value: style)
        super.init(provider: provider)
    }
    
    func transform(input: Input) -> Output {
        let models = [TBTableStyle.cell, TBTableStyle.section].map({TBDataCellViewModel(style: $0)})
        let items = Driver<[TBDataCellViewModel]>.just(models)
        let headerSection = TBDataSection(model: TBDataSectionModel(type: .header), items: models)
        let contentSection = TBDataSection(model: TBDataSectionModel(type: .content), items: models)
        let footerSection = TBDataSection(model: TBDataSectionModel(type: .footer), items: models)
        let sections = Driver<[TBDataSection]>.just([headerSection, contentSection, footerSection])
        let modelSelected = input.modelSelected
        return Output(items: items,
                      sections: sections,
                      modelSelected: modelSelected)
    }
}
