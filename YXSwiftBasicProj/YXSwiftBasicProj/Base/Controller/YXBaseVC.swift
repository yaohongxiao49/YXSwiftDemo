//
//  YXBaseVC.swift
//  YXSwiftBasicProj
//
//  Created by ios on 2021/5/10.
//

import UIKit

/** 相册选择闭包 */
typealias YXBaseVCPickerFinishedBlock = (_ pickerController: PhotoPickerController, _ result: PickerResult) ->(Void)

public class YXBaseVC: UIViewController {
    
    //MARK:- 初始化声明
    /** 相册选择闭包 */
    var yxBaseVCPickerFinishedBlock: YXBaseVCPickerFinishedBlock?
    
    /** 导航栏 */
    lazy var navigationView : YXBaseNavigationView = {
        
        let navigationView = YXBaseNavigationView.init()
        navigationView.baseVC = self
        self.view.addSubview(navigationView)
        
        weak var weakSelf = self
        navigationView.yxBaseNavigationViewBackBlock = {() ->() in
            
            weakSelf?.navigationController?.popViewController(animated: true)
        }
        navigationView.snp.makeConstraints { make in
            
            make.left.top.right.equalToSuperview()
            make.height.equalTo(self.yxNavigationHeight)
        }
        
        return navigationView
    }()

    //MARK:- 视图将要显示
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
    }
    
}

//MARK:- 开放公共方法
public extension YXBaseVC {
    
    //MARK:- 推送至子控制器
    func pushToSonVC(vc: YXBaseVC, animated: Bool) {
        
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    //MARK:- 弹出子视图
    func presentToSonVC(vc: YXBaseVC, animated: Bool) {
    
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: animated, completion: nil)
    }
    
    //MARK:- 弹出相册选择
    func presentPickerController() {
        
        //设置与微信主题一致的配置
        let config = PhotoTools.getWXPickerConfig()
        let pickerController = PhotoPickerController.init(picker: config)
        pickerController.pickerDelegate = self
        //当前被选择的资源对应的 PhotoAsset 对象数组
//        pickerController.selectedAssetArray = selectedAssets
        //是否选中原图
        pickerController.isOriginal = false
        pickerController.modalPresentationStyle = .fullScreen
        self.present(pickerController, animated: true, completion: nil)
    }
}


//MARK:- PhotoPickerControllerDelegate
extension YXBaseVC: PhotoPickerControllerDelegate {
    
    //MARK:- 选择完成之后调用
    /**
     *
     * pickerController: 对应的 PhotoPickerController
     * result: 选择的结果
     * result.photoAssets  选择的资源数组
     * result.isOriginal   是否选中原图
     */
    public func pickerController(_ pickerController: PhotoPickerController, didFinishSelection result: PickerResult) {
        
        self.yxBaseVCPickerFinishedBlock?(pickerController, result)
    }
    
    //MARK:- 点击取消时调用
    public func pickerController(didCancel pickerController: PhotoPickerController) {
        
    }
}
