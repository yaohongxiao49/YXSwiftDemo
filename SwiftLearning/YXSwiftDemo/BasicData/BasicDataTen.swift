//
//  BasicDataTen.swift
//  YXSwiftDemo
//
//  Created by Believer on 10/11/21.
//
/**
 * 属性
 *
 * 存储属性/计算属性
 */

import UIKit

/** 存储属性 */
struct SavePropertiesStruct {
    var value: Int
    let valueLength: Int
}

class BasicDataTen: YXBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.saveProperties()
    }
    
    //MARK:- 存储属性
    func saveProperties() {
        var value = SavePropertiesStruct(value: 1, valueLength: 4)
        print("存储属性 value == \(value.value)")
        
        value.value = 5
        print("存储属性 value == \(value.value)")
    }
}
