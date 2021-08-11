//
//  AddressCity.swift
//  YAPKit
//
//  Created by Zain on 30/04/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

struct AddressCity: Codable {
    let name: String
    let code: String
    let active: Bool
    let iata3Code: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case code = "cityCode"
        case active = "active"
        case iata3Code = "iata3Code"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AddressCity.CodingKeys.self)
        
        self.name = (try? container.decode(String?.self, forKey: .name)) ?? ""
        self.code = (try? container.decode(String?.self, forKey: .code)) ?? ""
        self.active = (try? container.decode(Bool?.self, forKey: .active)) ?? true
        self.iata3Code = (try? container.decode(String?.self, forKey: .iata3Code)) ?? ""
    }
}
