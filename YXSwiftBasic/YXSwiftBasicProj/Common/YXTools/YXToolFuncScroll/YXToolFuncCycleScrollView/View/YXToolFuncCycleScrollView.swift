//
//  YXToolFuncCycleScrollView.swift
//  YXSwiftBasicProj
//
//  Created by ios on 2021/5/13.
//

import UIKit

/** 滚动显示类型 */
enum YXToolFuncCycleScrollType {
    /** 铺满 */
    case YXToolFuncCycleScrollTypeFull
    /** 有间距 */
    case YXToolFuncCycleScrollTypeEdge
    /** 普通-卡片式 */
    case YXToolFuncCycleScrollTypeCard
    /** 3D-卡片式 */
    case YXToolFuncCycleScrollType3DCard
}

/** 滚动方向 */
enum YXToolFuncCycleScrollDirectionType {
    /** 水平方向 */
    case YXToolFuncCycleScrollDirectionTypeHorizontal
    /** 垂直方向 */
    case YXToolFuncCycleScrollDirectionTypeVertical
}

/** 点击事件回调 */
typealias YXToolFuncCycleScrollBlock = (YXToolFuncCycleScrollInfoModel) ->(Void)
/** 滚动事件回调 */
typealias YXToolFuncCycleScrollMoveBloc = (NSInteger) ->(Void)

class YXToolFuncCycleScrollView: UIView, UIScrollViewDelegate {
    
    //MARK: - 开放属性
    /**
     * 显示边距（充满/卡片式效果时设置，优先设置）
     * 如显示为充满效果（宽度：视图宽度 - left - bottom，高度：视图高度 - top - bottom）
     * 如显示为卡片式效果（水平滚动时，宽度：视图宽度 - left，高度：视图高度，间距：right）
     * 如显示为卡片式效果（垂直滚动时，宽度：视图宽度，高度：视图高度 - top，间距：bottom）
     */
    var edgeInsets: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0) {
        
        didSet {
            if self.showType == .YXToolFuncCycleScrollTypeFull {
                self.edgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }
            changeImgVShowFrame()
        }
    }
    /** 图片信息数组 */
    var imgValueArr: NSMutableArray? {
        
        didSet {
            if imgValueArr!.count == 0 {
                closeTimer()
                self.pageBackView.isHidden = true
                self.boolOpenTimer = false
                return
            }
            else if imgValueArr!.count == 1 {
                self.pageBackView.isHidden = !self.boolPageController
                self.scrollView.isScrollEnabled = false
                closeTimer()
                self.boolOpenTimer = false
            }
            else {
                self.pageBackView.isHidden = !self.boolPageController
                self.scrollView.isScrollEnabled = true
                updateFirstValueByBoolFirst(boolFirst: true)
                self.boolOpenTimer = true
            }
            
            self.pageControl.numberOfPages = imgValueArr!.count
            setImageFromImageNames()
        }
    }
    /** 圆角，如果boolCycle为false，则需要在imgValueArr赋值后设置；如果boolCycle为true，则需要在imgValueArr赋值前设置 */
    var cornerRadius: CGFloat = 0.0 {
        
        didSet {
            changeImgVShowCornerRadius()
        }
    }

    //MARK: - 定时器
    /** 是否含有定时器（设置完成后，需要再设置timeInterval） */
    var boolContainTimer: Bool = false
    /** 时间间隔（需要先设置boolContainTimer） */
    var timeInterval: CGFloat = 1.0 {
        
        didSet {
            if self.boolContainTimer && boolCycle {
                timer = Timer.scheduledTimer(timeInterval: Double(timeInterval), target: self, selector: #selector(processTimer), userInfo: nil, repeats: true)
                self.boolOpenTimer = true;
            }
        }
    }

    //MARK: - 分页控制器
    /** 分页控制器坐标 */
    var pageframe: CGRect? {
        
        didSet {
            self.pageBackView.frame = pageframe!
        }
    }
    /** 分页控制器当前页码（需要在设置了imgValueArr后，设置才可使用，起始值为0） */
    var currentPage: NSInteger = 0 {
        
        didSet {
            if !self.boolCycle {
                self.scrollView.setContentOffset(CGPoint.init(x: self.rollingDistance * CGFloat(currentPage), y: 0.0), animated: false)
                return
            }
            
            let judgeCount: NSInteger = self.showType == .YXToolFuncCycleScrollTypeCard ? 3 : self.showType == .YXToolFuncCycleScrollType3DCard ? 3 : 2
            let judgeShowCount: NSInteger = self.showType == .YXToolFuncCycleScrollTypeCard ? 2 : self.showType == .YXToolFuncCycleScrollType3DCard ? 2 : 1
            
            for i in 0 ..< currentPage {
                if self.boolHorizontal {
                    if i <= self.pageControl.currentPage {
                        self.scrollView.setContentOffset(CGPoint.init(x: self.rollingDistance * CGFloat(judgeCount), y: 0.0), animated: false)
                    }
                    else {
                        self.scrollView.setContentOffset(CGPoint.init(x: self.rollingDistance * CGFloat(judgeShowCount), y: 0.0), animated: false)
                    }
                }
                else {
                    if i <= self.pageControl.currentPage {
                        self.scrollView.setContentOffset(CGPoint.init(x: 0.0, y: self.rollingDistance * CGFloat(judgeCount)), animated: false)
                    }
                    else {
                        self.scrollView.setContentOffset(CGPoint.init(x: 0.0, y: self.rollingDistance * CGFloat(judgeShowCount)), animated: false)
                    }
                }
            }
        }
    }
    /** 是否开启分页控制（默认关闭，此功能暂时不能使用） */
    var boolOpenPageControl: Bool = false {
        
        didSet {
            self.pageControl.isUserInteractionEnabled = boolOpenPageControl
        }
    }
    /** 分页视图背景颜色 */
    var pageBgColor: UIColor? {
        
        didSet {
            self.pageBackView.backgroundColor = pageBgColor!
        }
    }
    /** 分页视图背景透明度 */
    var pageBgAlpha: CGFloat = 0.0 {
        
        didSet {
            self.pageBackView.backgroundColor = pageBgColor?.withAlphaComponent(pageBgAlpha)
        }
    }
    /** 普通分页颜色 */
    var norPageColor: UIColor? {
        
        didSet {
            self.pageControl.pageIndicatorTintColor = norPageColor!
        }
    }
    /** 选中分页颜色 */
    var selPageColor: UIColor? {
        
        didSet {
            self.pageControl.currentPageIndicatorTintColor = selPageColor!
        }
    }
    /** 普通分页图片 */
    var norPageImg: UIImage? {
        
        didSet {
            self.pageControl.norImg = norPageImg!
        }
    }
    /** 选中分页图片 */
    var selPageImg: UIImage? {
        
        didSet {
            self.pageControl.selImg = selPageImg!
        }
    }
    
    //MARK: - 回调
    var yxToolFuncCycleScrollBlock: YXToolFuncCycleScrollBlock?
    var yxToolFuncCycleScrollMoveBlock: YXToolFuncCycleScrollMoveBloc?
    
    //MARK: - 私有属性
    /** 显示类型 */
    private var showType: YXToolFuncCycleScrollType!
    private var boolHorizontal: Bool = false //滚动方向是否为水平滚动
    private var scrollView: UIScrollView! //滚动视图
    private var imgViewsArr: NSMutableArray = NSMutableArray.init() //图片视图数组
    private var timer: Timer? //时间控制器
    private var pageBackView: UIView! //分页背景视图
    private var pageControl: YXToolPageControl! //分页控制器
    private var pageBtn: UIButton! //分页计算按钮
    private var boolOpenTimer: Bool = false //是否开启定时器
    private var imgVSize: CGFloat = 0.0 //卡片式图片尺寸
    private var rollingDistance: CGFloat = 0.0 //滚动距离
    private var boolCycle: Bool = false //是否循环滚动
    private var boolDynamic: Bool = false  //3D卡片式效果时，是否需要实时动态滚动动画
    private var zoomRadio: CGFloat = 1.2 //3D卡片效果放大倍数
    private var boolPageController: Bool = false //是否显示页码控制器
    private var boolPageBtn: Bool = false //是否显示页码下标
    private var alreadCurrent: NSInteger = 0 //上一次的下标
    private var offsetOrigin: CGFloat = 0.0 //滚动距离记录
    
    //MARK: - 初始化视图
    /**
     - Parameters: 初始化视图
     - frame: 尺寸
     - showType: 显示类型
     - directionType: 滚动类型
     - boolCycle: 是否循环滚动，只有为true时，才能开启定时器
     - boolDynamic: 3D卡片式效果时，是否需要实时动态滚动动画
     - zoomRadio: 3D卡片效果放大倍数
     - boolPageController: 是否显示页码控制器
     - boolPageBtn: 是否显示页码下标
     */
    init(frame: CGRect, showType: YXToolFuncCycleScrollType, directionType: YXToolFuncCycleScrollDirectionType, boolCycle: Bool, boolDynamic: Bool, zoomRadio: CGFloat, boolPageController: Bool, boolPageBtn: Bool) {
        super.init(frame: frame)
        
        self.showType = showType
        self.boolHorizontal = directionType == .YXToolFuncCycleScrollDirectionTypeHorizontal ? true : false
        self.boolCycle = boolCycle
        self.boolDynamic = boolDynamic
        self.zoomRadio = zoomRadio
        self.boolPageController = boolPageController
        self.boolPageBtn = boolPageBtn
        
        if self.boolCycle {
            initViewByCycle()
        }
        else {
            initViewByNotCycle()
        }
        self.rollingDistance = self.boolHorizontal ? self.scrollView.bounds.size.width : self.scrollView.bounds.size.height
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 设置图片
    func setImageFromImageNames() {
        
        var i: NSInteger = 0
        var j: NSInteger = 0
        
        if !self.boolCycle {
            initImgVByCount(count: self.imgValueArr!.count)
            
            for imageView : UIImageView in self.imgViewsArr as! [UIImageView] {
                let infoModel: YXToolFuncCycleScrollInfoModel = self.imgValueArr![i] as! YXToolFuncCycleScrollInfoModel
                imageView.image = UIImage.init(named: infoModel.imgUrl as String)
                imageView.tag = i
                imageView.transform = .identity
                i += 1
            }
            changeImgVShowFrame()
            useZoomAnimationByCurrent(current: self.pageControl.currentPage)
        }
        else {
            let judgeCount: NSInteger = self.showType == .YXToolFuncCycleScrollTypeCard ? 5 : self.showType == .YXToolFuncCycleScrollType3DCard ? 5 : 3
            var judgeShowCount: NSInteger = self.showType == .YXToolFuncCycleScrollTypeCard ? 3 : self.showType == .YXToolFuncCycleScrollType3DCard ? 3 : 1
            let judgeHiddenCount:NSInteger = self.showType == .YXToolFuncCycleScrollTypeCard ? 2 : self.showType == .YXToolFuncCycleScrollType3DCard ? 2 : 1
            if self.imgValueArr!.count <= 3 {
                judgeShowCount = self.imgValueArr!.count == 0 ? 0 : self.imgValueArr!.count - 1
            }
            for imageView: UIImageView in self.imgViewsArr as! [UIImageView] {
                if self.imgValueArr!.count == 1 && i != judgeHiddenCount {
                    imageView.isHidden = true
                    imageView.isUserInteractionEnabled = false
                }
                else {
                    imageView.isHidden = false
                    imageView.isUserInteractionEnabled = true
                }
                
                if self.imgValueArr!.count < judgeCount && i > judgeShowCount { //只有两张图片时，将最后一张视图的图片，以第一张图片进行设置。
                    if (j == self.imgValueArr!.count) {
                        j = 0
                    }
                    let infoModel: YXToolFuncCycleScrollInfoModel = self.imgValueArr![j] as! YXToolFuncCycleScrollInfoModel
                    imageView.image = UIImage.init(named: infoModel.imgUrl as String)
                    imageView.tag = j
                    j += 1
                }
                else {
                    let infoModel: YXToolFuncCycleScrollInfoModel = self.imgValueArr![i] as! YXToolFuncCycleScrollInfoModel
                    imageView.image = UIImage.init(named: infoModel.imgUrl as String)
                    imageView.tag = i
                }
                i += 1
            }
        }
        
        if self.imgValueArr!.count == 1 {
            self.pageBtn.isHidden = !self.boolPageBtn
        }
        self.pageBtn.setTitle(NSString.localizedStringWithFormat(" %d/%d", self.pageControl.currentPage + 1, self.imgValueArr!.count) as String, for: UIControl.State.normal)
        scrollViewBlock()
    }
    
    //MARK: - 根据显示类型更改图片显示位置
    func changeImgVShowFrame() {
        
        var judgeCount: NSInteger = self.showType == .YXToolFuncCycleScrollTypeCard ? 2 : self.showType == .YXToolFuncCycleScrollType3DCard ? 2 : 1
        if !self.boolCycle {
            judgeCount = 0
        }
    
        let scrollViewWidth: CGFloat = self.bounds.size.width
        let scrollViewHeight: CGFloat = self.bounds.size.height
        let top: CGFloat = edgeInsets.top
        let left: CGFloat = edgeInsets.left
        let bottom: CGFloat = edgeInsets.bottom
        let right: CGFloat = edgeInsets.right
        var idx: CGFloat = 0.0
        
        if self.boolHorizontal {
            for imgV: UIImageView in self.imgViewsArr as! [UIImageView] {
                switch self.showType {
                case .YXToolFuncCycleScrollTypeFull:
                    imgV.frame = CGRect.init(x: scrollViewWidth * idx, y: 0.0, width: scrollViewWidth, height: scrollViewHeight)
                    imgV.clipsToBounds = true
                    break
                case .YXToolFuncCycleScrollTypeEdge:
                    imgV.frame = CGRect.init(x: scrollViewWidth * idx + left, y: top, width: scrollViewWidth - (left + right), height: scrollViewHeight - (top + bottom))
                    imgV.clipsToBounds = true
                    break
                case .YXToolFuncCycleScrollTypeCard:
                    self.imgVSize = scrollViewWidth - left
                    imgV.frame = CGRect.init(x: (self.imgVSize + right) * idx, y: top, width: self.imgVSize, height: scrollViewHeight - (top + bottom))
                    imgV.clipsToBounds = true
                    break
                case .YXToolFuncCycleScrollType3DCard:
                    self.imgVSize = scrollViewWidth - left
                    imgV.frame = CGRect.init(x: (self.imgVSize + right) * idx, y: top, width: self.imgVSize, height: scrollViewHeight - (top + bottom))
                    imgV.clipsToBounds = true
                    break
                default:
                    break
                }
                idx += 1
            }
            
            let imgCriticalValue: CGFloat = self.imgVSize != 0 ? self.imgVSize : scrollViewWidth
            self.rollingDistance = self.imgVSize != 0 ? (imgCriticalValue + right) : scrollViewWidth
            if self.showType == .YXToolFuncCycleScrollTypeCard {
                self.scrollView.clipsToBounds = false
                self.scrollView.frame = CGRect.init(x: left / 2.0, y: 0.0, width: self.rollingDistance, height: scrollViewHeight)
                self.scrollView.contentSize = CGSize.init(width: (imgCriticalValue + right) * CGFloat(self.imgViewsArr.count), height: scrollViewHeight)
            }
            else if self.showType == .YXToolFuncCycleScrollType3DCard {
                self.scrollView.clipsToBounds = false
                self.scrollView.frame = CGRect.init(x: left / 2.0, y: 0.0, width: self.rollingDistance, height: scrollViewHeight)
                self.scrollView.contentSize = CGSize.init(width: (imgCriticalValue + right) * CGFloat(self.imgViewsArr.count), height: scrollViewHeight)
            }
            else {
                self.scrollView.clipsToBounds = true
                self.scrollView.contentSize = CGSize.init(width: scrollViewWidth * CGFloat(self.imgViewsArr.count), height: scrollViewHeight)
            }
            self.scrollView.setContentOffset(CGPoint.init(x: self.rollingDistance * CGFloat(judgeCount), y: 0.0), animated: false)
        }
        else {
            for imgV: UIImageView in self.imgViewsArr as! [UIImageView] {
                switch self.showType {
                case .YXToolFuncCycleScrollTypeFull:
                    imgV.frame = CGRect.init(x: 0.0, y: scrollViewHeight * idx, width: scrollViewWidth, height: scrollViewHeight)
                    imgV.clipsToBounds = true
                    break
                case .YXToolFuncCycleScrollTypeEdge:
                    imgV.frame = CGRect.init(x: left, y: scrollViewHeight * idx + top, width: scrollViewWidth - (left + right), height: scrollViewHeight - (top + bottom))
                    imgV.clipsToBounds = true
                    break
                case .YXToolFuncCycleScrollTypeCard:
                    self.imgVSize = scrollViewHeight - top
                    imgV.frame = CGRect.init(x: left, y: (self.imgVSize + bottom) * idx, width: scrollViewWidth - (left + right), height: self.imgVSize)
                    imgV.clipsToBounds = true
                    break
                case .YXToolFuncCycleScrollType3DCard:
                    self.imgVSize = scrollViewHeight - top
                    imgV.frame = CGRect.init(x: left, y: (self.imgVSize + bottom) * idx, width: scrollViewWidth - (left + right), height: self.imgVSize)
                    imgV.clipsToBounds = true
                    break
                default:
                    break
                }
                idx += 1.0
            }
            
            let imgCriticalValue: CGFloat = self.imgVSize != 0 ? self.imgVSize : scrollViewHeight
            self.rollingDistance = self.imgVSize != 0 ? (imgCriticalValue + bottom) : scrollViewHeight
            if self.showType == .YXToolFuncCycleScrollTypeCard {
                self.scrollView.clipsToBounds = false
                self.scrollView.frame = CGRect.init(x: 0.0, y: top / 2.0, width: scrollViewWidth, height: self.rollingDistance)
                self.scrollView.contentSize = CGSize.init(width: scrollViewWidth, height: (imgCriticalValue + bottom) * CGFloat(self.imgViewsArr.count))
            }
            else if self.showType == .YXToolFuncCycleScrollType3DCard {
                self.scrollView.clipsToBounds = false
                self.scrollView.frame = CGRect.init(x: 0.0, y: top / 2.0, width: scrollViewWidth, height: self.rollingDistance)
                self.scrollView.contentSize = CGSize.init(width: scrollViewWidth, height: (imgCriticalValue + bottom) * CGFloat(self.imgViewsArr.count))
            }
            else {
                self.scrollView.clipsToBounds = true
                self.scrollView.contentSize = CGSize.init(width: scrollViewWidth, height: scrollViewHeight * CGFloat(self.imgViewsArr.count))
            }
            self.scrollView.setContentOffset(CGPoint.init(x: 0.0, y: self.rollingDistance * CGFloat(judgeCount)), animated: false)
        }
    }
    
    //MARK: - 更改图片显示圆角
    func changeImgVShowCornerRadius() {
        
        for imgV: UIImageView in self.imgViewsArr as! [UIImageView] {
            imgV.layer.cornerRadius = self.cornerRadius as CGFloat
            imgV.layer.masksToBounds = true
        }
    }
    
    //MARK: - 使用动画
    func useZoomAnimationByCurrent(current: NSInteger) {
        
        var i: NSInteger = 0
        for imageView: UIImageView in self.imgViewsArr as! [UIImageView] {
            if i == current {
                zoomAnimationByView(view: imageView, type: 0, current: i)
            }
            else {
                zoomAnimationByView(view: imageView, type: 1, current: i)
            }
            
            i += 1
        }
    }
    
    //MARK: processTimer
    @objc func processTimer() {

        let judgeCount: NSInteger = self.showType == .YXToolFuncCycleScrollTypeCard ? 3 : self.showType == .YXToolFuncCycleScrollType3DCard ? 3 : 2
        if self.boolHorizontal {
            self.scrollView.setContentOffset(CGPoint.init(x: self.rollingDistance * CGFloat(judgeCount), y: 0.0), animated: true)
        }
        else {
            self.scrollView.setContentOffset(CGPoint.init(x: 0.0, y: self.rollingDistance * CGFloat(judgeCount)), animated: true)
        }
    }
    
    //MARK: - 滚动视图block
    func scrollViewBlock() {
        
        guard let block = self.yxToolFuncCycleScrollMoveBlock else { return }
        block(self.pageControl.currentPage)
    }
    
    //MARK: - 更新第一条数据
    func updateFirstValueByBoolFirst(boolFirst: Bool) {
        
        if !self.boolCycle {
            return
        }
        
        var judgeCount = self.showType == .YXToolFuncCycleScrollTypeCard ? 2 : self.showType == .YXToolFuncCycleScrollType3DCard ? 2 : 1
        if !boolFirst {
            judgeCount = 1
        }
        
        for _ in 0 ..< judgeCount {
            let infoModel: YXToolFuncCycleScrollInfoModel = imgValueArr!.lastObject as! YXToolFuncCycleScrollInfoModel
            imgValueArr!.removeLastObject()
            imgValueArr!.insert(infoModel, at: 0)
        }
    }
    
    //MARK: - 更新最后一条数据
    func updateLastValue() {
        
        let infoModel: YXToolFuncCycleScrollInfoModel = imgValueArr!.firstObject as! YXToolFuncCycleScrollInfoModel
        imgValueArr?.removeObject(at: 0)
        imgValueArr?.add(infoModel)
    }
    
    //MARK: - 放大缩小动画 0:放大 1:缩小
    func zoomAnimationByView(view: UIView, type: NSInteger, current: NSInteger) {
        
        if self.showType != .YXToolFuncCycleScrollType3DCard {
            return
        }
        
        var fromValue: CGFloat = 1.0
        var toValue: CGFloat = 1.0
        if current == self.alreadCurrent { //缩小
            fromValue = self.zoomRadio
        }
        if type == 0 { //放大
            toValue = self.zoomRadio
        }

        if (fromValue == 1.0 && toValue != 1.0) || (fromValue != 1.0 && toValue != 1.0) {
            view.isUserInteractionEnabled = true
        }
        else {
            view.isUserInteractionEnabled = false
        }
        
        var centerOrigin: CGFloat = 0.0
        if self.boolHorizontal {
            centerOrigin = self.scrollView.bounds.size.width * 0.5 - edgeInsets.right / 2.0
        }
        else {
            centerOrigin = self.scrollView.bounds.size.height * 0.5 - edgeInsets.bottom / 2
        }
        centerOrigin = self.offsetOrigin + centerOrigin
        
        if self.boolDynamic {
            let centerImgOrigin: CGFloat = self.boolHorizontal ? view.center.x : view.center.y
            let imgSizeOrigin: CGFloat = self.boolHorizontal ? view.bounds.size.width : view.bounds.size.height
            //移动间距
            let distance: CGFloat = abs(centerImgOrigin - centerOrigin)
            //移动比例（如果间距为0，则说明当前所在中间位置，即使用设定比例）
            let proportion: CGFloat = distance == 0 ? self.zoomRadio : (imgSizeOrigin / distance)
            //放大比例（如果移动比例大于指定比例，则使用指定比例，最小比例为1）
            let scale: CGFloat = proportion >= self.zoomRadio ? self.zoomRadio : proportion <= 1 ? 1 : proportion
            view.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        }
        else {
            let animation: CABasicAnimation = CABasicAnimation.init(keyPath: "transform.scale")
            animation.fromValue = NSNumber.init(floatLiteral:Double(fromValue))
            animation.toValue = NSNumber.init(floatLiteral:Double(toValue))
            animation.duration = 0.3
            animation.repeatCount = 0
            animation.autoreverses = false
            animation.isRemovedOnCompletion = false
            animation.fillMode = .both
            view.layer.add(animation, forKey: "zoom")
        }
    }
    
    //MARK: - progress
    //MARK: - 单击图片
    @objc func singleTapAction(gesture: UITapGestureRecognizer) {
        
        guard let block = self.yxToolFuncCycleScrollBlock else { return }
        
        var infoModel: YXToolFuncCycleScrollInfoModel = YXToolFuncCycleScrollInfoModel.init()
        infoModel = self.imgValueArr![gesture.view!.tag] as! YXToolFuncCycleScrollInfoModel
        block(infoModel)
    }
    
    //MARK: - 点击分页控制器
    @objc func changePageControl(pageControl: UIPageControl) {
        
        currentPage = pageControl.currentPage
    }
    
    //MARK: - Timer
    //MARK: - 移除Timer
    func stopTimer() {
        
        timer!.invalidate()
        timer = nil
    }
    //MARK: - 关闭Timer
    func closeTimer() {
        
        timer?.fireDate = NSDate.distantFuture
    }
    //MARK: - 开启Timer
    func openTimer() {
        
        timer?.fireDate = NSDate.init(timeIntervalSinceNow: Double(timeInterval)) as Date
    }
    
    //MARK: - 滚动切换
    func scrollViewChangeImgByScrollView(scrollView: UIScrollView) {
        
        let judgeBigCount: NSInteger = self.showType == .YXToolFuncCycleScrollTypeCard ? 3 : self.showType == .YXToolFuncCycleScrollType3DCard ? 3 : 2
        let judgeSmallCount: NSInteger = self.showType == .YXToolFuncCycleScrollTypeCard ? 1 : self.showType == .YXToolFuncCycleScrollType3DCard ? 1 : 0
        var judgeShowCount: NSInteger = self.showType == .YXToolFuncCycleScrollTypeCard ? 2 : self.showType == .YXToolFuncCycleScrollType3DCard ? 2 : 1
        
        var offsetOrigin: CGFloat = 0.0
        if self.boolHorizontal {
            offsetOrigin = scrollView.contentOffset.x
        }
        else {
            offsetOrigin = scrollView.contentOffset.y
        }
        self.offsetOrigin = offsetOrigin;
        
        if !self.boolCycle {
            judgeShowCount = NSInteger(floor((scrollView.contentOffset.x + self.rollingDistance * 0.5) / self.rollingDistance))
            
            if judgeShowCount > self.pageControl.currentPage {
                self.alreadCurrent = (judgeShowCount - 1) > 0 ? (judgeShowCount - 1) : 0
                useZoomAnimationByCurrent(current: judgeShowCount)
            }
            else if judgeShowCount < self.pageControl.currentPage {
                self.alreadCurrent = (judgeShowCount + 1) > 0 ? (judgeShowCount + 1) : 0
                
                useZoomAnimationByCurrent(current: judgeShowCount)
            }
            else {
                if self.boolDynamic {
                    useZoomAnimationByCurrent(current: judgeShowCount)
                }
                return
            }
            self.pageControl.currentPage = judgeShowCount
            
            self.pageBtn.setTitle(NSString.localizedStringWithFormat(" %d/%d", self.pageControl.currentPage + 1, imgValueArr!.count) as String, for: UIControl.State.normal)
        }
        else {
            if offsetOrigin >= CGFloat(judgeBigCount) * self.rollingDistance { //滑动到右边视图
                updateLastValue()
                self.pageControl.currentPage = self.pageControl.currentPage == imgValueArr!.count - 1 ? 0 : self.pageControl.currentPage + 1
                self.alreadCurrent = (judgeShowCount - 1) > 0 ? (judgeShowCount - 1) : 0
                useZoomAnimationByCurrent(current: judgeShowCount)
            }
            else if offsetOrigin <= CGFloat(judgeSmallCount) * self.rollingDistance { //滑动到左边视图
                updateFirstValueByBoolFirst(boolFirst: false)
                self.pageControl.currentPage = self.pageControl.currentPage == 0 ? imgValueArr!.count - 1 : self.pageControl.currentPage - 1
                self.alreadCurrent = (judgeShowCount + 1) > 0 ? (judgeShowCount + 1) : 0
                useZoomAnimationByCurrent(current: judgeShowCount)
            }
            else {
                if self.boolDynamic {
                    useZoomAnimationByCurrent(current: judgeShowCount)
                }
                return
            }
            setImageFromImageNames()
            
            if self.boolHorizontal {
                scrollView.setContentOffset(CGPoint.init(x: self.rollingDistance * CGFloat(judgeShowCount), y: 0.0), animated: false)
            }
            else {
                scrollView.setContentOffset(CGPoint.init(x: 0.0, y: self.rollingDistance * CGFloat(judgeShowCount)), animated: false)
            }
        }
    }
    
    //MARK: - <UIScrollViewDelegate>
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollViewChangeImgByScrollView(scrollView: scrollView)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if self.boolOpenTimer {
            closeTimer()
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if self.boolOpenTimer {
            openTimer()
        }
    }
    
    //MARK: - 初始化循环视图
    func initViewByCycle() {
        
        let judgeCount: NSInteger = self.showType == .YXToolFuncCycleScrollTypeCard ? 5 : self.showType == .YXToolFuncCycleScrollType3DCard ? 5 : 3
        
        self.clipsToBounds = true
        
        self.scrollView = UIScrollView.init(frame: self.bounds)
        if self.boolHorizontal {
            self.scrollView.contentSize = CGSize.init(width: self.scrollView.frame.size.width * CGFloat(judgeCount), height: self.scrollView.frame.size.height)
            self.scrollView.setContentOffset(CGPoint.init(x: self.scrollView.frame.size.width, y: 0.0), animated: false)
        }
        else {
            self.scrollView.contentSize = CGSize.init(width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height * CGFloat(judgeCount))
            self.scrollView.setContentOffset(CGPoint.init(x: 0.0, y: self.scrollView.frame.size.height), animated: false)
        }
        self.scrollView.backgroundColor = UIColor.clear
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.isPagingEnabled = true
        self.scrollView.bounces = true
        self.scrollView.delegate = self
        addSubview(self.scrollView)

        //初始化图片显示视图
        initImgVByCount(count: judgeCount)
        
        self.pageBackView = UIView.init(frame: CGRect.init(x: 0.0, y: self.bounds.maxY - 20, width: self.bounds.width, height: 20))
        
        self.pageBackView.backgroundColor = UIColor.clear
        addSubview(self.pageBackView)
        
        self.pageControl = YXToolPageControl.init(frame: self.pageBackView.bounds)
        self.pageControl.center = CGPoint.init(x: self.pageBackView.bounds.midX, y: self.pageBackView.bounds.midY)
        self.pageControl.numberOfPages = self.imgViewsArr.count
        self.pageControl.currentPageIndicatorTintColor = UIColor.blue
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPage = 0
        self.pageControl.isUserInteractionEnabled = boolOpenPageControl
        self.pageControl.addTarget(self, action: #selector(changePageControl(pageControl:)), for: UIControl.Event.touchUpInside)
        self.pageBackView.addSubview(self.pageControl)
        self.pageBackView.isHidden = !self.boolPageController
        
        self.pageBtn = UIButton.init(type: UIButton.ButtonType.system)
        self.pageBtn.frame = CGRect.init(x: self.bounds.size.width - 40, y: 20, width: 30, height: 22)
        self.pageBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.pageBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.pageBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.pageBtn.layer.cornerRadius = 11
        self.pageBtn.layer.masksToBounds = true
        addSubview(self.pageBtn)
        self.pageBtn.isHidden = !self.boolPageBtn
        
        let judgeHiddenCount: NSInteger = self.showType == .YXToolFuncCycleScrollTypeCard ? 2 : self.showType == .YXToolFuncCycleScrollType3DCard ? 2 : 1
        useZoomAnimationByCurrent(current: judgeHiddenCount)
    }

    //MARK: - 初始化不循环视图
    func initViewByNotCycle() {
        
        self.clipsToBounds = true
        
        self.scrollView = UIScrollView.init(frame: self.bounds)
        self.scrollView.backgroundColor = UIColor.clear
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.isPagingEnabled = true
        self.scrollView.bounces = true
        self.scrollView.delegate = self
        addSubview(self.scrollView)
        
        self.pageBackView = UIView.init(frame: CGRect.init(x: 0, y: self.bounds.maxY - 20, width: self.bounds.width, height: 20))
        self.pageBackView.backgroundColor = UIColor.clear
        addSubview(self.pageBackView)
        
        self.pageControl = YXToolPageControl.init(frame: self.pageBackView.bounds)
        self.pageControl.center = CGPoint.init(x: self.pageBackView.bounds.midX, y: self.pageBackView.bounds.midY)
        self.pageControl.numberOfPages = self.imgViewsArr.count
        self.pageControl.currentPageIndicatorTintColor = UIColor.blue
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPage = 0
        self.pageControl.isUserInteractionEnabled = boolOpenPageControl
        self.pageControl.addTarget(self, action: #selector(changePageControl(pageControl:)), for: UIControl.Event.touchUpInside)
        self.pageBackView.addSubview(self.pageControl)
        self.pageBackView.isHidden = !self.boolPageController
        
        self.pageBtn = UIButton.init(type: UIButton.ButtonType.system)
        self.pageBtn.frame = CGRect.init(x: self.bounds.size.width - 40, y: 20, width: 30, height: 22)
        self.pageBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.pageBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.pageBtn.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.pageBtn.layer.cornerRadius = 11
        self.pageBtn.layer.masksToBounds = true
        addSubview(self.pageBtn)
        self.pageBtn.isHidden = !self.boolPageBtn
    }
    
    //MARK: - 初始化图片显示视图
    func initImgVByCount(count: NSInteger) {
        
        if self.imgViewsArr.count != count {
            for i in 0 ..< count {
                let imgV: UIImageView = UIImageView.init()
                imgV.tag = i
                if self.boolHorizontal {
                    imgV.frame = CGRect.init(x: self.scrollView.frame.size.width * CGFloat(i), y: 0.0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
                }
                else {
                    imgV.frame = CGRect.init(x: 0, y: self.scrollView.frame.size.height * CGFloat(i), width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
                }
                imgV.contentMode = .scaleAspectFill
                imgV.isUserInteractionEnabled = true
                self.scrollView.addSubview(imgV)
                self.imgViewsArr.add(imgV)
                
                let singleTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(singleTapAction(gesture:)))
                imgV.addGestureRecognizer(singleTap)
            }
        }
    }
    
}
