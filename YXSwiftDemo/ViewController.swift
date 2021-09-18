//
//  ViewController.swift
//  YXSwiftDemo
//
//  Created by ios on 2021/9/1.
//

import UIKit

class ViewController: YXBaseVC, UITableViewDelegate, UITableViewDataSource {
    
    lazy var dataSourceArr: [String] = {
        let dataSourceArr = ["基础部分", "基础运算符", "字符串与字符", "集合类型", "控制流", "函数", "闭包", "枚举", "结构体"]
        return dataSourceArr
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: UITableView.Style.plain)
        tableView.estimatedRowHeight = 100.0;
        tableView.estimatedSectionHeaderHeight = 0.0
        tableView.estimatedSectionFooterHeight = 0.0
        tableView.separatorStyle = .none
        tableView.delegate = self;
        tableView.dataSource = self;
        self.view.addSubview(tableView)
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        return tableView
    }()
    
    //MARK:- 跳转
    func pushToDetail(indexPath: IndexPath) {
        switch Int(indexPath.row) {
        case 0:
            let vc = BasicDataFirst.init()
            self.pushToSonVC(vc: vc, animated: true)
            break
        case 1:
            let vc = BasicDataSecond.init()
            self.pushToSonVC(vc: vc, animated: true)
            break
        case 2:
            let vc = BasicDataThird.init()
            self.pushToSonVC(vc: vc, animated: true)
            break
        case 3:
            let vc = BasicDataFour.init()
            self.pushToSonVC(vc: vc, animated: true)
        case 4:
            let vc = BasicDataFive.init()
            self.pushToSonVC(vc: vc, animated: true)
        case 5:
            let vc = BasicDataSix.init()
            self.pushToSonVC(vc: vc, animated: true)
        case 6:
            let vc = BasicDataSeven.init()
            self.pushToSonVC(vc: vc, animated: true)
        case 7:
            let vc = BasicDataEight.init()
            self.pushToSonVC(vc: vc, animated: true)
        case 8:
            let vc = BasicDataRight.init()
            self.pushToSonVC(vc: vc, animated: true)
        default:
            break
        }
    }
    
    //MARK:- UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.classForCoder()), for: indexPath)
        cell.textLabel?.text = self.dataSourceArr[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushToDetail(indexPath: indexPath)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.initView()
    }

    //MARK:- 初始化视图
    func initView() {
//        if #available(iOS 11.0, *) {
//            self.tableView.contentInsetAdjustmentBehavior = .never
//        }
        self.tableView.reloadData()
    }

}

