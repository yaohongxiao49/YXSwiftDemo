//
//  BasicDataThird.swift
//  YXSwiftDemo
//
//  Created by ios on 2021/9/2.
//
/**
 * 字符串与字符
 *
 * 字符串字面量及字符串换行
 * 字符串初始化
 * Character使用
 * 字符串拼接
 * 字符串索引
 */

import UIKit

class BasicDataThird: YXBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationView.titleLab.text = "字符串与字符"
        self.navigationView.backBtn.isHidden = false
        
        self.literalDemo()
        self.initString()
        self.characterDemo()
        self.stringAppendDemo()
        self.stringIndexDemo()
        
    }
    
    //MARK:- 字符串字面量及字符串换行
    func literalDemo() {
        
        //单行字符串使用""
        let single = "abcde"
        print("单行字符串 == \(single)")
        
        //多行字符串使用"""
        let more = """
            The White Rabbit put on his spectacles.  \n"Where shall I begin,
            please your Majesty?" he asked.

            "Begin at the beginning," the King said gravely, "and go on
            till you come to the end; then stop."
            """
        print("多行字符串 == \(more)")
        
    }
    
    //MAKR:- 字符串初始化
    func initString() {
        
        let emptyStr = ""
        var anotherEmptyStr = String()
        
        //判空处理
        if emptyStr.isEmpty && anotherEmptyStr.isEmpty {
            print("字符串为空")
        }
        
        //字符串拼接
        anotherEmptyStr += "这是拼接的数据"
        print("拼接的字符串 == \(anotherEmptyStr)")
        
        //遍历字符串
        for value in anotherEmptyStr {
            print("遍历字符串字符 == \(value)")
        }
        
    }
    
    //MARK:- Character使用
    func characterDemo() {
        
        let character: [Character] = ["H", "e", "l", "l", "o"]
        let characterValue = String(character)
        print("character == \(characterValue)")
        
        let regionalIndicatorForUS: Character = "\u{1F1FA}\u{1F1F8}"
        print("character == \(regionalIndicatorForUS)")
        
    }
    
    //MARK:- 字符串拼接
    func stringAppendDemo() {
        
        let hello = "hello"
        var space = hello + " "
        space += "world"
        print("字符串拼接1 == \(space)")
        
        let append = "!"
        space.append(append)
        print("字符串拼接2 == \(space)")
        
    }
    
    //MARK:- 字符串索引
    func stringIndexDemo() {
        
        var hello = "hello world"
        
        //取值
        print("首字符 == \(hello[hello.startIndex])")
        print("尾字符 == \(hello[hello.index(before: hello.endIndex)])")
        print("第二字符 == \(hello[hello.index(after: hello.startIndex)])")
        print("中间指定字符 == \(hello[hello.index(hello.startIndex, offsetBy: 2)])")
        
        //插入
        hello.insert("!", at: hello.endIndex)
        print("在尾部插入！== \(hello)")
        hello.insert(contentsOf: " wakk", at: hello.index(before: hello.endIndex))
        print("在尾部插入！== \(hello)")
        
        //移除
        hello.remove(at: hello.index(before: hello.endIndex))
        print("移除wakk == \(hello)")
        let range = hello.index(hello.endIndex, offsetBy: -5)..<hello.endIndex
        hello.removeSubrange(range)
        print("移除world! == \(hello)")
        
        //截取
        let index = hello.firstIndex(of: "w") ?? hello.endIndex
        let subValue = hello[..<index]
        //将结果转换为string
        let endValue = String(subValue)
        print("截取数据 == \(subValue) \(endValue)")
        
        //判断字符串是否包含某个元素
        let valueList = ["123", "1234", "1231", "23432", "4321", "2345"]
        var prefix = 0
        var suffix = 0
        
        for value in valueList {
            //由首元素开始的包含判定
            if value.hasPrefix("23") {
                prefix += 1
            }
            //由尾元素开始的包含判定
            if value.hasSuffix("23") {
                suffix += 1
            }
        }
        print("prefix == \(prefix), suffix == \(suffix)")
        
    }
    
}
