//
//  VRPlayer.swift
//  VRDemo
//
//  Created by huhuan on 2016/11/25.
//  Copyright © 2016年 Huanhoo. All rights reserved.
import UIKit
import AVFoundation
class VRPlayer: UIView, VRGLKViewDelegate {
    var avPlayer     : AVPlayer?
    var avPlayerItem : AVPlayerItem?
    var avAsset      : AVAsset?
    var output       : AVPlayerItemVideoOutput?
    let glkView : VRGLKView = VRGLKView.init(frame:CGRect(x: 0, y: 0, width: 0, height: 0))//glkView.translatesAutoresizingMaskIntoConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        glkView.frame=frame
        self.addSubview(glkView)
//        self.avPlayer?.play()
//        configureOutput()
        NotificationCenter.default.addObserver(self, selector:#selector(playEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    func playWithURL(url:NSURL) {
        self.avAsset = AVAsset.init(url:url as URL)
//        self.avAsset = AVAsset.init(url:NSURL.fileURL(withPath: Bundle.main.path(forResource: "demo", ofType: "m4v")!))
        self.avPlayerItem = AVPlayerItem.init(asset : self.avAsset!)
        self.avPlayer = AVPlayer.init(playerItem: self.avPlayerItem!)
        glkView.glkDelegate = self
        self.avPlayer?.play()
        configureOutput()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureOutput() {
        if self.avPlayerItem != nil && output != nil {
           self.avPlayerItem?.remove(output!)
        }
        output = nil;
        let pixelBuffer: Dictionary = [kCVPixelBufferPixelFormatTypeKey as String :  NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)];
        output = AVPlayerItemVideoOutput.init(pixelBufferAttributes: pixelBuffer)
        output!.requestNotificationOfMediaDataChange(withAdvanceInterval: 0.03)
        avPlayerItem?.add(output!)
    }
    internal func dataSource() -> CVPixelBuffer? {
        let pixelBuffer: CVPixelBuffer? = output?.copyPixelBuffer(forItemTime: (avPlayerItem?.currentTime())!, itemTimeForDisplay: nil)
        //if pixelBuffer == nil {configureOutput()}
        return pixelBuffer;
    }
    func playEnd() {
        self.avPlayer?.seek(to: kCMTimeZero)
        self.avPlayer?.play()
    }
}
