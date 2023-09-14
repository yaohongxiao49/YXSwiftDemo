//
//  YXHomePageListVC.swift
//  YXSwiftBasicProj
//
//  Created by Augus on 2022/8/9.
//

import UIKit

class YXHomePageListVC: YXBaseVC {

    //MARK: - 初始化声明
    lazy var tableView: YXBaseTableView = {
       
        let tableView = YXBaseTableView.init(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        self.view.addSubview(tableView)
        
        tableView.register(YXHomePageListCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(YXHomePageListCell.classForCoder()))
        
        tableView.snp.makeConstraints { make in
            
            make.top.equalTo(self.view)
            make.left.right.bottom.equalTo(self.view)
        }
        
        return tableView
    }()
    
    lazy var dataSourceArr: [String] = {
        
        let dataSourceArr = [""]
        
        return dataSourceArr
    }()
    
    var scrollCallBack: ((UIScrollView) -> ())?
    
    //MARK: - 初始化视图
    func initView() {
        
        self.tableView.reloadData()
    }
    
    //MARK: - 视图加载完毕
    override func viewDidLoad() {
        
        self.initView()
        self.initTableViewRefresh()
    }

}

//MARK: - 刷新
extension YXHomePageListVC {
    
    func initTableViewRefresh() {
        
        self.tableView.initRefresh(boolHeader: false, boolFooter: true)
        self.tableView.yxBaseTableViewBlock = { (boolHeader, boolFooter) in
            
        }
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension YXHomePageListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSourceArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: YXHomePageListCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(YXHomePageListCell.classForCoder()), for: indexPath) as! YXHomePageListCell
        cell.selectionStyle = .none
        
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
    
}

//MARK: - GKPageListViewDelegate, GKPageSmoothListViewDelegate
extension YXHomePageListVC: GKPageListViewDelegate, GKPageSmoothListViewDelegate {
    
    func listView() -> UIView {
        return self.view
    }
    
    func listScrollView() -> UIScrollView {
        return self.tableView
    }
    
    func listViewDidScroll(callBack: @escaping (UIScrollView) -> ()) {
        self.scrollCallBack = callBack
    }
    
}

