//
//  YXPaymentManager.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/5.
//

import UIKit

enum YXPaymentAlipayStatus: Int {
    /** 支付成功 */
    case YXPaymentAlipayStatusSuccess = 9000
    /** 正在处理中 */
    case YXPaymentAlipayStatusProcessing = 8000
    /** 支付失败 */
    case YXPaymentAlipayStatusFailed = 4000
    /** 取消操作 */
    case YXPaymentAlipayStatusCancel = 6001
    /** 网络异常 */
    case YXPaymentAlipayStatusNetProblems = 6002
}

typealias YXPaymentManagerAlipayBlock = (_ boolSuccess: Bool) ->(Void)

class YXPaymentManager: NSObject {

    /** 单例 */
    static let paymentTool = YXPaymentManager()
    
    //MARK: - 支付宝支付
    final func alipayWithPaymentInfoBase(sign: String, appScheme: String, callBlock: @escaping YXPaymentManagerAlipayBlock) {
  
        AlipaySDK.defaultService().payOrder(sign, fromScheme: appScheme) { result in
         
            let status = result?["resultStatus"] as! YXPaymentAlipayStatus
            self.alipayResultByStatus(status: status) { boolSuccess in
                
                callBlock(boolSuccess)
            }
        }
    }
    
    //MARK: - 获取支付宝支付结果
    final func getAlipayResultByUrl(url: URL, callBlock: @escaping YXPaymentManagerAlipayBlock) {
        
        AlipaySDK.defaultService().processOrder(withPaymentResult: url) { result in
            
            let status = result?["resultStatus"] as! YXPaymentAlipayStatus
            self.alipayResultByStatus(status: status) { boolSuccess in
                
                callBlock(boolSuccess)
            }
        }
    }
    
    //MARK: - 支付宝结果
    final func alipayResultByStatus(status: YXPaymentAlipayStatus, callBlock: @escaping YXPaymentManagerAlipayBlock) {
        
        switch status {
        case .YXPaymentAlipayStatusSuccess:
            callBlock(true);
            print("支付成功")
        case .YXPaymentAlipayStatusProcessing:
            print("正在处理中")
        case .YXPaymentAlipayStatusFailed:
            print("订单支付失败")
        case .YXPaymentAlipayStatusCancel:
            print("取消操作")
        case .YXPaymentAlipayStatusNetProblems:
            print("网络异常")
        }
    }
    
}
