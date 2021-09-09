//
//  Resource.swift
//  YAPComponents
//
//  Created by Sarmad on 09/09/2021.
//

import Foundation

public struct Resource {
    fileprivate var `extension`:String
    var name:String
    var bundle:Bundle
    public init(named:String, in bundle:Bundle) {
        var nameParts:[String] = named.split(separator: ".").map{ String($0) }
        
        self.extension = nameParts.last ?? ""
        nameParts.removeLast()
        self.name = nameParts.joined(separator: ".")
        self.bundle = bundle
    }
}

extension Resource {
    var url:URL? {
        bundle.url(forResource: self.name, withExtension: self.extension)
    }
}
