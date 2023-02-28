//
//  YXNetworkError.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/7.
//

import UIKit

//MARK: - 请求的错误反馈，继承`NSObject`为了让OC也能调用
public class YXNetworkError: NSObject {
    
    /** 错误码 */
    @objc var code = -1
    /** 错误描述 */
    @objc var localizedDescription: String

    init(code: Int, desc: String) {
        
        self.code = code
        self.localizedDescription = desc
        super.init()
    }
}
