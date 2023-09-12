//
//  YXSwiftyUserDefaultModel.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/4.
//

import Foundation

/** 定义SwiftyUserDefault模型 */
struct YXUserModel: DefaultsSerializable, Codable {

    static var _defaults: DefaultsFrogBridge { return DefaultsFrogBridge() }
    static var _defaultsArray: DefaultsFrogArrayBridge { return DefaultsFrogArrayBridge() }
                                                       
    let name: String
}

extension DefaultsKeys {
    
    var token: DefaultsKey<String?> { .init("token") }
    var userModel: DefaultsKey<YXUserModel?> { .init("YXUserModel") }
    
}

//MARK: - SwiftyUserDefault
/** 实现SwiftyUserDefault协议 */
final class DefaultsFrogBridge: DefaultsBridge {
    
    func get(key: String, userDefaults: UserDefaults) -> YXUserModel? {
        let name = userDefaults.string(forKey: key)
        return name.map(YXUserModel.init)
    }

    func save(key: String, value: YXUserModel?, userDefaults: UserDefaults) {
        userDefaults.set(value?.name, forKey: key)
    }

    func deserialize(_ object: Any) -> YXUserModel? {
        guard let name = object as? String else { return nil }
        return YXUserModel(name: name)
    }
    
}
/** 实现SwiftyUserDefault协议 */
final class DefaultsFrogArrayBridge: DefaultsBridge {
    
    func get(key: String, userDefaults: UserDefaults) -> [YXUserModel]? {
        return userDefaults.array(forKey: key)?
            .compactMap { $0 as? String }
            .map(YXUserModel.init)
        
    }

    func save(key: String, value: [YXUserModel]?, userDefaults: UserDefaults) {
        let values = value?.map { $0.name }
        userDefaults.set(values, forKey: key)
    }

    func deserialize(_ object: Any) -> [YXUserModel]? {
        guard let names = object as? [String] else { return nil }
        return names.map(YXUserModel.init)
    }
    
}

