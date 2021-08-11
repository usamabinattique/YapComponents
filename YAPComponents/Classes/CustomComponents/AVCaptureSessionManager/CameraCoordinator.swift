//
//  CameraCoordinator.swift
//  YAPKit
//
//  Created by Janbaz Ali on 21/10/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift

public class CameraCoordinator: Coordinator<ResultType<Void>> {
    
    private let root: UINavigationController
    private let result = PublishSubject<ResultType<Void>>()
    private var navigationRoot: UINavigationController!
    
    public init(root: UINavigationController) {
        self.root = root
    }
    
    public override func start() -> Observable<ResultType<Void>> {
        let viewModel: CameraViewModelType = CameraViewModel()
        let viewController = CameraViewController(viewModel: viewModel)
        navigationRoot = UINavigationControllerFactory.createOpaqueNavigationBarNavigationController(rootViewController: viewController)
        navigationRoot.navigationBar.isHidden = true
    
        root.present(navigationRoot, animated: true, completion: nil)
        
        return result
    }
}

private extension CameraCoordinator {
    
    
}
