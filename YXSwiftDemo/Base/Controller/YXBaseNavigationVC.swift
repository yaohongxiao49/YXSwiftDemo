//
//  YXBaseNavigationVC.swift
//  YXAccordingProj
//
//  Created by ios on 2021/5/10.
//

import UIKit

class YXBaseNavigationVC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }

    //MARK:- 初始化视图
    func initView() {
        
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .fullScreen
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        
        if (viewControllers.count == 1) {
            self.popViewController(animated: animated)
            return
        }
        
        for i in 0 ..< viewControllers.count {
            let vc = viewControllers[i]
            if (i == 1) {
                vc.hidesBottomBarWhenPushed = true
            }
            else {
                vc.hidesBottomBarWhenPushed = false
            }
        }
        
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if (self.viewControllers.count == 1) {
            viewController.hidesBottomBarWhenPushed = true
        }
        else {
            viewController.hidesBottomBarWhenPushed = false
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
}
