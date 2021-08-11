//
//  URL+Extension.swift
//  YAPKit
//
//  Created by Ahmer Hassan on 30/03/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation


public extension URL {
    
    init?(addingPercentEncodingInString string: String) {
        let urlString = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.init(string: urlString)
    }
}
