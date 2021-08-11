//
//  Document.swift
//  YAP
//
//  Created by Zain on 31/07/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

public enum DocumentType: String, Codable {
    case emiratesId = "EMIRATES_ID"
    case passport = "PASSPORT"
    case tradeLicense = "COMPANY_TRADE_LICENSE"
    case selfieVideo = "SELFIE_VIDEO"
    case articleOfAssociation = "ARTICLE_OF_ASSOCIATION"
    case shareHolderPassport = "COPY_OF_SHAREHOLDERS_PASSPORT"
    case tenancyContract = "COPY_OF_TENANCY_CONTRACT"
    case powerOfAttorney = "COPY_OF_POWER_OF_ATTORNEY"
    case other = "ANY_OTHER_OFFICIAL_DOCS"
}

public struct KYCDocument: Codable {
    public let imageText: String
    public let documentType: DocumentType
    public let pages: [DocumentPage]
}

public struct DocumentPage: Codable {
    let pageNo: Int
    let imageURL: String
    let contentType: String
    let fileName: String
}

public struct Document: Codable {
    public let documentType: String
    public let nationality, dateExpiry, dateIssue, dob: String
    public let gender: String
    public let active: Bool
    public let customerDocuments: [CustomerDocument]?
}

extension Document {
   public var isExpired: Bool {
        return (DateFormatter.serverReadableDateFromatter.date(from: dateExpiry) ?? Date()) < Date()
    }
}

public struct CustomerDocument: Codable {
    public let imageUrl: String?
    public let documentType: DocumentType
    public let information: DocumentInformation
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "fileName"
        case documentType = "documentType"
        case information = "documentInformation"
    }
}

public struct DocumentInformation: Codable {
    public let fullName: String?
    public let firstName: String?
    public let lastName: String?
    public let identityNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case fullName = "fullName"
        case firstName = "firstName"
        case lastName = "lastName"
        case identityNumber = "identityNo"
    }
}
