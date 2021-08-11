//
//  Coordinator.swift
//  YAPKit
//
//  Created by Zain on 18/06/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
//import Authentication

public enum SendMoneyFeatureType {
    case domestic
    case uaefts
    case cbwsi
    case rmt
    case swift
}

public enum CoordinatorFeature: Equatable {
    case addSendMoneyBeneficiary
    case editSendMoneyBeneficiary
    case sendMoneyTransfer(_ type: SendMoneyFeatureType)
    case topUpByExternalCard
    case addFunds
    case removeFunds
    case y2yTransfer
    case unfreezeCard
    case changePIN
    case forgotPIN
    case editPhoneNumber
    case editEmail
    case updateEID
    case changePasscode
    case forgotPasscode
    case reorderDebitCard
    case sendMoney
    case yapToYap
    case topUp
    case analytics
    case yapForYou
    case cardDetails
    case other
    case helpAndSupport
    case b2cKyc
    case setPin
    case addSpareCard
}

/// Base abstract coordinator generic over the return type of the `start` method.
open class Coordinator<ResultType>: NSObject {
    
    /// Typealias which will allows to access a ResultType of the Coordainator by `CoordinatorName.CoordinationResult`.
    typealias CoordinationResult = ResultType
    
    /// Utility `DisposeBag` used by the subclasses.
    public var disposeBag = DisposeBag()
    
    /// Feature that a particular coordinator will implement
    open var feature: CoordinatorFeature {
        return .other
    }
    
    open class func coordintor(for feature: CoordinatorFeature, root: UIViewController) -> Coordinator<ResultType>? {
        guard feature != .other else { return nil }
        
        fatalError("implmentation of class function 'coordintor(for feature: CoordinatorFeature)' must be provided by coordinator")
    }
    
    /// Unique identifier.
    let identifier = UUID()
    
    /// Dictionary of the child coordinators. Every child coordinator should be added
    /// to that dictionary in order to keep it in memory.
    /// Key is an `identifier` of the child coordinator and value is the coordinator itself.
    /// Value type is `Any` because Swift doesn't allow to store generic types in the array.
    private var childCoordinators = [UUID: Any]()
    
    /// Stores coordinator to the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Child coordinator to store.
    private func store<T>(coordinator: Coordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
        
    }
    
    /// Release coordinator from the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Coordinator to release.
    private func free<T>(coordinator: Coordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    public override init () {}
    
    /// 1. Stores coordinator in a dictionary of child coordinators.
    /// 2. Calls method `start()` on that coordinator.
    /// 3. On the `onNext:` of returning observable of method `start()` removes coordinator from the dictionary.
    ///
    /// - Parameter coordinator: Coordinator to start.
    /// - Returns: Result of `start()` method.
    open func coordinate<T>(to coordinator: Coordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in
                self?.free(coordinator: coordinator)
            })
    }
    
    /// Starts job of the coordinator.
    ///
    /// - Returns: Result of coordinator job.
    open func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
    
    open func freeAll() {
        childCoordinators = [UUID: Any]()
    }
}
