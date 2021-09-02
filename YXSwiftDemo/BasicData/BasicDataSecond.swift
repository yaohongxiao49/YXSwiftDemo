//
//  BasicDataSecond.swift
//  YXSwiftDemo
//
//  Created by ios on 2021/9/2.
//
/**
 * 基础运算符
 * 
 * 多元组
 * 元组比较
 * 空合运算符
 * 区间运算符
 */

import UIKit

class BasicDataSecond: YXBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationView.titleLab.text = "基础运算符"
        self.navigationView.backBtn.isHidden = false
        
        self.diverseDemo()
        self.tupleCompare()
        self.nilCoalescingOperatoDemo()
        self.intervalArithmeticDemo()
    }
    
    //MARK:- 多元组
    func diverseDemo() {
        
        let (x, y) = (1, 2)
        NSLog("多元组 == %d, %d", x, y)
    }
    
    //MARK:- 元祖比较
    func tupleCompare() {
        
        let tupleFirst = (1, "tupleFirst")
        let tupleSecond = (2, "tupleSecond")
        if tupleFirst > tupleSecond {
            print("元1 > 元2")
        }
        else if tupleFirst < tupleSecond {
            print("元1 < 元2")
        }
        else {
            print("元1 == 元2")
        }
    }
    
    //MARK:- 空合运算符 a ?? b 如果a不为nil，则解包，返回a，否则返回b。（a != nil ? a! : b）
    func nilCoalescingOperatoDemo() {
        
        let a: Int? = 0
        let b: Int = 2
        NSLog("空合运算符 == %d", a ?? b)
    }
    
    //MARK:- 区间运算符
    func intervalArithmeticDemo() {
        
        //闭区间
        for i in 0...5 {
            print("闭区间 == \(i)")
        }
        
        //半开区间
        let arr = ["1", "2", "3", "4"]
        for i in 0..<arr.count {
            print("半开区间 == \(i)")
        }
        
        //单侧区间
        for value in arr[2...] {
            print("单侧区间 == \(value)")
        }
        for value in arr[...2] {
            print("单侧区间 == \(value)")
        }
        let contains = ...5
        print("是否包含3 == \(contains.contains(3))")
    }

}
