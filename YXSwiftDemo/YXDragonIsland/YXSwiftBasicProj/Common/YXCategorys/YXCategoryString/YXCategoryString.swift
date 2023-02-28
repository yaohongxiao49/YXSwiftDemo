//
//  YXCategoryString.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/5.
//

import UIKit

//MARK: - 系统信息
//MARK: - 获取版本信息
/** 获取app信息 */
public let kInfoDictionary: Dictionary = Bundle.main.infoDictionary!
/** 程序名称 */
public let kAppDisplayName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
/** 版本号 */
public let kMajorVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
/** build号 */
public let kMinorVersion: String = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

//MARK: - 获取设备信息
/** ios版本 */
public let kIosVersion : NSString = UIDevice.current.systemVersion as NSString
/** 设备udid */
public let kIdentifierNumber  = UIDevice.current.identifierForVendor
/** 设备名称 */
public let kDeviceName : String = UIDevice.current.name
/** 系统名称 */
public let kSystemName : String = UIDevice.current.systemName
/** 设备型号 */
public let kModel = UIDevice.current.model
/** 设备区域化型号如A1533 */
public let kLocalizedModel = UIDevice.current.localizedModel

public extension String {
    
    //MARK: - 存储地址
    /** cache目录 */
    func cacheDir() -> String {
        
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String
        path.append(self as String)
        return path
    }
    
    /** doc目录 */
    func docDir() -> String {
        
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String
        path.append(self as String)
        return path
    }
    
    /** tmp目录 */
    func tmpDir() -> String {
        
        var path = NSTemporaryDirectory() as String
        path.append(self as String)
        return path
    }
    
    //MARK: - 系统信息
    
}
