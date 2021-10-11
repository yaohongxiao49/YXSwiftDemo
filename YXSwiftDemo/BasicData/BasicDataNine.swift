//
//  BasicDataRight.swift
//  YXSwiftDemo
//
//  Created by Believer on 9/18/21.
//
/**
 * 结构体/类的实例
 *
 * 结构体/类的实例定义
 * 恒运算符
 *
 * 使用大写命名风格，命名结构体及类，如 FirstInitStruct
   使用小写命名风格，命名属性及方法，如 viewDidLoad
   结构体/枚举，如不主动修改结构体/枚举实例，而采用赋值后修改的方式，则原结构体/枚举的值不会被修改。
 */

import UIKit

//MARK:- 定义结构体
struct FirstInitStruct {
    var width = 0
    var height = 0
}

//MARK:- 定义类的实例
class FirstInitClass {
    var firstInitStruct = FirstInitStruct()
    var boolValue = false
    var frameRate = 0.0
    var name: String?
}

class BasicDataNine: YXBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationView.titleLab.text = "枚举"
        self.navigationView.backBtn.isHidden = false
        
        self.useStructAndClass()
        self.hengYunOperator()
    }
    
    //MARK:- 使用结构体及类的实例
    func useStructAndClass() {
        let firstInitStruct = FirstInitStruct()
        let firstInitClass = FirstInitClass()
        
        print("取出结构体中的宽 \(firstInitStruct.width)")
        print("取出类的实例中的结构体的宽 \(firstInitClass.firstInitStruct.width)\n取出类的实例中的布尔值 \(firstInitClass.boolValue)")
        
        firstInitClass.frameRate = 2.0
        firstInitClass.firstInitStruct.width = 10
        print("类的实例赋值 \(firstInitClass.frameRate)\n类的实例中的结构体赋值 \(firstInitClass.firstInitStruct.width)\n\(firstInitStruct.width)")
        
        let firstInitStructVga = FirstInitStruct(width: 1, height: 2)
        print("结构体自动生成的成员逐一构造器 \(firstInitStructVga.width), \(firstInitStructVga.height)")
    }
    
    //MARK:- 恒运算符（相同 ===）(不相同 !==)
    func hengYunOperator() {
        let firstInitClass = FirstInitClass()
        let alsoFirstInitClass = firstInitClass
        alsoFirstInitClass.frameRate = 2.0
        
        if firstInitClass === alsoFirstInitClass {
            print("相同")
        }
        else {
            print("不相同")
        }
    }

}
