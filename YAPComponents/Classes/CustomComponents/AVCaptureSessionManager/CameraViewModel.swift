//
//  CameraViewModel.swift
//  YAPKit
//
//  Created by Janbaz Ali on 21/10/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift

public protocol CameraViewModelInput {
    var backObserver: AnyObserver<Void> { get }
    var photoObserver: AnyObserver<UIImage> { get }
    var captureObserter: AnyObserver<Void> { get }
}

public protocol CameraViewModelOutput {
    var photo: Observable<UIImage> { get }
    var capture: Observable<Void> { get }
}

public protocol CameraViewModelType {
    var inputs: CameraViewModelInput { get }
    var outputs: CameraViewModelOutput { get }
}

public class CameraViewModel: CameraViewModelType, CameraViewModelInput, CameraViewModelOutput {
    
    let disposeBag = DisposeBag()
    
    public var inputs: CameraViewModelInput { return self }
    public var outputs: CameraViewModelOutput { return self }
    
    private var backSubject = PublishSubject<Void>()
    private var photoSubject = PublishSubject<UIImage>()
    private var captureSubject = PublishSubject<Void>()
    
    //MARK:- Inputs
    public var backObserver: AnyObserver<Void> { return backSubject.asObserver() }
    public var photoObserver: AnyObserver<UIImage> { return photoSubject.asObserver() }
    public var captureObserter: AnyObserver<Void> { return captureSubject.asObserver() }
    
    //MARK: - Outputs
    public var photo: Observable<UIImage> { return photoSubject.asObservable() }
    public var capture: Observable<Void> { return captureSubject.asObservable() }
    
    //MARK: - Init
    
    public init() {
    
        photoSubject.subscribe(onNext: { [unowned self] image in
            self.printing()
        }).disposed(by: disposeBag)
    
    }
    
    func printing()  {
        print("yahooooo we got our image")
    }
}
