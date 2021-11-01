//
//  YXColorCategory.swift
//  YXAccordingProj
//
//  Created by ios on 2021/5/11.
//

import Foundation
import UIKit

public extension UIColor {
    
    //MARK:- 传入色值返回颜色
    class func yxColorWithHexString(hex: NSString) -> UIColor {
        
        return yxColorWithHexString(hex: hex, alpha: 1)
    }
    
    //MARK:- 传入色值返回颜色，带透明度
    class func yxColorWithHexString(hex: NSString, alpha: CGFloat) -> UIColor {
        
        var value : NSString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        if value.length < 6 {
            return UIColor.clear
        }
        
        if value.hasPrefix("0X") {
            value = value.substring(from: 2) as NSString
        }
        if value.hasPrefix("#") {
            value = value.substring(from: 1) as NSString
        }
        if value.length != 6 {
            return UIColor.clear
        }

        var range = NSRange.init()
        range.length = 2
        
        range.location = 0
        let red = value.substring(with: range)
        
        range.location = 2
        let green = value.substring(with: range)
        
        range.location = 4
        let blue = value.substring(with: range)

        var r: UInt64 = 0, g: UInt64 = 0, b: UInt64 = 0
        Scanner(string: red).scanHexInt64(&r)
        Scanner(string: green).scanHexInt64(&g)
        Scanner(string: blue).scanHexInt64(&b)
        
        return UIColor.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}
