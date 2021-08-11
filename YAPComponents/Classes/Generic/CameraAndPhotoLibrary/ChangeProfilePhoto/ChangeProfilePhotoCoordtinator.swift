//
//  ChangeProfilePhotoCoordtinator.swift
//  YAP
//
//  Created by Wajahat Hassan on 01/03/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

public enum PhotoSource {
    case camera
    case photos
}

public class ChangeProfilePhotoCoordtinator: Coordinator<ResultType<UIImage>> {
    
    public let navigationController: UINavigationController
    public var imagePicker: PhotoPicker!
    public let sourceType: PhotoSource
    
    public init(navigationController: UINavigationController, source: PhotoSource) {
        self.navigationController = navigationController
        self.sourceType = source
    }
    
    public override func start() -> Observable<ResultType<UIImage>> {
        
        let viewModel: ChangeProfilePhotoViewModelType = ChangeProfilePhotoViewModel(sourceType: self.sourceType)
        self.imagePicker = PhotoPicker(presentationController: navigationController, viewModel: viewModel)
        
        let resultWithImage = viewModel.outputs.result.flatMap { image -> Observable<ResultType<UIImage>>  in
            return Observable.just(ResultType.success(image))
        }
        
        let backObservable = viewModel.outputs.back.map { ResultType<UIImage>.cancel }.do(onNext: { _ in
        })
        
        let result = Observable.merge(backObservable, resultWithImage)
        return result
    }
}
