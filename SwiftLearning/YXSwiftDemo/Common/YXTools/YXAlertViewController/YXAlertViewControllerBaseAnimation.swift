//
//  YXAlertViewControllerBaseAnimation.swift
//  YXAccordingProj
//
//  Created by ios on 2021/5/20.
//

import UIKit

class YXAlertViewControllerBaseAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private(set) var isPresenting: Bool?
    
    public static func alertAnimationIsPresenting(isPresenting: Bool) -> Self {
        
        let animation: Self = self.classForCoder().alloc() as! Self
        return animation.initWithIsPresenting(isPresenting: isPresenting)
    }
    
    public static func alertAnimationIsPresenting(isPresenting: Bool, preferredStyle:YXAlertViewControllerStyle) -> Self {
        
        let animation: Self = self.classForCoder().alloc() as! Self
        return animation.initWithIsPresenting(isPresenting: isPresenting)
    }
    
    func presentAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        
    }
    func dismissAnimateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        
    }
    
    private func initWithIsPresenting(isPresenting: Bool) -> Self {
        
        self.isPresenting = isPresenting
        
        return self
    }
    
    //MARK:- UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
     
        if self.isPresenting! {
            presentAnimateTransition(transitionContext: transitionContext)
        }
        else {
            dismissAnimateTransition(transitionContext: transitionContext)
        }
    }

}
