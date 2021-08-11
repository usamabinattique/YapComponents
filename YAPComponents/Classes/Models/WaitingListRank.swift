//
//  WaitingListRank.swift
//  OnBoarding
//
//  Created by Muhammad Awais on 25/02/2021.
//  Copyright © 2021 YAP. All rights reserved.
//

import Foundation

public struct WaitingListRank: Codable {
    public let waitingNewRank: Int
    public let waitingBehind: Int
    private let jump: String?
    public let viewable: Bool
    private let gainPoints: String?
    private let inviteeDetails: [Invitee]?
    private let totalGainedPoints: Int?
    
    public var spotsBumped: String {
        gainPoints ?? "0"
    }
    
    public var jumpSpots: String {
        jump ?? "0"
    }
    
    public var inviteesList: [Invitee] {
       //return Invitee.mock
//        let array: [Invitee] = [Invitee]()
        return inviteeDetails ?? []
    }
    
    public var totalBumpedUpSpots : Int {
        totalGainedPoints ?? 0
    }
    
}

public struct Invitee: Codable, InviteeData {
    public let inviteeCustomerId: String
    public var inviteeCustomerName: String
}

public extension Invitee {
    static let mock: [Invitee] = [ Invitee.init(inviteeCustomerId: "sjdhfj", inviteeCustomerName: "Jawad Ali"),
                                   Invitee.init(inviteeCustomerId: "sjdhfj", inviteeCustomerName: "Awais Ali")
    ]
}

public extension WaitingListRank {
    static let mock: WaitingListRank = WaitingListRank(waitingNewRank: 100, waitingBehind: 1000, jump: "100", viewable: false, gainPoints: "100", inviteeDetails: Invitee.mock, totalGainedPoints: 600)
}

public protocol InviteeData {
    var inviteeCustomerName: String { get }
}
