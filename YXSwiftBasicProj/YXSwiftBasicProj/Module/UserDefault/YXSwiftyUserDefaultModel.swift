//
//  YXSwiftyUserDefaultModel.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/4.
//

import Foundation

struct UserDefaultModel: Codable, DefaultsSerializable {
    
    let name: String
    
 }


extension DefaultsKeys {
    
    var username: DefaultsKey<String?> { .init("username") }
    var launchCount: DefaultsKey<Int> { .init("launchCount", defaultValue: 0) }
    var onesMore: DefaultsKey<String?> { .init("onesMore") }
    var userDefaultModelArr: DefaultsKey<[UserDefaultModel]?> { .init("userDefaultModelArr") }
}

