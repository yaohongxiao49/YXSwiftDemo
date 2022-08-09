//
//  YXSwiftPublicColor.swift
//  YXSwiftBasicProj
//
//  Created by Augus on 2022/8/9.
//

import Foundation
import UIKit

struct YXPublicColorStruct {
    
    let yxWhiteColor = UIColor.white
    let yxClearColor = UIColor.clear
    
}

func kYXDiyColor(hex: NSString, alpha: CGFloat) -> UIColor {
    
    return UIColor.yxColorWithHexString(hex: hex, alpha: alpha)
}
