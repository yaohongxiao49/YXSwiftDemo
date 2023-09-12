//
//  YXUserCenterVC.swift
//  YXSwiftBasicProj
//
//  Created by Augus on 2022/8/25.
//

import UIKit

enum YXUserCenterVCSecEnum: String {
    case yxMyOrder = "我的订单"
    case yxMyWarehouse = "我的仓库"
    case yxMyAdverting = "广告"
    case yxMyModule = "模块"
}

enum YXUserCenterVCSecOrderEnum: String {
    case yxBePaid = "待付款"
    case yxBeShipped = "待发货"
    case yxBeReceived = "待收货"
    case yxBeEvaluate = "待评价"
    case yxAfterSale = "售后"
}

class YXUserCenterVC: YXBaseVC {
    
    lazy var bgImgV: UIImageView = {
       
        let bgImgV = UIImageView.init()
        bgImgV.contentMode = .scaleAspectFill
        bgImgV.image = UIImage.init(named: "YXUserCenterBaseBgImg")
        self.view.addSubview(bgImgV)
        
        bgImgV.snp.makeConstraints { make in
         
            make.edges.equalToSuperview()
        }
        
        return bgImgV
    }()
    
    lazy var headerView: YXUserCenterBaseHeaderView = {
        
        let headerView = YXUserCenterBaseHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: self.yxScreenWidth, height: 124 + self.yxNavigationHeight))
        
        return headerView
    }()
    
    lazy var tableView: YXBaseTableView = {
        
        let tableView = YXBaseTableView.init(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableHeaderView = self.headerView
        self.view.addSubview(tableView)
        
        tableView.register(YXUserCenterOrderCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(YXUserCenterOrderCell.classForCoder()))
        
        tableView.snp.makeConstraints { make in
            
            make.top.equalTo(self.view)
            make.left.right.bottom.equalTo(self.view)
        }
        
        return tableView
    }()
    
    lazy var secArr: [Dictionary<String, Any>] = {

        var secArr = [Dictionary<String, Any>]()
        var dic = Dictionary<String, Any>()
        
        dic = ["title":"我的订单", "tag":YXUserCenterVCSecEnum.yxMyOrder, "valueArr":self.orderArr]
        secArr.append(dic)
        
        dic = ["title":"我的仓库", "tag":YXUserCenterVCSecEnum.yxMyWarehouse, "valueArr":[Dictionary<String, Any>]()]
        secArr.append(dic)
        
        dic = ["title":"广告", "tag":YXUserCenterVCSecEnum.yxMyAdverting, "valueArr":[Dictionary<String, Any>]()]
        secArr.append(dic)
        
        dic = ["title":"模块", "tag":YXUserCenterVCSecEnum.yxMyModule, "valueArr":[Dictionary<String, Any>]()]
        secArr.append(dic)
        
        return secArr
    }()
    
    lazy var orderArr: [Dictionary<String, Any>] = {
        
        var orderArr = [Dictionary<String, Any>]()
        var dic = Dictionary<String, Any>()
        
        dic = ["title":"待付款", "tag":YXUserCenterVCSecOrderEnum.yxBePaid, "count":0, "icon":"YXUserCenterAllOrderImg"]
        orderArr.append(dic)
        
        dic = ["title":"待发货", "tag":YXUserCenterVCSecOrderEnum.yxBeShipped, "count":0, "icon":"YXUserCenterBeSend"]
        orderArr.append(dic)
        
        dic = ["title":"待收货", "tag":YXUserCenterVCSecOrderEnum.yxBeReceived, "count":0, "icon":"YXUserCenterBeReceivedImg"]
        orderArr.append(dic)
        
        dic = ["title":"待评价", "tag":YXUserCenterVCSecOrderEnum.yxBeEvaluate, "count":0, "icon":"YXUserCenterEvaluateImg"]
        orderArr.append(dic)
        
        dic = ["title":"售后", "tag":YXUserCenterVCSecOrderEnum.yxAfterSale, "count":0, "icon":"YXUserCenterEvaluateImg"]
        orderArr.append(dic)
        
        return orderArr
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.reloadData()
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension YXUserCenterVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.secArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var type: YXUserCenterVCSecEnum!
        type = (self.secArr[indexPath.section]["tag"] as! YXUserCenterVCSecEnum)
        let cell: YXUserCenterOrderCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(YXUserCenterOrderCell.classForCoder()), for: indexPath) as! YXUserCenterOrderCell
        switch type {
        case .yxMyOrder:
            print("\(String(describing: type))")
        default:
            print("")
        }
        
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
