//
//  IntializationWithPointer.swift
//  YAPKit
//
//  Created by Sarmad on 08/09/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import UIKit

//MARK: <<========== Method to initialize a variable with a pointer ==========>>
extension NSLayoutConstraint {
    func toPointer(_ pointer:UnsafeMutablePointer<NSLayoutConstraint?>!) {
        guard pointer != nil else { return }
        var constraint:NSLayoutConstraint? = self
        pointer!.initialize(from: &constraint, count: 1)
        
        #if DEBUG
        print("CFGetRetainCount: \(CFGetRetainCount(constraint))")
        #endif
    }
}
