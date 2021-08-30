//
//  UIScreen+Extension.swift
//  iOSApp
//
//  Created by Abbas on 06/06/2021.
//

import UIKit

let BASE_SCREEN_WIDTH:CGFloat = 400

extension UIScreen {
    static var size:CGSize {
        return UIScreen.main.bounds.size
    }
    
    static var width:CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var height:CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var aspectRatio:CGFloat {
        return UIScreen.height / UIScreen.width
    }
    
    static var roIWidth:CGFloat {
        let h = UIScreen.height
        let w = UIScreen.width
        if w < h    { return w }
        else        { return h }
    }
    
    static var roIHeight:CGFloat {
        let h = UIScreen.height
        let w = UIScreen.width
        if h > w    { return h }
        else        { return w }
    }
    
    static var roIAspectRatio:CGFloat {
        let h = UIScreen.height
        let w = UIScreen.width
        if h > w    { return h / w }
        else        { return w / h }
    }
}


extension CGFloat {
    var dynamic:CGFloat {
        return self * UIScreen.roIWidth / BASE_SCREEN_WIDTH
    }
}
extension Int {
    var dynamic:CGFloat {
        return CGFloat(self) * UIScreen.roIWidth / BASE_SCREEN_WIDTH
    }
}
extension Double {
    var dynamic:CGFloat {
        return CGFloat(self) * UIScreen.roIWidth / BASE_SCREEN_WIDTH
    }
}
