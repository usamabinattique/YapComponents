//
//  ChangePhoneNumberSuccessCoordinator.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 02/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift

public class ChangePhoneNumberSuccessCoordinator: Coordinator<ResultType<Void>> {
    
    private let root: UINavigationController!
    private var localRoot: UINavigationController!
    private let result = PublishSubject<ResultType<Void>>()
    private let phone: String
    
    public init(root: UINavigationController, phone: String) {
        self.root = root
        self.phone = phone
    }
    
    public override func start() -> Observable<ResultType<Void>> {
        let viewModel: SuccessViewModelType = ChangePhoneNumberSuccessViewModel(phone: phone)
        let viewController = SuccessViewControlle(viewModel: viewModel)
        root.pushViewController(viewController, animated: true)
        
        viewModel.outputs.doneButton.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.result.onNext(ResultType.success(()))
            self.result.onCompleted()
        }).disposed(by: disposeBag)
        
        return result
    }
}
