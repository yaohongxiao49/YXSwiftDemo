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
    public static func yxGetRequestAlamofireUse(showText: String? = nil, boolShowSuccess: Bool, boolShowError: Bool, block: @escaping YXNetworkUseManagerFinishBlock) {
        
        let url = kHostUrl.appending("/Login/get_forum_group")
        YXNetworkManager.shared.requestWithUrl(url: url, params: nil, showText: nil, boolShowSuccess: false, boolShowError: false) { dic, isSuccess in
            
        }
        
    }
    
}
