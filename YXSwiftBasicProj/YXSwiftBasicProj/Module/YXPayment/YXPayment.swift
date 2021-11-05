//
//  YXPayment.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/5.
//

import UIKit

class YXPayment: YXBaseVC {

    //MARK: - 初始化视图
    func initView() {
    
        self.getLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationView.titleLab.text = "支付"
        self.navigationView.backBtn.isHidden = false
        
        self.initView()
    }

}

//MARK: - 方法
extension YXPayment {
    
    func getLocation() {
        
        YXLocationManager.locationTool.locationManagerWithCity { name in
            
        }
    }
}
