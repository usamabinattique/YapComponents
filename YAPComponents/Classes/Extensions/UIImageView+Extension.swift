//
//  UIImageView+Extension.swift
//  YAPComponents
//
//  Created by Sarmad on 30/08/2021.
//

import UIKit

public extension UIImageView {
    @discardableResult func setImage(_ name:String,
                                     rendringMode:UIImage.RenderingMode) -> Self {
        image = UIImage(named: name)?.withRenderingMode(rendringMode)
        return self
    }
    
    @discardableResult func setImage(_ image:UIImage?,
                                     rendringMode:UIImage.RenderingMode) -> Self {
        self.image = image?.withRenderingMode(rendringMode)
        return self
    }
}
