//
//  YXRechBility.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/4.
//

import UIKit

class YXRechBility: NSObject {

    /** 单例 */
    static let rechBility = YXRechBility()
    
    func yxRealTimeGetRechBility(boolRechableBlock: @escaping (_ boolRechable: Bool) -> (Void)) {
        
        let reachability = try! Reachability()

        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            }
            else {
                print("Reachable via Cellular")
            }
            
            reachability.stopNotifier()
            boolRechableBlock(true)
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            
            reachability.stopNotifier()
            boolRechableBlock(false)
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }

    }
    
}
