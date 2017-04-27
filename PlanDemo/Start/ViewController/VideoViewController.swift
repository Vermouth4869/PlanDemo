//
//  VideoViewController.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/16.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {

    var containerV: UIView! //播放器容器
    var playerItem: AVPlayerItem! //播放资源对象
    var player: AVPlayer! //播放器对象
    var controllV: UIView! //底部控制view
    var playBtn: UIButton! //播放/暂停按钮
    var currentTime: UILabel! //当前播放时间
    var totalTime: UILabel! //视频总播放时间
    var progressSlider: UISlider! //进度条
    var timeObserver: Any! //时间观察者
    
    var paintV: DrawingBoardView! //绘画区域
    
    //var board: Board! = Board()
    var brushes = [PencilBrush()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        createUI()
        initPlayer()
        createPaintUI()

    }
    
    func rightBarAction() {
        
    }
    
    //初始化UI
    func createUI() {
        
        containerV = UIView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: (self.view.frame.height - 64) / 2))
        containerV.backgroundColor = UIColor.black
        view.addSubview(containerV)
        
        controllV = UIView(frame: CGRect(x: 0, y: containerV.frame.height - 50, width: self.view.frame.width, height: 50))
        controllV.backgroundColor = UIColor(red: 0 / 255, green: 235 / 255, blue: 85 / 255, alpha: 0.2)
        containerV.addSubview(controllV)
        
        playBtn = UIButton(frame: CGRect(x: 10.0, y: 5, width: 40, height: 40))
        playBtn.setImage(UIImage(named: "player_pause"), for: .normal)
        playBtn.addTarget(self, action: #selector(playOrPauseBtnAction(sender:)), for: .touchUpInside)
        controllV.addSubview(playBtn)
        
        currentTime = UILabel(frame: CGRect(x: playBtn.frame.origin.x + playBtn.frame.size.width + 5,
                                            y: 15,
                                            width: playBtn.frame.size.width,
                                            height: 20))
        currentTime.text = "00:00"
        currentTime.textColor = UIColor.green
        currentTime.textAlignment = .center
        currentTime.font = UIFont.systemFont(ofSize: 12.0)
        controllV.addSubview(currentTime)
        
        progressSlider = UISlider(frame: CGRect(x: currentTime.frame.origin.x + currentTime.frame.size.width + 5,
                                                y: 10,
                                                width: self.view.frame.width - (currentTime.frame.origin.x + currentTime.frame.size.width + 5) - 55,
                                                height: 30))
        progressSlider.minimumTrackTintColor = UIColor.green
        progressSlider.addTarget(self, action: #selector(progressSliderChangedAction(sender:)), for: .valueChanged)
        controllV.addSubview(progressSlider)
        
        totalTime = UILabel(frame: CGRect(x: self.view.frame.width - 55,
                                          y: currentTime.frame.origin.y,
                                          width: currentTime.frame.width,
                                          height: currentTime.frame.height))
        totalTime.text = "00:00"
        totalTime.textColor = UIColor.green
        totalTime.textAlignment = .center
        totalTime.font = UIFont.systemFont(ofSize: 12.0)
        controllV.addSubview(totalTime)
        
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
    
    //计算当前的缓冲进度
    func avalableDurationWithplayerItem() -> TimeInterval {
        
        guard let loadedTimeRanges = player?.currentItem?.loadedTimeRanges,let first = loadedTimeRanges.first else {fatalError()}
        
        //本次缓冲时间范围
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)//本次缓冲起始时间
        let durationSecound = CMTimeGetSeconds(timeRange.duration)//缓冲时间
        let result = startSeconds + durationSecound//缓冲总长度
        return result
        
    }
    
    //播放结束，回到最开始位置，播放按钮显示带播放图标
    func playerItemDidReachEnd(notification: Notification) {
        
        player?.seek(to: kCMTimeZero, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        progressSlider.value = 0.0
        playBtn.setImage(UIImage(named:"player_play"), for: .normal)
        
    }
    
    //播放、暂停按钮
    func playOrPauseBtnAction(sender: UIButton) {
        
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
    
    //滑动条方法
    func progressSliderChangedAction(sender: UISlider) {
        
        if let player = player {
            
            let duration = sender.value * Float(CMTimeGetSeconds((player.currentItem?.duration)!))
            let seekTime = CMTimeMake(Int64(duration), Int32(1))
            self.player.seek(to: seekTime)
            
        }
        
    }
    
    //去除观察者
    func removeObserver() {
        
        playerItem?.removeObserver(self, forKeyPath: "status")
        playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        player?.removeTimeObserver(timeObserver)
        
        NotificationCenter.default.removeObserver(self, name:  Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
    }
    
    /*********绘画**********/
    func createPaintUI() {
        
        //绘画控制条
        let paintControlV = UIView(frame: CGRect(x: 0,
                                                 y: containerV.frame.origin.y + containerV.frame.size.height,
                                                 width: view.frame.size.width,
                                                 height: 30))

        paintControlV.backgroundColor = UIColor.lightGray
        view.addSubview(paintControlV)
        
        //绘画区域
        let paintView = Board(frame: CGRect(x: 0,
                                             y: paintControlV.frame.origin.y + paintControlV.frame.size.height,
                                             width: paintControlV.frame.size.width,
                                             height: view.frame.size.height - paintControlV.frame.origin.y - paintControlV.frame.size.height))
    
        paintView.brush = brushes[0]
        view.addSubview(paintView)
        
//        paintV = DrawingBoardView(frame: CGRect(x: 0,
//                                                y: paintControlV.frame.origin.y + paintControlV.frame.size.height,
//                                                width: paintControlV.frame.size.width,
//                                                height: view.frame.size.height - paintControlV.frame.origin.y - paintControlV.frame.size.height))
//        paintV.backgroundColor = UIColor.white
//        view.addSubview(paintV)
        
        
    }
    
    deinit {
        
        removeObserver()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
