//
//  EditorImageResizerView+ControlView.swift
//  HXPHPicker
//
//  Created by Slience on 2021/8/25.
//

import UIKit

// MARK: EditorImageResizerControlViewDelegate
extension EditorImageResizerView: EditorImageResizerControlViewDelegate {
    
    func controlView(beganChanged controlView: EditorImageResizerControlView, _ rect: CGRect) {
        delegate?.imageResizerView(willChangedMaskRect: self)
        hideMaskBgView()
        stopControlTimer()
    }
    func controlView(didChanged controlView: EditorImageResizerControlView, _ rect: CGRect) {
        stopControlTimer()
        if state == .normal {
            return
        }
        maskBgView.updateLayers(rect, false)
        maskLinesView.updateLayers(rect, false)
        
        scrollView.minimumZoomScale = getScrollViewMinimumZoomScale(rect)
        var imageViewHeight: CGFloat
        var imageViewWidth: CGFloat
        switch getImageOrientation() {
        case .up, .down:
            imageViewWidth = imageView.width
            imageViewHeight = imageView.height
        case .left, .right:
            imageViewWidth = imageView.height
            imageViewHeight = imageView.width
        }
        var changedZoomScale = false
        if rect.height > imageViewHeight {
            let imageZoomScale = rect.height / imageViewHeight
            let zoomScale = scrollView.zoomScale
            scrollView.setZoomScale(zoomScale * imageZoomScale, animated: false)
            changedZoomScale = true
        }
        if rect.width > imageViewWidth {
            let imageZoomScale = rect.width / imageViewWidth
            let zoomScale = scrollView.zoomScale
            scrollView.setZoomScale(zoomScale * imageZoomScale, animated: false)
            changedZoomScale = true
        }
        if !changedZoomScale {
            updateScrollViewContentInset(controlView.frame)
        }
    }
    func controlView(endChanged controlView: EditorImageResizerControlView, _ rect: CGRect) {
        startControlTimer()
    }
    func startControlTimer() {
        controlTimer?.invalidate()
        let timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(controlTimerAction),
            userInfo: nil,
            repeats: false
        )
        controlTimer = timer
        inControlTimer = true
    }
    
    func stopControlTimer() {
        controlTimer?.invalidate()
        controlTimer = nil
    }
    
    @objc func controlTimerAction() {
        adjustmentViews(true)
    }
    func adjustmentViews(_ animated: Bool, showMaskShadow: Bool = true) {
        maskBgViewisShowing = true
        /// ??????????????????
        showMaskBgView()
        /// ???????????????
        stopControlTimer()
        /// ????????????
        let maxHeight = containerView.height - contentInsets.top - contentInsets.bottom
        /// ?????????x
        var rectX = contentInsets.left
        /// ??????????????????
        var rectW = containerView.width - contentInsets.left - contentInsets.right
        /// ???????????????
        var rectH = rectW / controlView.width * controlView.height
        if rectH > maxHeight {
            /// ??????????????????????????????????????????
            rectW = maxHeight / rectH *  rectW
            rectH = maxHeight
            rectX = controlView.maxImageresizerFrame.midX - rectW * 0.5
        }
        /// ?????????y
        let rectY = controlView.maxImageresizerFrame.midY - rectH * 0.5
        /// ??????????????????????????????
        let rect = CGRect(x: rectX, y: rectY, width: rectW, height: rectH)
        /// ????????????????????????
        let beforeRect = controlView.frame
        /// ??????????????????imageView????????????
        let controlBeforeRect = maskBgView.convert(controlView.frame, to: imageView)
        /// ????????????
        maskLinesView.setupShadow(true)
        /// ?????????????????????
        updateMaskViewFrame(to: rect, animated: animated)
        /// ????????????????????????imageView????????????
        let controlAfterRect = maskBgView.convert(controlView.frame, to: imageView)
        let scrollCotentInset = getScrollViewContentInset(rect)
        /// ??????scrollView?????????
        var offset = scrollView.contentOffset
        var offsetX: CGFloat
        var offsetY: CGFloat
        switch getImageOrientation() {
        case .up:
            if mirrorType == .horizontal {
                offsetX = offset.x + (rect.midX - beforeRect.midX)
            }else {
                offsetX = offset.x - (rect.midX - beforeRect.midX)
            }
            offsetY = offset.y - (rect.midY - beforeRect.midY)
        case .left:
            offsetX = offset.x + (rect.midY - beforeRect.midY)
            if mirrorType == .horizontal {
                offsetY = offset.y + (rect.midX - beforeRect.midX)
            }else {
                offsetY = offset.y - (rect.midX - beforeRect.midX)
            }
        case .down:
            if mirrorType == .horizontal {
                offsetX = offset.x - (rect.midX - beforeRect.midX)
            }else {
                offsetX = offset.x + (rect.midX - beforeRect.midX)
            }
            offsetY = offset.y + (rect.midY - beforeRect.midY)
        case .right:
            offsetX = offset.x - (rect.midY - beforeRect.midY)
            if mirrorType == .horizontal {
                offsetY = offset.y - (rect.midX - beforeRect.midX)
            }else {
                offsetY = offset.y + (rect.midX - beforeRect.midX)
            }
        }
        offset = checkZoomOffset(CGPoint(x: offsetX, y: offsetY), scrollCotentInset)
        let zoomScale = getZoomScale(fromRect: controlBeforeRect, toRect: controlAfterRect)
        let needZoomScale = zoomScale != scrollView.zoomScale
        if animated {
            isUserInteractionEnabled = false
            let currentOffset = scrollView.contentOffset
            scrollView.setContentOffset(currentOffset, animated: false)
            UIView.animate(
                withDuration: animationDuration,
                delay: 0,
                options: [.curveLinear]
            ) {
                self.updateScrollViewContentInset(rect)
                if needZoomScale {
                    /// ??????????????????
                    self.scrollView.zoomScale = zoomScale
                    offset = self.getZoomOffset(
                        fromRect: controlBeforeRect,
                        zoomScale: zoomScale,
                        scrollCotentInset: scrollCotentInset
                    )
                }
                self.scrollView.contentOffset = offset
            } completion: { (isFinished) in
                if showMaskShadow {
                    self.maskLinesView.setupShadow(false)
                }
                self.maskBgViewisShowing = false
                self.inControlTimer = false
                self.delegate?.imageResizerView(didEndChangedMaskRect: self)
                self.isUserInteractionEnabled = true
            }
        }else {
            updateScrollViewContentInset(rect)
            if needZoomScale {
                /// ??????????????????
                scrollView.zoomScale = zoomScale
                offset = getZoomOffset(
                    fromRect: controlBeforeRect,
                    zoomScale: zoomScale,
                    scrollCotentInset: scrollCotentInset
                )
            }
            scrollView.contentOffset = offset
            if showMaskShadow {
                maskLinesView.setupShadow(false)
            }
            maskBgViewisShowing = false
            inControlTimer = false
            delegate?.imageResizerView(didEndChangedMaskRect: self)
        }
    }
    func checkZoomOffset(_ offset: CGPoint, _ scrollCotentInset: UIEdgeInsets) -> CGPoint {
        var offsetX = offset.x
        var offsetY = offset.y
        var maxOffsetX: CGFloat
        var maxOffsetY: CGFloat
        switch getImageOrientation() {
        case .up:
            maxOffsetX = scrollView.contentSize.width - scrollView.width + scrollCotentInset.left
            maxOffsetY = scrollView.contentSize.height - scrollView.height + scrollCotentInset.bottom
        case .right:
            maxOffsetX = scrollView.contentSize.width - scrollView.height + scrollCotentInset.right
            maxOffsetY = scrollView.contentSize.height - scrollView.width + scrollCotentInset.bottom
        case .down:
            maxOffsetX = scrollView.contentSize.width - scrollView.width + scrollCotentInset.left
            maxOffsetY = scrollView.contentSize.height - scrollView.height + scrollCotentInset.bottom
        case .left:
            maxOffsetX = scrollView.contentSize.width - scrollView.height + scrollCotentInset.right
            maxOffsetY = scrollView.contentSize.height - scrollView.width + scrollCotentInset.top
        }
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        if offsetX < -scrollCotentInset.left {
            offsetX = -scrollCotentInset.left
        }
        if offsetY > maxOffsetY {
            offsetY = maxOffsetY
        }
        if offsetY < -scrollCotentInset.top {
            offsetY = -scrollCotentInset.top
        }
        return CGPoint(x: offsetX, y: offsetY)
    }
    func getZoomOffset(fromRect: CGRect, zoomScale: CGFloat, scrollCotentInset: UIEdgeInsets) -> CGPoint {
        let offsetX = fromRect.minX * zoomScale - scrollView.contentInset.left
        let offsetY = fromRect.minY * zoomScale - scrollView.contentInset.top
        return checkZoomOffset(CGPoint(x: offsetX, y: offsetY), scrollCotentInset)
    }
    func getExactnessSize(_ size: CGSize) -> CGSize {
        CGSize(
            width: CGFloat(Float(String(format: "%.2f", size.width))!),
            height: CGFloat(Float(String(format: "%.2f", size.height))!)
        )
    }
    func getZoomScale(fromRect: CGRect, toRect: CGRect) -> CGFloat {
        var widthScale = toRect.width / fromRect.width
        let fromSize = getExactnessSize(fromRect.size)
        let toSize = getExactnessSize(toRect.size)
        /// ???????????????????????????
        var isMaxZoom = fromSize.equalTo(toSize)
        if scrollView.zoomScale * widthScale > scrollView.maximumZoomScale {
            let scale = scrollView.maximumZoomScale - scrollView.zoomScale
            if scale > 0 {
                widthScale = scrollView.maximumZoomScale
            }else {
                isMaxZoom = true
            }
        }else {
            widthScale *= scrollView.zoomScale
        }
        return isMaxZoom ? scrollView.zoomScale : widthScale
    }
}
