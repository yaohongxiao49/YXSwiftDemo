//
//  YXBaseTabBar.swift
//  YXSwiftBasicProj
//
//  Created by ios on 2021/5/10.
//

import UIKit

class YXBaseTabBar: UITabBarController {
    
    lazy var customTabbar : UITabBar = {
        
        let customTabbar = self.tabBar
        customTabbar.frame = CGRect.init(x: 0.0, y: self.yxScreenHeight - self.yxToolHeight, width: self.yxScreenWidth, height: self.yxToolHeight)
        customTabbar.isTranslucent = true
        customTabbar.standardAppearance.backgroundEffect = nil
        customTabbar.standardAppearance.backgroundColor = UIColor.white
        customTabbar.standardAppearance.backgroundImage = UIImage()
        customTabbar.standardAppearance.shadowImage = UIImage()
        customTabbar.standardAppearance.shadowColor = UIColor.clear
        
        return customTabbar
    }()
    
    lazy var baseTabBarView : YXBaseTabBarView = {
        
        let baseTabBarView = YXBaseTabBarView(frame: self.tabBar.bounds)
        self.tabBar.addSubview(baseTabBarView)
        baseTabBarView.yxBaseTabBarViewTapBlock = {(tag) ->() in
            
            self.selectedIndex = tag
        }
        
        baseTabBarView.snp.makeConstraints { make in

            make.edges.equalToSuperview()
        }
        
        return baseTabBarView
    }()
    
    lazy var itemModelArr: [YXBaseTabBarItemModel] = {
       
        let homeVC = YXHomePageBaseVC.init()
        let bazaarVC = YXBazaarWebVC.init()
        let hatchingVC = YXHatchingBaseVC.init()
        let warehouseBaseVC = YXWarehouseBaseVC.init()
        let userCenterVC = YXUserCenterVC.init()
        
        var itemModelArr = [YXBaseTabBarItemModel]()
        let itemArr: [Dictionary<String, Any>] = [["vc": homeVC, "title": "首页", "norIcon": "YXHomeTabIconNorImg", "selIcon": "YXHomeTabIconSelImg"],
                       ["vc": bazaarVC, "title": "集市", "norIcon": "YXBazzarTabIconNorImg", "selIcon": "YXBazzarTabIconSelImg"],
                       ["vc": hatchingVC, "title": "孵化", "norIcon": "YXHatchingTabIconNorImg", "selIcon": "YXHatchingTabIconSelImg"],
                       ["vc": warehouseBaseVC, "title": "仓库", "norIcon": "YXWarehouseTabIconNorImg", "selIcon": "YXWarehouseTabIconSelImg"],
                       ["vc": userCenterVC, "title": "我的", "norIcon": "YXUserTabIconNorImg", "selIcon": "YXUserTabIconSelImg"]]
        
        //项目数据
        for i in 0 ..< itemArr.count {
            let model = YXBaseTabBarItemModel.init()
            model.vc = (itemArr[i]["vc"] as! YXBaseVC)
            model.itemTitle = itemArr[i]["title"] as? String
            model.norIcon = itemArr[i]["norIcon"] as? String
            model.selIcon = itemArr[i]["selIcon"] as? String
            model.norTitleColor = kYXMainTextColor
            model.selTitleColor = kYXMainThemeColor
            model.type = i == 0 ? .YXBaseTabBarItemStateTypeSel : .YXBaseTabBarItemStateTypeNor
            itemModelArr.insert(model, at: i)
        }
        
        return itemModelArr
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.subviews.forEach { (subView) in
            if subView is UIControl {
                subView.removeFromSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initVC()
        initView()
    }

    //MARK: - 初始化视图
    func initView() {
        
//        self.baseTabBarView.isHidden = false
        self.baseTabBarView.itemModelArr = self.itemModelArr
    }
    
    //MARK: - 初始化控制器
    func initVC() {
        
        for model : YXBaseTabBarItemModel in self.itemModelArr {
            addChildrenVC(model.vc, title: nil, image: nil, selectedImage: nil)
        }
    }
    
    //MARK: - 添加控制器
    func addChildrenVC(_ childController: UIViewController, title: String?, image: UIImage?, selectedImage: UIImage?) {

        addChild(YXBaseNavigationVC(rootViewController: childController))
    }
    
}
