//
//  HomeViewModel.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewModel: ViewModel, ViewModelType {
    struct Input {
        let modelSelected: Driver<HomeCellViewModel>
    }
    
    struct Output {
        let title: Driver<String>
        let items: Driver<[HomeCellViewModel]>
        let modelSelected: Driver<Navigator.Scene>
    }
    
    func transform(input: Input) -> Output {
        let modelSelected = input.modelSelected.map {[weak self] model -> Navigator.Scene? in
            guard let self = self else { return nil}
            switch model.type.value {
            case .fieldBind:
                return .bind(ViewModel: BindViewModel(provider: self.provider))
            case .table:
                return .tbDataSources(ViewModel: TBDataSourcesViewModel(provider: self.provider))
            default:
                break
            }
            return nil
        }.filterNil()
        let models = [Demo(type: .fieldBind), Demo(type: .table)]
        let title = Driver<String>.just("RxSwift+MVVM演示Demo")
        let items = Driver<[HomeCellViewModel]>.just(models.map({ HomeCellViewModel(demo: $0)}))
        return Output(title: title, items: items, modelSelected: modelSelected)
    }
}
