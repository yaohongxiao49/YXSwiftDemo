//
//  YXAlertViewControllerDropDownAnimation.swift
//  YXAccordingProj
//
//  Created by ios on 2021/5/20.
//

import UIKit

class YXAlertViewControllerDropDownAnimation: YXAlertViewControllerBaseAnimation {

    //MARK:- UIViewControllerAnimatedTransitioning
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            
        if self.isPresenting! {
            return 0.5
        }
        return 0.25
    }

    override func presentAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let alertViewController: YXAlertViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! YXAlertViewController
        alertViewController.backgroundView!.alpha = 0.0
        
        switch alertViewController.preferredStyle {
        case .YXAlertViewControllerStyleAlert:
            alertViewController.alertView!.transform = CGAffineTransform(translationX: 0, y: -alertViewController.alertView!.frame.maxY)
            break
        case .YXAlertViewControllerStyleActionSheet:
            
            break
        default:
            break
        }
        
        let containerView: UIView = transitionContext.containerView
        containerView.addSubview(alertViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.layoutSubviews) {
            
            alertViewController.backgroundView!.alpha = 1.0
            alertViewController.alertView!.transform = CGAffineTransform.identity
        } completion: { Bool in
         
            transitionContext.completeTransition(true)
        }
    }
    
    override func dismissAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let alertViewController: YXAlertViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! YXAlertViewController
        
        UIView.animate(withDuration: 0.25) {
            
            alertViewController.backgroundView!.alpha = 0.0
            switch alertViewController.preferredStyle {
            case .YXAlertViewControllerStyleAlert:
                alertViewController.alertView!.alpha = 0.0
                alertViewController.alertView!.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    break
            case .YXAlertViewControllerStyleActionSheet:
                    break
                default:
                    break
            }
        } completion: { Bool in
            
            transitionContext.completeTransition(true)
        }
    }
}
