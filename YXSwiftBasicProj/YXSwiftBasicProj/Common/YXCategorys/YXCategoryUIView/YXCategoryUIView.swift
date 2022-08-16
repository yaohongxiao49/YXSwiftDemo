//
//  YXCategoryUIView.swift
//  YXSwiftBasicProj
//
//  Created by Augus on 2022/8/9.
//

import UIKit

public enum YXFilterActionType: integer_t {
    /** 替换字符串为空 */
    case YXFilterKeyWordsType = 0x001
    /** 限制Emoji表情 */
    case YXFilterEmojiType = 0x010
    /** 限制字数 */
    case YXFilterLimitType = 0x100
    /** 显示字数及Emoji表情 */
    case YXFilterLimitEmojiType = 0x003
    /** 不做控制 */
    case YXFilterNoneType = 0x000
}

var kTapGestureRecognizerBlockAddress = "kTapGestureRecognizerBlockAddress"
var UIControlAcceptEventInterval = "UIControl_acceptEventInterval"
var UIControlAcceptEventTime = "UIControl_acceptEventTime"

public extension UIView {
    
    private struct viewSizeStruct {
        
        /** 视图x坐标 */
        static var x: CGFloat?
        /** 视图y坐标 */
        static var y: CGFloat?
        /** 视图宽 */
        static var width: CGFloat?
        /** 视图高 */
        static var height: CGFloat?

        /** 视图最右侧坐标 */
        static var right: CGFloat?
        /** 视图最底部坐标 */
        static var bottom: CGFloat?

        /** 视图中心x坐标 */
        static var centerX: CGFloat?
        /** 视图中心y坐标 */
        static var centerY: CGFloat?

        /** 视图坐标 */
        static var origin: CGPoint?
        /** 视图大小 */
        static var size: CGSize?

        //MARK: - 输入框限制
        /** 需要替换的文字数组 */
        var filterKeyWordsArray: Array<Any>
        /** 限制字符串总数 */
        var limitInputWords: Int
        /** 限制类型 */
        var filterActionType: YXFilterActionType
        
        /** 视图点击 */
        static var tapAction: ((UIView) -> Void)?
        /** 防止按钮重复点击 */
        static var repeatClickEventInterval: TimeInterval?
        /** 重复点击的间隔 */
        static var acceptEventTime: TimeInterval?
        
    }
    
    //MARK: - getting/setting
    var x: CGFloat {
        
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var y: CGFloat {
        
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var width: CGFloat {
        
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var right: CGFloat {
        
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
    }
    
    var bottom: CGFloat {
        
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }
    
    var centerX: CGFloat {
        
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint.init(x: newValue, y: self.center.y)
        }
    }
    
    var centerY: CGFloat {
        
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint.init(x: self.center.y, y: newValue)
        }
    }
    
    var origin: CGPoint {
        
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    var size: CGSize {
        
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }

    //MARK: - 获取当前视图所在的视图控制器
    func viewController() -> UIViewController? {
        
        var n = next
        while n != nil {
            if n is UIViewController {
                return n as? UIViewController
            }
            n = n?.next
        }
        return nil
    }
    
    //MARK: - 添加点击手势
    func yxTapUpWithBlock(view: @escaping (UIView) -> Void) {
        
        self.tapAction = view
        self.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapSelfTargetAction))
        self.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    var tapAction: ((UIView) -> Void) {
        
        get {
            return objc_getAssociatedObject(self, &kTapGestureRecognizerBlockAddress) as! (UIView) -> Void
        }
        set {
            objc_setAssociatedObject(self, &kTapGestureRecognizerBlockAddress, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @objc func tapSelfTargetAction() {
        
        let block = objc_getAssociatedObject(self, &kTapGestureRecognizerBlockAddress);
        if ((block == nil)) {
            return;
        }
        self.repeatClickEventInterval = 1.0
        if (NSDate().timeIntervalSince1970 - self.acceptEventTime < self.repeatClickEventInterval) {
            return
        }

        if (self.repeatClickEventInterval > 0) {
            self.acceptEventTime = NSDate().timeIntervalSince1970;
        }
    
        let touchUpBlock: ((UIView) -> Void) = block as! (UIView) -> Void
        touchUpBlock(self)
    }
    
    var repeatClickEventInterval: TimeInterval {
        
        get {
            return (objc_getAssociatedObject(self, &UIControlAcceptEventInterval)) == nil ? 0 : objc_getAssociatedObject(self, &UIControlAcceptEventInterval) as! TimeInterval
        }
        set {
            objc_setAssociatedObject(self, &UIControlAcceptEventInterval, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var acceptEventTime: TimeInterval {
        
        get {
            return (objc_getAssociatedObject(self, &UIControlAcceptEventTime)) == nil ? 0 : objc_getAssociatedObject(self, &UIControlAcceptEventTime) as! TimeInterval
        }
        set {
            objc_setAssociatedObject(self, &UIControlAcceptEventTime, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    //MARK: - 设置圆角
    /**
     * 指定圆角
     * @param view 视图
     * @param corners 圆角方位
     * @param cornerRadii 圆角程度
     */
    func yxSpecifiedCornerFilletByView(view: UIView, corners: UIRectCorner, cornerRadii: CGSize) {
        
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.frame
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }

    /**
     * 指定圆角带边框
     * @param view 视图
     * @param corners 圆角方位
     * @param cornerRadii 圆角程度
     * @param lineWidth 边框宽度
     * @param lineColor 边框色值
     */
    func yxGetSpecifiedFilletWithBorder(view: UIView, corners: UIRectCorner, cornerRadii: CGSize, lineWidth: CGFloat, lineColor: UIColor) {
        
        self.yxSpecifiedCornerFilletByView(view: view, corners: corners, cornerRadii: cornerRadii)
        if let sublayer = view.layer.sublayers {
            for idx in sublayer {
                if idx is CAShapeLayer {
                    idx.removeFromSuperlayer()
                }
            }
        }
        
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = lineColor.cgColor
        maskLayer.lineWidth = lineWidth
        view.layer.addSublayer(maskLayer)
    }

}
