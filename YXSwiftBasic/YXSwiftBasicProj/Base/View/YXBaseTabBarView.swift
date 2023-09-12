//
//  YXBaseTabBarView.swift
//  YXSwiftBasicProj
//
//  Created by ios on 2021/5/10.
//

import UIKit

typealias YXBaseTabBarViewTapBlock = (Int) ->(Void)

class YXBaseTabBarView: UIView {
    
    var itemViewArr = Array<Any>()
    var itemModelArr: Array<Any>? {
        
        didSet {
            self.initView()
        }
    }
    var yxBaseTabBarViewTapBlock : YXBaseTabBarViewTapBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 初始化视图
    func initView() {
        
        let imgView = UIImageView.init(frame: self.bounds)
        imgView.backgroundColor = UIColor.clear
        self.addSubview(imgView)
        
        let itemWidth = Int(UIScreen.main.bounds.width) / self.itemModelArr!.count
        
        for i in 0 ..< self.itemModelArr!.count {
            let itemView = YXBaseTabBarItemView.init(frame: CGRect.init(x: (itemWidth * Int(i)), y: 0, width: itemWidth, height: Int(self.bounds.height)))
            itemView.itemModel = self.itemModelArr![i] as? YXBaseTabBarItemModel
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
                
                guard let block = self.yxBaseTabBarViewTapBlock else { return }
                block(view.tag)
            }
            self.addSubview(itemView)
            self.itemViewArr.append(itemView)
        }
    }
    
}
