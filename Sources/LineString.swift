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
    public private(set) var geometryStorage: GeometryStorage
    
    public init(position: Position? = nil) {
        let geometry = OGR_G_CreateGeometry(wkbLineString)
        let geometryStorage = GeometryStorage(geometry: geometry)!
        self.init(geometryStorage: geometryStorage)
        
//        if let position = position {
//            self.position = position
//        }
    }
    
    init(geometryStorage: GeometryStorage) {
        self.geometryStorage = geometryStorage
    }
}
