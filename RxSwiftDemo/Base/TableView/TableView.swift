//
//  TableView.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit

class TableView: UITableView {
    
    init () {
        super.init(frame: CGRect(), style: .grouped)
        makeUI()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    func makeUI() {
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 0
        sectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
        estimatedSectionHeaderHeight = 0
        backgroundColor = .clear
        cellLayoutMarginsFollowReadableWidth = false
        keyboardDismissMode = .onDrag
        separatorColor = .clear
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        tableFooterView = UIView()
    }
}

