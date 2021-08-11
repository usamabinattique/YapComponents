//
//  CameraViewController.swift
//  YAPKit
//
//  Created by Janbaz Ali on 21/10/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift

public class CameraViewController: UIViewController {
    
    //MARK:- Properties
    var viewModel : CameraViewModelType!
    let disposeBag: DisposeBag
    var captureSession : AVCaptureSessionManager = AVCaptureSessionManager()
    
    
    // MARK: - Init
    public init(viewModel: CameraViewModelType) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
        
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Life Cycle
    public override func viewDidLoad() {
       
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
            registerAppStateNotifications()
            
            DispatchQueue.main.async {
                self.configureCameraController()
            }
            
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {[weak self] (granted: Bool) -> Void in
                if granted == true {
                    // User granted permission
                    self?.registerAppStateNotifications()
                    DispatchQueue.main.async {
                        self?.configureCameraController()
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self?.showAlert(message: "", defaultButtonTitle: "Ok", secondayButtonTitle: "Settings", secondaryButtonHandler: { _  in
                            // Open settings...
                        }, completion: {
                            
                        })
                    }
                }
            })
        }
        
        binding()
    }
    
    func configureCameraController() {
        captureSession.inputs.configureObserver.onNext((self.view))
    }
    
}

// MARK: - Setup
fileprivate extension CameraViewController {
    func setup() {
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .black
    }

}

//MARK: - Binding
extension CameraViewController{
    func binding() {
        
        captureSession.outputs.photo.bind(to: viewModel.inputs.photoObserver).disposed(by: disposeBag)
        viewModel.outputs.capture.bind(to: captureSession.capturePhotoObserver).disposed(by: disposeBag)
    }
}

//MARK: App States
extension CameraViewController {
    private func registerAppStateNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func appMovedToForeground() {
        self.captureSession.inputs.startObserver.onNext(())
    }
    
    @objc func appMovedToBackground() {
        self.captureSession.inputs.stopObserver.onNext(())
    }
}


