//
//  PhotoPicker.swift
//  YAP
//
//  Created by Wajahat Hassan on 01/03/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import Photos


open class PhotoPicker: NSObject {
    
    private var pickerController: UIImagePickerController
    private weak var presentationController: UINavigationController?
    private var viewModel: ChangeProfilePhotoViewModelType
    private let disposeBag = DisposeBag()
    
    init(presentationController: UINavigationController, viewModel: ChangeProfilePhotoViewModelType) {
        self.pickerController = UIImagePickerController()
        self.viewModel = viewModel
        super.init()
        bind(viewModel: viewModel)
        self.presentationController = presentationController
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        if image != nil {
            guard let image = image else { return }
            viewModel.inputs.resultObserver.onNext(image)
        } else {
            viewModel.inputs.backObserver.onNext(())
        }
    }
    
    fileprivate func present(sourceType: PhotoSource) {
        switch sourceType {
        case .camera:
            self.pickerController.sourceType = .camera
            self.pickerController.cameraDevice = .front
            self.presentationController?.present(self.pickerController, animated: true)
        case .photos:
            self.pickerController.sourceType = .photoLibrary
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }
    
    fileprivate func proceedWithCameraAccess(source: PhotoSource) {
        switch source {
        case .camera:
            AVCaptureDevice.requestAccess(for: .video) {[weak self] success in
                DispatchQueue.main.async {
                    if success { self?.present(sourceType: source) } else {
                        self?.cameraPermissionAlert(message:  "screen_user_profile_display_text_video_permission_error".localized)
                    }
                }
            }
        case .photos:
            PHPhotoLibrary.requestAuthorization {[weak self] (status) in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self?.present(sourceType: source)
                    } else if status == .denied {
                        self?.cameraPermissionAlert(message:  "screen_user_profile_display_text_photo_permission_error".localized)
                    }
                }
            }
        }
    }
    
    fileprivate func cameraPermissionAlert(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) {
            _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            _ in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.presentationController!.present(alertController, animated: false)
        
    }
    
    fileprivate func resetNavigationBarTintColor() {
        UINavigationBar.appearance().barTintColor = UIColor.white
    }
}

extension PhotoPicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension PhotoPicker: UINavigationControllerDelegate {
    fileprivate func bind(viewModel: ChangeProfilePhotoViewModelType?) {
        guard let `viewModel` = viewModel else { return }
        viewModel.outputs.cameraSourceType.subscribe(onNext: { [weak self] source in
            guard let `self` = self else { return }
            self.proceedWithCameraAccess(source: source)
            
        }).disposed(by: disposeBag)
    }
}
