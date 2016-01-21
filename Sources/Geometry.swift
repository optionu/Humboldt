//
//  GeometryStorage.swift
//  Humboldt
//
//  Created by Claus Höfele on 23.01.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import Foundation
import CGDAL

/// Protocol shared between geometries.
public protocol Geometry {
    var geometryStorage: GeometryStorage { get }
}

public final class GeometryStorage {
    let geometry: OGRGeometryH
    
    /// Take ownership of the given geometry
    init?(geometry: OGRGeometryH) {
        // Can't use guard in Swift <2.2 because classes must initialize stored
        // properties before returning nil
        self.geometry = geometry
        
        if (geometry == nil) {
            return nil
        }
    }
    
    /// Take ownership of the geometry inside a feature.
    convenience init?(feature: OGRFeatureH) {
        guard feature != nil else {
            return nil
        }
        
        let geometry = OGR_F_StealGeometry(feature)
        self.init(geometry: geometry)
    }
    
    /// Copies the contents of this geometry into a new object.
    func copy() -> GeometryStorage? {
        let geometry = OGR_G_Clone(self.geometry)
        return GeometryStorage(geometry: geometry)
    }
    
    deinit {
        OGR_G_DestroyGeometry(geometry)
    }
}

/// Makes sure that the given geometry storage is not referenced by more than one object.
func ensureUnique(inout geometryStorage geometryStorage: GeometryStorage) {
    guard !isUniquelyReferencedNonObjC(&geometryStorage) else {
        return
    }
    
    guard let clonedGeometryStorage = geometryStorage.copy() else {
        return
    }
    
    geometryStorage = clonedGeometryStorage
}