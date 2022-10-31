//
//  YXSwiftPublicColor.swift
//  YXSwiftBasicProj
//
//  Created by Augus on 2022/8/9.
//

import Foundation
import UIKit

let kYXWhiteColor = UIColor.white
let kYXClearColor = UIColor.clear

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
