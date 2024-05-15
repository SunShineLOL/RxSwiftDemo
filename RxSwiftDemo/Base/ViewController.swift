//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit
import DZNEmptyDataSet
import SwifterSwift
import RxCocoa
import RxSwift
import SnapKit
import NSObject_Rx
import Toast_Swift

class ViewController: UIViewController, Navigatable {
    
    var viewModel: ViewModel?
    var navigator: Navigator!
    
    init(viewModel: ViewModel?, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    let isLoading = BehaviorRelay(value: false)
    let error = PublishSubject<ApiError>()
    
    var automaticallyAdjustsLeftBarButtonItem = true
    
    var navigationTitle = "" {
        didSet {
            navigationItem.title = navigationTitle
        }
    }
    
    let spaceBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    
    let emptyDataSetButtonTap = PublishSubject<Void>()
    let emptyDataSetViewTap = PublishSubject<Void>()
    var emptyDataSetTitle = ""
    var emptyDataSetDescription = "暂无数据"
    var emptyDataSetImage: UIImage?
    var emptyDataSetVerticalOffset: CGFloat = kNavigationHeight - 4
    var emptyDataSetImageTintColor = BehaviorRelay<UIColor?>(value: nil)
    ///
    var emptyDataSetDisplay = BehaviorRelay<Bool>(value: true)
    
    let languageChanged = BehaviorRelay<Void>(value: ())
    
    let motionShakeEvent = PublishSubject<Void>()
    
    //contentView top 布局是否在安全域内部(解决在JXSegmentedView子View中的偏移问题)
    var isSafeAreaLayoutGuideTop = BehaviorRelay(value: true)
    
    lazy var contentView: UIView = {
        let view = View()
        //        view.hero.id = "CententView"
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        return view
    }()
    
    lazy var stackView: StackView = {
        let subviews: [UIView] = []
        let view = StackView(arrangedSubviews: subviews)
        view.spacing = 0
        self.contentView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return view
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 设置界面从{0,0}开始而不是在导航栏底部 -部分界面布局会有问题
        self.edgesForExtendedLayout = UIRectEdge.all
        self.extendedLayoutIncludesOpaqueBars = true
        makeUI()
        bindViewModel()
        
        // Observe device orientation change
        NotificationCenter.default
            .rx.notification(UIDevice.orientationDidChangeNotification)
            .subscribe { [weak self] (event) in
                self?.orientationChanged()
            }.disposed(by: rx.disposeBag)
        
        // Observe application did become active notification
        NotificationCenter.default
            .rx.notification(UIApplication.didBecomeActiveNotification)
            .subscribe { [weak self] (event) in
                self?.didBecomeActive()
            }.disposed(by: rx.disposeBag)
        
        NotificationCenter.default
            .rx.notification(UIAccessibility.reduceMotionStatusDidChangeNotification)
            .subscribe(onNext: { (event) in
                DLog("Motion Status changed")
            }).disposed(by: rx.disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 防止用户快速pop导致pop动画异常
        self.navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
        logResourcesCount()
        // 防止用户快速pop导致pop动画异常
        self.navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    deinit {
        DLog("\(type(of: self)): Deinited ✅")
        logResourcesCount()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        DLog("\(type(of: self)): Received Memory Warning")
    }
    
    func makeUI() {
        hero.isEnabled = true
        self.view.backgroundColor = .white
        navigationController?.navigationBar.setTitleFont(UIFont.systemFont(ofSize: 18),
                                                         color: .white)
        updateUI()
    }
    
    func bindViewModel() {
        
        viewModel?.parsedError.subscribe(onNext: {[weak self] (error) in
            switch error {
            case .authError(_):
                self?.showAlert(title: "提示", message: "登录信息过期请重新登录", buttonTitles: ["确定"], highlightedButtonIndex: 0, completion: { (index) in
                    ///token过期需要重新登录
                    // 跳转登录页面
                })
            default: break
            }
            
        }).disposed(by: rx.disposeBag)
        
        //errors
        //过滤token失效信息
        error.filter({$0.isAuthError == false}).asDriverOnErrorJustComplete().drive(onNext: { [weak self] (error) in
            var description = "未知错误"
            //let image = R.image.icon_toast_warning()
            switch error {
            case .serverError(let response):
#if DEBUG
                description = "\(response.msg ?? "")(\(response.code ?? -1))"
#else
                description = "\(response.msg ?? "")"
#endif
            case .otherError(let msg, let code, _):
#if DEBUG
                description = "\(msg ?? "")(\((code != nil) ? "\(code ?? -1)" : "未知错误"))"
#else
                description = "\(msg)"
#endif
            default: break
            }
            self?.view.makeToast(description)
        }).disposed(by: rx.disposeBag)
        
        isLoading.asDriver().drive(onNext: { [weak self] (isLoading) in
            isLoading ? self?.view.makeToastActivity(.center) : self?.view.hideToast()
        }).disposed(by: rx.disposeBag)
        
    }
    
    ///errorCode 302 弹出登录页面后默认导航栏返回rootVC,子类重写可自定义业务
    func showLoginViewComletion(){
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    
    
    func updateUI() {
        //
        isSafeAreaLayoutGuideTop.asDriver().skip(1).distinctUntilChanged().drive(onNext: {[weak self] (b) in
            guard let self = self else { return }
            self.contentView.snp.remakeConstraints({ (make) in
                make.left.bottom.right.equalToSuperview()
                if b {
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                }else{
                    make.top.equalTo(self.view.snp.top)
                }
            })
            
        }).disposed(by: rx.disposeBag)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            motionShakeEvent.onNext(())
        }
    }
    
    func orientationChanged() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.updateUI()
        }
    }
    
    func didBecomeActive() {
        self.updateUI()
    }
}

extension ViewController {
    
    var inset: CGFloat {
        return 10
    }
    
    func emptyView(withHeight height: CGFloat) -> View {
        let view = View()
        view.snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
        return view
    }
}

extension Reactive where Base: ViewController {
    
    /// Bindable sink for `backgroundColor` property
    var emptyDataSetImageTintColorBinder: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.emptyDataSetImageTintColor.accept(attr)
        }
    }
}

extension ViewController: DZNEmptyDataSetSource {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: emptyDataSetTitle,
                                  attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.Text.title])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: emptyDataSetDescription)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return emptyDataSetImage
    }
    
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return emptyDataSetImageTintColor.value
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .clear
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -emptyDataSetVerticalOffset
    }
}

extension ViewController: DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !isLoading.value && emptyDataSetDisplay.value
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        emptyDataSetButtonTap.onNext(())
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        emptyDataSetViewTap.onNext(())
    }
}
