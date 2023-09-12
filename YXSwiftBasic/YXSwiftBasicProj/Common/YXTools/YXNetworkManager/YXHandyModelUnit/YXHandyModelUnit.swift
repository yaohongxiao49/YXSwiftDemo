//
//  YXHandyModelUnit.swift
//  YXSwiftBasicProj
//
//  Created by Augus on 2023/9/12.
//

import Foundation
import UIKit
import HandyJSON

class JsonUtil: NSObject {
    
    /** Json转对象 */
    static func jsonToModel(_ jsonStr:String,_ modelType:HandyJSON.Type) ->YXHandyBaseModel {
        if jsonStr == "" || jsonStr.count == 0 {
            #if DEBUG
                print("jsonoModel:字符串为空")
            #endif
            return YXHandyBaseModel()
        }
        return modelType.deserialize(from: jsonStr)  as! YXHandyBaseModel

    }

    /** Json转数组对象 */
    static func jsonArrayToModel(_ jsonArrayStr:String, _ modelType:HandyJSON.Type) ->[YXHandyBaseModel] {
        if jsonArrayStr == "" || jsonArrayStr.count == 0 {
            #if DEBUG
                print("jsonToModelArray:字符串为空")
            #endif
            return []
        }
        var modelArray:[YXHandyBaseModel] = []
        let data = jsonArrayStr.data(using: String.Encoding.utf8)
        let peoplesArray = try! JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
        for people in peoplesArray! {
            modelArray.append(dictionaryToModel(people as! [String : Any], modelType))
        }
        return modelArray

    }

    /** 字典转对象 */
    static func dictionaryToModel(_ dictionStr:[String:Any],_ modelType:HandyJSON.Type) -> YXHandyBaseModel {
        if dictionStr.count == 0 {
            #if DEBUG
                print("dictionaryToModel:字符串为空")
            #endif
            return YXHandyBaseModel()
        }
        return modelType.deserialize(from: dictionStr) as! YXHandyBaseModel
    }

    /** 对象转JSON */
    static func modelToJson(_ model:YXHandyBaseModel?) -> String {
        if model == nil {
            #if DEBUG
                print("modelToJson:model为空")
            #endif
             return ""
        }
        return (model?.toJSONString())!
    }

    /** 对象转字典 */
    static func modelToDictionary(_ model:YXHandyBaseModel?) -> [String:Any] {
        if model == nil {
            #if DEBUG
                print("modelToJson:model为空")
            #endif
            return [:]
        }
        return (model?.toJSON())!
    }

}
