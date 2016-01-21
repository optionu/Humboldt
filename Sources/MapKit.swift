//
//  MapKit.swift
//  Humboldt
//
//  Created by Claus Höfele on 23.01.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import Foundation
import MapKit

public protocol MapKitAnnotationConvertible {
    func annotations() -> [MKAnnotation]
}

public extension Geometry {
    public func annotations() -> [MKAnnotation] {
        if let annotationConvertible = self as? MapKitAnnotationConvertible {
            return annotationConvertible.annotations()
        } else {
            return [MKAnnotation]()
        }
    }
}

extension Point : MapKitAnnotationConvertible {
    public func annotations() -> [MKAnnotation] {
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: position.latitude, longitude: position.longitude)
        return [pointAnnotation]
    }
}

extension LineString {
    public func overlay() -> MKOverlay {
        let lineStringOverlay = LineStringOverlay()
        return lineStringOverlay
    }
}

// ToDo: convert to MKPolyLine and copy data instead? If not, provide LineStringRenderer
public class LineStringOverlay : NSObject, MKOverlay {
    //    public let lineStringData: LineStringData
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    public var boundingMapRect: MKMapRect {
        return MKMapRectNull
    }
}