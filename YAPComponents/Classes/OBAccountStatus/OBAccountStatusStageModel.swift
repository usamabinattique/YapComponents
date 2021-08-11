//
//  OBAccountStatusStageModel.swift
//  App
//
//  Created by Uzair on 11/06/2021.
//

import Foundation
import RxSwift


public enum OBAccountStatusStage {
    case personalDetails(state: OBStages)
    case companyDocuments(state: OBStages)
    case companyDetails(state: OBStages)
    case shareHolderDetails(state: OBStages)
}

public enum OBStages {
    case completed
    case inProgress
    case notIntiated
}

extension OBAccountStatusStage {
    var title :String {
        switch self {
        case .personalDetails:
            return "Your personal details"
        case .companyDocuments:
            return "Company documents"
        case .companyDetails:
            return "Company details"
        case .shareHolderDetails:
            return "Your shareholder details"
        }
    }
    
    var count :String {
        switch self {
        case .personalDetails:
            return "1"
        case .companyDocuments:
            return "2"
        case .companyDetails:
            return "3"
        case .shareHolderDetails:
            return "4"
        }
    }
}



