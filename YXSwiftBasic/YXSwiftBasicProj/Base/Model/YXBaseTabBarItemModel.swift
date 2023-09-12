//
//  YXBaseTabBarItemModel.swift
//  YXSwiftBasicProj
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
    var itemTitle: String?
    /** 正常icon */
    var norIcon: String?
    /** 选中icon */
    var selIcon: String?
    /** 正常标题色值 */
    var norTitleColor: UIColor?
    /** 选中标题色值 */
    var selTitleColor: UIColor?
    /** 标签栏样式类型 */
    var type: YXBaseTabBarItemStateType?
}
