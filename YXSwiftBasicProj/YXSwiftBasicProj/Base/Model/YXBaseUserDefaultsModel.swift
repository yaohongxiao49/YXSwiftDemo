//
//  YXBaseUserDefaultsModel.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/4.
//

import Foundation

//MAKR: - 设置需要的枚举
extension UserDefaults {
    
    /** 账户信息 */
    struct AccountInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case userName
            case age
        }
    }
    
    /** 登录信息 */
    struct LoginInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case token
            case userId
        }
    }
    
}

//MARK: - 填充以及获取
protocol UserDefaultsSettable {
    
    associatedtype defaultKeys: RawRepresentable
}

extension UserDefaultsSettable where defaultKeys.RawValue == String {
    
    static func set<T>(value: T, forKey key: defaultKeys) {
        
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    /** 整形 */
    static func int(forKey key: defaultKeys) -> Int? {
        
        return UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    /** 字符串 */
    static func string(forKey key: defaultKeys) -> String? {
        
        return UserDefaults.standard.string(forKey: key.rawValue)
    }
    
    /** 集合 */
    static func array(forKey key: defaultKeys) -> Array<Any>? {
        
        return UserDefaults.standard.array(forKey: key.rawValue)
    }
}

