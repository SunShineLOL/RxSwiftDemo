//
//  RxTableViewSectionedDelegateReloadDataSource.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/16.
//

#if os(iOS)
import UIKit
import RxSwift
import RxDataSources

fileprivate struct AssociatedKeys {
    static var ConfigureHeaderViewKey: String = "ConfigureHeaderViewKey"
    static var ConfigureFooterViewKey: String = "ConfigureFooterViewKey"
}
/// custom tableView headerView /footer View
class RxTableViewSectionedDelegateReloadDataSource<S: SectionModelType>: RxTableViewSectionedReloadDataSource<S>, UITableViewDelegate {
    
    /// custom haderView
    public typealias ConfigureHeaderView = (TableViewSectionedDataSource<S>, UITableView, Int, S) -> UIView?
    /// haderView Height
    public typealias ConfigureHeaderViewHeight = (TableViewSectionedDataSource<S>, UITableView, Int, S) -> CGFloat
    
    /// custom footerView
    public typealias ConfigureFooterView = (TableViewSectionedDataSource<S>, UITableView, Int, S) -> UIView?
    /// custom footerView
    public typealias ConfigureFooterViewHeight = (TableViewSectionedDataSource<S>, UITableView, Int, S) -> CGFloat
    
    // sections
    public typealias NumberOfSections = (TableViewSectionedDataSource<S>, UITableView, [S]) -> Int
    // rows
    public typealias NumberOfRowsInSection = (TableViewSectionedDataSource<S>, UITableView, S) -> Int
    
    init(
        configureCell: @escaping ConfigureCell,
        titleForHeaderInSection: @escaping  TitleForHeaderInSection = { _, _ in nil },
        titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
        canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
        canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
        sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
        sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index },
        configureHeaderView: @escaping ConfigureHeaderView = {_, _, _, _ in nil},
        configureHeaderViewHeight: @escaping ConfigureHeaderViewHeight = {_, _, _, _ in 0.001},
        configureFooterView: @escaping ConfigureFooterView = {_, _, _, _ in nil},
        configureFooterViewHeight: @escaping ConfigureFooterViewHeight = {_, _, _, _ in 0.001},
        numberOfSections: NumberOfSections? = nil,
        numberOfRowsInSection: NumberOfRowsInSection? = nil
        ) {
        
        self.configureHeaderView = configureHeaderView
        self.configureHeaderViewHeight = configureHeaderViewHeight
        self.configureFooterView = configureFooterView
        self.configureFooterViewHeight = configureFooterViewHeight
        self.numberOfSections = numberOfSections
        self.numberOfRowsInSection = numberOfRowsInSection
        super.init(
            configureCell: configureCell,
            titleForHeaderInSection: titleForHeaderInSection,
            titleForFooterInSection: titleForFooterInSection,
            canEditRowAtIndexPath: canEditRowAtIndexPath,
            canMoveRowAtIndexPath: canMoveRowAtIndexPath,
            sectionIndexTitles: sectionIndexTitles,
            sectionForSectionIndexTitle: sectionForSectionIndexTitle
        )
    }
    
    
    /// headerView
    ///
    /// configureHeaderView
    open var configureHeaderView: ConfigureHeaderView
    
    /// configureHeaderView height
    open var configureHeaderViewHeight: ConfigureHeaderViewHeight
    
    /// numberOfSections
    open var numberOfSections: NumberOfSections?
    
    /// numberOfRowsInSection
    open var numberOfRowsInSection: NumberOfRowsInSection?
    
    /// footerView
    ///
    /// configureFooterView
    open var configureFooterView: ConfigureFooterView
    
    /// configureFooterView height
    open var configureFooterViewHeight: ConfigureFooterViewHeight
    
    /// UITableViewDelegate
    ///
    /// headerView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return configureHeaderView(self, tableView, section, sectionModels[section])
    }
    
    //footerView
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return configureFooterView(self, tableView, section, sectionModels[section])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return configureHeaderViewHeight(self, tableView, section, sectionModels[section])
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return configureFooterViewHeight(self, tableView, section, sectionModels[section])
    }
    
    // UITableViewDataScoure
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let numSections = numberOfSections else { return super.numberOfSections(in: tableView) }
        return numSections(self, tableView, sectionModels)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowsInSection = numberOfRowsInSection else { return super.tableView(tableView, numberOfRowsInSection: section) }
        return rowsInSection(self, tableView, sectionModels[section])
    }
    
}

#endif

