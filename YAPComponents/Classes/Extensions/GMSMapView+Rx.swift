//
//  GMSMapView+Rx.swift
//  Example
//
//  Created by Gabriel Araujo on 28/10/17.
//  Copyright © 2017 Gen X Hippies Company. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import RxSwift
import RxCocoa
import GoogleMaps

public typealias GMSHandleTapMarker = (GMSMarker) -> (Bool)
public typealias GMSHandleTapOverlay = (GMSOverlay) -> Void
public typealias GMSHandleMarkerInfo = (GMSMarker) -> (UIView?)
public typealias GMSHandleTapMyLocationButton = () -> (Bool)

class GMSMapViewDelegateProxy: DelegateProxy<GMSMapView, GMSMapViewDelegate>, DelegateProxyType, GMSMapViewDelegate {
    
    var handleTapMarker: GMSHandleTapMarker?
    var handleTapOverlay: GMSHandleTapOverlay?
    var handleTapMyLocationButton: GMSHandleTapMyLocationButton?
    var handleMarkerInfoWindow: GMSHandleMarkerInfo?
    var handleMarkerInfoContents: GMSHandleMarkerInfo?
    
    let didTapMyLocationButtonEvent = PublishSubject<Void>()
    let didTapMarkerEvent = PublishSubject<GMSMarker>()
    let didTapOverlayEvent = PublishSubject<GMSOverlay>()
    
    /// Typed parent object.
    public weak private(set) var mapView: GMSMapView?
    
    /// - parameter tabBar: Parent object for delegate proxy.
    public init(gsMapView: ParentObject) {
        self.mapView = gsMapView
        super.init(parentObject: gsMapView, delegateProxy: GMSMapViewDelegateProxy.self)
    }
    
    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { GMSMapViewDelegateProxy(gsMapView: $0) }
    }
    
    /// For more information take a look at `DelegateProxyType`.
    open class func currentDelegate(for object: ParentObject) -> GMSMapViewDelegate? {
        return object.delegate
    }
    
    /// For more information take a look at `DelegateProxyType`.
    open class func setCurrentDelegate(_ delegate: GMSMapViewDelegate?, to object: ParentObject) {
        object.delegate = delegate
    }
    
    public func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return self.didHandleTap(marker)
    }
    
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        return self.didHandleTapOverlay(overlay)
    }
    
    public func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return self.markerInfoWindow(marker: marker)
    }
    
    public func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        return self.markerInfoContents(marker: marker)
    }
    
    public func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        return self.didTapMyLocationButton()
    }
}

extension GMSMapViewDelegateProxy {
    
    public func didHandleTap(_ marker: GMSMarker) -> Bool {
        didTapMarkerEvent.onNext(marker)
        return handleTapMarker?(marker) ?? false
    }
    
    public func didHandleTapOverlay(_ overlay: GMSOverlay) {
        didTapOverlayEvent.onNext(overlay)
        return handleTapOverlay?(overlay) ?? ()
    }
    
    public func didTapMyLocationButton() -> Bool {
        didTapMyLocationButtonEvent.onNext(())
        return handleTapMyLocationButton?() ?? false
    }
    
    public func markerInfoWindow(marker: GMSMarker) -> UIView? {
        return handleMarkerInfoWindow?(marker)
    }
    
    public func markerInfoContents(marker: GMSMarker) -> UIView? {
        return handleMarkerInfoContents?(marker)
    }
    
}

// - MARK: Internal Helpers
func castOptionalOrFatalError<T>(_ value: Any?) -> T? {
    if value == nil {
        return nil
    }
    let v: T = castOrFatalError(value)
    return v
}

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}

func castOrFatalError<T>(_ value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        fatalError("Failure converting from \(value ?? "") to \(T.self)")
    }
    
    return result
}

public extension Reactive where Base: GMSMapView {
    
    var camera: AnyObserver<GMSCameraPosition> {
        return Binder(base) { control, camera in
            control.camera = camera
        }.asObserver()
    }
    
    var cameraToAnimate: AnyObserver<GMSCameraPosition> {
        return Binder(base) { control, camera in
            control.animate(to: camera)
        }.asObserver()
    }
    
    var locationToAnimate: AnyObserver<CLLocationCoordinate2D> {
        return Binder(base) { control, location in
            control.animate(toLocation: location)
        }.asObserver()
    }
    
    var zoomToAnimate: AnyObserver<Float> {
        return Binder(base) { control, zoom in
            control.animate(toZoom: zoom)
        }.asObserver()
    }
    
    var bearingToAnimate: AnyObserver<CLLocationDirection> {
        return Binder(base) { control, bearing in
            control.animate(toBearing: bearing)
        }.asObserver()
    }
    
    var viewingAngleToAnimate: AnyObserver<Double> {
        return Binder(base) { control, viewingAngle in
            control.animate(toViewingAngle: viewingAngle)
        }.asObserver()
    }
    
    var myLocationEnabled: AnyObserver<Bool> {
        return Binder(base) { control, myLocationEnabled in
            control.isMyLocationEnabled = myLocationEnabled
        }.asObserver()
    }
    
    var myLocation: Observable<CLLocation?> {
        return observeWeakly(CLLocation.self, "myLocation")
    }
    
    var selectedMarker: ControlProperty<GMSMarker?> {
        return ControlProperty(values: observeWeakly(GMSMarker.self, "selectedMarker"), valueSink: Binder(base) { control, selectedMarker in
                control.selectedMarker = selectedMarker
            }.asObserver()
        )
    }
    
    var trafficEnabled: AnyObserver<Bool> {
        return Binder(base) { control, trafficEnabled in
            control.isTrafficEnabled = trafficEnabled
        }.asObserver()
    }
    
    var padding: AnyObserver<UIEdgeInsets> {
        return Binder(base) { control, padding in
            control.padding = padding
        }.asObserver()
    }
    
    var scrollGesturesEnabled: AnyObserver<Bool> {
        return Binder(base) { control, scrollGestures in
            control.settings.scrollGestures = scrollGestures
        }.asObserver()
    }
    
    var zoomGesturesEnabled: AnyObserver<Bool> {
        return Binder(base) { control, zoomGestures in
            control.settings.zoomGestures = zoomGestures
        }.asObserver()
    }
    
    var tiltGesturesEnabled: AnyObserver<Bool> {
        return Binder(base) { control, tiltGestures in
            control.settings.tiltGestures = tiltGestures
        }.asObserver()
    }
    
    var rotateGesturesEnabled: AnyObserver<Bool> {
        return Binder(base) { control, rotateGestures in
            control.settings.rotateGestures = rotateGestures
        }.asObserver()
    }
    
    var compassButtonVisible: AnyObserver<Bool> {
        return Binder(base) { control, compassButton in
            control.settings.compassButton = compassButton
        }.asObserver()
    }
    
    var myLocationButtonVisible: AnyObserver<Bool> {
        return Binder(base) { control, myLocationButton in
            control.settings.myLocationButton = myLocationButton
        }.asObserver()
    }
}

extension Reactive where Base: GMSMapView {
    
    fileprivate var delegate: GMSMapViewDelegateProxy {
        return GMSMapViewDelegateProxy.proxy(for: base)
    }
    
    public func handleTapMarkerWrapper(_ closure: GMSHandleTapMarker?) {
        delegate.handleTapMarker = closure
    }
    
    public func handleTapOverlayWrapper(_ closure: @escaping GMSHandleTapOverlay) {
        delegate.handleTapOverlay = closure
    }
    
    public func handleMarkerInfoWindowWrapper(_ closure: GMSHandleMarkerInfo?) {
        delegate.handleMarkerInfoWindow = closure
    }
    
    public func handleMarkerInfoContentsWrapper(_ closure: GMSHandleMarkerInfo?) {
        delegate.handleMarkerInfoContents = closure
    }
    
    public func handleTapMyLocationButton(_ closure: GMSHandleTapMyLocationButton?) {
        delegate.handleTapMyLocationButton = closure
    }
    
    public var willMove: ControlEvent<Bool> {
        let source = delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:willMove:)))
            .map { a in
                return try castOrThrow(Bool.self, a[1])
            }
        return ControlEvent(events: source)
    }
    
    public var didChange: ControlEvent<GMSCameraPosition> {
        let source = delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didChange:)))
            .map { a in
                return try castOrThrow(GMSCameraPosition.self, a[1])
            }
        return ControlEvent(events: source)
    }
    
    public var idleAt: ControlEvent<GMSCameraPosition> {
        let source = delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:idleAt:)))
            .map { a in
                return try castOrThrow(GMSCameraPosition.self, a[1])
            }
        return ControlEvent(events: source)
    }
    
    public var didTapAt: ControlEvent<CLLocationCoordinate2D> {
        let source =  delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didTapAt:)))
            .map { a in
                return try castCoordinateOrThrow(a[1])
            }
        return ControlEvent(events: source)
    }
    
    public var didLongPressAt: ControlEvent<CLLocationCoordinate2D> {
        let source =  delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didLongPressAt:)))
            .map { a in
                return try castCoordinateOrThrow(a[1])
            }
        return ControlEvent(events: source)
    }
    
    public var didTap: ControlEvent<GMSMarker> {
        let source =  delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didTap:)))
            .map { a in
                return try castOrThrow(GMSMarker.self, a[1])
            }
        return ControlEvent(events: source)
    }
    
    public var didTapInfoWindowOf: ControlEvent<GMSMarker> {
        let source =  delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didTapInfoWindowOf:)))
            .map { a in
                return try castOrThrow(GMSMarker.self, a[1])
            }
        return ControlEvent(events: source)
    }
    
    public var didLongPressInfoWindowOf: ControlEvent<GMSMarker> {
        let source =  delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didLongPressInfoWindowOf:)))
            .map { a in
                return try castOrThrow(GMSMarker.self, a[1])
            }
        return ControlEvent(events: source)
    }

    public var didTapAtPoi: ControlEvent<(placeId: String, name: String, location: CLLocationCoordinate2D)> {
        let source = delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didTapPOIWithPlaceID:name:location:)))
            .map { a -> (placeId: String, name: String, location: CLLocationCoordinate2D) in
                let placeId = try castOrThrow(NSString.self, a[1]) as String
                let name = try castOrThrow(NSString.self, a[2]) as String
                let value = try castOrThrow(NSValue.self, a[3])
                var coordinate = CLLocationCoordinate2D()
                value.getValue(&coordinate)
                return (placeId, name, coordinate)
            }
        return ControlEvent(events: source)
    }
    
    public var didCloseInfoWindowOfMarker: ControlEvent<GMSMarker> {
        let source =  delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didCloseInfoWindowOf:)))
            .map { a in return try castOrThrow(GMSMarker.self, a[1]) }
        return ControlEvent(events: source)
    }
    
    public var didBeginDragging: ControlEvent<GMSMarker> {
        let source = delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didBeginDragging:)))
            .map {  a in
                return try castOrThrow(GMSMarker.self, a[1])
            }
        return ControlEvent(events: source)
    }
    
    public var didEndDragging: ControlEvent<GMSMarker> {
        let source =  delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didEndDragging:)))
            .map { a in return try castOrThrow(GMSMarker.self, a[1]) }
        return ControlEvent(events: source)
    }
    
    public var didDrag: ControlEvent<GMSMarker> {
        let source =  delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapView(_:didDrag:)))
            .map { a in return try castOrThrow(GMSMarker.self, a[1]) }
        return ControlEvent(events: source)
    }
    
    public var didTapMyLocationButton: ControlEvent<Void> {
        return ControlEvent(events: delegate.didTapMyLocationButtonEvent)
    }
    
    public var didStartTileRendering: Observable<Void> {
        return  delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapViewDidStartTileRendering(_:)))
            .map { _ in return }
    }
    
    public var didFinishTileRendering: Observable<Void> {
        return  delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapViewDidFinishTileRendering(_:)))
            .map { _ in return }
    }
    
    public var snapshotReady: Observable<Void> {
        return  delegate
            .methodInvoked(#selector(GMSMapViewDelegate.mapViewSnapshotReady(_:)))
            .map { _ in return }
    }
    
    public func handleTapMarker(_ closure: ((GMSMarker) -> (Bool))?) {
        if let c = closure {
            handleTapMarkerWrapper { c($0) }
        } else {
            handleTapMarkerWrapper(nil)
        }
    }
    
    public func handleTapOverlay(_ closure: @escaping ((GMSOverlay) -> Void)) {
        handleTapOverlayWrapper { closure($0) }
    }
    
    public func handleMarkerInfoWindow(_ closure: ((GMSMarker) -> (UIView?))?) {
        if let c = closure {
            handleMarkerInfoWindowWrapper { c($0) }
        } else {
            handleMarkerInfoWindowWrapper(nil)
        }
    }
    
    public func handleMarkerInfoContents(_ closure: ((GMSMarker) -> (UIView?))?) {
        if let c = closure {
            handleMarkerInfoContentsWrapper { c($0) }
        } else {
            handleMarkerInfoContentsWrapper(nil)
        }
    }
}

private func castCoordinateOrThrow(_ object: Any) throws -> CLLocationCoordinate2D {
    let value = try castOrThrow(NSValue.self, object)
    var coordinate = CLLocationCoordinate2D()
    value.getValue(&coordinate)
    return coordinate
}
