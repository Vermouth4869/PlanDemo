//
//  BoardViewController.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/23.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit
import AVFoundation

class BoardViewController: UIViewController {

    var playerItem: AVPlayerItem! //播放资源对象
    var player: AVPlayer! //播放器对象
    var timeObserver: Any! //时间观察者

    @IBOutlet weak var containerV: UIView!
    @IBOutlet weak var controllV: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var paintControlV: UIView!
    @IBOutlet weak var board: Board!
    @IBOutlet weak var brushSeg: UISegmentedControl!
    
    var brushes = [PencilBrush(), EraserBrush()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        
        self.board.brush = brushes[0]
        
        initPlayer()

    }
    
    //初始化播放器
    func initPlayer() {
        
        let path = Bundle.main.path(forResource: "yinhun", ofType: ".mp4")
        //        let path = "https://www.youtube.com/watch?v=L2dKjnmWRkk"
        let url = NSURL.fileURL(withPath: path!)
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        let layer = AVPlayerLayer(player: player)
        layer.frame = CGRect(x: 0,
                             y: 0,
                             width: containerV.frame.width,
                             height: containerV.frame.height - 50)
        layer.videoGravity = AVLayerVideoGravityResizeAspect
        containerV.layer.addSublayer(layer)
        
        addProgressObserver()
        addObserver()
        
    }
    
    //给播放器添加进度更新
    func addProgressObserver() {
        
        //这里设置每秒执行一次
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMake(Int64(1.0), Int32(1.0)), queue: DispatchQueue.main, using: { (time) in
            
            //CMTimeGetSeconds函数是将CMTime转换为秒，如果CMTime无效，将返回NaN
            let currentTime = CMTimeGetSeconds(time)
            let totalTime = CMTimeGetSeconds(self.playerItem.duration)
            
            //更新显示的时间和进度条
            let currentMin: Int = Int(currentTime.truncatingRemainder(dividingBy: 3600) / 60)
            let currentSec: Int = Int(currentTime.truncatingRemainder(dividingBy: 60))
            self.currentTime.text = String(format: "%02i:%02i", currentMin, currentSec)
            
            self.progressSlider.setValue(Float(currentTime / totalTime), animated: true)
            
        })
        
    }
    
    //给AVPlayerItem、AVPlayer添加监控
    func addObserver() {
        
        playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
    }
    
    //通过KVO监控播放器状态
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let object = object as? AVPlayerItem else {
            return
        }
        guard let keyPath = keyPath else {
            return
        }
        
        if keyPath == "status" {
            
            let total = CMTimeGetSeconds(object.duration)
            let min: Int = Int(total.truncatingRemainder(dividingBy: 3600) / 60)
            let second: Int = Int(total.truncatingRemainder(dividingBy: 60))
            self.totalTime.text = String(format: "%02i:%02i", min, second)
            
            if object.status == .readyToPlay {
                player.play()
            } else if object.status == .failed || object.status == .unknown {
                print("播放出错")
                print(object.error!)
            }
            
        } else if keyPath == "loadedTimeRanges" {
            
            //            let loadedTime = avalableDurationWithplayerItem()
            //            print("当前加载进度\(loadedTime)")
            print("当前加载进度")
            
        }
        
    }

    //播放结束，回到最开始位置，播放按钮显示带播放图标
    func playerItemDidReachEnd(notification: Notification) {
        
        player?.seek(to: kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        progressSlider.value = 0.0
        playBtn.setImage(UIImage(named:"player_play"), for: .normal)
        
    }
    
    //进度条滑动
    @IBAction func progressSliderChangedAction(_ sender: UISlider) {
        
        if let player = player {
            
            let duration = sender.value * Float(CMTimeGetSeconds((player.currentItem?.duration)!))
            let seekTime = CMTimeMake(Int64(duration), Int32(1))
            self.player.seek(to: seekTime)
            
        }
        
    }
    
    //播放&暂停按钮点击
    @IBAction func playOrPauseBtnAction(_ sender: UIButton) {
        
        if let player = player {
            
            if player.rate == 0 { //点击时已暂停
                playBtn.setImage(UIImage(named:"player_pause"), for: .normal)
                player.play()
            } else if player.rate == 1.0 { //点击时正在播放
                player.pause()
                playBtn.setImage(UIImage(named:"player_play"), for: .normal)
            }
            
        }
        
    }
    
    //画笔样式选择
    @IBAction func brushSegAction(_ sender: UISegmentedControl) {
        
        self.board.brush = self.brushes[sender.selectedSegmentIndex]
        
    }
    
    //去除观察者
    func removeObserver() {
        
        playerItem?.removeObserver(self, forKeyPath: "status")
        playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        player?.removeTimeObserver(timeObserver)
        
        NotificationCenter.default.removeObserver(self, name:  Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
    }
    
    deinit {
        
        removeObserver()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
