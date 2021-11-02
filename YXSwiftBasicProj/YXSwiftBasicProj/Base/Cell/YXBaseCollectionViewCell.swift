//
//  YXBaseCollectionViewCell.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/1.
//

import UIKit

class YXBaseCollectionViewCell: UICollectionViewCell {
 
    //MARK:- 初始化视图
    func initView() {
        
        
    }
    
    //MARK:- 初始化
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
