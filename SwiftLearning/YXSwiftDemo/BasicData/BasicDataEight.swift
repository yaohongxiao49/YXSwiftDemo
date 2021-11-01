//
//  BasicDataEight.swift
//  YXSwiftDemo
//
//  Created by Believer on 9/18/21.
//
/**
 * 枚举
 *
 */

import UIKit

//MARK:- 未设置原始值的，就不能赋予初始值
enum BasicDataEightEnum {
    case left(String)
    case right
    case top
    case bottom
}

//MARK:- 设置了原始值，则可以设置初始值
enum BasicDataEightOriginalEnum: String {
    case first = "1"
    case second = "2"
}

class BasicDataEight: YXBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        self.navigationView.titleLab.text = "枚举"
        self.navigationView.backBtn.isHidden = false
        
        self.enumDemo()
    }

    func enumDemo() {
        var value: BasicDataEightEnum!
        value = .right //BasicDataEightEnum.left("2")
        switch value {
        case .left("1"):
            print("left")
        case .right:
            print("right")
        case .top:
            print("top")
        case .bottom:
            print("bottom")
        default:
            print("other")
        }
    }
    
}
