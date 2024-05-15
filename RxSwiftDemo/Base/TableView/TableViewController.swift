//
//  TableViewController.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import KafkaRefresh

class TableViewController: ViewController, UITableViewDelegate {
    
    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()
    
    let isHeaderLoading = BehaviorRelay(value: false)
    let isFooterLoading = BehaviorRelay(value: false)
    
    var tableViewStyle: UITableView.Style {
        return .plain
    }
    
    lazy var tableView: TableView = {
        let view = TableView(frame: CGRect(), style: tableViewStyle)
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kBottomSafeHeight, right: 0)
        view.rx.setDelegate(self).disposed(by: rx.disposeBag)
        return view
    }()
    
    var clearsSelectionOnViewWillAppear = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if clearsSelectionOnViewWillAppear == true {
            deselectSelectedRow()
        }
    }
    
    override func makeUI() {
        super.makeUI()
        self.emptyDataSetImage = nil
        stackView.spacing = 0
        stackView.insertArrangedSubview(tableView, at: 0)
        self.tableView.contentInsetAdjustmentBehavior = .never
        tableView.bindGlobalStyle(forHeadRefreshHandler: { [weak self] in
            self?.headerRefreshTrigger.onNext(())
        })
        
        tableView.bindGlobalStyle(forFootRefreshHandler: { [weak self] in
            self?.footerRefreshTrigger.onNext(())
        })
        
        isHeaderLoading.bind(to: tableView.headRefreshControl.rx.isAnimating).disposed(by: rx.disposeBag)
        
        isFooterLoading.bind(to: tableView.footRefreshControl.rx.isAnimating).disposed(by: rx.disposeBag)
        
        tableView.footRefreshControl.autoRefreshOnFoot = true
        
        let updateEmptyDataSet = Observable.of(isLoading.mapToVoid().asObservable(), emptyDataSetImageTintColor.mapToVoid(), languageChanged.asObservable()).merge()
        updateEmptyDataSet.subscribe(onNext: { [weak self] () in
            self?.tableView.reloadEmptyDataSet()
        }).disposed(by: rx.disposeBag)
        
        //errors
    }
    
    override func updateUI() {
        super.updateUI()
    }
}

extension TableViewController {
    
    func deselectSelectedRow() {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            selectedIndexPaths.forEach({ (indexPath) in
                tableView.deselectRow(at: indexPath, animated: false)
            })
        }
    }
}
