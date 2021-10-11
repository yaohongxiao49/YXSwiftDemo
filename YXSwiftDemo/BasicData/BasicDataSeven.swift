//
//  BasicDataSeven.swift
//  YXSwiftDemo
//
//  Created by ios on 2021/9/7.
//
/**
 * 闭包
 *
 * sorted排序闭包
 * 尾随闭包
 * 值捕获嵌套函数
 */

import UIKit

class BasicDataSeven: YXBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationView.titleLab.text = "闭包"
        self.navigationView.backBtn.isHidden = false
        
        self.sortedDemo()
        self.followingBlockDemo()
        print("值捕获 == %d", self.makeIncrementer(forIncrement: 2))
        
        self.doClosuresMethod()
        self.callComplexClosureMethod()
    }
    
    //MARK:- sorted排序闭包
    func sortedDemo() {
        let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        let reversedNames = names.sorted(by: self.sortedDemoMethod(first:second:))
        print("sorted排序闭包 == \(reversedNames)")
        
        //直接调用(内联闭包)
        let sortedMethod = names.sorted(by: {(first: String, second: String) -> Bool in
            
            return first > second
        })
        print("sorted排序闭包 == \(sortedMethod)")
        
        //Swift 自动为内联闭包提供了参数名称缩写功能，可以直接通过 $0，$1，$2 来顺序调用闭包的参数，以此类推。
        let sortedAbb = names.sorted(by: {$0 > $1})
        print("sorted排序缩写闭包 == \(sortedAbb)")
    }
    func sortedDemoMethod(first: String, second: String) -> Bool {
        return first > second
    }
    
    //MARK:- 尾随闭包
    func followingBlockDemo() {
        //不使用尾随闭包函数调用
        self.followingBlockDemoMethod(closure: {
            print("不使用尾随闭包函数调用")
        })
        //使用尾随闭包函数调用
        self.followingBlockDemoMethod {
            print("使用尾随闭包函数调用")
        }
    }
    func followingBlockDemoMethod(closure: () -> Void) {
//        print("尾随闭包函数体")
    }
    
    //MARK:- 值捕获嵌套函数
    func makeIncrementer(forIncrement amount: Int) -> () -> Int {
        var runningTotal = 0
        func incrementer() -> Int {
            runningTotal += amount
            return runningTotal
        }
        return incrementer
    }

    //MARK: 逃逸闭包（先创建，再调用，最后回调）
    var escapeClosureArr: [() -> Void] = []
    var x: Int = 0
    func escapeClosureMethod(escapeClosure: @escaping () -> Void) {
        self.escapeClosureArr.append(escapeClosure)
    }
    
    func doClosuresMethod() {
        self.escapeClosureMethod {
            self.x += 1
        }
        
        self.escapeClosureArr.first?()
        print("逃逸闭包 == \(self.x)")
    }
    
    typealias YXAliasComplexClosure = (Int, String) -> Void
    var yxAliasComplexClosure : YXAliasComplexClosure?
    func complexClosureMethod(param: @escaping YXAliasComplexClosure) {
        self.yxAliasComplexClosure = param
        print("当前x == \(self.x)")
    }
    func callComplexClosureMethod() {
        self.complexClosureMethod(param: { i, s in
            print("整形 == \(i), 字符串 == \(s)")
        })
        self.yxAliasComplexClosure!(1, "2")
    }
    
}
