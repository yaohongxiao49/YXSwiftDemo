//
//  YXBaseTableViewCell.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/1.
//

import UIKit

class YXBaseTableViewCell: UITableViewCell {

    //MARK: - 初始化视图
    func initView() {
        
        
    }
    
    //MARK: - 初始化
    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
