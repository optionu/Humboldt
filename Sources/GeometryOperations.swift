//
//  GeometryOperations.swift
//  Humboldt
//
//  Created by Claus Höfele on 23.01.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import Foundation
import CGDAL

public extension Geometry {
    public var is3D: Bool {
        return OGR_G_GetCoordinateDimension(geometryStorage.geometry) > 2
    }
    
    public var name: String {
        return String.fromCString(OGR_G_GetGeometryName(geometryStorage.geometry)) ?? ""
    }
    
    public func buffer(distance distance: Double) -> Polygon {
        let geometry = OGR_G_Buffer(self.geometryStorage.geometry, distance, 0)
        let geometryStorage = GeometryStorage(geometry: geometry)! // ToDo: change to ?? Polygon()
        return Polygon(geometryStorage: geometryStorage)
    }
}