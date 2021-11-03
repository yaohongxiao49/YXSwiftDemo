//
//  YXVideoPlayerVC.swift
//  YXSwiftBasicProj
//
//  Created by Believer Just on 2021/11/3.
//

import UIKit
import AVKit

/** 要创建一个继承自UIView的类, 重写它的layerClass方法, 返回AVPlayerLayer类, 同时说明一下, 显示视频的view, 需要是创建的VideoPlayer类型. */
class YXVideoPlayer: UIView {
    
    override class var layerClass: AnyClass {
        
        get {
            return AVPlayerLayer.self
        }
    }

}

class YXVideoPlayerVC: YXBaseVC {
    
    private var playerItem: AVPlayerItem!
    lazy private var avPlayer: AVPlayer! = {
        
        let avPlayer = AVPlayer.init(playerItem: self.playerItem)
        avPlayer.rate = 1.0 //播放速度播放前设置
        if let playerLayer = self.videoView.layer as? AVPlayerLayer {
            playerLayer.videoGravity = .resizeAspect
            playerLayer.player = avPlayer
        }
        
        return avPlayer
    }()
    
    lazy private var videoView: YXVideoPlayer! = {
        
        let videoView = YXVideoPlayer()
        videoView.backgroundColor = .white
        videoView.frame = CGRect(x: 0, y: 0, width: self.yxScreenWidth, height: self.yxScreenHeight)
        self.view.addSubview(videoView)
        
        videoView.snp.makeConstraints { make in
            
            make.top.equalTo(self.navigationView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        return videoView
    }() //显示的视频

    /** 视频总时长 */
    var totalTimeFormat: String {
        
        if let totalTime = self.avPlayer.currentItem?.duration {
            let totalTimeSec = CMTimeGetSeconds(totalTime)
            if (totalTimeSec.isNaN) {
                return "00:00"
            }
            return String.init(format: "%02zd:%02zd", Int(totalTimeSec / 60), Int(totalTimeSec.truncatingRemainder(dividingBy: 60.0)))
        }

        return "00:00"
    }

    /** 视频播放时长 */
    var currentTimeFormat: String {
        
        if let playTime = self.avPlayer.currentItem?.currentTime() {
            let playTimeSec = CMTimeGetSeconds(playTime)
            if (playTimeSec.isNaN) {
                return "00:00"
            }
            return String.init(format: "%02zd:%02zd", Int(playTimeSec / 60), Int(playTimeSec.truncatingRemainder(dividingBy: 60.0)))
        }
        
        return "00:00"
    }
    
    deinit {
        
        self.playerItem?.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        
        self.navigationView.titleLab.text = "视频播放"
        self.navigationView.backBtn.isHidden = false
        
        let url = URL(string: "http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4")
        let asset = AVURLAsset(url: url!)
        self.playerItem = AVPlayerItem(asset: asset)
        
        self.playVideo();
    }
}

//MARK: - 方法
extension YXVideoPlayerVC {
    
    /** 播放 */
    func playVideo() {
        
        self.resumeVideo()
        //监听它状态的改变, 实现kvo的方法
        self.playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)

        //播放结束的通知.
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    /** 暂停 */
    func pauseVideo() {
        
        self.avPlayer.pause()
    }

    /** 开始/继续 */
    func resumeVideo() {
        
        self.avPlayer.play()
    }

    /** 播放进度 */
    func progressVideo(_ sender: UISlider) {
        
        let progress: Float64 = Float64(sender.value)
        if (progress < 0 || progress > 1) {
            return;
        }
        //当前视频资源的总时长
        if let totalTime = self.avPlayer.currentItem?.duration {
            let totalSec = CMTimeGetSeconds(totalTime)
            let playTimeSec = totalSec * progress
            let currentTime = CMTimeMake(value: Int64(playTimeSec), timescale: 1)
            self.avPlayer.seek(to: currentTime, completionHandler: { (finished) in })
        }
    }

    /** 2倍速 */
    func rateVideo() {
        
        self.avPlayer.rate = 2.0
    }
    
    /** 静音 */
    func mutedVideo() {
        
        self.avPlayer.isMuted = false
    }

    /** 音量 */
    func volume(_ sender: UISlider) {
        
        if (sender.value < 0 || sender.value > 1) {
            return;
        }
        if (sender.value > 0) {
            self.avPlayer.isMuted = false
        }
        self.avPlayer.volume = sender.value
    }

    /** 播放完成 */
    @objc func playToEndTime() {}

    //MARK: - 播放状态通知
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let playerItem = object as? AVPlayerItem else { return }
        if keyPath == "status" {
            //资源准备好, 可以播放
            if playerItem.status == .readyToPlay {
                self.avPlayer.play()
            }
            else {
                print("load error")
            }
        }
    }
    
}
