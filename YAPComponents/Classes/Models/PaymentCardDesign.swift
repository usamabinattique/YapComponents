//
//  CardDesign.swift
//  Cards
//
//  Created by Zain on 18/12/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import UIKit

public struct CardDesign {
    public let designCodeName: String
    public let designCode: String
    public let frontImageUrl: String?
    public let backImageUrl: String?
    public let isActive: Bool
    public let colorCodes: [CardDesignColorCode]
}

extension CardDesign: Codable {
    enum CodingKeys: String, CodingKey {
        case designCodeName = "designCodeName"
        case designCode = "designCode"
        case frontImageUrl = "frontSideDesignImage"
        case backImageUrl = "backSideDesignImage"
        case isActive = "status"
        case colorCodes = "designCodeColors"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CardDesign.CodingKeys.self)
        designCodeName = (try? container.decode(String?.self, forKey: .designCodeName)) ?? ""
        designCode = (try? container.decode(String?.self, forKey: .designCode)) ?? ""
        frontImageUrl = try? container.decode(String?.self, forKey: .frontImageUrl)
        backImageUrl = try? container.decode(String?.self, forKey: .backImageUrl)
        isActive = ((try? container.decode(String?.self, forKey: .designCode)) ?? "") == "ACTIVE"
        colorCodes = (try? container.decode([CardDesignColorCode]?.self, forKey: .colorCodes)) ?? []
    }
}


public struct CardDesignColorCode {
    public let colorCode: String
    public let colorCodeId: String
}

extension CardDesignColorCode: Codable {
    enum CodingKeys: String, CodingKey {
        case colorCode = "colorCode"
        case colorCodeId = "designCodeUUID"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CardDesignColorCode.CodingKeys.self)
        colorCode = (try? container.decode(String?.self, forKey: .colorCode)) ?? ""
        colorCodeId = (try? container.decode(String?.self, forKey: .colorCodeId)) ?? ""
    }
}

public extension CardDesign {
    var gradiants: [UIColor] {
        var gradiants = colorCodes.map({ $0.color })
        if gradiants.count < 2 {
            let first: UIColor = gradiants.first ?? .greyLight
            gradiants.removeAll()
            gradiants.append(contentsOf: [first, first])
        }
        return Array(gradiants.prefix(2))
    }
}

extension CardDesignColorCode {
    var color: UIColor {
        UIColor(hexString: colorCode)
    }
}

public extension CardDesign {
    static var mock: CardDesign {
        CardDesign(designCodeName: "DC1", designCode: "DC1", frontImageUrl: YAPCard.virtualDarkBlue.cardImageUrl, backImageUrl: nil, isActive: true, colorCodes: [
            CardDesignColorCode(colorCode: "#443d92", colorCodeId: ""),
            CardDesignColorCode(colorCode: "#272262", colorCodeId: "")
        ])
    }
    
    static var mockData: [CardDesign] {
        [
            CardDesign(designCodeName: "DC1", designCode: "DC1", frontImageUrl: YAPCard.virtualDarkBlue.cardImageUrl, backImageUrl: nil, isActive: true, colorCodes: [
                CardDesignColorCode(colorCode: "#443d92", colorCodeId: ""),
                CardDesignColorCode(colorCode: "#272262", colorCodeId: "")
            ]),
            CardDesign(designCodeName: "DC2", designCode: "DC2", frontImageUrl: YAPCard.virtualGreen.cardImageUrl, backImageUrl: nil, isActive: true, colorCodes: [
                CardDesignColorCode(colorCode: "#44d7b6", colorCodeId: ""),
                CardDesignColorCode(colorCode: "#cbe1e7", colorCodeId: "")
            ]),
            CardDesign(designCodeName: "DC2", designCode: "DC2", frontImageUrl: YAPCard.virtualMulti.cardImageUrl, backImageUrl: nil, isActive: true, colorCodes: [
                CardDesignColorCode(colorCode: "#88c8f9", colorCodeId: ""),
                CardDesignColorCode(colorCode: "#8b489c", colorCodeId: "")
            ]),
            CardDesign(designCodeName: "DC2", designCode: "DC2", frontImageUrl: YAPCard.virtualLightBlue.cardImageUrl, backImageUrl: nil, isActive: true, colorCodes: [
                CardDesignColorCode(colorCode: "#48b3d3", colorCodeId: "")
            ]),
            CardDesign(designCodeName: "DC2", designCode: "DC2", frontImageUrl: YAPCard.virtualPurple.cardImageUrl, backImageUrl: nil, isActive: true, colorCodes: [
                CardDesignColorCode(colorCode: "#a582ff", colorCodeId: "")
            ])
        ]
    }
}
