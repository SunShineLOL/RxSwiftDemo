//
//  TableViewCell.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/15.
//

import UIKit
import RxCocoa
import RxSwift

//cell reuserIdentifier
protocol Registrable {
    static var ReuserIdentifier: String { get }
}
extension Registrable {
    // cell重用标识符 return String(describing: self)
    static var ReuserIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView: Registrable {}

extension UITableViewCell: Registrable {}

class TableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    var isSelection = false
    
    var selectionColor: UIColor? {
        didSet {
            setSelected(isSelected, animated: true)
        }
    }
    
    lazy var containerView: View = {
        let view = View()
        view.backgroundColor = .clear
        self.contentView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: self.inset*2, vertical: self.inset)).priority(999)
        })
        return view
    }()
    
    lazy var stackView: StackView = {
        let subviews: [UIView] = []
        let view = StackView(arrangedSubviews: subviews)
        view.axis = .horizontal
        view.alignment = .fill
        self.containerView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(inset)
        })
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        backgroundColor = selected ? selectionColor : .clear
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func makeUI() {
        layer.masksToBounds = true
        selectionStyle = .none
        backgroundColor = .clear
        
        updateUI()
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
}

extension Reactive where Base: TableViewCell {
    
    var selectionColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.selectionColor = attr
        }
    }
}
