//
//  YXUserCenterOrderCell.swift
//  YXSwiftBasicProj
//
//  Created by Augus on 2022/10/9.
//

import UIKit

class YXUserCenterOrderCell: UITableViewCell {
    
    //MARK: - 初始化
    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    //MARK: - 初始化视图
    func initView() {
        
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
