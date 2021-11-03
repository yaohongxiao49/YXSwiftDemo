//
//  YXCollectionVCWater.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/1.
//

import UIKit

class YXCollectionVCWater: YXBaseVC {

    /** 显示类型 */
    var showType: YXBaseCollectionViewEnum = .YXBaseCollectionViewEnumWater {
        
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - 初始化声明
    lazy var collectionView: YXBaseCollectionView = {
       
        let layout = YXBaseCollectionViewFlowLayout()
        layout.delegate = self
        
        let collectionView = YXBaseCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        collectionView.register(YXCollectionViewVCCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(YXCollectionViewVCCell.classForCoder()))
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.classForCoder()))
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.classForCoder()))
        
        collectionView.snp.makeConstraints { make in
            
            make.top.equalTo(self.navigationView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationView.backBtn.isHidden = false
    }

}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension YXCollectionVCWater: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : YXCollectionViewVCCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(YXCollectionViewVCCell.classForCoder()), for: indexPath) as! YXCollectionViewVCCell
        cell.backgroundColor = UIColor.red
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
    
}

//MARK: - YXBaseCollectionViewDelegate
extension YXCollectionVCWater: YXBaseCollectionViewDelegate {
    
    func heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: YXBaseCollectionViewFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        
        switch self.showType {
        case YXBaseCollectionViewEnum.YXBaseCollectionViewEnumWater:
            return CGFloat((arc4random() % 3 + 1) * 30)
        case YXBaseCollectionViewEnum.YXBaseCollectionViewEnumLine:
            return 135
        default:
            return 80
        }
    }
    func columnNumber(collectionView collection: UICollectionView, layout: YXBaseCollectionViewFlowLayout, section: Int) -> Int {
        
        switch self.showType {
        case YXBaseCollectionViewEnum.YXBaseCollectionViewEnumWater:
            return 2
        case YXBaseCollectionViewEnum.YXBaseCollectionViewEnumLine:
            return 1
        default:
            return 3
        }
    }
    func referenceSizeForHeader(collectionView collection: UICollectionView, layout: YXBaseCollectionViewFlowLayout, section: Int) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: 40)
    }
    func referenceSizeForFooter(collectionView collection: UICollectionView, layout: YXBaseCollectionViewFlowLayout, section: Int) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width, height: 30)
    }
    func insetForSection(collectionView collection: UICollectionView, layout: YXBaseCollectionViewFlowLayout, section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func lineSpacing(collectionView collection: UICollectionView, layout: YXBaseCollectionViewFlowLayout, section: Int) -> CGFloat {
        
        return 5
    }
    func interitemSpacing(collectionView collection: UICollectionView, layout: YXBaseCollectionViewFlowLayout, section: Int) -> CGFloat {
        
        return 5
    }
    func spacingWithLastSection(collectionView collection: UICollectionView, layout: YXBaseCollectionViewFlowLayout, section: Int) -> CGFloat {
        
        return 15
    }
    
}
