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
    public internal(set) var positions: PositionCollection
    
    public init() {
        let geometry = OGR_G_CreateGeometry(wkbLineString)
        let geometryStorage = GeometryStorage(geometry: geometry)!
        self.init(geometryStorage: geometryStorage)
    }
    
    init(geometryStorage: GeometryStorage) {
        precondition(OGR_G_GetGeometryType(geometryStorage.geometry) == wkbLineString)
        
        self.positions = PositionCollection(geometryStorage: geometryStorage)
    }
}
