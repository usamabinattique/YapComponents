//
//  PCCredentialsViewModel.swift
//  YAPKit
//
//  Created by Muhammad Hussaan Saeed on 12/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift


/**
 
 */
public protocol PCCredentialsViewModelInputs {
    var closeObserver: AnyObserver<Void> { get }
    var currentPageObserver: AnyObserver<Int> { get }
    var copyCardNumberObserver: AnyObserver<Void> {get}
}

public protocol PCCredentialsViewModelOutputs {
    var close: Observable<Void> { get }
    var name: Observable<String> { get }
    var title: Observable<String?> { get }
    var panNumber: Observable<String> { get }
    var validity: Observable<String> { get }
    var cvv: Observable<String> { get }
    var currentPage: Observable<Int> { get }
    var image: Observable<ImageWithURL> { get }
}

public protocol PCCredentialsViewModelType {
    var inputs: PCCredentialsViewModelInputs { get }
    var outputs: PCCredentialsViewModelOutputs { get }
    
}

public class PCCredentialsViewModel: PCCredentialsViewModelType, PCCredentialsViewModelInputs, PCCredentialsViewModelOutputs {
    
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    public var inputs: PCCredentialsViewModelInputs { return self }
    public var outputs: PCCredentialsViewModelOutputs { return self }
    
    private let closeSubject = PublishSubject<Void>()
    private let nameSubject: BehaviorSubject<String>
    private let titleSubject: BehaviorSubject<String?>
    private let panNumberSubject: BehaviorSubject<String>
    private let validitySubject: BehaviorSubject<String>
    private let cvvSubject: BehaviorSubject<String>
    private let currentPageSubject = BehaviorSubject<Int>(value: 0)
    private let imageSubject: BehaviorSubject<ImageWithURL>
    private let copyButtonSubject = PublishSubject<Void>()
    
    // MARK: - Inputs
    public var closeObserver: AnyObserver<Void> { return closeSubject.asObserver() }
    public var currentPageObserver: AnyObserver<Int> { currentPageSubject.asObserver() }
    public var copyCardNumberObserver: AnyObserver<Void> { copyButtonSubject.asObserver() }
    
    // MARK: - Outputs
    public var close: Observable<Void> { return closeSubject.asObservable() }
    public var name: Observable<String> { return nameSubject.asObservable() }
    public var title: Observable<String?> { titleSubject.asObservable() }
    public var panNumber: Observable<String> { return panNumberSubject.asObservable() }
    public var validity: Observable<String> { return validitySubject.asObservable() }
    public var cvv: Observable<String> { return cvvSubject.asObservable() }
    public var currentPage: Observable<Int> { currentPageSubject.asObservable() }
    public var image: Observable<ImageWithURL> { imageSubject.asObservable() }
    
    private var timer: Timer?
    var timeRemaining: Int = 15
    
    // MARK: - Init
    
    public init(name: String, title: String?, imageUrl: ImageWithURL, credentials: PaymentCardCredentials) {
        
        nameSubject = BehaviorSubject(value: name)
        panNumberSubject = BehaviorSubject(value: credentials.formattedCardNumber)
        validitySubject = BehaviorSubject(value: credentials.expiryDate)
        cvvSubject = BehaviorSubject(value: credentials.cvv)
        titleSubject = BehaviorSubject(value: title)
        imageSubject = BehaviorSubject(value: imageUrl)
        closeSubject
            .subscribe(onNext: { [unowned self] in
                        self.timer?.invalidate()
                        self.timer = nil })
            .disposed(by: disposeBag)
        copyCardNumber(cardNumber: credentials.cardNumber)
    }
    
    private func copyCardNumber(cardNumber: String) {
        copyButtonSubject.subscribe(onNext: {
            _ in
            UIPasteboard.general.string = cardNumber
            YAPToast.show("Copied")
        }).disposed(by: disposeBag)
    }
}
