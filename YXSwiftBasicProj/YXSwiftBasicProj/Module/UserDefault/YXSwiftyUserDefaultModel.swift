//
//  YXSwiftyUserDefaultModel.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/4.
//

import Foundation

//MARK: - SwiftyUserDefault
/** 实现SwiftyUserDefault协议 */
final class DefaultsFrogBridge: DefaultsBridge {
    
    func get(key: String, userDefaults: UserDefaults) -> SwiftyUserDefaultArrModel? {
        let name = userDefaults.string(forKey: key)
        return name.map(SwiftyUserDefaultArrModel.init)
    }

    func save(key: String, value: SwiftyUserDefaultArrModel?, userDefaults: UserDefaults) {
        userDefaults.set(value?.name, forKey: key)
    }

    func deserialize(_ object: Any) -> SwiftyUserDefaultArrModel? {
        guard let name = object as? String else { return nil }
        return SwiftyUserDefaultArrModel(name: name)
    }
    
}
/** 实现SwiftyUserDefault协议 */
final class DefaultsFrogArrayBridge: DefaultsBridge {
    
    func get(key: String, userDefaults: UserDefaults) -> [SwiftyUserDefaultArrModel]? {
        return userDefaults.array(forKey: key)?
            .compactMap { $0 as? String }
            .map(SwiftyUserDefaultArrModel.init)
        
    }

    func save(key: String, value: [SwiftyUserDefaultArrModel]?, userDefaults: UserDefaults) {
        let values = value?.map { $0.name }
        userDefaults.set(values, forKey: key)
    }

    func deserialize(_ object: Any) -> [SwiftyUserDefaultArrModel]? {
        guard let names = object as? [String] else { return nil }
        return names.map(SwiftyUserDefaultArrModel.init)
    }
    
}

/** 定义SwiftyUserDefault模型 */
struct SwiftyUserDefaultArrModel: DefaultsSerializable, Codable {

    static var _defaults: DefaultsFrogBridge { return DefaultsFrogBridge() }
    static var _defaultsArray: DefaultsFrogArrayBridge { return DefaultsFrogArrayBridge() }
                                                       
    let name: String

}

extension DefaultsKeys {
    
    var username: DefaultsKey<String?> { .init("username") }
    var launchCount: DefaultsKey<Int> { .init("launchCount", defaultValue: 0) }
    var onesMore: DefaultsKey<String?> { .init("onesMore") }
    var swiftyUserDefaultModelArr: DefaultsKey<[SwiftyUserDefaultArrModel]?> { .init("swiftyUserDefaultModelArr") }
    
}

//MARK : - 自定义模型
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
    
    /** codable */
    struct BookItemKey: UserDefaultsSettable {
        enum defaultKeys: String {
            case book
        }
    }
    
}

//MARK: - codable
struct BookItem: Codable {
    
    var bookName: String
    var bookDescribe: String
    var bookPrice: Float
    
    //解析赋值 可以将字典中`name`的值解析到`bookName`
    fileprivate enum CodingKeys: String, CodingKey {
        case bookName = "name"
        case bookDescribe
        case bookPrice
    }
    
}

