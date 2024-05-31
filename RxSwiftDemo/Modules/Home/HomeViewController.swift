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
        crashTest()
    }
    
    var superNode: BaseCoordinator? = BaseCoordinator(with: nil, parent: nil)
    // test crash
    func crashTest() {
        var node1: BaseCoordinator? = BaseCoordinator(with: nil, parent: superNode)
        var node2 = BaseCoordinator(with: nil, parent: node1)
        node1 = nil
        superNode?.finish()
        /// crash
        /// Fatal error: Attempted to read an unowned reference but object 0x300165890 was already deallocated
        node2.finish()
    }
}

public class CoordinatorNode {
    fileprivate private(set) unowned var parent: Coordinator?
    public private(set) var children: [Coordinator] = []

    fileprivate init(parent: Coordinator?) {
        self.parent = parent
    }

    fileprivate func addChild(coordinator: Coordinator) {
        self.children.append(coordinator)
    }

    fileprivate func removeChild(coordinator: Coordinator) {
        self.children = self.children.filter { $0 !== coordinator }
    }
}

public protocol Coordinator: AnyObject {
    var node: CoordinatorNode { get }
    var presenter: UIViewController? { get }

    var onFinish: (() -> Void)? { get set }

    var shouldPopBack: Bool { get }

    var shouldPopToRoot: Bool { get }

    func shouldPopTo(viewController: UIViewController) -> Bool

    func start()
//    func finish()//NOTE: [uy.nguyen@wonderlabs.io] Comment out this function because we will create a finish function in the extension of Coordinator as default implementation. And also don't want it can be overriden by sub-class when using the BaseCoordinator. Ref https://stackoverflow.com/a/34777469
}

extension Coordinator {
    public var shouldPopBack: Bool {
        return true
    }

    public var shouldPopToRoot: Bool {
        return true
    }

    public func shouldPopTo(viewController: UIViewController) -> Bool {
        return true
    }

    fileprivate func free(coordinator: Coordinator) {
        self.node.removeChild(coordinator: coordinator)
    }

    public func finish() {
        while !(self.node.children.isEmpty) {
            self.node.children.first?.finish()
        }
        
        /// crash occurred when attempting to access self.node.parent,
        /// indicating that parent may have been deallocated when accessing this property.
        if let parent = self.node.parent {
            parent.free(coordinator: self)
        }
        

        self.onFinish?()

        let className = type(of: self)
        let classAddress = Unmanaged.passUnretained(self).toOpaque()
        let message = "coordinator_log: 🟡 "
            .appending("\(className)")
            .appending(" - ")
            .appending("\(classAddress)")
            .appending(" finished (called from Coordinator)")
        print(message)
    }
}

open class BaseCoordinator: Coordinator {
    public weak var presenter: UIViewController?
    public private(set) var node: CoordinatorNode

    public var onFinish: (() -> Void)?

    open var shouldPopBack: Bool {
        return true
    }

    open var shouldPopToRoot: Bool {
        return true
    }

    open func shouldPopTo(viewController: UIViewController) -> Bool {
        return true
    }
    
    public init(with presenter: UIViewController?, parent coordinator: Coordinator?) {
        self.presenter = presenter
        self.node = CoordinatorNode(parent: coordinator)

        self.node.parent?.node.addChild(coordinator: self)

        let className = type(of: self)
        let classAddress = Unmanaged.passUnretained(self).toOpaque()
        let message = "coordinator_log: ☘️ "
            .appending("\(className)")
            .appending(" - ")
            .appending("\(classAddress)")
            .appending(" has been init (called from BaseCoordinator)")
        print(message)
    }

    open func start() {
        fatalError("This function must be overridden by subclass")
    }

    deinit {
        let className = type(of: self)
        let classAddress = Unmanaged.passUnretained(self).toOpaque()
        let message = "coordinator_log: ❌ "
            .appending("\(className)")
            .appending(" - ")
            .appending("\(classAddress)")
            .appending(" has been deinit (called from BaseCoordinator)")
        print(message)
        print("coordinator_log: ")
    }
}
