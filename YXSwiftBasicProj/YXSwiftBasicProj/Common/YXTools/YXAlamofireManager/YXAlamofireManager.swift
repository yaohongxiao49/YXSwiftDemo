//
//  YXAlamofireManager.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/6.
//

import UIKit

typealias YXRequestBlock<T> = (_ dic: T, _ isSuccess: Bool) ->(Void)
typealias YXRequestSuccessBlock<T> = (_ responseObj: T) ->(Void)
typealias YXRequesFailBlock = (_ error: Error) ->(Void)
typealias YXRequesNetworkUseBlock<T> = (_ newworkObj: T) ->(Void)

class YXAlamofireManager: NSObject {
    
    /** 单例 */
    static let almofireManagerTool = YXAlamofireManager()
    
    //header
    lazy var headers: HTTPHeaders = {
     
        let headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json", "version": "1"]
        return headers
    }()
    
    //params
    func getPublicParams(params: [String : AnyObject]) -> [String : AnyObject] {
     
        var dic = [String: AnyObject]()
        for e in params { //如果key不存在，直接增加。存在的话就会更改。
            dic[e.key] = params[e.key]
        }
        return dic
    }
    
}

//MARK: - 对外方法
extension YXAlamofireManager {
    
    //MAKR: - 对外开放的get请求
    /** 对外开放的get请求 */
    public func getWithURL<T>(url: String, params: [String: AnyObject], showText: String, boolShowSuccess: Bool, boolShowError: Bool, block: @escaping YXRequestBlock<T>) {
        
        let headerField = self.headers
        let newParams = self.getPublicParams(params: params)
        
        self.getWithURL(url: url, params: newParams, headerField: headerField) { responseObj in
            
        } failBlock: { error in
            
        } networkBlock: { newworkObj in
            
        }

    }
    
}

//MARK: - 对内方法
extension YXAlamofireManager {
    
    private func getWithURL<T>(url: String, params: [String: AnyObject], headerField: T, successBlock: @escaping YXRequestSuccessBlock<T>, failBlock: @escaping YXRequesFailBlock, networkBlock: @escaping YXRequesNetworkUseBlock<T>) {
        
        
    }
    
}
