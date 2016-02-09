//
//  LineString.swift
//  Humboldt
//
//  Created by Claus Höfele on 23.01.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import Foundation
import CGDAL

public struct LineString : Geometry {
    public var geometryStorage: GeometryStorage {
        return positions.geometryStorage
    }
    public var positions: PositionCollection
    
    public init() {
        let geometry = OGR_G_CreateGeometry(wkbLineString)
        self.init(geometry: geometry)
    }
    
    init(geometry: OGRGeometryH) {
        precondition(OGR_G_GetGeometryType(geometry) == wkbLineString)

        let geometryStorage = GeometryStorage(geometry: geometry, ownsChildGeometries: true)!
        self.positions = PositionCollection(geometryStorage: geometryStorage)
    }
}
