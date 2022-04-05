//
//  ScrollDirection+Extensions.swift
//  YAPComponents
//
//  Created by Yasir on 04/04/2022.
//

import Foundation

public extension UICollectionView.ScrollDirection {
    func length(for view: UIView) -> CGFloat {
        switch self {
        case .horizontal:
            return view.frame.size.width
        case .vertical:
            return view.frame.size.height
        @unknown default:
            return .zero
        }
    }
    
    func value(for point: CGPoint) -> CGFloat {
        switch self {
        case .horizontal:
            return point.x
        case .vertical:
            return point.y
        @unknown default:
            return .zero
        }
    }
    
    func value(for size: CGSize) -> CGFloat {
        switch self {
        case .horizontal:
            return size.width
        case .vertical:
            return size.height
        @unknown default:
            return .zero
        }
    }
    
    func point(for value: CGFloat, defaultPoint: CGPoint) -> CGPoint {
        switch self {
        case .horizontal:
            return CGPoint(x: value, y: defaultPoint.y)
        case .vertical:
            return CGPoint(x: defaultPoint.x, y: value)
        @unknown default:
            return .zero
        }
    }
    
    func size(for value: CGFloat, defaultSize: CGSize) -> CGSize {
        switch self {
        case .horizontal:
            return CGSize(width: value, height: defaultSize.height)
        case .vertical:
            return CGSize(width: defaultSize.width, height: value)
        @unknown default:
            return .zero
        }
    }
    
    func edgeInsets(for value: CGFloat) -> UIEdgeInsets {
        switch self {
        case .horizontal:
            return UIEdgeInsets(top: 0, left: value, bottom: 0, right: value)
        case .vertical:
            return UIEdgeInsets(top: value, left: 0, bottom: value, right: 0)
        @unknown default:
            return .zero
        }
    }
}
