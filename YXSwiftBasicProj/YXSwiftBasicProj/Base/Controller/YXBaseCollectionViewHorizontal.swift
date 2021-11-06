//
//  YXBaseCollectionViewHorizontal.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/1.
//

import UIKit

typealias YXBaseCollectionViewHorizontalBlock = (_ boolHeader: Bool, _ boolFooter: Bool) ->(Void)

class YXBaseCollectionViewHorizontal: UICollectionView {
    
    /** 顶部刷新 */
    let headerRefresh = MJRefreshNormalHeader()
    /**底部刷新 */
    let footerRefresh = MJRefreshAutoNormalFooter()
    var yxBaseCollectionViewHorizontalBlock: YXBaseCollectionViewHorizontalBlock?
    
    //MARK: - 初始化视图
    func initView() {
        
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
        
        self.initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 刷新
extension YXBaseCollectionViewHorizontal {
    
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
        
        guard let block = self.yxBaseCollectionViewHorizontalBlock else { return }
        block(true, false)
    }
    
    /** 上拉加载 */
    @objc func footerRefreshMethod() {
        
        guard let block = self.yxBaseCollectionViewHorizontalBlock else { return }
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

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension YXBaseCollectionViewHorizontal: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(UICollectionViewCell.classForCoder()), for: indexPath)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
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

//MARK: - UICollectionViewDelegateFlowLayout
extension YXBaseCollectionViewHorizontal: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
}
