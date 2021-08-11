//
//  PaymentCardViewModel.swift
//  YAPKit
//
//  Created by Muhammad Hussaan Saeed on 05/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift

/**
 
 */
public protocol PaymentCardViewModelInputs {
    var detailObserver: AnyObserver<Void> { get }
    var pcNameOberver: AnyObserver<String> { get }
    var pcNumberOberver: AnyObserver<String> { get }
    var pcImageUrlObserver: AnyObserver<ImageWithURL> { get }
    var cardTitleObserver: AnyObserver<String?> { get }
}

public protocol PaymentCardViewModelOutputs {
    var pcName: Observable<String> { get }
    var pcNumber: Observable<String> { get }
    var detailable: Observable<Bool> { get }
    var detail: Observable<Void> { get }
    var pcImageUrl: Observable<ImageWithURL> { get }
    var cardTitle: Observable<String?> { get }
}

public protocol PaymentCardViewModelType {
    var inputs: PaymentCardViewModelInputs { get }
    var outputs: PaymentCardViewModelOutputs { get }
}

public class PaymentCardViewModel: PaymentCardViewModelType, PaymentCardViewModelInputs, PaymentCardViewModelOutputs {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    public var inputs: PaymentCardViewModelInputs { return self }
    public var outputs: PaymentCardViewModelOutputs { return self }
    
    private let pcNameSubject: BehaviorSubject<String>
    private let pcNumberSubject: BehaviorSubject<String>
    private let detailableSubject: BehaviorSubject<Bool>
    private let detailSubject = PublishSubject<Void>()
    private let imageUrlSubject: BehaviorSubject<ImageWithURL>
    private let cardTitleSubject: BehaviorSubject<String?>
    
    // MARK: - Inputs
    
    public var detailObserver: AnyObserver<Void> { return detailSubject.asObserver() }
    public var pcNameOberver: AnyObserver<String> { return pcNameSubject.asObserver() }
    public var pcNumberOberver: AnyObserver<String> { return pcNumberSubject.asObserver() }
    public var pcImageUrlObserver: AnyObserver<ImageWithURL> { imageUrlSubject.asObserver() }
    public var cardTitleObserver: AnyObserver<String?> { cardTitleSubject.asObserver() }
    
    // MARK: - Outputs
    public var pcName: Observable<String> { return pcNameSubject.asObservable() }
    public var pcNumber: Observable<String> { return pcNumberSubject.asObservable() }
    public var detailable: Observable<Bool> { return detailableSubject.asObservable() }
    public var detail: Observable<Void> { return detailSubject.asObservable() }
    public var pcImageUrl: Observable<ImageWithURL> { imageUrlSubject.asObservable() }
    public var cardTitle: Observable<String?> { cardTitleSubject.asObservable() }
    
    // MARK: - Init
    public init(paymentCardName: String, paymentCardNumber: String, detailable: Bool = false, imageUrl: ImageWithURL, cardTitle: String? = nil) {
        
        self.pcNameSubject = BehaviorSubject(value: paymentCardName)
        self.pcNumberSubject = BehaviorSubject(value: paymentCardNumber)
        self.detailableSubject = BehaviorSubject(value: detailable)
        imageUrlSubject = BehaviorSubject(value: imageUrl)
        cardTitleSubject = BehaviorSubject(value: cardTitle)
    }
}
        
