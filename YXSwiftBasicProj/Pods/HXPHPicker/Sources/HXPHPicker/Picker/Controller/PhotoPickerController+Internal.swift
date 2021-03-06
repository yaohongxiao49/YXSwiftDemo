//
//  PhotoPickerController+Internal.swift
//  HXPHPicker
//
//  Created by Slience on 2021/8/25.
//

import UIKit
import AVFoundation
import Photos

// MARK: ViewControllers function
extension PhotoPickerController {
    func finishCallback() {
        #if HXPICKER_ENABLE_EDITOR
        removeAllEditedPhotoAsset()
        #endif
        let result = PickerResult(
            photoAssets: selectedAssetArray,
            isOriginal: isOriginal
        )
        finishHandler?(result, self)
        pickerDelegate?.pickerController(
            self,
            didFinishSelection: result
        )
        if isExternalPickerPreview {
            disablesCustomDismiss = true
        }
        if autoDismiss {
            dismiss(animated: true, completion: nil)
        }
    }
    func singleFinishCallback(for photoAsset: PhotoAsset) {
        #if HXPICKER_ENABLE_EDITOR
        removeAllEditedPhotoAsset()
        #endif
        let result = PickerResult(
            photoAssets: [photoAsset],
            isOriginal: isOriginal
        )
        finishHandler?(result, self)
        pickerDelegate?.pickerController(
            self,
            didFinishSelection: result
        )
        if isExternalPickerPreview {
            disablesCustomDismiss = true
        }
        if autoDismiss {
            dismiss(animated: true, completion: nil)
        }
    }
    func cancelCallback() {
        #if HXPICKER_ENABLE_EDITOR
        for photoAsset in editedPhotoAssetArray {
            photoAsset.photoEdit = photoAsset.initialPhotoEdit
            photoAsset.videoEdit = photoAsset.initialVideoEdit
        }
        editedPhotoAssetArray.removeAll()
        #endif
        cancelHandler?(self)
        pickerDelegate?.pickerController(didCancel: self)
        if autoDismiss {
            dismiss(animated: true, completion: nil)
        }else {
            if pickerDelegate == nil && cancelHandler == nil {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    func originalButtonCallback() {
        pickerDelegate?.pickerController(
            self,
            didOriginalButton: isOriginal
        )
    }
    func shouldPresentCamera() -> Bool {
        if let shouldPresent = pickerDelegate?.pickerController(
            shouldPresentCamera: self
        ) {
            return shouldPresent
        }
        return true
    }
    func previewUpdateCurrentlyDisplayedAsset(
        photoAsset: PhotoAsset,
        index: Int
    ) {
        pickerDelegate?.pickerController(
            self,
            previewUpdateCurrentlyDisplayedAsset: photoAsset,
            atIndex: index
        )
    }
    func shouldClickCell(
        photoAsset: PhotoAsset,
        index: Int
    ) -> Bool {
        if let shouldClick = pickerDelegate?.pickerController(
            self,
            shouldClickCell: photoAsset,
            atIndex: index
        ) {
            return shouldClick
        }
        return true
    }
    func shouldEditAsset(
        photoAsset: PhotoAsset,
        atIndex: Int
    ) -> Bool {
        if let shouldEditAsset = pickerDelegate?.pickerController(
            self,
            shouldEditAsset: photoAsset,
            atIndex: atIndex
        ) {
            return shouldEditAsset
        }
        return true
    }
    func didEditAsset(
        photoAsset: PhotoAsset,
        atIndex: Int
    ) {
        pickerDelegate?.pickerController(
            self,
            didEditAsset: photoAsset,
            atIndex: atIndex
        )
    }
    func previewShouldDeleteAsset(
        photoAsset: PhotoAsset,
        index: Int
    ) -> Bool {
        if let previewShouldDeleteAsset = pickerDelegate?.pickerController(
            self,
            previewShouldDeleteAsset: photoAsset,
            atIndex: index
        ) {
            return previewShouldDeleteAsset
        }
        return true
    }
    func previewDidDeleteAsset(
        photoAsset: PhotoAsset,
        index: Int
    ) {
        pickerDelegate?.pickerController(
            self,
            previewDidDeleteAsset: photoAsset,
            atIndex: index
        )
    }
    func viewControllersWillAppear(_ viewController: UIViewController) {
        pickerDelegate?.pickerController(
            self,
            viewControllersWillAppear: viewController
        )
    }
    func viewControllersDidAppear(_ viewController: UIViewController) {
        pickerDelegate?.pickerController(
            self,
            viewControllersDidAppear: viewController
        )
    }
    func viewControllersWillDisappear(_ viewController: UIViewController) {
        pickerDelegate?.pickerController(
            self,
            viewControllersWillDisappear: viewController
        )
    }
    func viewControllersDidDisappear(_ viewController: UIViewController) {
        pickerDelegate?.pickerController(
            self,
            viewControllersDidDisappear: viewController
        )
    }
    
    /// ??????????????????????????????
    /// - Parameters:
    ///   - isPreview: ???????????????????????????
    ///   - completion: ????????????
    func requestSelectedAssetFileSize(
        isPreview: Bool,
        completion: @escaping (Int, String) -> Void
    ) {
        cancelRequestAssetFileSize(isPreview: isPreview)
        let operation = BlockOperation()
        operation.addExecutionBlock { [unowned operation] in
            var totalFileSize = 0
            var total: Int = 0
             
            func calculationCompletion(_ totalSize: Int) {
                DispatchQueue.main.async {
                    completion(
                        totalSize,
                        PhotoTools.transformBytesToString(
                                bytes: totalSize
                        )
                    )
                }
            }
            
            for photoAsset in self.selectedAssetArray {
                if operation.isCancelled {
                    return
                }
                if let fileSize = photoAsset.getPFileSize() {
                    totalFileSize += fileSize
                    total += 1
                    if total == self.selectedAssetArray.count {
                        calculationCompletion(totalFileSize)
                    }
                    continue
                }
                let requestId = photoAsset.checkAdjustmentStatus { (isAdjusted, asset) in
                    if isAdjusted {
                        if asset.mediaType == .photo {
                            asset.requestImageData(
                                iCloudHandler: nil,
                                progressHandler: nil
                            ) { sAsset, result in
                                switch result {
                                case .success(let dataResult):
                                    sAsset.updateFileSize(dataResult.imageData.count)
                                    totalFileSize += sAsset.fileSize
                                    total += 1
                                    if total == self.selectedAssetArray.count {
                                        calculationCompletion(totalFileSize)
                                    }
                                case .failure(_):
                                    total += 1
                                    if total == self.selectedAssetArray.count {
                                        calculationCompletion(totalFileSize)
                                    }
                                }
                            }
                        }else {
                            asset.requestAVAsset(iCloudHandler: nil, progressHandler: nil) { (sAsset, avAsset, info) in
                                if let urlAsset = avAsset as? AVURLAsset {
                                    totalFileSize += urlAsset.url.fileSize
                                }
                                total += 1
                                if total == self.selectedAssetArray.count {
                                    calculationCompletion(totalFileSize)
                                }
                            } failure: { (sAsset, info, error) in
                                total += 1
                                if total == self.selectedAssetArray.count {
                                    calculationCompletion(totalFileSize)
                                }
                            }
                        }
                        return
                    }else {
                        totalFileSize += asset.fileSize
                    }
                    total += 1
                    if total == self.selectedAssetArray.count {
                        calculationCompletion(totalFileSize)
                    }
                }
                photoAsset.adjustmentStatusId = requestId
            }
        }
        if isPreview {
            previewRequestAssetBytesQueue.addOperation(operation)
        }else {
            requestAssetBytesQueue.addOperation(operation)
        }
    }
    
    /// ??????????????????????????????
    /// - Parameter isPreview: ??????????????????
    func cancelRequestAssetFileSize(isPreview: Bool) {
        for photoAsset in selectedAssetArray {
            if let id = photoAsset.adjustmentStatusId {
                photoAsset.phAsset?.cancelContentEditingInputRequest(id)
                photoAsset.adjustmentStatusId = nil
            }
        }
        if isPreview {
            previewRequestAssetBytesQueue.cancelAllOperations()
        }else {
            requestAssetBytesQueue.cancelAllOperations()
        }
    }
    
    /// ??????????????????
    /// - Parameters:
    ///   - coverImage: ????????????
    ///   - count: ?????????????????????
    func updateAlbums(coverImage: UIImage?, count: Int) {
        for assetCollection in assetCollectionsArray {
            if assetCollection.realCoverImage != nil {
                assetCollection.realCoverImage = coverImage
            }
            assetCollection.count += count
        }
        reloadAlbumData()
    }
    
    /// ?????????????????????????????????PhotoAsset??????
    /// - Parameter photoAsset: ?????????PhotoAsset??????
    func addedLocalCameraAsset(photoAsset: PhotoAsset) {
        photoAsset.localIndex = localCameraAssetArray.count
        localCameraAssetArray.append(photoAsset)
    }
    
    /// ??????PhotoAsset?????????????????????
    /// - Parameter photoAsset: ?????????PhotoAsset??????
    /// - Returns: ????????????
    @discardableResult
    func addedPhotoAsset(
        photoAsset: PhotoAsset,
        filterEditor: Bool = false
    ) -> Bool {
        if singleVideo && photoAsset.mediaType == .video {
            return false
        }
        if config.selectMode == .single {
            // ????????????????????????
            return false
        }
        if selectedAssetArray.contains(photoAsset) {
            photoAsset.isSelected = true
            return true
        }
        let canSelect = canSelectAsset(
            for: photoAsset,
            showHUD: true,
            filterEditor: filterEditor
        )
        if canSelect {
            pickerDelegate?.pickerController(
                self,
                willSelectAsset: photoAsset,
                atIndex: selectedAssetArray.count
            )
            canAddAsset = false
            photoAsset.isSelected = true
            photoAsset.selectIndex = selectedAssetArray.count
            if photoAsset.mediaType == .photo {
                selectedPhotoAssetArray.append(photoAsset)
            }else if photoAsset.mediaType == .video {
                selectedVideoAssetArray.append(photoAsset)
            }
            selectedAssetArray.append(photoAsset)
            pickerDelegate?.pickerController(
                self,
                didSelectAsset: photoAsset,
                atIndex: selectedAssetArray.count - 1
            )
        }
        return canSelect
    }
    
    /// ???????????????PhotoAsset??????
    /// - Parameter photoAsset: ??????PhotoAsset??????
    /// - Returns: ????????????
    @discardableResult
    func removePhotoAsset(photoAsset: PhotoAsset) -> Bool {
        if selectedAssetArray.isEmpty || !selectedAssetArray.contains(photoAsset) {
            return false
        }
        canAddAsset = false
        pickerDelegate?.pickerController(
            self,
            willUnselectAsset: photoAsset,
            atIndex: selectedAssetArray.count
        )
        photoAsset.isSelected = false
        if photoAsset.mediaType == .photo {
            selectedPhotoAssetArray.remove(
                at: selectedPhotoAssetArray.firstIndex(of: photoAsset)!
            )
        }else if photoAsset.mediaType == .video {
            selectedVideoAssetArray.remove(
                at: selectedVideoAssetArray.firstIndex(of: photoAsset)!
            )
        }
        selectedAssetArray.remove(at: selectedAssetArray.firstIndex(of: photoAsset)!)
        for (index, asset) in selectedAssetArray.enumerated() {
            asset.selectIndex = index
        }
        pickerDelegate?.pickerController(
            self,
            didUnselectAsset: photoAsset,
            atIndex: selectedAssetArray.count
        )
        return true
    }
    
    /// ??????????????????Asset
    /// - Parameters:
    ///   - photoAsset: ?????????PhotoAsset
    ///   - showHUD: ????????????HUD
    /// - Returns: ??????
    // swiftlint:disable cyclomatic_complexity
    func canSelectAsset(
        for photoAsset: PhotoAsset,
        showHUD: Bool,
        filterEditor: Bool = false
    ) -> Bool {
        // swiftlint:enable cyclomatic_complexity
        var canSelect = true
        var text: String?
        if photoAsset.mediaType == .photo {
            if config.maximumSelectedPhotoFileSize > 0 {
                if photoAsset.fileSize > config.maximumSelectedPhotoFileSize {
                    text = "??????????????????????????????".localized + PhotoTools.transformBytesToString(
                        bytes: config.maximumSelectedPhotoFileSize
                    )
                    canSelect = false
                }
            }
            if !config.allowSelectedTogether {
                if selectedVideoAssetArray.count > 0 {
                    text = "?????????????????????????????????".localized
                    canSelect = false
                }
            }
            if config.maximumSelectedPhotoCount > 0 {
                if selectedPhotoAssetArray.count >= config.maximumSelectedPhotoCount {
                    text = String.init(format: "??????????????????%d?????????".localized, arguments: [config.maximumSelectedPhotoCount])
                    canSelect = false
                }
            }else {
                if selectedAssetArray.count >= config.maximumSelectedCount && config.maximumSelectedCount > 0 {
                    text = String.init(format: "????????????????????????".localized, arguments: [config.maximumSelectedPhotoCount])
                    canSelect = false
                }
            }
        }else if photoAsset.mediaType == .video {
            if config.maximumSelectedVideoFileSize > 0 {
                if photoAsset.fileSize > config.maximumSelectedVideoFileSize {
                    text = "??????????????????????????????".localized + PhotoTools.transformBytesToString(
                        bytes: config.maximumSelectedVideoFileSize
                    )
                    canSelect = false
                }
            }
            if config.maximumSelectedVideoDuration > 0 {
                if round(photoAsset.videoDuration) > Double(config.maximumSelectedVideoDuration) {
                    #if HXPICKER_ENABLE_EDITOR
                    if !config.editorOptions.contains(.video) || filterEditor {
                        text = String(
                            format: "?????????????????????%d??????????????????".localized,
                            arguments: [config.maximumSelectedVideoDuration]
                        )
                        canSelect = false
                    }else {
                        if config.maximumVideoEditDuration > 0 &&
                            round(photoAsset.videoDuration) > Double(config.maximumVideoEditDuration) {
                            text = String(
                                format: "??????????????????????????????%d??????????????????".localized,
                                arguments: [config.maximumVideoEditDuration]
                            )
                            canSelect = false
                        }
                    }
                    #else
                    text = String(
                        format: "?????????????????????%d??????????????????".localized,
                        arguments: [config.maximumSelectedVideoDuration]
                    )
                    canSelect = false
                    #endif
                }
            }
            if config.minimumSelectedVideoDuration > 0 {
                if round(photoAsset.videoDuration) < Double(config.minimumSelectedVideoDuration) {
                    text = String(
                        format: "?????????????????????%d??????????????????".localized,
                        arguments: [config.minimumSelectedVideoDuration]
                    )
                    canSelect = false
                }
            }
            if !config.allowSelectedTogether {
                if selectedPhotoAssetArray.count > 0 {
                    text = "?????????????????????????????????".localized
                    canSelect = false
                }
            }
            if config.maximumSelectedVideoCount > 0 {
                if selectedVideoAssetArray.count >= config.maximumSelectedVideoCount {
                    text = String.init(format: "??????????????????%d?????????".localized, arguments: [config.maximumSelectedVideoCount])
                    canSelect = false
                }
            }else {
                if selectedAssetArray.count >= config.maximumSelectedCount && config.maximumSelectedCount > 0 {
                    text = String.init(format: "????????????????????????".localized, arguments: [config.maximumSelectedPhotoCount])
                    canSelect = false
                }
            }
        }
        if let shouldSelect = pickerDelegate?.pickerController(
            self,
            shouldSelectedAsset: photoAsset,
            atIndex: selectedAssetArray.count
        ) {
            if canSelect {
                canSelect = shouldSelect
            }
        }
        if let text = text, !canSelect, showHUD {
            if DispatchQueue.isMain {
                ProgressHUD.showWarning(addedTo: view, text: text, animated: true, delayHide: 1.5)
            }else {
                DispatchQueue.main.async {
                    ProgressHUD.showWarning(addedTo: self.view, text: text, animated: true, delayHide: 1.5)
                }
            }
        }
        return canSelect
    }
    
    /// ????????????????????????????????????
    /// - Parameter photoAsset: ?????????PhotoAsset??????
    func videoDurationExceedsTheLimit(photoAsset: PhotoAsset) -> Bool {
        if photoAsset.mediaType == .video {
            if config.maximumSelectedVideoDuration > 0 {
                if round(photoAsset.videoDuration) > Double(config.maximumSelectedVideoDuration) {
                    return true
                }
            }
        }
        return false
    }
    
    /// ???????????????????????????
    func selectArrayIsFull() -> Bool {
        if selectedAssetArray.count >= config.maximumSelectedCount && config.maximumSelectedCount > 0 {
            return true
        }
        return false
    }
    
    #if HXPICKER_ENABLE_EDITOR
    func addedEditedPhotoAsset(_ photoAsset: PhotoAsset) {
        if editedPhotoAssetArray.contains(photoAsset) {
            return
        }
        editedPhotoAssetArray.append(photoAsset)
    }
    func removeAllEditedPhotoAsset() {
        if editedPhotoAssetArray.isEmpty {
            return
        }
        for photoAsset in editedPhotoAssetArray {
            photoAsset.initialPhotoEdit = nil
            photoAsset.initialVideoEdit = nil
        }
        editedPhotoAssetArray.removeAll()
    }
    #endif
}
