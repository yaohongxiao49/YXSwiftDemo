//
//  YXSegmentVC.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/2.
//

import UIKit

class YXSegmentVC: YXBaseVC {
    
    //初始化声明
    lazy var segmentView: YXSegmentTitleView! = {
        
        let config = YXSegmentTitleView.Configuration()
        config.positionStyle = .bottom
        config.indicatorStyle = .dynamic
        config.indicatorFixedWidth = 30.0
        config.indicatorFixedHeight = 2.0
        config.indicatorAdditionWidthMargin = 5.0
        config.indicatorAdditionHeightMargin = 2.0
        config.isShowSeparator = false
        
        let segmentView: YXSegmentTitleView = YXSegmentTitleView.init(frame: CGRect(x: 0, y: self.yxNavigationHeight, width: self.yxScreenWidth, height: 40), config: config, titles: self.itemArr)
        segmentView.delegate = self
        segmentView.backgroundColor = UIColor.white
        self.view.addSubview(segmentView)
        
        segmentView.snp.makeConstraints { make in
            
            make.top.equalTo(self.navigationView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        return segmentView
    }()
    lazy var pageView: YXSegmentPageView! = {
        
        let pageView: YXSegmentPageView = YXSegmentPageView.init(parent: self, children: self.childVCArr)
        pageView.delegate = self
        self.view.addSubview(pageView)
        
        pageView.snp.makeConstraints { make in
            
            make.top.equalTo(self.segmentView.snp.bottom)
            make.left.right.equalTo(self.segmentView)
            make.bottom.equalToSuperview()
        }
        
        return pageView
    }()
    
    private lazy var itemArr: [String] = {
        
        return ["要闻", "推荐", "抗肺炎", "视频", "新时代",
                "娱乐", "体育", "军事", "小视频", "微天下"]
    }()
    
    private lazy var childVCArr: [YXBaseVC] = {
        
        var children: [YXBaseVC] = []
        for (index, title) in self.itemArr.enumerated() {
            
            let vc: YXCollectionVCWater = YXCollectionVCWater.init()
            children.append(vc)
        }
        return children
    }()

    //视图已经加载完毕
    override func viewDidLoad() {
        
        self.segmentView.isHidden = false
        self.pageView.isHidden = false
    }
    
}

//MARK:- YXSegmentPageViewDelegate
extension YXSegmentVC: YXSegmentPageViewDelegate {
    
    func segmentPageView(_ segmentPageView: YXSegmentPageView, at index: Int) {
        
        NSLog("index = %d", index)
    }
    
    func segmentPageView(_ page: YXSegmentPageView, progress: CGFloat) {
        
        NSLog("select = %d, will = %d, progress = %f", page.selectedIndex, page.willSelectedIndex, progress)
        self.segmentView.setSegmentTitleView(selectIndex: page.selectedIndex, willSelectIndex: page.willSelectedIndex, progress: progress)
    }
    
}

//MARK:- YXSegmentTitleViewDelegate
extension YXSegmentVC: YXSegmentTitleViewDelegate {
    
    func segmentTitleView(_ page: YXSegmentTitleView, at index: Int) {
        
        self.pageView.scrollToItem(to: index, animated: true)
    }
    
}
