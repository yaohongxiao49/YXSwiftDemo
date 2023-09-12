//
//  YXHandyBaseModel.swift
//  YXSwiftBasicProj
//
//  Created by Augus on 2023/9/12.
//

import Foundation
import UIKit
import HandyJSON

class YXHandyBaseModel: HandyJSON {
    
//    var date: Date?
//    var decimal: NSDecimalNumber?
//    var url: URL?
//    var data: Data?
//    var color: UIColor?

    required init() {}

    func mapping(mapper: HelpingMapper) { //自定义解析规则，日期数字颜色，如果要指定解析格式，子类实现重写此方法即可
//            date <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd")
//            decimal <-- NSDecimalNumberTransform()
//            url <-- URLTransform(shouldEncodeURLString: false)
//            data <-- DataTransform()
//            color <-- HexColorTransform()
      }
}
