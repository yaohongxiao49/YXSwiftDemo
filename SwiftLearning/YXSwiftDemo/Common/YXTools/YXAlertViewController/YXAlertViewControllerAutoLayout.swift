//
//  YXAlertViewControllerAutoLayout.swift
//  YXAccordingProj
//
//  Created by ios on 2021/5/20.
//

import Foundation
import UIKit

public extension UIView {
    
    func addConstraintToView(view: UIView, edgeInset: UIEdgeInsets) {
        
        addConstarintWithView(view: view, topView: self, leftView: self, bottomView: self, rightView: self, edgeInset: edgeInset)
    }
    
    func addConstarintWithView(view: UIView, topView: UIView?, leftView: UIView?, bottomView: UIView?, rightView: UIView?, edgeInset:UIEdgeInsets) {
     
        if topView != nil {
            addConstraint(NSLayoutConstraint.init(item: view, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: topView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: edgeInset.top))
        }
        if leftView != nil {
            addConstraint(NSLayoutConstraint.init(item: view, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: leftView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: edgeInset.left))
        }
        if rightView != nil {
            addConstraint(NSLayoutConstraint.init(item: view, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: rightView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: edgeInset.right))
        }
        if bottomView != nil {
            addConstraint(NSLayoutConstraint.init(item: view, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: bottomView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: edgeInset.bottom))
        }
    }
    
    func addConstarintWithLeftView(letView: UIView, toRightView: UIView, constant: CGFloat) {
        
        addConstraint(NSLayoutConstraint.init(item: letView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toRightView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant: -constant))
    }
    
    func addConstarintWithTopView(topView: UIView, toBottomView: UIView, constant: CGFloat) -> NSLayoutConstraint {
        
        let topButtomConstraint: NSLayoutConstraint = NSLayoutConstraint.init(item: topView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: toBottomView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: -constant)
        addConstraint(topButtomConstraint)
        return topButtomConstraint
    }

    func addConstarintWidth(width: CGFloat, height: CGFloat) {
        
        if width > 0 {
            addConstraint(NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: width))
        }
        
        if height > 0 {
            addConstraint(NSLayoutConstraint.init(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: height))
        }
    }

    func addConstarintEqualWithView(view: UIView, widthToView: UIView?, heightToView: UIView?) {
        
        if widthToView != nil {
            addConstraint(NSLayoutConstraint.init(item: view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: widthToView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0))
        }
        
        if heightToView != nil {
            addConstraint(NSLayoutConstraint.init(item: view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: heightToView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0))
        }
    }

    func addConstraintCenterXToView(centerXToView: UIView?, centerYToView: UIView?) {
        
        if centerXToView != nil {
            addConstraint(NSLayoutConstraint.init(item: centerXToView!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0))
        }
        
        if centerYToView != nil {
            addConstraint(NSLayoutConstraint.init(item: centerYToView!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1.0, constant: 0))
        }
    }

    func addConstraintCenterYToView(centerYToView: UIView?, constant: CGFloat) -> NSLayoutConstraint? {
            
        if centerYToView != nil {
            let centerYConstraint: NSLayoutConstraint = NSLayoutConstraint.init(item: centerYToView!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: constant)
            addConstraint(centerYConstraint)
            return centerYConstraint
        }
        return nil
    }
    
    func removeConstraintWithAttribte(attr: NSLayoutConstraint.Attribute) {
        
        for constraint: NSLayoutConstraint in self.constraints {
            if constraint.firstAttribute == attr {
                removeConstraint(constraint)
                break
            }
        }
    }

    func removeConstraintWithView(view: UIView, attr: NSLayoutConstraint.Attribute) {
        
        for constraint: NSLayoutConstraint in self.constraints {
            if constraint.firstAttribute == attr && constraint.firstItem as! NSObject == view {
                removeConstraint(constraint)
                break
            }
        }
    }

    func removeAllConstraints() {
        
        removeConstraints(self.constraints)
    }
}
