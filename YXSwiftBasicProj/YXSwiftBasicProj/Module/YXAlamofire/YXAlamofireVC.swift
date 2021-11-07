//
//  YXAlamofireVC.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/7.
//

import UIKit

class YXAlamofireVC: YXBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationView.titleLab.text = "网络请求"
        self.navigationView.backBtn.isHidden = false
        
        self.initData()
        self.initView()
    }

}

extension YXAlamofireVC {

    //MAKR: - 初始化数据
    private final func initData() {
        
        UserDefaults.LoginInfo.set(value: "b7dcfce216278e931b49d3592f5f298c", forKey: .token)
    }
    
    //MARK: - 初始化视图
    private final func initView() {
        
        let url = kHostUrl.appending("/Login/get_forum_group")
        YXNetworkManager.shared.requestWithUrl(url: url, params: nil, showText: nil, boolShowSuccess: false, boolShowError: false) { dic, isSuccess in
            
        }
    }
}
