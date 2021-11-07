//
//  YXSwiftGlobalSettings.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/1.
//

import Foundation

/** 环境变量 */
public enum YXServerDebugEnum: Int {
    /** 开发环境 */
    case YXServerDebugEnumDevelopment = 0
    /** 测试环境 */
    case YXServerDebugEnumTest = 1
    /** 发布环境 */
    case YXServerDebugEnumPublic = 2
}

/** 环境设置 */
public let kServerDebug: YXServerDebugEnum = .YXServerDebugEnumDevelopment

/** 接口地址 */
public var kHostUrl: String = {
    
    switch kServerDebug {
    case .YXServerDebugEnumDevelopment:
        return "https://en-api-qf.qiufa.com/v2_7_2"
    case .YXServerDebugEnumTest:
        return "测试"
    case .YXServerDebugEnumPublic:
        return "正式"
    }
}()

/** 网页地址 */
public var kHostUrlH5: String = {
    
    switch kServerDebug {
    case .YXServerDebugEnumDevelopment:
        return ""
    case .YXServerDebugEnumTest:
        return ""
    case .YXServerDebugEnumPublic:
        return ""
    }
}()
