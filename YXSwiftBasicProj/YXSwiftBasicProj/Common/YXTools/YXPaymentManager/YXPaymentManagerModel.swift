//
//  YXPaymentManagerModel.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/5.
//

import UIKit

class YXPaymentManagerModel: NSObject {

    /** 商家根据微信开放平台文档对数据做的签名 */
    var sign: String?
    /** 时间戳 */
    var timeStamp: String?
    /** 随机串 */
    var nonceStr: String?
    /** 商家向财付通申请的商家id */
    var partnerId: String?
    /** 预支付订单 */
    var prePayId: String?
    /** 商家根据财付通文档填写的数据和签名 */
    var packageName: String?
    /** 由用户微信号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验微信用户是否换号登录 */
    var appId: String?
    var notifyUrl: String?

    func initWithDic(dic: NSDictionary) -> Self {
        
        self.sign = (dic.object(forKey: "sign") as! String)
        self.timeStamp = (dic.object(forKey: "timestamp") as! String)
        self.nonceStr = (dic.object(forKey: "noncestr") as! String)
        self.partnerId = (dic.object(forKey: "partnerid") as! String)
        self.prePayId = (dic.object(forKey: "prepayid") as! String)
        self.packageName = (dic.object(forKey: "package") as! String)
        self.appId = (dic.object(forKey: "appid") as! String)
        self.notifyUrl = (dic.object(forKey: "notifyUrl") as! String)
        
        return self
    }
    
}
