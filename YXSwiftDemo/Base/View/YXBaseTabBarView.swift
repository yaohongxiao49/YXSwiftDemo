//
//  YXBaseTabBarView.swift
//  YXAccordingProj
//
//  Created by ios on 2021/5/10.
//

import UIKit

typealias YXBaseTabBarViewTapBlock = (Int) ->(Void)

class YXBaseTabBarView: UIView {
    
    var itemViewArr = NSMutableArray.init()
    var itemModelArr = NSMutableArray.init()
    var yxBaseTabBarViewTapBlock : YXBaseTabBarViewTapBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- 初始化视图
    func initView() {
        
        let imgView = UIImageView.init(frame: self.bounds)
        imgView.backgroundColor = UIColor.clear
        self.addSubview(imgView)
        
        initTabBarItem()
        
        let itemWidth = Int(UIScreen.main.bounds.width) / itemModelArr.count
        
        for i in 0 ..< itemModelArr.count {
            let itemView = YXBaseTabBarItemView.init(frame: CGRect.init(x: (itemWidth * Int(i)), y: 0, width: itemWidth, height: Int(self.bounds.height)))
            itemView.itemModel = itemModelArr[i] as? YXBaseTabBarItemModel
            itemView.tag = i
            itemView.yxBaseTabBarItemViewTapBlock = {(view : YXBaseTabBarItemView) ->() in
                
                for originalItemView in self.itemViewArr {
                    let forItemView : YXBaseTabBarItemView = originalItemView as! YXBaseTabBarItemView
                    if forItemView.tag == view.tag {
                        forItemView.itemModel?.type = .YXBaseTabBarItemStateTypeSel
                    }
                    else {
                        forItemView.itemModel?.type = .YXBaseTabBarItemStateTypeNor
                    }
                    forItemView.itemModel = forItemView.itemModel!
                }
                self.yxBaseTabBarViewTapBlock!(view.tag)
            }
            self.addSubview(itemView)
            itemViewArr.add(itemView)
        }
    }
    
    //MARK:- 初始化标签
    func initTabBarItem() {
        
        let itemArr = [["title": "首页", "norIcon": "YXHomeTabNorImg", "selIcon": "YXHomeTabSelImg"]]
        
        //项目数据
        for i in 0 ..< itemArr.count {
            let model = YXBaseTabBarItemModel.init()
            model.itemTitle = itemArr[i]["title"]! as NSString
            model.norIcon = itemArr[i]["norIcon"]! as NSString
            model.selIcon = itemArr[i]["selIcon"]! as NSString
            model.norTitleColor = UIColor.yxColorWithHexString(hex: "#000000")
            model.selTitleColor = UIColor.yxColorWithHexString(hex: "#1D48FF")
            model.type = i == 0 ? .YXBaseTabBarItemStateTypeSel : .YXBaseTabBarItemStateTypeNor
            itemModelArr.add(model)
        }
    }
}
