//
//  WaitingList.swift
//  YAPKit
//
//  Created by Zain on 08/08/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation

public struct WaitingList: Codable {
    public let otpToken: String?
   // public let waitingListRank: String?
   // public let isWaiting: Bool
    
    enum CodingKeys: String, CodingKey {
        case otpToken = "otpToken"
       // case waitingListRank = "waitingListRank"
       // case isWaiting = "isWaiting"
    }
}
