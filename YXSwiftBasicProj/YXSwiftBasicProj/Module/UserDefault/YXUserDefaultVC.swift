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
        
        self.getAndSetNormal()
        self.getAndSetItem()
        self.swiftyUserDefault()
        self.sqliteDefault()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationView.titleLab.text = "UserDefault"
        self.navigationView.backBtn.isHidden = false
        
        self.initView()
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
        
        let defaultModel = SwiftyUserDefaultArrModel(name: "1")
        Defaults[\.swiftyUserDefaultModelArr] = [defaultModel, defaultModel]
        let arr = Defaults[\.swiftyUserDefaultModelArr]
        let arrModel : SwiftyUserDefaultArrModel = arr![0]
        print("swiftyUserDefaultModelArr == ", arrModel.name)
    }
    
    //MARK: - 数据库
    func sqliteDefault() {
        
        let id = Expression<Int64>.init("uId")
        let name = Expression<String>.init("userName")
        let isMan = Expression<Bool>.init("isMan")
        
        let sqlPath = "/demo.sqlite".cacheDir()
        let sql = SqLiteManager.init(sqlPath: sqlPath)
        let table = sql.createTable(tableName: "User") { (builder) in
            
            builder.column(id, primaryKey: .autoincrement)
            builder.column(name)
            builder.column(isMan)
        }
            
        if sql.insert(table: table, setters: [name <- "小红", isMan <- true]) {
            print("添加成功")
        }
        if sql.delete(table: table, filter: name == "小红") {
            print("删除成功")
        }
        if sql.update(table: table, setters: [name <- "小明"], filter: name == "小红") {
            print("修改成功")
        }
        let rows = sql.select(table: table, selected: [id, name, isMan], filter: id >= 0)
        for item in rows ?? [] {
            print("查询成功", item[id], item[name], item[isMan])
        }
        let allRows = sql.select(table: table)
        print("所有数据", allRows!)
    }
}
