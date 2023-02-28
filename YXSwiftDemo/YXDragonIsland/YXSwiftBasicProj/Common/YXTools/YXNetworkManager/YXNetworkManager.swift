//
//  YXNetworkManager.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/7.
//

import Foundation

enum YXNetworkManagerFinishedEnum: Int {
    /** 成功 */
    case success = 0
}

public typealias YXNetworkManagerFinishBlock = (_ dic: [String: Any]?, _ isSuccess: Bool) -> Void

public class YXNetworkManager {
    
    public static let shared = YXNetworkManager()
    
    lazy var headers: [String : String] = {
       
        var token = Defaults[\.token]!
        let headers = ["Accept":"application/json", "Content-Type":"application/json", "version":kMajorVersion, "token": token]
        return headers
    }()
    
    //MARK: - 网络请求
    public func requestWithUrl(url: String, method: HTTPMethod = .get, params: [String : Any]? = nil, showText: String? = nil, boolShowSuccess: Bool, boolShowError: Bool, block: @escaping YXNetworkManagerFinishBlock) {
        
        if (kServerDebug ==  .YXServerDebugEnumDevelopment) {
            print("接口请求：\(url)\n params：\(String(describing: params))\n headerField：\(self.headers)")
        }
        
        if let showTexts = showText {
            SVProgressHUD.show(withStatus: showTexts)
        }
        
        YXNet.request(url: url, method: method, parameters: params, headers: self.headers, encoding: URLEncoding.default).success { response in
            
            if let showTexts = showText {
                SVProgressHUD.dismiss()
                print(showTexts)
            }
            
            let dic: Dictionary = response as! [String : Any]
            let code = dic["code"] as! Int
            let msg = dic["msg"] as! String
            if code == YXNetworkManagerFinishedEnum.success.rawValue {
                if (boolShowSuccess) {
                    SVProgressHUD.showSuccess(withStatus: msg)
                }
                block(dic, true)
            }
            else {
                if (boolShowError) {
                    SVProgressHUD.showError(withStatus: msg)
                }
                block(dic, false)
            }
            
        }.failed { error in
            
            if (boolShowError) {
                SVProgressHUD.showError(withStatus: "请求失败")
            }
            else {
                if let showTexts = showText {
                    SVProgressHUD.dismiss()
                    print(showTexts)
                }
            }
            
            block(nil, false)
        }

    }

}
