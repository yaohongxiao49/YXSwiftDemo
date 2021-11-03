//
//  YXBaseTableView.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/1.
//

import UIKit

class YXBaseTableView: UITableView {
    
    //MARK: - 初始化视图
    func initView() {
        
        self.estimatedRowHeight = 10
        self.estimatedSectionHeaderHeight = 10
        self.estimatedSectionFooterHeight = 10
        self.backgroundColor = UIColor.white
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none
        self.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    //MARK: - 初始化
    required override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension YXBaseTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.classForCoder()), for: indexPath)
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView.init(frame: CGRect.zero)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView.init(frame: CGRect.zero)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
}
