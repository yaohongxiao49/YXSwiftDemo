//
//  YXPhotoPickerCell.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/3.
//

import UIKit

class YXPhotoPickerCell: YXBaseCollectionViewCell {
    
    lazy var imgV: UIImageView = {
       
        let imgV = UIImageView.init()
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        self.contentView.addSubview(imgV)
        
        imgV.snp.makeConstraints { make in

            make.edges.equalToSuperview()
        }
        
        return imgV
    }()
    
    override func initView() {
        
    }
    
}
