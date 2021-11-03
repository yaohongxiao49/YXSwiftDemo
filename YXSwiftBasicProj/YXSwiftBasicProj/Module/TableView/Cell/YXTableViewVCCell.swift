//
//  YXTableViewVCCell.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/1.
//

import UIKit

class YXTableViewVCCell: UITableViewCell {
    
    //MARK: - 初始化声明
    lazy var titleLab: UILabel = {
       
        let titleLab = UILabel.init(frame: CGRect.zero);
        titleLab.textColor = UIColor.black
        titleLab.textAlignment = .left
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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
