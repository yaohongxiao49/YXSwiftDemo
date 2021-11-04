//
//  YXSwiftyUserDefaultModel.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/4.
//

import Foundation

//MARK: - SwiftyUserDefault
struct SwiftyUserDefaultModel: Codable, DefaultsSerializable {
    
    let name: String
    
}

extension DefaultsKeys {
    
    var username: DefaultsKey<String?> { .init("username") }
    var launchCount: DefaultsKey<Int> { .init("launchCount", defaultValue: 0) }
    var onesMore: DefaultsKey<String?> { .init("onesMore") }
    var swiftyUserDefaultModelArr: DefaultsKey<[SwiftyUserDefaultModel]?> { .init("swiftyUserDefaultModelArr") }
    
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

