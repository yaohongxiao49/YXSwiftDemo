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
    
    var yxPaymentManagerAlipayBlock: YXPaymentManagerAlipayBlock?
}

//MARK: - 支付宝支付
extension YXPaymentManager {
    
    /** 支付宝调起支付 */
    final func alipayWithPaymentInfoBase(sign: String, appScheme: String, callBlock: @escaping YXPaymentManagerAlipayBlock) {
  
        if UIApplication.shared.canOpenURL(URL.init(string: "alipay://")!) {
            AlipaySDK.defaultService().payOrder(sign, fromScheme: appScheme) { result in
                
                let status = result?["resultStatus"] as! YXPaymentAlipayStatus
                self.alipayResultByStatus(status: status) { boolSuccess in
                    
                    callBlock(boolSuccess)
                }
            }
        }
        else {
            print("没有安装支付宝")
        }
    }
    
    /** 获取支付宝支付结果 */
    final func getAlipayResultByUrl(url: URL, callBlock: @escaping YXPaymentManagerAlipayBlock) {
        
        AlipaySDK.defaultService().processOrder(withPaymentResult: url) { result in
            
            let status = result?["resultStatus"] as! YXPaymentAlipayStatus
            self.alipayResultByStatus(status: status) { boolSuccess in
                
                callBlock(boolSuccess)
            }
        }
    }
    
    /** 支付宝结果状态判定 */
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

//MARK: - 微信支付
extension YXPaymentManager {
    
    /** 注册微信 */
    final func registerWX(appId: String, universalLink: String) {
        
        WXApi.registerApp(appId, universalLink: universalLink)
    }
    
    /** 调起微信支付 */
    final func wechatPayWithPaymentInfo(paymentInfo: YXPaymentManagerModel) {
        
        let req = PayReq.init()
        req.openID = paymentInfo.appId!
        req.partnerId = paymentInfo.partnerId!
        req.prepayId = paymentInfo.prePayId!
        req.nonceStr = paymentInfo.nonceStr!
        req.timeStamp = UInt32(paymentInfo.timeStamp!)!
        req.package = paymentInfo.packageName!
        req.sign = paymentInfo.sign!
        
        if WXApi.isWXAppInstalled() {
            WXApi.send(req) { result in
                
            }
        }
        else {
            print("没有安装微信")
        }
    }
    
    /** 获取微信支付结果 */
    final func getWXResultByUrl(url: URL, callBlock: @escaping YXPaymentManagerAlipayBlock) {
        
        WXApi.handleOpen(url, delegate: self)
    }
    
}

//MARK: - WXApiDelegate
extension YXPaymentManager: WXApiDelegate {
    
    func onResp(_ resp: BaseResp) {
        
        if let payResp = resp as? PayResp {
            switch payResp.errCode {
            case WXSuccess.rawValue:
                print("支付成功")
                guard let block = self.yxPaymentManagerAlipayBlock else { return }
                block(true)
            default:
                print("支付失败")
                guard let block = self.yxPaymentManagerAlipayBlock else { return }
                block(false)
            }
        }
    }
}
