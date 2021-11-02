//
//  YXWkWebView.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/2.
//

import UIKit

class YXWkWebViewVC: YXBaseWKWebView {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationView.backBtn.isHidden = false
        self.webUrl = "https://www.baidu.com"
        self.getH5MethodBtn.isHidden = false
    }

}
