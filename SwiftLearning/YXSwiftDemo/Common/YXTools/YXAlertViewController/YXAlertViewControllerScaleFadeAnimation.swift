//
//  YXAlertViewControllerScaleFadeAnimation.swift
//  YXAccordingProj
//
//  Created by ios on 2021/5/20.
//

import UIKit

class YXAlertViewControllerScaleFadeAnimation: YXAlertViewControllerBaseAnimation {

    //MARK:- UIViewControllerAnimatedTransitioning
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            
        return 0.3
    }

    override func presentAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let alertViewController: YXAlertViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! YXAlertViewController
        alertViewController.backgroundView!.alpha = 0.0
        
        switch alertViewController.preferredStyle {
        case .YXAlertViewControllerStyleAlert:
            alertViewController.alertView!.alpha = 0.0
            alertViewController.alertView!.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            break
        case .YXAlertViewControllerStyleActionSheet:
            alertViewController.alertView!.transform = CGAffineTransform(translationX: 0, y: alertViewController.alertView!.frame.height)
                break
        default:
            break
        }
        
        let containerView: UIView = transitionContext.containerView
        containerView.addSubview(alertViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            
            alertViewController.backgroundView!.alpha = 1.0
            switch alertViewController.preferredStyle {
            case .YXAlertViewControllerStyleAlert:
                alertViewController.alertView!.alpha = 1.0
                alertViewController.alertView!.transform = CGAffineTransform.identity
                    break
            case .YXAlertViewControllerStyleActionSheet:
                alertViewController.alertView!.transform = CGAffineTransform.identity
                    break
                default:
                    break
            }
        } completion: { Bool in
            
            transitionContext.completeTransition(true)
        }
    }
    
    override func dismissAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let alertViewController: YXAlertViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! YXAlertViewController
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            
            alertViewController.backgroundView!.alpha = 0.0
            switch alertViewController.preferredStyle {
            case .YXAlertViewControllerStyleAlert:
                alertViewController.alertView!.alpha = 0.0
                alertViewController.alertView!.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    break
            case .YXAlertViewControllerStyleActionSheet:
                alertViewController.alertView!.transform = CGAffineTransform(translationX: 0, y: alertViewController.alertView!.frame.height)
                    break
                default:
                    break
            }
        } completion: { Bool in
            
            transitionContext.completeTransition(true)
        }
    }
    
}
