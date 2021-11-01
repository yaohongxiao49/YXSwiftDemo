//
//  YXSizeCategory.swift
//  YXAccordingProj
//
//  Created by ios on 2021/5/11.
//

import Foundation
import UIKit

public extension NSObject {
    
    private struct viewSizeStruct {
        
        /** 安全区域 */
        static var yxSafeAreaInsets: UIEdgeInsets?
        /** 是否是全面屏 */
        static var yxBoolFullScreen: Bool?
        /** 是否是竖屏 */
        static var yxBoolPortrait: Bool?
        
        /** 屏幕宽 */
        static var yxScreenWidth: CGFloat = UIScreen.main.bounds.width
        /** 屏幕高 */
        static var yxScreenHeight: CGFloat = UIScreen.main.bounds.height
        /** 状态栏高 */
        static var yxStatusBarHeight: CGFloat?
        /** 导航栏高 */
        static var yxNavigationHeight: CGFloat?
        /** 工具栏高 */
        static var yxToolHeight: CGFloat?
        /** 最小设定值 */
        static var yxSmallHeight: CGFloat = 0.01
        
        /** 基础视图 */
        static var yxAppWindow: UIWindow?
    }
    
    //MARK:- getting/setting
    //MARK:- 获取安全区域
    var yxSafeAreaInsets: UIEdgeInsets {
        
        get {
            return setYXSafeAreaInsets()
        }
    }
    
    //MARK:- 获取是否是全面屏
    var yxBoolFullScreen: Bool {
        
        get {
            return self.yxSafeAreaInsets.bottom > 0.0 ? true : false
        }
    }
    
    //MARK:- 获取是否是竖屏
    var yxBoolPortrait: Bool {
        
        get {
            return UIApplication.shared.isProxy()
        }
    }
    
    //MARK:- 获取屏幕宽度
    var yxScreenWidth: CGFloat {
        
        get {
            return viewSizeStruct.yxScreenWidth
        }
    }
    
    //MARK:- 获取屏幕高度
    var yxScreenHeight: CGFloat {
        
        get {
            return viewSizeStruct.yxScreenHeight
        }
    }
    
    //MARK:- 获取状态栏高度
    var yxStatusBarHeight: CGFloat {
        
        get {
            return self.yxBoolFullScreen ? self.yxSafeAreaInsets.top : 20.0
        }
    }
    
    //MARK:- 获取导航栏高度
    var yxNavigationHeight: CGFloat {
        
        get {
            return 44.0 + self.yxStatusBarHeight
        }
    }
    
    //MARK:- 获取工具栏高度
    var yxToolHeight: CGFloat {
        
        get {
            return 49.0 + self.yxSafeAreaInsets.bottom
        }
    }
    
    //MARK:- 获取最小设定值
    var yxSmallHeight: CGFloat {
        
        get {
            return viewSizeStruct.yxSmallHeight
        }
        set {
            objc_setAssociatedObject(self, &viewSizeStruct.yxSmallHeight, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    //MARK:- 基础视图
    var yxAppWindow: UIWindow {
        
        get {
            return UIApplication.shared.windows.count == 0 ? UIWindow() : UIApplication.shared.windows.first!
        }
    }
    
    //MARK:- 设置属性值
    //MARK:- 全面屏尺寸
    func setYXSafeAreaInsets() -> UIEdgeInsets {
        
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows.count == 0 ? .zero : UIApplication.shared.windows.first!.safeAreaInsets
        }
        
        return .zero
    }
    
}
