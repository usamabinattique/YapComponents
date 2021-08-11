//
//  GuidedTourCoordinator.swift
//  YAPKit
//
//  Created by Zain on 30/03/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import Foundation
import RxSwift

public class GuidedTourCoordinator: Coordinator<ResultType<Void>> {
    
    private let root: UIViewController
    private let tours: [GuidedTour]
    private let result = PublishSubject<ResultType<Void>>()
    
    public init (root: UIViewController, tours: [GuidedTour]) {
        self.root = root
        self.tours = tours
    }
    
    public override func start() -> Observable<ResultType<Void>> {
        let viewModel = GuidedTourViewModel(guidedToursArray: tours)
        let viewController = GuidedTourViewController(viewModel: viewModel)
        
        let nav = UINavigationControllerFactory.createTransparentNavigationBarNavigationController(rootViewController: viewController)
        nav.modalPresentationStyle = .overCurrentContext
        
        root.present(nav, animated: false, completion: nil)
        
        viewModel.outputs.skip.subscribe(onNext: { [weak self] in
            self?.result.onNext(.cancel)
            self?.result.onCompleted()
        }).disposed(by: disposeBag)
        
        viewModel.outputs.completed.subscribe(onNext: { [weak self] in
            self?.result.onNext(.success($0))
            self?.result.onCompleted()
        }).disposed(by: disposeBag)
        
        return result.do(onNext: { _ in
            nav.dismiss(animated: false, completion: nil)
        }).asObservable()
    }
    
}
