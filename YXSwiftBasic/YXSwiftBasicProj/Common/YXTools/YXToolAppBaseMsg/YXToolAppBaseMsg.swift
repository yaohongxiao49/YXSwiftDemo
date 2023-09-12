//
//  YXToolAppBaseMsg.swift
//  YXSwiftBasicProj
//
//  Created by Augus on 2023/3/6.
//

import UIKit

/** 应用使用状态 */
enum YXToolAppBaseTypeEnum: String {
    case yxNormal = "通常情况"
    case yxFirstUse = "首次启动"
    case yxUpgrade = "升级后首次启动"
}

class YXToolAppBaseMsg: NSObject {

    /** 0，普通情况；1，初次启用；2，系统更新(该值不做保存，每次启动临时使用) */
    var appState: YXToolAppBaseTypeEnum?
    /** 版本号（用以区分是否发生更新） */
    var version: String! //= (UserDefaults().object(forKey: "YXToolAppBaseMsgVersion") as! String)
    /** 延时结束 */
    var boolDelayStartDone: Bool!
    /** 首次启动是否未进入首页 */
    var _boolNotInHomeFirstUse: Bool?
    var boolNotInHomeFirstUse: Bool? {
        
        get {
            return _boolNotInHomeFirstUse
        }
        set {
            _boolNotInHomeFirstUse = newValue
        }
    }
    
    /** 单例 */
    static let defaults = YXToolAppBaseMsg()
    
    func synchronize() {
        
        UserDefaults().synchronize()
    }
    
    //MARK: - 注册App应用使用状态
    static func registerUserDefaults() {
        
        let bundleVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let settingVersion = self.defaults.version
        if (settingVersion == nil) { //初次使用应用
            self.defaults.version = bundleVersion
            self.defaults.appState = .yxFirstUse;
        }
        else if (!(bundleVersion == settingVersion)) { //通过版本和bundleVersion进行匹配来判断是否进行了更新
            self.defaults.version = bundleVersion
            self.defaults.appState = .yxUpgrade;
        }
        else { //正常情况
            defaults.appState = .yxNormal;
        }
        
        YXToolAppBaseMsg().synchronize()
    }
    
}
