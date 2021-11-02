//
//  YXBaseWKWebView.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/2.
//

import UIKit
import WebKit

class YXBaseWKWebView: YXBaseVC {

    //MARK:- 初始化声明
    var webUrl: String? {
        
        didSet {
            let url = URL(string: webUrl! as String)
            let request = URLRequest(url: url!)
            self.wkWebView.load(request)
        }
    }
    lazy var wkWebView: WKWebView = {
       
        let config = WKWebViewConfiguration.init()
        let wkWebView = WKWebView(frame: self.view.bounds, configuration: config)
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
        self.view.addSubview(wkWebView)
        
        wkWebView.snp.makeConstraints { make in
            
            make.top.equalTo(self.navigationView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        return wkWebView
    }()
    lazy var progressView: UIProgressView = {
        
        let progressView = UIProgressView()
        progressView.frame = CGRect(x: 0, y: 0, width: self.yxScreenWidth, height: 2)
        progressView.progressTintColor = UIColor.red
        progressView.trackTintColor = UIColor.clear
        self.view.addSubview(progressView)
        
        progressView.snp.makeConstraints { make in
            
            make.top.equalTo(self.navigationView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        
        return progressView
    }()
    lazy var getH5MethodBtn: UIButton = {
        
        let getH5MethodBtn = UIButton(type: .custom)
        getH5MethodBtn.setTitle("点击调用h5方法", for: .normal)
        getH5MethodBtn.setTitleColor(UIColor.blue, for: .normal)
        getH5MethodBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        getH5MethodBtn.addTarget(self, action: #selector(progressGetH5MethodBtn(_:)), for: .touchUpInside)
        self.wkWebView.addSubview(getH5MethodBtn)
        
        getH5MethodBtn.snp.makeConstraints { make in
            
            make.left.equalTo(self.wkWebView).offset(15)
            make.top.equalTo(self.wkWebView).offset(40)
            make.width.equalTo(120)
            make.height.equalTo(30)
        }
        
        return getH5MethodBtn
    }()
    
    //MARK:- WKWebView调用JS方法
    func wkGetJsContents(jsMethods: String) {
        
        //jsMethods js方法名
        self.wkWebView.evaluateJavaScript(jsMethods) { (response, error) in
            
            print("回调数据：\(String(describing: response))")
        }
    }
    
    //MARK:- JS调用WKWebView方法
    func jsGetWkContents(value: String) {
        
        self.wkWebView.configuration.userContentController.add(self, name: value)
    }
    
    //MARK:- progress
    //MARK:- 点击调用h5按钮
    @objc func progressGetH5MethodBtn(_ button: UIButton) {
    
        self.wkGetJsContents(jsMethods: "document.getElementsByName('input')[0].attributes['value'].value")
    }
    
    //MARK:- 初始化视图
    func initView() {
        
    }
    
    //MARK:- 视图加载完毕
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }
    
    //MAKR:- 销毁
    deinit {
    
        self.wkWebView.configuration.userContentController.removeScriptMessageHandler(forName:"xxx")
    }

}

//MARK:- WKNavigationDelegate
extension YXBaseWKWebView: WKNavigationDelegate {
    
    //MARK:- 监听网页加载进度
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        self.progressView.progress = Float(self.wkWebView.estimatedProgress)
    }
    //MARK:- 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        print("开始加载")
    }
    //MARK:- 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        print("当内容开始返回")
    }
    //MARK:- 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("页面加载完成")
        
        //获取网页title
        self.navigationView.titleLab.text = self.wkWebView.title
        UIView.animate(withDuration: 0.5) {
            
            self.progressView.isHidden = true
        }
    }
    //MARK:- 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        print("页面加载失败")
        UIView.animate(withDuration: 0.5) {
            
            self.progressView.progress = 0.0
            self.progressView.isHidden = true
        }
        
        //弹出提示框点击确定返回
        let alertView = UIAlertController.init(title: "提示", message: "加载失败", preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title:"确定", style: .default) { okAction in
            
            _ = self.navigationController?.popViewController(animated: true)
        }
        alertView.addAction(sureAction)
        self.present(alertView, animated: true, completion: nil)
    }
}

//MARK:- WKUIDelegate
extension YXBaseWKWebView: WKUIDelegate {
    
    //MARK:- HTML页面Alert出内容
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        
        let alertCtrl = UIAlertController(title: "温馨提示", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { (action) in
            
//            completionHandler()
            print("点击了确定按钮")
        }
        alertCtrl.addAction(okAction)
        self.present(alertCtrl, animated: true, completion: nil)
    }
    //MARK:- HTML页面弹出Confirm时调用此方法
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alertCtrl = UIAlertController(title: "温馨提示", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default) { (action) in
            
            completionHandler(true)
            print("点击了确定按钮")
        }
        let cancelAction = UIAlertAction(title: "取消", style: .default) { (action) in
            
            completionHandler(false)
            print("点击了取消按钮")
        }
        alertCtrl.addAction(okAction)
        alertCtrl.addAction(cancelAction)
        self.present(alertCtrl, animated: true, completion: nil)
    }
    //MARK:- HTML页面弹出TextInpu时调用此方法
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
          
          let alertCtrl = UIAlertController(title: "温馨提示", message: "", preferredStyle: .alert)
          alertCtrl.addTextField { (textField) in
              
              textField.text = defaultText
          }
          
          let okAction = UIAlertAction(title: "确定", style: .default) { (action) in
              
              completionHandler(alertCtrl.textFields?[0].text)
              print("点击了确定按钮，内容：\(String(describing: alertCtrl.textFields?[0].text))")
          }
          let cancelAction = UIAlertAction(title: "取消", style: .default) { (action) in
              
              completionHandler(alertCtrl.textFields?[0].text)
              print("点击了取消按钮，内容：\(String(describing: alertCtrl.textFields?[0].text))")
          }
          alertCtrl.addAction(okAction)
          alertCtrl.addAction(cancelAction)
          self.present(alertCtrl, animated: true, completion: nil)
      }
        
}

//MARK:- WKScriptMessageHandler
extension YXBaseWKWebView: WKScriptMessageHandler {
    
    //MARK:- 获取JS传回的数据
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let nativeMethodName = message.name //name : nativeMethod
        let body = message.body //js回传参数
        if nativeMethodName == "" {
            print("参数\(body)")
        }
        
    }
    
}
