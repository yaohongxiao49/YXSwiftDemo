//
//  YXBaseCollectionView.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/1.
//

import UIKit

/** collectionView模式枚举 */
public enum YXBaseCollectionViewEnum: Int {
    /** 瀑布流 */
    case YXBaseCollectionViewEnumWater = 0
    /** 线性 */
    case YXBaseCollectionViewEnumLine = 1
    /** 九宫格 */
    case YXBaseCollectionViewEnumBox = 2
}

class YXBaseCollectionView: UICollectionView {
    
    var baseLayout: UICollectionViewLayout?
    let moduleArr: [YXBaseCollectionViewEnum] = [.YXBaseCollectionViewEnumWater, .YXBaseCollectionViewEnumLine, .YXBaseCollectionViewEnumBox]
    
    //MARK: - 初始化视图
    func initView() {
        
        let layout = YXBaseCollectionViewFlowLayout()
        layout.delegate = self
        
        if let layouts = self.baseLayout {
            self.collectionViewLayout = layouts
        }
        else {
            self.collectionViewLayout = layout
        }
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = UIColor.white
        self.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.classForCoder()))
        self.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.classForCoder()))
        self.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.classForCoder()))
        
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    //MARK: - 初始化
    required override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.baseLayout = layout
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension YXBaseCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return self.moduleArr.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.classForCoder()), for: indexPath)
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
extension YXBaseCollectionView: YXBaseCollectionViewDelegate {
    
    func heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: YXBaseCollectionViewFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        
        switch indexPath.row {
        case YXBaseCollectionViewEnum.YXBaseCollectionViewEnumWater.rawValue:
            return CGFloat((arc4random() % 3 + 1) * 30)
        case YXBaseCollectionViewEnum.YXBaseCollectionViewEnumLine.rawValue:
            return 135
        default:
            return 80
        }
    }
    func columnNumber(collectionView collection: UICollectionView, layout: YXBaseCollectionViewFlowLayout, section: Int) -> Int {
        
        switch section {
        case YXBaseCollectionViewEnum.YXBaseCollectionViewEnumWater.rawValue:
            return 2
        case YXBaseCollectionViewEnum.YXBaseCollectionViewEnumLine.rawValue:
            return 1
        default:
            return 3
        }
    }
    func referenceSizeForHeader(collectionView collection: UICollectionView, layout: YXBaseCollectionViewFlowLayout, section: Int) -> CGSize {
        
        return CGSize(width: self.frame.size.width, height: 40)
    }
    func referenceSizeForFooter(collectionView collection: UICollectionView, layout: YXBaseCollectionViewFlowLayout, section: Int) -> CGSize {
        
        return CGSize(width: self.frame.size.width, height: 30)
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
