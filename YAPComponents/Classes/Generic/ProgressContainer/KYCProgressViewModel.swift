//
//  KYCProgressViewModel.swift
//  OnBoarding
//
//  Created by Zain on 06/06/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift

public protocol KYCProgressViewModelInput {
    var backTapObserver: AnyObserver<Void> { get }
    var progressObserver: AnyObserver<Float> { get }
    var popppedObserver: AnyObserver<Void> { get }
    var disableBackButtonObserver: AnyObserver<Bool> {  get }
    var hideBackButtonObserver: AnyObserver<Bool> { get }
}

public protocol KYCProgressViewModelOutput {
    var progress: Observable<Float> { get }
    var progressCompletion: Observable<Bool> { get }
    var backTap: Observable<Void> { get }
    var disableBackButton: Observable<Bool> {  get }
    var hideBackButton: Observable<Bool> { get }
}

public protocol KYCProgressViewModelType {
    var inputs: KYCProgressViewModelInput { get }
    var outputs: KYCProgressViewModelOutput { get }
}

public class KYCProgressViewModel: KYCProgressViewModelInput, KYCProgressViewModelOutput, KYCProgressViewModelType {
    
    public var inputs: KYCProgressViewModelInput { self }
    public var outputs: KYCProgressViewModelOutput { self }
    
    private let progressSubject = BehaviorSubject<Float>(value: 0)
    private let progressCompletionSubject = PublishSubject<Bool>()
    private let backTapSubject = PublishSubject<Void>()
    private let poppedSubject = PublishSubject<Void>()
    private let disableBackButtonSubject = BehaviorSubject<Bool>(value: true)
    private let hideBackButtonSubject = BehaviorSubject<Bool>(value: false)
    
    //inputs
    public var backTapObserver: AnyObserver<Void> { backTapSubject.asObserver() }
    public var progressObserver: AnyObserver<Float> { progressSubject.asObserver() }
    public var popppedObserver: AnyObserver<Void> { poppedSubject.asObserver()}
    public var disableBackButtonObserver: AnyObserver<Bool> {  disableBackButtonSubject.asObserver() }
    public var hideBackButtonObserver: AnyObserver<Bool> { hideBackButtonSubject.asObserver() }
    
    //outputs
    public var progressCompletion: Observable<Bool> { progressCompletionSubject.asObservable() }
    public var progress: Observable<Float> { progressSubject.asObservable() }
    public var backTap: Observable<Void> {  backTapSubject.asObservable() }
    public var disableBackButton: Observable<Bool> {  disableBackButtonSubject.asObservable() }
    public var hideBackButton: Observable<Bool> { hideBackButtonSubject }
    
    private let disposeBag = DisposeBag()
    
    public init() {
        poppedSubject.subscribe(onNext: { [weak self] in
            self?.backTapSubject.onCompleted()
        }).disposed(by: disposeBag)
    }
}


