//
//  YXTableViewVC.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/1.
//

import UIKit

struct YXTableViewVCStruct {
    var YXTableViewVCStructFirst = "WkWebView"
    var YXTableViewVCStructSecond = "SegmentVC"
}

class YXTableViewVC: YXBaseVC {
    
    //MARK:- 初始化声明
    lazy var tableView: YXBaseTableView = {
       
        let tableView = YXBaseTableView.init(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        self.view.addSubview(tableView)
        
        tableView.register(YXTableViewVCCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(YXTableViewVCCell.classForCoder()))
        
        tableView.snp.makeConstraints { make in
            
            make.top.equalTo(self.navigationView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        
        return tableView
    }()
    
    lazy var dataSourceArr: [String] = {
        
        var yxTableViewVCStruct = YXTableViewVCStruct()
        let dataSourceArr = [yxTableViewVCStruct.YXTableViewVCStructFirst, yxTableViewVCStruct.YXTableViewVCStructSecond]
        
        return dataSourceArr
    }()
    
    //MARK:- 点击跳转
    func pushToCollectionView(index: Int) {
        
        switch index {
        case 0:
            let wekWebView = YXWkWebViewVC.init()
            self.pushToSonVC(vc: wekWebView, animated: true)
        case 1:
            let segmentVC = YXSegmentVC.init()
            self.pushToSonVC(vc: segmentVC, animated: true)
        default:
            print("跳转")
        }
    }
    
    //MARK:- 初始化视图
    func initView() {
        
        self.tableView.reloadData()
    }
    
    //MARK:- 视图加载完毕
    override func viewDidLoad() {
        
        self.initView()
    }

}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension YXTableViewVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSourceArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: YXTableViewVCCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(YXTableViewVCCell.classForCoder()), for: indexPath) as! YXTableViewVCCell
        cell.selectionStyle = .none
        cell.titleLab.text = self.dataSourceArr[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.pushToCollectionView(index: indexPath.row)
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
