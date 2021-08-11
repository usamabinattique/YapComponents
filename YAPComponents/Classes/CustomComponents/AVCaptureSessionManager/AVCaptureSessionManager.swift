//
//  AVCaptureSessionManager.swift
//  YAPKit
//
//  Created by Janbaz Ali on 21/10/2020.
//  Copyright © 2020 YAP. All rights reserved.
//

import AVFoundation
import UIKit
import RxSwift

protocol AVCaptureSessionManagerInput {
    var configureObserver: AnyObserver<UIView> { get }
    var capturePhotoObserver: AnyObserver<Void> { get }
    var startObserver: AnyObserver<Void> { get }
    var stopObserver: AnyObserver<Void> { get }
}
protocol AVCaptureSessionManagerOutput {
    var photo: Observable<UIImage> { get }
    var error: Observable<String> { get }
    var configurationSuccess: Observable<Void> { get }
}

protocol AVCaptureSessionManagerType {
    var inputs: AVCaptureSessionManagerInput { get }
    var outputs: AVCaptureSessionManagerOutput { get }
}

class AVCaptureSessionManager: NSObject, AVCaptureSessionManagerType, AVCaptureSessionManagerInput, AVCaptureSessionManagerOutput  {
    
    // MARK: Properties
    private var captureSession: AVCaptureSession?
    private var currentCameraPosition: CameraPosition?
    private var frontCamera: AVCaptureDevice?
    private var frontCameraInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput
    private var backCamera: AVCaptureDevice?
    private var backCameraInput: AVCaptureDeviceInput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var flashMode = AVCaptureDevice.FlashMode.off
    
    let disposeBag = DisposeBag()
    var inputs: AVCaptureSessionManagerInput { return self }
    var outputs: AVCaptureSessionManagerOutput { return self }
    
    private let connfigureSubject = PublishSubject<UIView>()
    private let configurationSuccessSubject = PublishSubject<Void>()
    private let capturePhotoSubject = PublishSubject<Void>()
    private let photoSubject = PublishSubject<UIImage>()
    private let errorSubject = PublishSubject<String>()
    private let startSubject = PublishSubject<Void>()
    private let stopSubject = PublishSubject<Void>()
    
    
    //MARK: - Inputs
    var configureObserver: AnyObserver<UIView> { return connfigureSubject.asObserver() }
    var capturePhotoObserver: AnyObserver<Void> { return capturePhotoSubject.asObserver() }
    var startObserver: AnyObserver<Void> { return startSubject.asObserver() }
    var stopObserver: AnyObserver<Void> { return stopSubject.asObserver() }
    
    //MARK: - Outputs
    var configurationSuccess: Observable<Void> { return configurationSuccessSubject.asObservable() }
    var photo: Observable<UIImage> { return photoSubject.asObservable() }
    var error: Observable<String> { return errorSubject.asObservable() }
    
    override init() {
        
        photoOutput = AVCapturePhotoOutput()
        
        super.init()
    
        capturePhotoSubject.subscribe(onNext: { [weak self] in
            self?.captureImage()
        }).disposed(by: disposeBag)
        
        connfigureSubject.subscribe(onNext: { [weak self] view in
            self?.prepare(view: view)
        }).disposed(by: disposeBag)
        
        startSubject.subscribe(onNext: { [weak self] view in
            self?.startRunning()
        }).disposed(by: disposeBag)
        
        stopSubject.subscribe(onNext: { [weak self] view in
            self?.stopRunning()
        }).disposed(by: disposeBag)
    }
    
}

extension AVCaptureSessionManager {
    func prepare(view: UIView) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        func configureCaptureDevices() throws {
            
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
            
            let cameras = session.devices.compactMap { $0 }
            guard !cameras.isEmpty else {
                throw CameraControllerError.noCamerasAvailable
            }
            
            for camera in cameras {
                if camera.position == .front {
                    self.frontCamera = camera
                }
                
                if camera.position == .back {
                    self.backCamera = camera
                    
                    try camera.lockForConfiguration()
                    camera.focusMode = .continuousAutoFocus
                    camera.unlockForConfiguration()
                }
            }
        }
        
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            captureSession.startRunning()

            if let backCamera = self.backCamera {
                self.backCameraInput = try AVCaptureDeviceInput(device: backCamera)
                
                if captureSession.canAddInput(self.backCameraInput!) { captureSession.addInput(self.backCameraInput!) }
                
                self.currentCameraPosition = .back
            }
                
            else if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
                else { throw CameraControllerError.inputsAreInvalid }
                
                self.currentCameraPosition = .front
            }
                
            else { throw CameraControllerError.noCamerasAvailable }
        }
        
        func configurePhotoOutput() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            captureSession.startRunning()
            self.photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            
            if captureSession.canAddOutput(self.photoOutput) { captureSession.addOutput(self.photoOutput) }
        }
        
        DispatchQueue(label: "PrepareCameraSessions").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configurePhotoOutput()
            } catch {
                DispatchQueue.main.async {
                    self.errorSubject.onNext(error.localizedDescription)
                }
                return
            }
            
            DispatchQueue.main.async {
                //// call session prepared observer
                try? self.displayPreview(on: view)
                self.configurationSuccessSubject.onNext(())
            }
        }
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.bounds
    }
    
    private func captureImage() {
        guard let captureSession = captureSession, captureSession.isRunning else { errorSubject.onNext("Capture is missing") ; return }
    
        let settings = AVCapturePhotoSettings()
        
        if currentCameraPosition == .front, let hasFlash = self.frontCamera?.hasFlash, hasFlash{
            settings.flashMode = self.flashMode
        }
        
        if currentCameraPosition == .back, let hasFlash = self.backCamera?.hasFlash, hasFlash{
            settings.flashMode = self.flashMode
        }
        
        self.photoOutput.capturePhoto(with: settings, delegate: self)
        
    }

    func stopRunning() {
        captureSession?.stopRunning()
    }
    func startRunning() {
        captureSession?.startRunning()
    }
}

extension AVCaptureSessionManager: AVCapturePhotoCaptureDelegate {
    
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
                
        if let error = error { errorSubject.onNext(error.localizedDescription) }
            
        else if let data = photo.fileDataRepresentation(),
            let image = UIImage(data: data) {
            photoSubject.onNext(image)
        }

        else {
            errorSubject.onNext("Unable to capture photo")
        }
    }
}

extension AVCaptureSessionManager {
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    public enum CameraPosition {
        case front
        case back
    }
}
