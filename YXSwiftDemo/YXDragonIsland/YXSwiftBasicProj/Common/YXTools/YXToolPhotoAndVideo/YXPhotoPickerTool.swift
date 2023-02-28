//
//  YXPhotoPickerTool.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/3.
//

import UIKit
import AVKit
import AVFoundation
import Photos

struct PhotoSource: OptionSet {
    let rawValue:Int
    static let camera = PhotoSource(rawValue: 1)
    static let photoLibrary = PhotoSource(rawValue: 1 << 1)
}

typealias finishedImageBlock = (_ image: UIImage) -> ()

var audioPlayer : AVAudioPlayer?
var playViewController = AVPlayerViewController()
var videoPlayer = AVPlayer()

class YXPhotoPickerTool: NSObject {

    /** 单例 */
    static let pickerTool = YXPhotoPickerTool()
    
    var finishedImageBlock : finishedImageBlock?
    var isEditor = false
    
    private override init() {}
    
    //MARK: - 相册相关
    /** 选择图片 */
    func choosePicture(_ controller: UIViewController, editor: Bool, options: PhotoSource = [.camera, .photoLibrary], finished: @escaping finishedImageBlock) {
        
        finishedImageBlock = finished
        isEditor = editor
        
        if options.contains(.camera) && options.contains(.photoLibrary) {
            let alertController = UIAlertController(title: "请选择图片", message: nil, preferredStyle: .actionSheet)
            let photographAction = UIAlertAction(title: "拍照", style: .default) { (_) in
                
                self.openCamera(controller: controller, editor: editor)
            }
            let photoAction = UIAlertAction(title: "从相册选取", style: .default) { (_) in
                
                self.openPhotoLibrary(controller: controller, editor: editor)
            }
            let cannelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            alertController.addAction(photographAction)
            alertController.addAction(photoAction)
            alertController.addAction(cannelAction)
            controller.present(alertController, animated: true, completion: nil)
        }
        else if options.contains(.photoLibrary) {
            self.openPhotoLibrary(controller: controller, editor: editor)
        }
        else if options.contains(.camera) {
            self.openCamera(controller: controller, editor: editor)
        }
    }
    
    /** 打开相册 */
    func openPhotoLibrary(controller: UIViewController, editor: Bool) {
        
        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = .photoLibrary
        photo.allowsEditing = editor
        controller.present(photo, animated: true, completion: nil)
    }
    
    /** 打开相机 */
    func openCamera(controller: UIViewController, editor: Bool) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = .camera
        photo.allowsEditing = editor
        controller.present(photo, animated: true, completion: nil)
    }
    
    //MARK: - 确认弹出框
    class func confirm(title: String?, message: String?, controller: UIViewController, handler: ( (UIAlertAction) -> Swift.Void)? = nil) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let entureAction = UIAlertAction(title: "确定", style: .destructive, handler: handler)
        
        alertVC.addAction(entureAction)
        controller.present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - 音频相关
    /** 停止音频 */
    class func stopAudioPlayer() {
        
        guard let temAudioPlayer = audioPlayer else { return }
        temAudioPlayer.stop()
    }
    
    /** 播放音频 */
    class func playAudioWithPath(sound: String) {
        
        var url:URL?
        if sound.hasPrefix("http") { //远程的地址
            url = URL.init(string: sound)
        }
        else { //本地的路径
            guard let soundPath = Bundle.main.path(forResource: sound, ofType: nil) else {
                NSLog("没找到相关音频")
                return
            }
            
            url = URL.init(fileURLWithPath: soundPath)
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer.init(contentsOf: url!)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
        catch let audioError as NSError {
            NSLog(audioError.debugDescription)
        }
    }
    
    //MARK: - 视频相关
    /** 播放视频 */
    class func playVideoWithPath(video: String, viewController: UIViewController) {
        
        var url:URL?
        if video.hasPrefix("http") { //远程的地址
            url = URL.init(string: video)
        }
        else{ //本地的路径
            guard let videoPath = Bundle.main.path(forResource: video, ofType: nil) else {
                NSLog("没找到相关视频")
                return
            }
            
            url = URL.init(fileURLWithPath: videoPath)
        }
        
        videoPlayer = AVPlayer.init(url: url!)
        playViewController.player = videoPlayer
        
        /**
         可以设置的值及意义如下：
         AVLayerVideoGravityResizeAspect  不进行比例缩放 以宽高中长的一边充满为基准(defult)
         AVLayerVideoGravityResizeAspectFill 不进行比例缩放 以宽高中短的一边充满为基准
         AVLayerVideoGravityResize    进行缩放充满屏幕
         */
        playViewController.videoGravity = AVLayerVideoGravity.resizeAspect
        viewController.present(playViewController, animated: true) {
            
            playViewController.player?.play()
        }
    }
    
}

//MARK: - 由于AVPlayerViewController不能被继承, 如果想要实现只支持横屏播放的话, 可以考虑用extension
//extension AVPlayerViewController {
//
//    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//
//        return .landscapeLeft
//    }
//}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension YXPhotoPickerTool: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[(isEditor ? UIImagePickerController.InfoKey.editedImage : UIImagePickerController.InfoKey.originalImage).rawValue] as? UIImage else { return }
        
        picker.dismiss(animated: true) { [weak self] in
            
            guard let tmpFinishedImg = self?.finishedImageBlock else { return }
            tmpFinishedImg(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - 存储音视频/图片
public enum YXToolLocalSaveMediaType: Int {
    /** 图片 */
    case yxToolLocalSaveMediaTypeImg = 0
    /** 视频 */
    case yxToolLocalSaveMediaTypeVideo = 1
    /** 音频 */
    case yxToolLocalSaveMediaTypeAudio = 2
}
extension YXPhotoPickerTool {
    
    public func yxSaveMediaByPath(path: String, mediaType: YXToolLocalSaveMediaType, successBlock: @escaping ((_ isSuccess: Bool) -> Void), failBlock: @escaping ((_ isFail: Any) -> Void)) {
        
        let url = NSURL.init(string: path)
        var resourceType: PHAssetResourceType = .photo
        switch (mediaType) {
        case .yxToolLocalSaveMediaTypeImg:
            resourceType = .photo
        case .yxToolLocalSaveMediaTypeVideo:
            resourceType = .video
        case .yxToolLocalSaveMediaTypeAudio:
            resourceType = .audio
        }
        
        PHPhotoLibrary.shared().performChanges {
            
            let options = PHAssetResourceCreationOptions.init()
            PHAssetCreationRequest.forAsset().addResource(with: resourceType, fileURL: url! as URL, options: options)
        } completionHandler: { success, error in
            
            if (success) {
                successBlock(success)
            }
            else {
                failBlock(error?.localizedDescription as Any)
            }
        }

    }
}
