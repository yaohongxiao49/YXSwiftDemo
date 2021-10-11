//
//  BasicDataFive.swift
//  YXSwiftDemo
//
//  Created by ios on 2021/9/6.
//
/**
 * 控制流
 *
 * for循环
 * While循环
 * switch
 * 版本可用性
 */

import UIKit

class BasicDataFive: YXBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationView.titleLab.text = "控制流"
        self.navigationView.backBtn.isHidden = false
        
        self.forLoopDemo()
        self.whileLoopDemo()
        self.switchDemo()
        self.guardDemo(person: ["name":"1"])
        self.versionState()
        
    }
    
    //MARK:- for循环
    func forLoopDemo() {
        
        //数组循环
        let arr = ["1", "2", "3"]
        for value in arr {
            print("数组循环元素值 == \(value)")
        }
        
        //字典循环
        let dic = ["key":"1", "value":"value"]
        for (key, value) in dic {
            print("字典循环 key == \(key), value == \(value)")
        }
        
        //数字循环
        for num in 1...5 {
            print("数字循环 == \(num)")
        }
        
        //_ 替换变量
        let base = 2
        let power = 10
        var answer = 1
        for _ in 1...power {
            answer *= base
        }
        print("以 _ 来替换变量名，达到忽略的目的。\(answer)")
        
        //区间、刻度
        let minutes: Int = 60
        for tickMark in 0..<60 {
            print("区间 == \(tickMark)")
        }
        
        //以5为间刻
        let timeInterval: Int = 5
        for tickMark in stride(from: 0, to: minutes, by: timeInterval) {
            print("以5为间刻 == \(tickMark)")
        }
        
    }

    //MARK:- While循环
    func whileLoopDemo() {
        
        let finalSquare = 25
        var board = [Int](repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
        
        var square = 0
        var diceRoll = 0
        while square < finalSquare {
            //掷骰子
            diceRoll += 1
            if diceRoll == 7 { diceRoll = 1 }
            //根据点数移动
            square += diceRoll
            if square < board.count {
                //如果玩家还在棋盘上，顺着梯子爬上去或者顺着蛇滑下去
                square += board[square]
            }
        }
        print("Game over!")
        
    }
    
    //MARK:- switch
    func switchDemo() {
        
        //默认为单独执行
        let value: Character = "三"
        switch value {
        case "一", "五":
            print("switch == \(1)")
        case "二", "四":
            print("switch == \(2)")
        case "三", "期":
            print("switch == \(3)")
        default:
            break
        }
        
        //贯穿执行
        switch value {
        case "三", "期":
            print("switch贯穿 == \(1)")
            fallthrough
        case "一", "五":
            print("switch贯穿 == \(2)")
        case "二", "四":
            print("switch贯穿 == \(3)")
        default:
            break
        }
        
    }
    
    //MARK:- guard
    func guardDemo(person: [String:String]) {
        
        guard let name = person["name"] else {
            return
        }
        print("Hello \(name)!")
        
    }
    
    //MARK:- 版本可用性
    func versionState() {
        
        if #available(iOS 10, macOS 10.12, *) {
            //在 iOS 使用 iOS 10 的 API, 在 macOS 使用 macOS 10.12 的 API
        }
        else {
            //使用先前版本的 iOS 和 macOS 的 API
        }
        
    }
    
}
