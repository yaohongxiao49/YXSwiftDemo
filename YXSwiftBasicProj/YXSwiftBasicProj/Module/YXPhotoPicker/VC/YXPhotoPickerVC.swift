//
//  YXPhotoPickerVC.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/2.
//

import UIKit
import Photos

class YXPhotoPickerVC: YXBaseVC {
    
    //相册资源集合
    lazy var photosArray : PHFetchResult<PHAsset> = {
        
        let allOptions = PHFetchOptions()
        //按照时间排序
        //这里设置的key = 'creationDate' 排序字段可以按照已有的属性去查 ascending:升序和降序属性
        allOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
        let allResults = PHAsset.fetchAssets(with: allOptions)
        
        return allResults
    }()
    
    //MARK: - 初始化声明
    lazy var collectionView: YXBaseCollectionViewHorizontal = {
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 40, height: 40)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        
        let collectionView = YXBaseCollectionViewHorizontal.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        collectionView.register(YXPhotoPickerCell.classForCoder(), forCellWithReuseIdentifier: NSStringFromClass(YXPhotoPickerCell.classForCoder()))
        
        collectionView.snp.makeConstraints { make in
            
            make.top.equalTo(self.navigationView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        
        return collectionView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationView.titleLab.text = "相册数据"
        self.navigationView.backBtn.isHidden = false
        self.collectionView.reloadData()
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension YXPhotoPickerVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.photosArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : YXPhotoPickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(YXPhotoPickerCell.classForCoder()), for: indexPath) as! YXPhotoPickerCell
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let pickerCell = cell as! YXPhotoPickerCell
        
        let asset: PHAsset? = self.photosArray[indexPath.row]
        if asset!.mediaType == .image {
            let size = CGSize(width: asset!.pixelWidth, height: asset!.pixelHeight)
            PHCachingImageManager.default().requestImage(for: asset!, targetSize: size, contentMode: .aspectFill, options: .none) { (img, dic) in
                
                pickerCell.imgV.image = img
            }
        }
        else if asset!.mediaType == .video {
            let option = PHVideoRequestOptions()
            option.version = .current
            option.deliveryMode = .automatic
            option.isNetworkAccessAllowed = true
            
            PHCachingImageManager.default().requestAVAsset(forVideo: asset!, options: option) { (avsset, mix, dict) in
                if avsset != nil {
//                    guard let uslAsset: AVURLAsset = avsset as? AVURLAsset else {return}
                    
                    let generator = AVAssetImageGenerator.init(asset: avsset!)
                    generator.appliesPreferredTrackTransform = true
                    let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
                    var actualTime:CMTime = CMTimeMake(value: 0, timescale: 0)
                    let imageRef:CGImage = try! generator.copyCGImage(at: time, actualTime: &actualTime)
                    
                    DispatchQueue.main.async {
                        
                        pickerCell.imgV.image = UIImage.init(cgImage: imageRef)
                        let getSeconds = NSInteger(round(CMTimeGetSeconds(avsset!.duration)))
                        let seconds = getSeconds % 60
                        let minutes = getSeconds % 3600 / 60
                        let hours = getSeconds / 3600
                        print("视频时长 == \(hours):\(minutes):\(seconds)")
                    }
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.classForCoder()), for: indexPath)
            
            return headerReusableView
        }
        else {
            let footerReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(UICollectionReusableView.classForCoder()), for: indexPath)
            
            return footerReusableView
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension YXPhotoPickerVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize.zero
    }
    
}
