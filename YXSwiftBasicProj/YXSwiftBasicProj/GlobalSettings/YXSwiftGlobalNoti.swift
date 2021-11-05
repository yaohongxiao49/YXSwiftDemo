//
//  YXSwiftGlobalNoti.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/5.
//

import UIKit

/** 通知结构体 */
public struct YXSwiftGlobalNotiStruct {
    /** 支付宝支付结果通知 */
    var yxPaymentAlipayResultNofi = "yxPaymentAlipayResultNofi"
}

class YXSwiftGlobalNoti: NSObject {
 
    /** 发送通知统一方法 */
    public func postNotifiation(name: String, object: Any?) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object)
    }
}
