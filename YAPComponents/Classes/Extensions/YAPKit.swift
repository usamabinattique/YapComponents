//
//  YAPKit.swift
//  YAPKit
//
//  Created by Zain on 17/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import UIKit

class YAPKit {
    private init() { }
}

public typealias ImageWithURL = (String?, UIImage?)

// MARK: Bundle

var yapKitBundle: Bundle {
    return Bundle(for: YAPKit.self)
}

// MARK: Public content

public func getToolBar(target: Any?, done: Selector?, cancel: Selector?) -> UIToolbar {
    
    let toolBar = UIToolbar()
    toolBar.autoresizingMask = .flexibleHeight
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.tintColor = UIColor.appColor(ofType: .primaryDark)
    toolBar.sizeToFit()
    
    // Adding Button ToolBar
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: done)
    var items: [UIBarButtonItem] = [doneButton]
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    items.insert(spaceButton, at: 0)
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: target, action: cancel)
    items.insert(cancelButton, at: 0)
    
    toolBar.setItems(items, animated: false)
    toolBar.isUserInteractionEnabled = true
    return toolBar
}
 
