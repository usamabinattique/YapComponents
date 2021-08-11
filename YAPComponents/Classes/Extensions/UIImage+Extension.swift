//
//  UIImage+Extension.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 18/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreImage

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 0.1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    static func render(size: CGSize, _ draw: () -> Void) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        
        draw()
        
        return UIGraphicsGetImageFromCurrentImageContext()?
            .withRenderingMode(.alwaysOriginal)
    }
    
    static func make(size: CGSize, color: UIColor = .white) -> UIImage? {
        return render(size: size) {
            color.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
        }
    }
    
    class func imageSnap(text: String?, color: UIColor, textColor: UIColor = .white, bounds: CGRect, contentMode: UIView.ContentMode = .scaleToFill) -> UIImage? {
        
        let scale = Float(UIScreen.main.scale)
        var imageSize = bounds.size
        if contentMode == .scaleToFill || contentMode == .scaleAspectFill || contentMode == .scaleAspectFit || contentMode == .redraw {
            imageSize.width = CGFloat(floorf((Float(imageSize.width) * scale) / scale))
            imageSize.height = CGFloat(floorf((Float(imageSize.height) * scale) / scale))
        }
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, CGFloat(scale))
        let context = UIGraphicsGetCurrentContext()
        
        let path = CGPath(ellipseIn: bounds, transform: nil)
        context?.addPath(path)
        context?.clip()
        
        // Fill
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        // Text
        if let text = text {
            let attributes = [NSAttributedString.Key.foregroundColor: textColor,
                              NSAttributedString.Key.font: UIFont.appFont(forTextStyle: .title1)]
            
            let textSize = text.size(withAttributes: attributes)
            let bounds = bounds
            let rect = CGRect(x: bounds.size.width/2 - textSize.width/2, y: bounds.size.height/2 - textSize.height/2, width: textSize.width, height: textSize.height)
            
            text.draw(in: rect, withAttributes: attributes)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    static func sharedImage(named: String) -> UIImage? {
        return UIImage.init(named: named, in: yapKitBundle, compatibleWith: nil)
    }
    
    var asTemplate: UIImage? {
        return withRenderingMode(.alwaysTemplate)
    }
    
    var parseQrCode: [String] {
        guard let image = CIImage(image: self) else { return [] }

        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])

        let features = detector?.features(in: image) ?? []

        return features.compactMap { feature in
            return (feature as? CIQRCodeFeature)?.messageString
        }
    }
    
}
