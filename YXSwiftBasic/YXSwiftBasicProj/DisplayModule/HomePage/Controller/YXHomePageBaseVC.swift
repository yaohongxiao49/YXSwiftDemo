//
//  YXHomePageBaseVC.swift
//  YXSwiftBasicProj
//
//  Created by Augus on 2022/8/9.
//

import UIKit

class YXHomePageBaseVC: YXBaseVC {

    let segmentHeight: CGFloat! = 40.0
    
    lazy var headerView: UIImageView! = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.yxScreenWidth, height: 100))
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.backgroundColor = .red
        
        return imgView
        
    }()
    
    lazy var pageView: UIView! = {
        let pageView = UIView()
        pageView.addSubview(self.segmentedView)
        pageView.addSubview(self.contentScrollView)
        
        return pageView
        
    }()
    
    lazy var childVCs: [YXHomePageListVC] = {
        var childVCs = [YXHomePageListVC]()
        
        for var title in self.titleDataSource.titles {
            childVCs.append(YXHomePageListVC.init())
        }
        
        return childVCs
        
    }()
    
    var titleDataSource = JXSegmentedTitleDataSource()
    
    public lazy var pageScrollView: GKPageScrollView! = {
        var pageScrollView = GKPageScrollView(delegate: self)
        pageScrollView.ceilPointHeight = self.headerView.height;
        pageScrollView.isAllowListRefresh = false
        self.view.addSubview(pageScrollView)
        
        pageScrollView.snp.makeConstraints { (make) in
            
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view).offset(-self.yxToolHeight)
            make.top.equalTo(self.view).offset(self.yxStatusBarHeight)
        }
        
        pageScrollView.setNeedsLayout()
        pageScrollView.layoutIfNeeded()
        
        return pageScrollView
    }()
    
    public lazy var segmentedView: JXSegmentedView = {
        self.titleDataSource.titles = ["TableView", "CollectionView", "ScrollView", "WebView"]
        self.titleDataSource.titleNormalColor = UIColor.gray
        self.titleDataSource.titleSelectedColor = UIColor.red
        self.titleDataSource.titleNormalFont = UIFont.systemFont(ofSize: 15.0)
        self.titleDataSource.titleSelectedFont = UIFont.systemFont(ofSize: 15.0)
        self.titleDataSource.reloadData(selectedIndex: 0)
        
        var segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: self.yxScreenWidth, height: self.segmentHeight))
        segmentedView.delegate = self
        segmentedView.dataSource = self.titleDataSource
        
        let lineView = JXSegmentedIndicatorLineView()
        lineView.lineStyle = .normal
        lineView.indicatorHeight = 4
        lineView.verticalOffset = 0
        segmentedView.indicators = [lineView]
        
        segmentedView.contentScrollView = self.contentScrollView
        
        let btmLineView = UIView()
        btmLineView.backgroundColor = .green
        segmentedView.addSubview(btmLineView)
        btmLineView.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(segmentedView)
            make.height.equalTo(1)
        })
        
        return segmentedView
    }()
   
    lazy var contentScrollView: UIScrollView = {
        let width = self.yxScreenWidth
        let height = self.pageScrollView.height - self.yxToolHeight - self.segmentHeight
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: self.segmentHeight, width: width, height: height))
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
//        scrollView.gk_openGestureHandle = true
//        scrollView.contentInsetAdjustmentBehavior = .never
        
        for (index, vc) in self.childVCs.enumerated() {
            self.addChild(vc)
            scrollView.addSubview(vc.view)
            
            vc.view.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
        }
        scrollView.contentSize = CGSize(width: CGFloat(self.childVCs.count) * width, height: 0)
        
        return scrollView
    }()
    
    //MARK: - 加载视图
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.segmentedView.reloadData()
        self.pageScrollView.reloadData()
        
        if (YXToolAppBaseMsg.defaults.boolNotFirstUse == true) {
            let view = UIView.init(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
            self.view.addSubview(view);
        }
        self.initRefresh()
    }
}

//MARK: - Method
extension YXHomePageBaseVC {
    //MARK: - 初始刷新
    func initRefresh() {
        weak var weakSelf = self
        self.pageScrollView.mainTableView.mj_header = MJRefreshHeader(refreshingBlock: {
            
            weakSelf?.page = 1
            weakSelf?.getHttpMethod()
        })
        
        self.pageScrollView.mainTableView.mj_header?.beginRefreshing()
    }
    
    //MARK: - 刷新方法
    func getHttpMethod() {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "request_queue")
        queue.async {
            group.enter()
            self.getBannerHTTPMethod { finished in
                group.leave()
            }
        }
        queue.async {
            
        }
        group.notify(queue: queue) {
            
        }
    }
    
    //MARK: - 获取banner
    func getBannerHTTPMethod(block: @escaping (Bool) -> Void) {
        weak var weakSelf = self
        YXNetworkUseManager.yxGetAdvertingHTTPByCode(code: "nft_home_top", showText: nil, boolShowSuccess: false, boolShowError: false) { dic, isSuccess in
            
            if (isSuccess) {
//                //JSONModel
//                let jsonData = JSON.init(dic!)
//                let diyJsonData = JSON.init(jsonData["list"])
//                let bannerModel = YXBannerSwiftyJsonModel(diyJsonData[0])
//                print("bannerModel == \(bannerModel)")
                
                //HandyModel
//                //字典模型
//                if let bannerModel = YXBannerHandyJsonModel.deserialize(from: dic) {
//                    print("bannerModel == \(bannerModel)")
//                }
                //数组模型
                let dataSourceArr = Array<YXBannerHandyJsonModel>.deserialize(from: dic?["list"] as? Array<Any>)
                let bannerModel = (dataSourceArr?[0])! as YXBannerHandyJsonModel;
                print("bannerModel == \(String(describing: bannerModel.advertisementImgUrl))")
                if let url = URL(string: bannerModel.advertisementImgUrl) {
                    weakSelf?.headerView.kf.setImage(with: url)
                }
                
//                let cats = JsonUtil.jsonArrayToModel(dic["list"], YXBannerHandyJsonModel.self) as! [YXBannerHandyJsonModel]
            }
        }
    }
}

//MARK: - JXSegmentedViewDelegate
extension YXHomePageBaseVC: JXSegmentedViewDelegate {
    
}

//MARK: - GKPageScrollViewDelegate
extension YXHomePageBaseVC: GKPageScrollViewDelegate {
    func headerView(in pageScrollView: GKPageScrollView) -> UIView {
        return self.headerView
    }
    
    func pageView(in pageScrollView: GKPageScrollView) -> UIView {
        return self.pageView
    }
    
    func listView(in pageScrollView: GKPageScrollView) -> [GKPageListViewDelegate] {
        return self.childVCs
    }
}

//MARK: - UIScrollViewDelegate
extension YXHomePageBaseVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.pageScrollView.horizonScrollViewWillBeginScroll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageScrollView.horizonScrollViewDidEndedScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.pageScrollView.horizonScrollViewDidEndedScroll()
    }
}

