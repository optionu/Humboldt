//
//  Point.swift
//  Humboldt
//
//  Created by Claus Höfele on 23.01.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import Foundation
import CGDAL

/// Data structure representing a single position.
public struct Point : Geometry {
    public private(set) var geometryStorage: GeometryStorage
    public var position: Position {
        get {
            let x = OGR_G_GetX(geometryStorage.geometry, 0)
            let y = OGR_G_GetY(geometryStorage.geometry, 0)
            let altitude: Double? = is3D ? OGR_G_GetZ(geometryStorage.geometry, 0) : nil
            return Position(x: x, y: y, altitude: altitude)
        }
        mutating set(position) {
            ensureUnique(geometryStorage: &geometryStorage)
            
            if let altitude = position.altitude {
                OGR_G_SetPoint(geometryStorage.geometry, 0, position.x, position.y, altitude)
            } else {
                OGR_G_SetPoint_2D(geometryStorage.geometry, 0, position.x, position.y)
            }
        }
    }
    
    public init(position: Position? = nil) {
        let geometry = OGR_G_CreateGeometry(wkbPoint)
        self.init(geometry: geometry)
        
        if let position = position {
            self.position = position
        }
    }
    
    init(geometry: OGRGeometryH) {
        precondition(OGR_G_GetGeometryType(geometry) == wkbPoint)

        self.geometryStorage = GeometryStorage(geometry: geometry, ownsChildGeometries: true)!
    }
}