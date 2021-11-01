//
//  YXBaseTabBarItemModel.swift
//  YXAccordingProj
//
//  Created by ios on 2021/5/10.
//

import UIKit

/** 标签栏样式类型 */
public enum YXBaseTabBarItemStateType {
    /** 普通/未选中 */
    case YXBaseTabBarItemStateTypeNor
    /** 选中 */
    case YXBaseTabBarItemStateTypeSel
}

class YXBaseTabBarItemModel: NSObject {

    /** 基础控制器 */
    var vc: YXBaseVC!
    /** 标题 */
    var itemTitle: NSString?
    /** 正常icon */
    var norIcon: NSString?
    /** 选中icon */
    var selIcon: NSString?
    /** 正常标题色值 */
    var norTitleColor: UIColor?
    /** 选中标题色值 */
    var selTitleColor: UIColor?
    /** 标签栏样式类型 */
    var type: YXBaseTabBarItemStateType?
}
