//
//  YXHomeVC.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/1.
//

import UIKit

class YXHomeVC: YXBaseVC, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- 初始化声明
    lazy var tableView: UITableView = {
       
        let tableView = UITableView.init(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.estimatedRowHeight = 30
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        tableView.register(YXHomeVCListCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(YXHomeVCListCell.classForCoder()))
        
        return tableView
    }()
    
    //MARK:- UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: YXHomeVCListCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(YXHomeVCListCell.classForCoder()), for: indexPath) as! YXHomeVCListCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.0
    }
    
    //MARK:- 初始化视图
    func initView() {
        
        self.tableView.reloadData()
        print(kHostUrl)
    }
    
    //MARK:- 视图加载完毕
    override func viewDidLoad() {
        
        self.initView()
    }

}
