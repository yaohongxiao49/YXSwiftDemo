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
    
    lazy var itemModelArr: NSMutableArray = {
       
        let tableVC = YXTableViewVC.init()
        let collectionVC = YXCollectionViewVC.init()
        
        let itemModelArr = NSMutableArray.init()
        let itemArr = [["vc": tableVC, "title": "TableView", "norIcon": "YXHomeTabNorImg", "selIcon": "YXHomeTabSelImg"], ["vc": collectionVC, "title": "CollectionView", "norIcon": "YXHomeTabNorImg", "selIcon": "YXHomeTabSelImg"]]
        
        //项目数据
        for i in 0 ..< itemArr.count {
            let model = YXBaseTabBarItemModel.init()
            model.vc = (itemArr[i]["vc"] as! YXBaseVC)
            model.itemTitle = (itemArr[i]["title"] as! NSString)
            model.norIcon = (itemArr[i]["norIcon"] as! NSString)
            model.selIcon = (itemArr[i]["selIcon"] as! NSString)
            model.norTitleColor = UIColor.yxColorWithHexString(hex: "#000000")
            model.selTitleColor = UIColor.yxColorWithHexString(hex: "#1D48FF")
            model.type = i == 0 ? .YXBaseTabBarItemStateTypeSel : .YXBaseTabBarItemStateTypeNor
            itemModelArr.add(model)
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

    //MARK:- 初始化视图
    func initView() {
        
//        self.baseTabBarView.isHidden = false
        self.baseTabBarView.itemModelArr = self.itemModelArr
    }
    
    //MARK:- 初始化控制器
    func initVC() {
        
        for model : YXBaseTabBarItemModel in self.itemModelArr as! [YXBaseTabBarItemModel] {
            addChildrenVC(model.vc, title: nil, image: nil, selectedImage: nil)
        }
    }
    
    //MARK:- 添加控制器
    func addChildrenVC(_ childController: UIViewController, title: String?, image: UIImage?, selectedImage: UIImage?) {

        addChild(YXBaseNavigationVC(rootViewController: childController))
    }
    
}
