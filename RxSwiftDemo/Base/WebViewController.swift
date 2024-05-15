//
//  WebViewController.swift
//  RxSwiftDemo
//
//  Created by czn on 2024/5/14.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit

class WebViewController: ViewController {
    
    let url = BehaviorRelay<URL?>(value: nil)
    
    let titleStr = BehaviorRelay<String?>(value: "")
    
    //是否显示错误数据页面
    private var isShowEmpty: Bool = true
    
    lazy var rightBarButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: nil,
                                   style: .done,
                                   target: nil,
                                   action: nil)
        view.title = "关闭"
        return view
    }()
    
    lazy var webView: WKWebView = {
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        let wkUScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        let webConfig = WKWebViewConfiguration()
        webConfig.userContentController = wkUController
        let view = WKWebView(frame: .zero, configuration: webConfig)
        view.navigationDelegate = self
        return view
    }()
    
    lazy var emptyDataView: View = {
        let view = View()
        view.addSubview(self.emptyDataStackView)
        self.emptyDataStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-64)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        return view
    }()
    
    lazy var emptyDataStackView: StackView = {
        let view = StackView()
        let imgV = ImageView()
        imgV.image = nil
        imgV.contentMode = .scaleAspectFit
        let lab = Label()
        lab.text = "加载失败轻触屏幕重试"
        lab.textColor = UIColor.Text.title
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.numberOfLines = 0
        view.addArrangedSubviews([imgV,lab])
        view.distribution = .equalCentering
        view.alignment = .center
        return view
    }()
    
    lazy var emptyDataSetImageView: ImageView = {
        let view = ImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let isHiddenEmptyView = BehaviorRelay<Bool>(value: true)
    
    init(viewModel: ViewModel?, navigator: Navigator, isShowEmpty: Bool? = true) {
        super.init(viewModel: viewModel, navigator: navigator)
        self.isShowEmpty = isShowEmpty ?? true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(viewModel: nil, navigator: nil)
    //    }
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func makeUI() {
        super.makeUI()
        
        self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        stackView.insertArrangedSubview(webView, at: 0)
        self.webView.addSubview(emptyDataView)
        
        self.emptyDataView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        rightBarButton.rx.tap.asObservable().subscribe(onNext: { [weak self] () in
            if let url = self?.url.value {
                self?.navigator.show(segue: .safari(url), sender: self, transition: .custom)
            }
        }).disposed(by: rx.disposeBag)
        
        ///touch view refresh data
        self.emptyDataView.tap.rx.event.asDriver().map({_ in }).filter({[weak self] () -> Bool in
            return !(self?.isLoading.value ?? false)
        }).drive(onNext: {[weak self] in
            self?.webView.reload()
        }).disposed(by: rx.disposeBag)
        
        self.isHiddenEmptyView.bind(to: self.emptyDataView.rx.isHidden).disposed(by: rx.disposeBag)
        
        //url.map { $0?.absoluteString }.asObservable().bind(to: navigationItem.rx.title).disposed(by: rx.disposeBag)
        titleStr.bind(to: navigationItem.rx.title).disposed(by: rx.disposeBag)
    }
    
    func load(url: URL?, title: String?) {
        guard let url = url else {
            return
        }
        self.url.accept(url)
        if let t = title {
            self.titleStr.accept(t)
        }
        //本地文件
        if url.absoluteString.hasPrefix("file://"){
            let accessURL = url.deletingLastPathComponent()
            webView.loadFileURL(url, allowingReadAccessTo: accessURL)
        }else{
            //网络地址
            webView.load(URLRequest(url: url))
        }
        
    }
    
}

//MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.url.accept(webView.url)
        updateUI()
        self.isLoading.accept(true)
        self.isHiddenEmptyView.accept(true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateUI()
        self.isLoading.accept(false)
        self.isHiddenEmptyView.accept(true)
    }
    
    /*! @abstract Invoked when an error occurs during a committed main frame
     navigation.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @param error The error that occurred.
     */
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        updateUI()
        DLog("\n1.加载失败:\n url:\(webView.url?.absoluteString ?? "")\n error:\(error)")
        self.isLoading.accept(false)
    }
    
    // 页面开始加载失败时调用
    /*! @abstract Invoked when an error occurs while starting to load data for
     the main frame.
     @param webView The web view invoking the delegate method.
     @param navigation The navigation.
     @param error The error that occurred.
     */
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        DLog("\n2.加载失败:\n url:\(webView.url?.absoluteString ?? "")\n error:\(error)")
        self.isLoading.accept(false)
        if isShowEmpty {
            self.isHiddenEmptyView.accept(false)
        }
    }
    
    //Alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        self.showAlert(title: "提示", message: message, buttonTitles: ["确定"])
    }
}

//MARK: - WKUIDelegate
extension WebViewController: WKUIDelegate {
    
}

//MARK: - EmptyDataSetSource
extension WebViewController {
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let view = View(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let imgV = UIImageView(image: nil)
        imgV.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        view.addSubview(view)
        return view
    }
}
