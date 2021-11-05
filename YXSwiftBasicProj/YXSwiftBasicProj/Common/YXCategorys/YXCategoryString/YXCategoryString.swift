//
//  YXCategoryString.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/5.
//

import UIKit

public extension String {
    
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
    
}
