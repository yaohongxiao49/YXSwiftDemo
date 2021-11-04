//
//  YXBaseUserDefaultsModel.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/4.
//

import Foundation

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
 
    //MARK: - 自定义对象遵守Codable协议
    /** 设置item */
    static func setItem<T: Encodable>(_ object: T, forKey key: defaultKeys) {
        
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(object) else {
            return
        }
        
        UserDefaults.standard.set(encoded, forKey: key.rawValue)
    }
    
    /** 获取item */
    static func getItem<T: Decodable>(_ type: T.Type, forKey key: defaultKeys) -> T? {
        
        guard let data = UserDefaults.standard.data(forKey: key.rawValue) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        guard let object = try? decoder.decode(type, from: data) else {
            print("Couldnt find key")
            return nil
        }
        
        return object
    }
    
}

