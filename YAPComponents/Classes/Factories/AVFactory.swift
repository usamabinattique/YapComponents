//
//  AVFactory.swift
//  YAPComponents
//
//  Created by Sarmad on 09/09/2021.
//

import AVFoundation

public class AVFactory {}

public extension AVFactory {
    class func makeAVPlayerLayer(with player:AVPlayer? = nil, videoGravity:AVLayerVideoGravity = .resizeAspectFill) -> AVPlayerLayer {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = videoGravity
        return playerLayer
    }
    
    class func makePlayer(with resource:Resource? = nil) -> AVPlayer  {
        if let url = resource?.url {
            return AVPlayer(url: url)
        }
        return AVPlayer()
    }
}
