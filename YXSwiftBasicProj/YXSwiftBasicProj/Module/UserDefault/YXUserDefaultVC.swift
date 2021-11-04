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
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationView.titleLab.text = "UserDefault"
        self.navigationView.backBtn.isHidden = false
        
        self.initView()
        
        self.getAndSetNormal()
        self.getAndSetItem()
        self.swiftyUserDefault()
    }

}

extension YXUserDefaultVC {
    
    //MARK: - 自定义模型
    func getAndSetNormal() {
        
        UserDefaults.AccountInfo.set(value: [["1":"3"], "2"], forKey: .userName)
        let userName: Array = UserDefaults.AccountInfo.array(forKey: .userName)!
        NSLog("自定义UserDefaults == %@", userName)
    }
    
    //MARK: - JSON转模型
    func getAndSetItem() {
        
        //json字符串转自定义对象
        let json = """
        {"name": "米饭童鞋", "bookPrice": 200.87, "bookDescribe": "A handsome boy."}
        """
        
        //string -> data
        guard let data = json.data(using: .utf8) else {
            return
        }
        
        //data -> item
        let decoder = JSONDecoder()
        guard let book = try? decoder.decode(BookItem.self, from: data) else {
            return
        }
        
        //自定义对象存UserDefaults
        UserDefaults.BookItemKey.setItem(book, forKey: .book)
        guard let bookF = UserDefaults.BookItemKey.getItem(BookItem.self, forKey: .book) else {
            return
        }
        print("bookF ==", bookF)
    }
    
    //MARK: - swiftyUserDefault
    func swiftyUserDefault() {
        
        Defaults[\.username] = "123"
        Defaults[\.onesMore] = "321"
        let swiftyUserName = Defaults[\.username]
        let swiftyOnesMore = Defaults[\.onesMore]
        NSLog("swiftyUserDefaults == %@, swiftyOnesMore == %@", swiftyUserName!, swiftyOnesMore!)
        
        let defaultModel = SwiftyUserDefaultModel(name: "1")
        Defaults[\.swiftyUserDefaultModelArr] = [defaultModel, defaultModel]
        let arr = Defaults[\.swiftyUserDefaultModelArr]
        NSLog("swiftyUserDefaultModelArr == %@", arr!)
    }
    
}
