//
//  YXSegmentCollectionView.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/2.
//

import UIKit

public class YXSegmentCollectionView: UICollectionView, UIGestureRecognizerDelegate {

    public var isPanSimultaneously: Bool = true
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard self.isPanSimultaneously else {
            return false
        }
        
        if let otherPan: UIPanGestureRecognizer = otherGestureRecognizer as? UIPanGestureRecognizer {
            let point = otherPan.translation(in: otherPan.view)
            if point.x > 0 && self.contentOffset.x <= -self.contentInset.left {
                return true
            }
            else if point.x < 0 && self.contentOffset.x >= self.contentSize.width - self.frame.width - self.contentInset.left + self.contentInset.right {
                return true
            }
        }
        
        return false
    }

}
