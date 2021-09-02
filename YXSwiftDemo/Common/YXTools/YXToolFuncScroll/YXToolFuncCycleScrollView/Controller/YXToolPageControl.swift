//
//  YXToolPageControl.swift
//  YXAccordingProj
//
//  Created by ios on 2021/5/13.
//

import UIKit

class YXToolPageControl: UIPageControl {

    /** 普通分页图片 */
    var norImg: UIImage?
    /** 选中分页图片 */
    var selImg: UIImage?

    //MARK:- 设置当前页码
    override var currentPage: Int {
        
        didSet {
            if self.selImg != nil && self.norImg != nil {
                for i in 0 ..< self.subviews.count {
                    let bgView: UIView = self.subviews[i]
                    bgView.frame = CGRect.init(x: bgView.frame.origin.x, y: bgView.frame.origin.y, width: 6.0, height: 6.0)
                    if bgView.subviews.count == 0 {
                        let view: UIImageView = UIImageView.init(frame: bgView.bounds)
                        bgView.addSubview(view)
                    }
                    
                    let img: UIImageView = bgView.subviews[0] as! UIImageView
                    img.contentMode = .center
                    
                    if i == currentPage {
                        img.image = self.selImg
                    }
                    else {
                        img.image = self.norImg
                    }
                    
                    bgView.backgroundColor = UIColor.clear
                }
                
                self.transform = .identity
            }
        }
    }

}
