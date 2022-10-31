//
//  YXToolFuncCycleScrollInfoModel.swift
//  YXSwiftBasicProj
//
//  Created by ios on 2021/5/13.
//

import UIKit

class YXToolFuncCycleScrollInfoModel: NSObject {
    
    var imgUrl : NSString = ""
    
    public static func arrayOfModelsFromDictionaries(arr: NSArray) -> NSMutableArray {
        
        let dataAry = NSMutableArray.init()
        for dic: NSDictionary in arr as! [NSDictionary] {
            let model = YXToolFuncCycleScrollInfoModel().initWithDic(dic: dic)
            dataAry.add(model)
        }
        
        return dataAry
    }
    
    func initWithDic(dic: NSDictionary) -> Self {
        
        self.imgUrl = dic.object(forKey: "imgUrl") as! NSString
        
        return self
    }

}
