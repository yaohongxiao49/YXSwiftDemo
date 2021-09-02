//
//  BasicDataFirst.swift
//  YXSwiftDemo
//
//  Created by ios on 2021/9/2.
//
/**
 * 基础部分
 *
 * 常量与变量
 * 类型转换
 * 类型别名
 * 元祖
 *（隐式）可选类型
 * 问题
 * 断言
 */
import UIKit

typealias kTypeTheAlias = Int

class BasicDataFirst: YXBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationView.titleLab.text = "基础部分"
        self.navigationView.backBtn.isHidden = false
        
        self.constantsAndVariables()
        self.typeConversion()
        self.typeTheAlias()
        self.tuplesDemo()
        self.optionalDemo()
        self.errorDemo()
        self.assertionsDemo()
    }

    //MARK:- 常量与变量
    func constantsAndVariables() {
        
        //常量声明
        let constants: Int = 1
        //变量声明
        var variables: Int = 2
        //多变量声明
        var variablesF: Int = 3, variablesS: Int = 4, variablesT: Int = 5
        var variablesFour, variablesFive, variablesSix : Int
        
        variables += variables
        variablesF += variablesF
        variablesFour = 3
        variablesFive = 4
        variablesSix = 5
        print("常量 \(constants)")
        NSLog("变量 == %d/%d/%d/%d, 整体变量 == %d/%d/%d", variables, variablesF, variablesS, variablesT, variablesFour, variablesFive, variablesSix)
    }
    
    //MARK:- 类型转换
    func typeConversion() {
        
        let int16: UInt16 = 200
        let int8: UInt8 = 2
        let conversion = int16 + UInt16(int8)
        print("UInt8转UInt16结果值 \(conversion)")
    }
    
    //MARK:- 类型别名
    func typeTheAlias() {
        
        let type: kTypeTheAlias = 1
        print("类型别名 == \(type)")
    }
    
    //MARK:- 元祖
    func tuplesDemo() {
        
        //元祖基础结构
        let tuplesBasic = (404, "Not Found")
        
        //拆分元祖
        let (intValue, stringValue) = tuplesBasic
        
        //元祖数据带命名
        let tuplesDic = (intValue: 404, stringValue: "Not Found")
        
        print("元祖数据 \(tuplesBasic)")
        print("整数 == 1、\(intValue) 2、\(tuplesBasic.0) 3、\(tuplesDic.intValue)")
        print("字符串 == 1、\(stringValue) 2、\(tuplesBasic.1) 3、\(tuplesDic.stringValue)")
    }
    
    //MARK:- 可选类型 ? 隐私解析可选类型 !
    func optionalDemo() {
        
        var value: Int? = 404
        value = nil
        print("可选类型 == \(String(describing: value))")
        
        //自动设置成nil
        var optinalValue: Int?
        optinalValue = 1
        print("可选类型 == \(String(describing: optinalValue))")
        
        let sureValue: Int! = 404
        print("隐式解析可选类型 == \(String(describing: sureValue))")
    }
    
    //MARK:- 问题
    func errorDemo() {
        
        do {
            try self.canThrowAnError()
            //没有错误抛出
        }
        catch {
            //有错误抛出
        }
    }
    func canThrowAnError() throws {
        //这个函数可能抛出错误
    }
    
    //MARK:- 断言
    func assertionsDemo() {
        
        let age = 1
        assert(age >= 0, "这是个断言")
    }
}
