//
//  YXUserDefaultVC.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/4.
//

import UIKit

class YXUserDefaultVC: YXBaseVC {

    //MARK: - 初始化视图
    func initView() {
        
        UserDefaults.AccountInfo.set(value: [["1":"3"], "2"], forKey: .userName)
        let userName: Array = UserDefaults.AccountInfo.array(forKey: .userName)!
        NSLog("自定义UserDefaults == %@", userName)
        
        Defaults[\.username] = "123"
        Defaults[\.onesMore] = "321"
        let swiftyUserName = Defaults[\.username]
        let swiftyOnesMore = Defaults[\.onesMore]
        NSLog("swiftyUserDefaults == %@, swiftyOnesMore == %@", swiftyUserName!, swiftyOnesMore!)
        
        let defaultModel = UserDefaultModel(name: "1")
        Defaults[\.userDefaultModelArr] = [defaultModel, defaultModel]
        let arr = Defaults[\.userDefaultModelArr]
        NSLog("userDefaultModelArr == %@", arr!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationView.titleLab.text = "UserDefault"
        self.navigationView.backBtn.isHidden = false
        
        self.initView()
    }

}
