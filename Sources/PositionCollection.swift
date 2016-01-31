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
    var geometryStorage: GeometryStorage
    
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

extension PositionCollection : MutableCollectionType {
    public typealias Index = Int
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return Int(OGR_G_GetPointCount(self.geometryStorage.geometry))
    }
    
    public subscript(index: Int) -> Position {
        get {
            // Don't allow access outside bounds (even though GDAL supports this)
            // so that the behavior is similar to Array
            precondition(index >= 0)
            precondition(index < endIndex)

            let is3D = OGR_G_GetCoordinateDimension(self.geometryStorage.geometry) > 2
            let x = OGR_G_GetX(self.geometryStorage.geometry, Int32(index))
            let y = OGR_G_GetY(self.geometryStorage.geometry, Int32(index))
            let altitude: Double? = is3D ? OGR_G_GetZ(self.geometryStorage.geometry, Int32(index)) : nil
            
            return Position(x: x, y: y, altitude: altitude)
        }
        mutating set(position) {
            // Don't allow geometry to grow automatically (even though GDAL supports this)
            // so that the behavior is similar to Array
            precondition(index >= 0)
            precondition(index < endIndex)
            
            ensureUnique(geometryStorage: &geometryStorage)
            
            if let altitude = position.altitude {
                OGR_G_SetPoint(geometryStorage.geometry, Int32(index), position.x, position.y, altitude)
            } else {
                OGR_G_SetPoint_2D(geometryStorage.geometry, Int32(index), position.x, position.y)
            }
        }
    }
}

extension PositionCollection : RangeReplaceableCollectionType {
    public init() {
        let geometry = OGR_G_CreateGeometry(wkbLineString)
        self.geometryStorage = GeometryStorage(geometry: geometry)!
    }
    
    public mutating func replaceRange<C : CollectionType where C.Generator.Element == Generator.Element>(subRange: Range<PositionCollection.Index>, with newElements: C) {
        precondition(subRange.startIndex >= 0)
        precondition(subRange.endIndex <= endIndex)

        // Move elements down to keep existing elements
        let endIndexMoveDown = endIndex - subRange.count
        for index in subRange.startIndex..<endIndexMoveDown {
            self[index] = self[index + subRange.count]
        }
        
        // Adjust space to required elements
        let numberOfPoints = count + numericCast(newElements.count) - (subRange.endIndex - subRange.startIndex)
        OGR_G_SetPointCount(geometryStorage.geometry, Int32(numberOfPoints))
        
        // Move elements up to make space for inserted elements
        let startIndexMoveUp = subRange.startIndex + numericCast(newElements.count)
        for index in (startIndexMoveUp..<numberOfPoints).reverse() {
            self[index] = self[index - numericCast(newElements.count)]
        }
        
        // Insert new elements
        for (index, newElement) in newElements.enumerate() {
            self[index + subRange.startIndex] = newElement
        }
    }
}