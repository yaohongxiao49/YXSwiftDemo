//
//  YXTableViewVC.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/1.
//

import UIKit

struct YXTableViewVCStruct {
    var YXTableViewVCStructWKWebView = "WkWebView"
    var YXTableViewVCStructSegmentVC = "SegmentVC"
    var YXTableViewVCStructPickerVC = "拍照"
    var YXTableViewVCStructPickerListVC = "相册选择"
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
        let dataSourceArr = [yxTableViewVCStruct.YXTableViewVCStructWKWebView, yxTableViewVCStruct.YXTableViewVCStructSegmentVC, yxTableViewVCStruct.YXTableViewVCStructPickerVC, yxTableViewVCStruct.YXTableViewVCStructPickerListVC]
        
        return dataSourceArr
    }()
    
    //MARK:- 视图加载完毕
    override func viewDidLoad() {
        
        self.initView()
    }

}

//MARK:- 私有方法
private extension YXTableViewVC {
    
    //MARK:- 点击跳转
    func pushToCollectionView(index: Int) {
        
        switch index {
        case 0:
            let wekWebView = YXWkWebViewVC.init()
            self.pushToSonVC(vc: wekWebView, animated: true)
        case 1:
            let segmentVC = YXSegmentVC.init()
            self.pushToSonVC(vc: segmentVC, animated: true)
        case 2:
            self.takingCamera()
        case 3:
            self.takingPhotoAlbum()
        default:
            print("跳转")
        }
    }
    
    //MAKR:- 相机
    func takingCamera() {
        
        let config = CameraConfiguration()
        CameraController.capture(
            config: config, // 相机配置
            type: .all // 相机类型
        ) { result, location in
            // result: 拍摄的结果
            // location: 如果允许定位的情况则会有当前定位信息
            switch result {
            case .image(let image):
                // image: 拍摄的图片
                break
            case .video(let videoURL):
                // videoURL: 录制的视频地址
                
                break
            }
        }
    }
    
    //MAKR:- 相册
    func takingPhotoAlbum() {
        
        self.presentPickerController()
        self.yxBaseVCPickerFinishedBlock = {(pickerController, result) ->() in
            
            result.getImage { (image, photoAsset, index) in
                
                if let image = image {
                    print("success", image)
                }
                else {
                    print("failed")
                }
            } completionHandler: { (images) in
                
                print(images)
            }
        }
    }
    
    //MARK:- 初始化视图
    func initView() {
        
        self.tableView.reloadData()
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
