//
//  ChangePasscodeSuccessCoordinator.swift
//  YAPKit
//
//  Created by Wajahat Hassan on 04/10/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation
import RxSwift

public class ChangePasscodeSuccessCoordinator: Coordinator<ResultType<Void>> {
    
    private let root: UINavigationController!
    private var localRoot: UINavigationController!
    private let result = PublishSubject<ResultType<Void>>()
    
    public init(root: UINavigationController) {
        self.root = root
    }
    
    public override func start() -> Observable<ResultType<Void>> {
        let viewModel: SuccessViewModelType = ChangePasscodeSuccessViewModel()
        let viewController = SuccessViewControlle(viewModel: viewModel)
        localRoot = UINavigationControllerFactory.createTransparentNavigationBarNavigationController(rootViewController: viewController)
        root.present(localRoot, animated: true, completion: nil)
        
        viewModel.outputs.doneButton.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.result.onNext(ResultType.success(()))
            self.result.onCompleted()
        }).disposed(by: disposeBag)
        
        return result
    }
}
