//
//  PositionCollection.swift
//  Humboldt
//
//  Created by Claus Höfele on 24.01.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import Foundation
import CGDAL

public struct PositionCollection {
    private let geometryStorage: GeometryStorage
    
    public init(geometryStorage: GeometryStorage) {
        self.geometryStorage = geometryStorage
    }
}

extension PositionCollection : SequenceType {
    public typealias Generator = AnyGenerator<Position>

    public func generate() -> Generator {
        var index = 0
        return anyGenerator {
            if index < Int(OGR_G_GetPointCount(self.geometryStorage.geometry)) {
                let is3D = OGR_G_GetCoordinateDimension(self.geometryStorage.geometry) > 2
                let x = OGR_G_GetX(self.geometryStorage.geometry, Int32(index))
                let y = OGR_G_GetY(self.geometryStorage.geometry, Int32(index))
                let altitude: Double? = is3D ? OGR_G_GetZ(self.geometryStorage.geometry, Int32(index)) : nil
                index += 1
                
                return Position(x: x, y: y, altitude: altitude)
            }
            
            return nil
        }
    }
}

extension PositionCollection : CollectionType {
    public typealias Index = Int
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return Int(OGR_G_GetPointCount(self.geometryStorage.geometry))
    }
    
    public subscript(index: Int) -> Position {
        let is3D = OGR_G_GetCoordinateDimension(self.geometryStorage.geometry) > 2
        let x = OGR_G_GetX(self.geometryStorage.geometry, Int32(index))
        let y = OGR_G_GetY(self.geometryStorage.geometry, Int32(index))
        let altitude: Double? = is3D ? OGR_G_GetZ(self.geometryStorage.geometry, Int32(index)) : nil
        
        return Position(x: x, y: y, altitude: altitude)
    }
}