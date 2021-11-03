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
    var YXTableViewVCStructHXPickerVC = "HX拍照"
    var YXTableViewVCStructHXPickerListVC = "HX相册选择"
    var YXTableViewVCStructDiyPickerListVC = "自定义相册"
    var YXTableViewVCStructLoadImgVC = "加载图片"
    var YXTableViewVCStructLoadVideoVC = "加载视频"
    var YXTableViewVCStructLoadMusicVC = "加载音乐"
    var YXTableViewVCStructLoadVideoPlayerVC = "加载可自定义视图视频"
}

class YXTableViewVC: YXBaseVC {
    
    //MARK: - 初始化声明
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
        let dataSourceArr = [yxTableViewVCStruct.YXTableViewVCStructWKWebView, yxTableViewVCStruct.YXTableViewVCStructSegmentVC, yxTableViewVCStruct.YXTableViewVCStructHXPickerVC, yxTableViewVCStruct.YXTableViewVCStructHXPickerListVC, yxTableViewVCStruct.YXTableViewVCStructDiyPickerListVC, yxTableViewVCStruct.YXTableViewVCStructLoadImgVC, yxTableViewVCStruct.YXTableViewVCStructLoadVideoVC, yxTableViewVCStruct.YXTableViewVCStructLoadMusicVC, yxTableViewVCStruct.YXTableViewVCStructLoadVideoPlayerVC]
        
        return dataSourceArr
    }()
    
    //MARK: - 视图加载完毕
    override func viewDidLoad() {
        
        self.initView()
    }

}

//MARK: - 私有方法
private extension YXTableViewVC {
    
    //MARK: - 点击跳转
    func pushToCollectionView(index: Int) {
        
        switch index {
        case 0:
            self.pushToWKWebView()
        case 1:
            self.pushToSegmentVC()
        case 2:
            self.takingCamera()
        case 3:
            self.takingPhotoAlbum()
        case 4:
            self.pushToDiyPhotoAlbum()
        case 5:
            fallthrough
        case 6:
            fallthrough
        case 7:
            self.loadMediaByIndex(index: index)
        case 8:
            self.pushToVideoPlayerVC()
        default:
            print("跳转")
        }
    }
    
    //MARK: - WKWebView
    func pushToWKWebView() {
        
        let wekWebView = YXWkWebViewVC.init()
        self.pushToSonVC(vc: wekWebView, animated: true)
    }
    
    //MARK: - 分段控制器
    func pushToSegmentVC() {
        
        let segmentVC = YXSegmentVC.init()
        self.pushToSonVC(vc: segmentVC, animated: true)
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
    
    //MARK: - 自定义相册
    func pushToDiyPhotoAlbum() {
        
        let pickerVC = YXPhotoPickerVC.init()
        self.pushToSonVC(vc: pickerVC, animated: true)
    }
    
    //MARK: - 加载媒体
    func loadMediaByIndex(index: Int) {
        
        switch index {
        case 5:
            YXPhotoPickerTool.shareTool.choosePicture(self, editor: false) { (image) in

            }
        case 6:
            YXPhotoPickerTool.playVideoWithPath(video: "http://baobab.wdjcdn.com/14562919706254.mp4", viewController: self)
        case 7:
            YXPhotoPickerTool.playAudioWithPath(sound: "song.mp3")
        default:
            print("more")
        }
    }
    
    //MARK: - 可自定义播放视图视频
    func pushToVideoPlayerVC() {
        
        let vc = YXVideoPlayerVC.init()
        self.pushToSonVC(vc: vc, animated: true)
    }
    
    //MARK: - 初始化视图
    func initView() {
        
        self.tableView.reloadData()
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
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
