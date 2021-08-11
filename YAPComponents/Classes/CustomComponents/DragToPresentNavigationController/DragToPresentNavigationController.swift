//
//  DragToPresentNavigationController.swift
//  YAPKit
//
//  Created by Zain on 13/09/2019.
//  Copyright © 2019 YAP. All rights reserved.
//

import Foundation

/// Drag to present navigation controller presents itself with drag
public extension UINavigationController {
    
    /// Prepares navigation controller for drag to present navigation
    ///
    /// - Parameters:
    ///   none
    ///
    /// - Returns:
    ///   none
    func prepareForDragToPresent() {
        view.alpha = 0
        modalPresentationStyle = .overCurrentContext
    }
    
    /// Must be called when drag has begun
    /// Must be called after present is called
    ///
    /// - Parameters:
    ///   none
    ///
    /// - Returns:
    ///   none
    func dragBegan() {
        var frame = view.frame
        frame.origin.y = frame.height
        view.frame = frame
    }
    
    /// Presents view according to progress (progress must be 0.0 to 1.0)
    ///
    /// - Parameters:
    ///   progress: CGFloat (must be betweeen 0.0 to 1.0)
    ///
    /// - Returns:
    ///   none
    func dragged(withProgress progress: CGFloat) {
        guard progress >= 0 && progress <= 1 else { return }
        var frame = view.frame
        frame.origin.y = (1 - progress) * frame.height
        frame.origin.y = frame.origin.y < 50 ? 50 : frame.origin.y
        view.frame = frame
        view.alpha = progress * 1.3
    }
    
    /// Must be called when drag has ended
    ///
    /// - Parameters:
    ///   velocity: velocity at which drag was ended ( -ve velocity indicates dragging down )
    ///
    /// - Returns:
    ///   none
    func dragEnded(withVelocity velocity: CGFloat) {
        
        let progress = (view.frame.height - view.frame.origin.y) / view.frame.height
        
        if progress < 0.3 {
            velocity > 900 ? completeShow(velocity) : completeHide(velocity)
        } else {
            velocity < -900 ? completeHide(velocity) : completeShow(velocity)
        }
    }
    
    /// Completes show animation after drag has ended
    /// Called after drag has ended
    ///
    /// - Parameters:
    ///   velocity: velocity at which drag was ended
    ///
    /// - Returns:
    ///   none
    private func completeShow(_ velocity: CGFloat) {
        let velocity = abs(velocity)
        
        var time: TimeInterval = velocity > 0 ? TimeInterval(view.frame.origin.y/velocity) : 0.25
        time = time > 0.25 ? 0.25 : time
        
        var frame = view.frame
        frame.origin.y = 0
        UIView.animate(withDuration: time, animations: {
            self.view.frame = frame
            self.view.alpha = 1
        }) { (completed) in
            guard completed else { return }
            self.view.alpha = 1
            _ = self.viewControllers.map { $0.dragToPresentNavigationControllerDidEndDragging(withPresentationSuccess: true) }
        }
    }
    
    /// Completes hide animation after drag has ended
    /// Called after drag has ended
    ///
    /// - Parameters:
    ///   velocity: velocity at which drag was ended
    ///
    /// - Returns:
    ///   none
    private func completeHide(_ velocity: CGFloat) {
        let velocity = abs(velocity)
        
        var time: TimeInterval = velocity > 0 ? TimeInterval((view.frame.height - view.frame.origin.y)/velocity) : 0.25
        time = time > 0.25 ? 0.25 : time
        
        var frame = view.frame
        frame.origin.y = view.frame.size.height
        
        UIView.animate(withDuration: time, animations: {
            self.view.frame = frame
            self.view.alpha = 0
        }) { (completed) in
            guard completed else { return }
            self.dismiss(animated: false, completion: nil)
            _ = self.viewControllers.map { $0.dragToPresentNavigationControllerDidEndDragging(withPresentationSuccess: false) }
        }
    }
}

extension UIViewController {
    /// Method to inform view controller about dissmissal of it's navigation controller
    ///
    /// - Parameters:
    ///   none
    ///
    /// - Returns:
    ///   none
    @objc
    open func dragToPresentNavigationControllerDidEndDragging(withPresentationSuccess success: Bool) {}
}
