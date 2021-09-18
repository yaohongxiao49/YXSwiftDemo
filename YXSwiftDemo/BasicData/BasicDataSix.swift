//
//  BasicDataSix.swift
//  YXSwiftDemo
//
//  Created by ios on 2021/9/6.
//
/**
 * 函数
 *
 * 初始化函数，传入参数并返回参数
 * 初始化函数，带函数名
 * 初始化函数，默认函数值
 * 初始化函数，可变参数(可以当做一个叫 numbers 的 [Float] 型的数组常量)
 * 初始化函数，可变函数（输入输出参数）
 * 变量相加
 */

import UIKit

class BasicDataSix: YXBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationView.titleLab.text = "函数"
        self.navigationView.backBtn.isHidden = false
        
        var firstOldDic = ["key":"value"]
        firstOldDic = self.funcFirst(dic: firstOldDic)
        print("带参数及返回值的函数旧值 == \(firstOldDic)")
        
        self.funcSecond(for: "1", from: "2")
        
        var sixOldDic = ["key":"value"]
        print("oldDic == \(sixOldDic), newDic == \(self.funcFic(dic: &sixOldDic))")
        
        let mathFunction: (Int, Int) -> Int = self.addTwoInts
        print("返回函数结果: \(mathFunction(2, 3))")
    }

    //MARK:- 初始化函数，传入参数并返回参数
    func funcFirst(dic: [String : String]) -> [String : String] {
        var newDic = dic
        newDic.updateValue("123", forKey: "key")
        return newDic
    }
    
    //MARK:- 初始化函数，带函数名
    func funcSecond(for valueFirst: String, from valueSecond: String) {
        print("带函数名的函数方法 == \(valueFirst) \(valueSecond)")
    }
    
    //MARK:- 初始化函数，默认函数值
    func funcThird(varValue: Int, letValue: Int = 2) {
        print("默认函数值的函数方法 == \(varValue) \(letValue)")
    }
    
    //MARK:- 初始化函数，可变参数(可以当做一个叫 numbers 的 [Float] 型的数组常量)
    func funcFour(numbers: Float...) -> Float {
        var total: Float = 0.0
        for number in numbers {
            total += number
        }
        return total / Float(numbers.count)
    }
    
    //MARK:- 初始化函数，可变函数（输入输出参数）
    func funcFic(dic: inout [String : String]) -> [String : String] {
        dic.updateValue("123", forKey: "key")
        return dic
    }
    
    //MARK:- 变量相加
    func addTwoInts(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    
}
