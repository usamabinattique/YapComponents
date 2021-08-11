//
//  CardMeetingLocation.swift
//  YAP
//
//  Created by Zain on 17/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public struct CardMeetingLocation: Codable {
    public let address1: String
    public let address2: String?
    public let latitude: Double?
    public let longitude: Double?
    public let city: String?
    public let country: String?
    public let postalCode : String?
    public let emirates : String?
}

// MARK: - Mocked extension

public extension CardMeetingLocation {
    static var mocked: CardMeetingLocation {
        return CardMeetingLocation(address1: "Dubai Mall, Dubai, UAE", address2: "Dubai Mall, Dubai, UAE", latitude: 25.199663, longitude: 55.277557, city: "Dubai", country: "United Arab Emirates",postalCode: "324234234234234",emirates: "Ajman")
    }

}

