//
//  ChangeAddressSuccessCoordinator.swift
//  YAPKit
//
//  Created by Zain on 10/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift

public class ChangeAddressSuccessCoordinator: Coordinator<ResultType<Void>> {
    
    private let root: UINavigationController!
    private let result = PublishSubject<ResultType<Void>>()
    let address: UserMapAddress
    
    public init(root: UINavigationController, address: UserMapAddress) {
        self.address = address
        self.root = root
    }
    
    public override func start() -> Observable<ResultType<Void>> {
        let viewModel: SuccessViewModelType = ChangeAddressSuccessViewModel(address: address)
        let viewController = ChangeAddressSuccessViewController(viewModel: viewModel)
        
        root.pushViewController(viewController, animated: false)
        
        viewModel.outputs.doneButton.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.result.onNext(ResultType.success(()))
            self.result.onCompleted()
        }).disposed(by: disposeBag)
        
        return result
    }
}
