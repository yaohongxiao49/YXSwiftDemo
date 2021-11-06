//
//  YXBaseTableView.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/1.
//

import UIKit

typealias YXBaseTableViewBlock = (_ boolHeader: Bool, _ boolFooter: Bool) ->(Void)

class YXBaseTableView: UITableView {
    
    /** 顶部刷新 */
    let headerRefresh = MJRefreshNormalHeader()
    /**底部刷新 */
    let footerRefresh = MJRefreshAutoNormalFooter()
    var yxBaseTableViewBlock: YXBaseTableViewBlock?
    
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

//MARK: - 刷新
extension YXBaseTableView {
    
    /** 初始化刷新 */
    func initRefresh(boolHeader: Bool, boolFooter: Bool) {
        
        //下拉刷新
        self.headerRefresh.setRefreshingTarget(self, refreshingAction: #selector(headerRefreshMethod))
        if boolHeader { self.mj_header = self.headerRefresh }
        
        // 上拉刷新
        self.footerRefresh.setRefreshingTarget(self, refreshingAction: #selector(footerRefreshMethod))
        if boolFooter { self.mj_footer = self.footerRefresh }
    }
    
    /** 下拉刷新 */
    @objc func headerRefreshMethod() {
        
        guard let block = self.yxBaseTableViewBlock else { return }
        block(true, false)
    }
    
    /** 上拉加载 */
    @objc func footerRefreshMethod() {
        
        guard let block = self.yxBaseTableViewBlock else { return }
        block(false, true)
    }
    
    /** 结束刷新/加载 */
    func endRefresh(boolHeader: Bool, boolFooter: Bool) {
        
        if boolHeader { self.mj_header?.endRefreshing() }
        if boolFooter { self.mj_footer?.endRefreshing() }
    }
    
    /** 没有更多数据显示 */
    func noMoreData() {
        
        self.mj_footer?.endRefreshingWithNoMoreData()
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
