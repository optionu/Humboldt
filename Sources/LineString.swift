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
    
    public init(position: Position? = nil) {
        let geometry = OGR_G_CreateGeometry(wkbLineString)
        let geometryStorage = GeometryStorage(geometry: geometry)!
        self.init(geometryStorage: geometryStorage)
        
//        if let position = position {
//            OGR_G_SetPointCount(geometry, 1)
//            self.positions[0] = position
//        }
    }
    
    init(geometryStorage: GeometryStorage) {
        self.positions = PositionCollection(geometryStorage: geometryStorage)
    }
}
