//
//  YXCollectionViewVCCell.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/1.
//

import UIKit

class YXCollectionViewVCCell: UICollectionViewCell {
    
    //MARK: - 初始化声明
    lazy var titleLab: UILabel = {
       
        let titleLab = UILabel.init(frame: CGRect.zero);
        titleLab.textColor = UIColor.black
        titleLab.textAlignment = .center
        titleLab.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(titleLab);
        
        titleLab.snp.makeConstraints { make in
            make.left.equalTo(self.contentView).offset(15)
            make.top.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-15)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
        
        return titleLab
    }()
    
}
