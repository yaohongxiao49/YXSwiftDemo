//
//  YXSwiftPublicColor.swift
//  YXSwiftBasicProj
//
//  Created by Augus on 2022/8/9.
//

import Foundation
import UIKit

///白色
let kYXWhiteColor = UIColor.white
///透明色
let kYXClearColor = UIColor.clear
///主题色
let kYXMainThemeColor = YXSwiftPublicColor().kYXDiyColor(hex: "#0B60FF", alpha: 1)
///文本色
let kYXMainTextColor = YXSwiftPublicColor().kYXDiyColor(hex: "#AAAAAA", alpha: 1)

class YXSwiftPublicColor: NSObject {
    
    //MARK: - 自定义色值
    public func kYXDiyColor(hex: NSString, alpha: CGFloat) -> UIColor {
        
        return UIColor.yxColorWithHexString(hex: hex, alpha: alpha)
    }
    
    //MARK: - 自定义字体大小
    /** 系统字体 */
    public func kYXSystemFont(size: CGFloat) -> UIFont {
        
        return UIFont.systemFont(ofSize: size)
    }
    
    /** 加粗字体 */
    public func kYXBoldSystemFont(size: CGFloat) -> UIFont {
        
        return UIFont.boldSystemFont(ofSize: size)
    }
    
}
