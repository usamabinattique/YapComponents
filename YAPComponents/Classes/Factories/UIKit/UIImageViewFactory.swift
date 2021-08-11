//
//  UIBackgroundImageViewFactory.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 31/07/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public class UIImageViewFactory {
    
    public class func createBackgroundImageView(mode: UIImageView.ContentMode = .scaleAspectFill, image: UIImage = UIImage(named: "image_backgound")!) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = mode
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        return imageView
    }
    
    public class func createImageView(mode: UIImageView.ContentMode = .scaleAspectFill, image: UIImage? = nil, tintColor: UIColor = .clear) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = mode
        imageView.tintColor = tintColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        return imageView
    }
    
    public class func createGifImageView(mode: UIImageView.ContentMode = .scaleAspectFill, image: UIImage? = nil, tintColor: UIColor = .clear) -> GifImageView {
        let imageView = GifImageView()
        imageView.contentMode = mode
        imageView.tintColor = tintColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        return imageView
    }
}

public class GifImageView: UIImageView{
    
}
