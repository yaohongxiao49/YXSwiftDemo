//
//  YXCollectionViewVC.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/1.
//

import UIKit

struct YXCollectionViewVCStruct {
    var YXCollectionViewVCStructFirst = "1"
    var YXCollectionViewVCStructSecond = "2"
    var YXCollectionViewVCStructThird = "3"
    var YXCollectionViewVCStructFour = "4"
    var YXCollectionViewVCStructFive = "5"
    var YXCollectionViewVCStructSix = "6"
    var YXCollectionViewVCStructSeven = "7"
    var YXCollectionViewVCStructEight = "8"
}

class YXCollectionViewVC: YXBaseVC {

    //MARK:- 初始化声明
    lazy var collectionView: YXBaseCollectionViewHorizontal = {
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        
        let collectionView = YXBaseCollectionViewHorizontal.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        collectionView.register(YXCollectionViewVCCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(YXCollectionViewVCCell.classForCoder()))
        
        collectionView.snp.makeConstraints { make in
            
            make.top.equalTo(self.navigationView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(100)
        }
        
        return collectionView
    }()
    
    lazy var dataSourceArr: [String] = {
        
        var yxCollectionViewVCStruct = YXCollectionViewVCStruct()
        let dataSourceArr = [yxCollectionViewVCStruct.YXCollectionViewVCStructFirst, yxCollectionViewVCStruct.YXCollectionViewVCStructSecond, yxCollectionViewVCStruct.YXCollectionViewVCStructThird]
        
        return dataSourceArr
    }()
    
    //MARK:- 初始化视图
    func initView() {
        
        self.collectionView.reloadData()
    }
    
    //MARK:- 视图加载完毕
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }

}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension YXCollectionViewVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataSourceArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : YXCollectionViewVCCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(YXCollectionViewVCCell.classForCoder()), for: indexPath) as! YXCollectionViewVCCell
        cell.titleLab.text = self.dataSourceArr[indexPath.row]
        cell.backgroundColor = UIColor.red
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.classForCoder()), for: indexPath)
            
            return headerReusableView
        }
        else {
            let footerReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.classForCoder()), for: indexPath)
            
            return footerReusableView
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let waterVC = YXCollectionVCWater.init()
        switch indexPath.row {
        case YXBaseCollectionViewEnum.YXBaseCollectionViewEnumWater.rawValue:
            waterVC.showType = .YXBaseCollectionViewEnumWater
        case YXBaseCollectionViewEnum.YXBaseCollectionViewEnumLine.rawValue:
            waterVC.showType = .YXBaseCollectionViewEnumLine
        default:
            waterVC.showType = .YXBaseCollectionViewEnumBox
        }
        
        self.pushToSonVC(vc: waterVC, animated: true)  
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension YXCollectionViewVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
}
