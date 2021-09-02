//
//  YXBaseTabBarItemView.swift
//  YXAccordingProj
//
//  Created by ios on 2021/5/10.
//

import UIKit
import RxSwift
import SnapKit

typealias YXBaseTabBarItemViewTapBlock = (YXBaseTabBarItemView) ->(Void)

class YXBaseTabBarItemView: UIView {
    
    var yxBaseTabBarItemViewTapBlock: YXBaseTabBarItemViewTapBlock?
    lazy var imgV : UIImageView = {
        
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFit
        self.addSubview(imgV)
        imgV.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(6)
            make.height.equalTo(25)
        }
        
        return imgV
    }()
    
    lazy var titleLab : UILabel = {
        
        let titleLab = UILabel()
        titleLab.textAlignment = .center
        titleLab.font = .boldSystemFont(ofSize: 10)
        titleLab.textColor = UIColor.white
        self.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(self.imgV.snp.bottom)
            make.height.equalTo(16)
        }
        
        return titleLab
    }()
    
    lazy var btn : UIButton = {
        
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(progressBtn(sender:)), for: UIControl.Event.touchUpInside)
        self.addSubview(btn)
        btn.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- progress
    //MARK:- 点击按钮
    @objc func progressBtn(sender: UIButton) {
        
        self.yxBaseTabBarItemViewTapBlock!(self)
    }
    
    //MARK:- setting
    public var itemModel : YXBaseTabBarItemModel? {
        
        didSet {
            updateView()
        }
    }
    
    //MARK:- 初始化视图
    func initView() {
        
        self.btn.isHidden = false
    }
    
    //MARK:- 更新视图
    func updateView() {
        
        switch self.itemModel?.type {
        case .YXBaseTabBarItemStateTypeNor:
            self.imgV.image = UIImage.init(named: (self.itemModel?.norIcon!)! as String)
            self.titleLab.textColor = self.itemModel?.norTitleColor
            break
        case .YXBaseTabBarItemStateTypeSel:
            self.imgV.image = UIImage.init(named: (self.itemModel?.selIcon!)! as String)
            self.titleLab.textColor = self.itemModel?.selTitleColor
            break
        default:
            break
        }
        
        self.titleLab.text = self.itemModel?.itemTitle as String?
    }
    
}
