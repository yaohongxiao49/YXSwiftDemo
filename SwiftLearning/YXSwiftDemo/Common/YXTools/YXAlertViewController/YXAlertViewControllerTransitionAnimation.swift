//
//  YXAlertViewControllerTransitionAnimation.swift
//  YXAccordingProj
//
//  Created by ios on 2021/5/20.
//

import Foundation
import UIKit

extension YXAlertViewController {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
     
        switch self.transitionAnimation {
        case .YXAlertTransitionAnimationFade:
            return YXAlertViewControllerFadeAnimation.alertAnimationIsPresenting(isPresenting: true)
        case .YXAlertTransitionAnimationScaleFade:
            return YXAlertViewControllerScaleFadeAnimation.alertAnimationIsPresenting(isPresenting: true)
        case .YXAlertTransitionAnimationDropDown:
            return YXAlertViewControllerScaleFadeAnimation.alertAnimationIsPresenting(isPresenting: true)
        case .YXAlertTransitionAnimationCustom:
            return YXAlertViewControllerBaseAnimation.alertAnimationIsPresenting(isPresenting: true, preferredStyle: self.preferredStyle!)
        default:
            return nil
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch (self.transitionAnimation) {
        case .YXAlertTransitionAnimationFade:
            return YXAlertViewControllerFadeAnimation.alertAnimationIsPresenting(isPresenting: false)
        case .YXAlertTransitionAnimationScaleFade:
            return YXAlertViewControllerScaleFadeAnimation.alertAnimationIsPresenting(isPresenting: false)
        case .YXAlertTransitionAnimationDropDown:
            return YXAlertViewControllerScaleFadeAnimation.alertAnimationIsPresenting(isPresenting: false)
        case .YXAlertTransitionAnimationCustom:
            return YXAlertViewControllerBaseAnimation.alertAnimationIsPresenting(isPresenting: false, preferredStyle: self.preferredStyle!)
        default:
            return nil
        }
    }

}
