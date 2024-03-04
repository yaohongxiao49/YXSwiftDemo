//
//  YXNetworkUseManager.swift
//  YXSwiftBasicProj
//
//  Created by Augus on 2022/8/8.
//

import Foundation

public typealias YXNetworkUseManagerFinishBlock = (_ dic: [String: Any]?, _ isSuccess: Bool) -> Void

public class YXNetworkUseManager {
 
    public static let shared = YXNetworkUseManager()
    
    //MARK: - 登录
    public static func yxGetRequestLogainHTTPByAccount(account: String?, code: String?, invitecode:String?, showText: String?, boolShowSuccess: Bool? = false, boolShowError: Bool? = false, block: @escaping YXNetworkUseManagerFinishBlock) {
        
        let url = kYXGetLogainAPI
        var params = [String: Any]()
        params["account"] = account
        params["code"] = code
        if (!invitecode!.isEmpty) {
            params["invitecode"] = invitecode
        }
        
        YXNetworkManager.shared.requestWithUrl(url: url, params: params, showText: showText, boolShowSuccess: boolShowSuccess!, boolShowError: boolShowError!) { dic, isSuccess in
            
        }
    }
    
    //MARK: - 获取广告
    public static func yxGetAdvertingHTTPByCode(code: String?, boolPage: Bool? = false, page: Int? = 1, showText: String?, boolShowSuccess: Bool, boolShowError: Bool, block: @escaping YXNetworkUseManagerFinishBlock) {
        
        let url = kYXGetAdvertingAPI
        var params = [String: Any]()
        params["advertisementCode"] = code
        if (boolPage == true) {
            params["pageSize"] = 10
            params["pageNum"] = page
        }
        else {
            params["pageSize"] = 100
        }
        
        YXNetworkManager.shared.requestWithUrl(url: url, params: params, showText: showText, boolShowSuccess: boolShowSuccess, boolShowError: boolShowError) { dic, isSuccess in
            
            if (isSuccess == true) {
                block(dic?["data"] as? [String : Any], isSuccess)
            }
            else {
                block(nil, isSuccess)
            }
        }
    }
    
    //MARK: - 获取往期列表数据
    public static func yxGetOldListHTTPByPage(page: Int? = 1, showText: String?, boolShowSuccess: Bool, boolShowError: Bool, block: @escaping YXNetworkUseManagerFinishBlock) {
     
        let url = "http://www.cwl.gov.cn/cwl_admin/kjxx/findDrawNotice"
        let pageValue = page! * 10
        var params = [String: Any]()
        
        params["name"] = "ssq"
        params["issueCount"] = pageValue
        
        YXNetworkManager.shared.requestWithUrl(url: url, method: .get, params: params, showText: showText, boolShowSuccess: boolShowSuccess, boolShowError: boolShowError) { dic, isSuccess in
            
            if (isSuccess == true) {
                block(dic?["result"] as? [String : Any], isSuccess)
            }
            else {
                block(nil, isSuccess)
            }
        }
    }
}
