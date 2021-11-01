//
//  YXAlertViewController.swift
//  YXAccordingProj
//
//  Created by ios on 2021/5/14.
//

import UIKit

/** 弹窗类型 */
enum YXAlertViewControllerStyle {
    /** alert */
    case YXAlertViewControllerStyleAlert
    /** sheet */
    case YXAlertViewControllerStyleActionSheet
}

/** 动画 */
enum YXAlertTransitionAnimation {
    case YXAlertTransitionAnimationFade
    case YXAlertTransitionAnimationScaleFade
    case YXAlertTransitionAnimationDropDown
    case YXAlertTransitionAnimationCustom
}

typealias DismissComplete = () ->(Void)

class YXAlertViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    private(set) var alertView: UIView?
    
    var _backgroundView: UIView?
    var backgroundView: UIView? {
       
        get {
            return _backgroundView
        }
        set {
            if self.backgroundView == nil {
                _backgroundView = newValue
            }
            else if self.backgroundView != newValue {
                newValue!.translatesAutoresizingMaskIntoConstraints = false
                self.view.insertSubview(newValue!, aboveSubview: self.backgroundView!)
                self.view.addConstraintToView(view: newValue!, edgeInset: UIEdgeInsets.zero)
                
                newValue!.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    
                    newValue!.alpha = 1
                } completion: { [self] Bool in
                    
                    backgroundView?.removeFromSuperview()
                    backgroundView = newValue
                    initSingleTapGesture()
                }
            }
        }
    }
    private(set) var preferredStyle: YXAlertViewControllerStyle?
    private(set) var transitionAnimation: YXAlertTransitionAnimation?
    private(set) var transitionAnimationClass: AnyClass?
    var backgoundTapDismissEnable: Bool = false
    var alertViewOriginY: CGFloat = 0.0
    var alertStyleEdging: CGFloat = 15.0
    var actionSheetStyleEdging: CGFloat = 0.0
    var dismissComplete: DismissComplete?
    private var singleTap: UITapGestureRecognizer?
    private var alertViewCenterYConstraint: NSLayoutConstraint?
    private var alertViewCenterYOffset: CGFloat = 0.0
    
    public static func alertControllerWithAlertView(alertView: UIView) -> Self {

        return YXAlertViewController.init().initWithAlertView(alertView: alertView, preferredStyle: .YXAlertViewControllerStyleAlert, transitionAnimation: .YXAlertTransitionAnimationFade, transitionAnimationClass: nil) as! Self
    }

    public static func alertControllerWithAlertView(alertView: UIView, preferredStyle: YXAlertViewControllerStyle) -> Self {

        return YXAlertViewController.init().initWithAlertView(alertView: alertView, preferredStyle: preferredStyle, transitionAnimation: .YXAlertTransitionAnimationFade, transitionAnimationClass: nil) as! Self
    }
    
    public static func alertControllerWithAlertView(alertView: UIView, preferredStyle: YXAlertViewControllerStyle, transitionAnimation: YXAlertTransitionAnimation) -> Self {
        
        return YXAlertViewController.init().initWithAlertView(alertView: alertView, preferredStyle: preferredStyle, transitionAnimation: transitionAnimation, transitionAnimationClass: nil) as! Self
    }
    
    public static func alertControllerWithAlertView(alertView: UIView, preferredStyle: YXAlertViewControllerStyle, transitionAnimationClass: AnyClass?) -> Self {
        
        return YXAlertViewController.init().initWithAlertView(alertView: alertView, preferredStyle: preferredStyle, transitionAnimation: .YXAlertTransitionAnimationCustom, transitionAnimationClass: transitionAnimationClass) as! Self
    }
    
    //MARK:- dealloc
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        initViewController()
    }

    init() {
        super.init(nibName: nil, bundle: nil)

        initViewController()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        initViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initBackGroundView()
        initSingleTapGesture()
        initView()
        self.view.layoutIfNeeded()
        
        if self.preferredStyle == .YXAlertViewControllerStyleAlert {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    //MARK:- sheet
    func layoutActionSheetStyleView() {
        
        self.view.addConstraintCenterXToView(centerXToView: self.alertView, centerYToView: nil)
        self.view.addConstarintWithView(view: self.alertView!, topView: nil, leftView: self.view, bottomView: self.view, rightView: self.view, edgeInset: UIEdgeInsets.init(top: 0, left: self.actionSheetStyleEdging, bottom: 0, right: -self.actionSheetStyleEdging))
        if self.alertView!.frame.height > 0.0 {
            self.alertView!.addConstarintWidth(width: 0, height: self.alertView!.frame.height)
        }
    }
    
    //MARK:- alert
    func layoutAlertStyleView() {
        
        self.view.addConstraintCenterXToView(centerXToView: self.alertView, centerYToView: nil)
        configureAlertViewWidth()
        self.alertViewCenterYConstraint = self.view.addConstraintCenterYToView(centerYToView: self.alertView, constant: 0)!
        
        if self.alertViewOriginY > 0 {
            self.alertView!.layoutIfNeeded()
            self.alertViewCenterYOffset = self.alertViewOriginY - self.view.frame.height - self.alertView!.frame.height / 2
            self.alertViewCenterYConstraint!.constant = self.alertViewCenterYOffset
        }
        else{
            self.alertViewCenterYOffset = 0.0
        }
    }
    
    //MARK:- alertViewWidth
    func configureAlertViewWidth() {
        
        if !__CGSizeEqualToSize(self.alertView!.frame.size, CGSize.zero) {
            self.alertView!.addConstarintWidth(width: self.alertView!.frame.width, height: self.alertView!.frame.height)
        }
        else {
            var findAlertViewWidthConstraint: Bool = false
            for constraint: NSLayoutConstraint in self.alertView!.constraints {
                if constraint.firstAttribute == NSLayoutConstraint.Attribute.width {
                    findAlertViewWidthConstraint = true
                    break
                }
            }
            if !findAlertViewWidthConstraint {
                self.alertView!.addConstarintWidth(width: self.view.frame.width - 2 * self.alertStyleEdging, height: 0.0)
            }
        }
    }
    
    //MARK:- 键盘监听
    //MARK:- 显示
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardRect: CGRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
        let alertViewBottomEdge: CGFloat = self.view.frame.height - self.alertView!.frame.maxY
        let different: CGFloat = keyboardRect.height - alertViewBottomEdge
        
        if (different > 0) {
            self.alertViewCenterYConstraint!.constant = self.alertViewCenterYOffset - different
            UIView.animate(withDuration: 0.25) {
                
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //MARK:- 隐藏
    @objc func keyboardWillHide(notification: NSNotification) {
        
        self.alertViewCenterYConstraint!.constant = self.alertViewCenterYOffset
        UIView.animate(withDuration: 0.25) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- progress
    //MARK:- 点击事件
    @objc func singleTop(gesture: UITapGestureRecognizer) {
        
        dismissViewControllerAnimated(animated: true)
    }
    
    //MARK:- 初始化数据
    func initViewController() {
        
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
        self.backgoundTapDismissEnable = false
        self.alertStyleEdging = 15.0
        self.actionSheetStyleEdging = 0.0
    }
    
    //MARK:- 初始化背景视图
    func initBackGroundView() {
        
        self.backgroundView = UIView()
        self.backgroundView!.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.backgroundView!.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(self.backgroundView!, at: 0)
        self.view.addConstraintToView(view: self.backgroundView!, edgeInset: UIEdgeInsets.zero)
    }
    
    //MARK:- 初始化单击事件
    func initSingleTapGesture() {
        
        self.view.isUserInteractionEnabled = true
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(singleTop(gesture:)))
        singleTap.isEnabled = self.backgoundTapDismissEnable
        self.backgroundView?.addGestureRecognizer(singleTap)
        self.singleTap = singleTap
    }
    
    //MARK:- 初始化视图
    func initView() {
        
        if self.alertView == nil {
            NSLog("%@: alertView is nil", NSStringFromClass(self.classForCoder))
            return
        }
        self.alertView!.isUserInteractionEnabled = true
        self.view.addSubview(self.alertView!)
        self.alertView!.translatesAutoresizingMaskIntoConstraints = false
        
        switch (self.preferredStyle) {
        case .YXAlertViewControllerStyleActionSheet:
            layoutActionSheetStyleView()
            break
        case .YXAlertViewControllerStyleAlert:
            layoutAlertStyleView()
            break
        default:
            break
        }
    }
    
    private func initWithAlertView(alertView: UIView, preferredStyle: YXAlertViewControllerStyle, transitionAnimation: YXAlertTransitionAnimation, transitionAnimationClass: AnyClass?) -> Self {
        
        self.alertView = alertView
        self.preferredStyle = preferredStyle
        self.transitionAnimation = transitionAnimation
        self.transitionAnimationClass = transitionAnimationClass
        
        return self
    }
    
    //MARK:- 视图消失
    func dismissViewControllerAnimated(animated: Bool) {
        
        self.dismiss(animated: true, completion: self.dismissComplete)
    }
}
