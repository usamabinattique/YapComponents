//
//  ImageLoadingManager.swift
//  YAPKit
//
//  Created by Janbaz Ali on 29/03/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation
import SDWebImage


public class ImageLoadingManager {
    public static let shared = ImageLoadingManager()
    
    private init() {
        imageLoadingConfigurations()
        clearAllCachedImages()
    }
    
    func imageLoadingConfigurations() {
        SDImageCache.shared.config.shouldRemoveExpiredDataWhenEnterBackground = true
        SDImageCache.shared.config.maxDiskAge = 0
        SDImageCache.shared.config.maxMemoryCount = 1
    }
    
    public func clearAllCachedImages() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
}

 
