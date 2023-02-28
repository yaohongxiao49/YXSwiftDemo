//
//  YXAlamofireManager.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/6.
//

import UIKit

public typealias YXSuccessClosure = (_ JSON: Any) -> Void
public typealias YXFailedClosure = (_ error: YXNetworkError) -> Void
public typealias YXProgressHandler = (Progress) -> Void

/** 网络状况 */
public enum YXReachabilityStatus {
    /** 未知原因 */
    case unknown
    /** 没有网络 */
    case notReachable
    /** WiFi */
    case ethernetOrWiFi
    /** 蜂窝网络 */
    case cellular
}

public let YXNet = YXNetworkBaseManager.shared

/** 网络状态通知 */
public let kNetworkStatusNotification = NSNotification.Name("kNetworkStatusNotification")

//MARK: - 请求主类
public class YXNetworkBaseManager {
    
    /** 单例 */
    public static let shared = YXNetworkBaseManager()
    /** 请求主体集合 */
    private(set) var taskQueue = [YXNetworkRequest]()
    /** 请求会话 */
    var sessionManager: Alamofire.Session!

    /** 检测网络状态 */
    var reachability: NetworkReachabilityManager?
    /** 网络状态 */
    var networkStatus: YXReachabilityStatus = .unknown

    //MAKR: - 设置会话信息
    private init() {
        
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 30 //下载超时
        config.timeoutIntervalForResource = 30 //加载超时
        self.sessionManager = Alamofire.Session(configuration: config)
        self.stopMonitoring()
    }

    //MARK: - 发送请求
    /** 发送请求 */
    @discardableResult public func request(url: String, method: HTTPMethod = .get, parameters: [String : Any]?, headers: [String : String]? = nil, encoding: ParameterEncoding = URLEncoding.default) -> YXNetworkRequest {
        
        let task = YXNetworkRequest()
        task.printUrl = url

        var h: HTTPHeaders?
        if let tempHeaders = headers {
            h = HTTPHeaders(tempHeaders)
        }

        task.request = self.sessionManager.request(url, method: method, parameters: parameters, encoding: encoding, headers: h).validate().responseJSON { [weak self] response in
            
            task.handleResponse(response: response)
            if let index = self?.taskQueue.firstIndex(of: task) {
                self?.taskQueue.remove(at: index)
            }
        }
        self.taskQueue.append(task)
        
        return task
    }

    /** 上传数据 */
    //MARK: - 上传数据
    public func upload(url: String, method: HTTPMethod = .post, parameters: [String : String]?, datas: [YXNetworkMulipartData], headers: [String : String]? = nil) -> YXNetworkRequest {
        
        let task = YXNetworkRequest()
        task.printUrl = url
        
        var h: HTTPHeaders?
        if let tempHeaders = headers {
            h = HTTPHeaders(tempHeaders)
        }

        task.request = sessionManager.upload(multipartFormData: { (multipartData) in
            
            if let parameters = parameters { //参数
                for p in parameters {
                    multipartData.append(p.value.data(using: .utf8)!, withName: p.key)
                }
            }
            for d in datas { //数据
                multipartData.append(d.data, withName: d.name, fileName: d.fileName, mimeType: d.mimeType)
            }
        }, to: url, method: method, headers: h).uploadProgress(queue: .main, closure: { (progress) in
            
            task.handleProgress(progress: progress)
        }).validate().responseJSON(completionHandler: { [weak self] response in
            
            task.handleResponse(response: response)

            if let index = self?.taskQueue.firstIndex(of: task) {
                self?.taskQueue.remove(at: index)
            }
        })
        self.taskQueue.append(task)
        
        return task
    }

    /** 下载 */
    //MARK: - 下载
    public func download(url: String, method: HTTPMethod = .post) -> YXNetworkRequest {
        
        fatalError("download(...) has not been implemented")
    }

    //MARK: - 取消所有请求
    public func cancelAllRequests(completingOnQueue queue: DispatchQueue = .main, completion: (() -> Void)? = nil) {
        
        self.sessionManager.cancelAllRequests(completingOnQueue: queue, completion: completion)
    }
    
}

//MAKR: - 请求分类
extension YXNetworkBaseManager {

    //MARK: - Post Json类请求
    /** Post Json类请求 */
    @discardableResult public func POST(url: String, parameters: [String : Any]? = nil, headers: [String : String]? = nil) -> YXNetworkRequest {
        
        self.request(url: url, method: .post, parameters: parameters, headers: nil)
    }

    //MARK: - Post Data类请求
    /** Post Data类请求 */
    @discardableResult public func POST(url: String, parameters: [String : String]? = nil, headers: [String : String]? = nil, datas: [YXNetworkMulipartData]? = nil) -> YXNetworkRequest {
        
        guard datas != nil else {
            return self.request(url: url, method: .post, parameters: parameters, headers: nil)
        }
        return self.upload(url: url, parameters: parameters, datas: datas!, headers: headers)
    }

    //MARK: - Get请求
    /** Get请求 */
    @discardableResult public func GET(url: String, parameters: [String : Any]? = nil, headers: [String : String]? = nil) -> YXNetworkRequest {
        
        self.request(url: url, method: .get, parameters: parameters, headers: nil)
    }
    
}

//MKAR: - 监听网络状态
extension YXNetworkBaseManager {
    
    //MARK: - 开启网络监听
    public func startMonitoring() {
        
        if self.reachability == nil {
            self.reachability = NetworkReachabilityManager.default
        }

        self.reachability?.startListening(onQueue: .main, onUpdatePerforming: { [unowned self] (status) in
            
            switch status {
            case .notReachable:
                self.networkStatus = .notReachable
            case .unknown:
                self.networkStatus = .unknown
            case .reachable(.ethernetOrWiFi):
                self.networkStatus = .ethernetOrWiFi
            case .reachable(.cellular):
                self.networkStatus = .cellular
            }
            
            //发送通知
            NotificationCenter.default.post(name: kNetworkStatusNotification, object: nil)
            debugPrint("YXNetworkBaseManager Network Status: \(self.networkStatus)")
        })
    }

    //MAKR: - 停止网络监听
    public func stopMonitoring() {
        
        guard self.reachability != nil else { return }
        self.reachability?.stopListening()
    }
    
}

//MARK: - 请求结果
public class YXNetworkRequest: Equatable {

    /** 请求主体 */
    var request: Alamofire.Request?
    /** 描述 */
    var description: String?
    /** 附加信息 */
    var extra: String?
    /** 请求地址 */
    var printUrl: String?

    /** 成功回调 */
    private var successHandler: YXSuccessClosure?
    /** 失败回调 */
    private var failedHandler: YXFailedClosure?
    /** 上传进度回调 */
    private var progressHandler: YXProgressHandler?

    //MARK: - 结果回调
    /** 结果回调 */
    func handleResponse(response: AFDataResponse<Any>) {
        
        switch response.result {
        case .failure(let error):
            if let closure = self.failedHandler {
                let hwe = YXNetworkError(code: error.responseCode ?? -1, desc: error.localizedDescription)
                print("地址：\(String(describing: self.printUrl))，请求失败：\(hwe.localizedDescription)")
                closure(hwe)
            }
        case .success(let JSON):
            if let closure = self.successHandler {
                print("地址：\(String(describing: self.printUrl)) ，请求成功：\(JSON)")
                closure(JSON)
            }
        }
        self.clearReference()
    }

    //MARK: - 进度回调（只有upload时，使用）
    /** 进度回调（只有upload时，使用） */
    func handleProgress(progress: Foundation.Progress) {
        
        if let closure = progressHandler {
            closure(progress)
        }
    }

    //MARK: - 成功
    @discardableResult public func success(_ closure: @escaping YXSuccessClosure) -> Self {
        
        self.successHandler = closure
//        print("地址：\(String(describing: self.printUrl)) ，请求成功：\(JSON)")
        return self
    }

    //MAKR: - 失败
    @discardableResult public func failed(_ closure: @escaping YXFailedClosure) -> Self {
        
        self.failedHandler = closure
//        print("地址：\(String(describing: self.printUrl))，请求失败：\(hwe.localizedDescription)")
        return self
    }

    //MARK: - 进度
    /** 进度 */
    @discardableResult public func progress(closure: @escaping YXProgressHandler) -> Self {
        
        self.progressHandler = closure
        return self
    }

    //MARK: - 取消
    /** 取消 */
    func cancel() {
        
        self.request?.cancel()
    }

    //MARK: - 清除缓存
    /** 清除缓存 */
    func clearReference() {
        
        self.successHandler = nil
        self.failedHandler = nil
        self.progressHandler = nil
    }
    
}

//MARK: - 判定设置
extension YXNetworkRequest {
    
    //MARK: - 判定两个值是否相等
    public static func == (lhs: YXNetworkRequest, rhs: YXNetworkRequest) -> Bool {
        
        return lhs.request?.id == rhs.request?.id
    }
    
}
