//
//  UserDefaultsHelper.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 10/12/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

final class UserDefaultsHelper {
    
    static func setData<T: Codable>(value: T, key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    static func getData<T: Codable>(type: T.Type, forkey: String) -> T? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: forkey) as? T
    }
    
    static func removeData(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
}
