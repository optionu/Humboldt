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

/// Handles storage for a geometry type.
public final class GeometryStorage {
    let geometry: OGRGeometryH
    let ownsChildGeometries: Bool

    /// Handle the given geometry.
    init?(geometry: OGRGeometryH, ownsChildGeometries: Bool) {
        guard geometry != nil else {
            return nil
        }

        self.geometry = geometry
        self.ownsChildGeometries = ownsChildGeometries
    }
    
    /// Copies the contents of this geometry into a new object.
    func copy() -> GeometryStorage? {
        let geometry = OGR_G_Clone(self.geometry)
        return GeometryStorage(geometry: geometry, ownsChildGeometries: ownsChildGeometries)
    }
    
    deinit {
        if ownsChildGeometries == false && geometry != nil {
            if OGR_G_GetGeometryType(geometry) == wkbPolygon {
                // OGR_G_RemoveGeometry is not supported for polygons yet
                let geometryCount = OGR_G_GetGeometryCount(geometry)
                if geometryCount > 0 {
                    Humboldt_OGR_G_StealExteriorRing(geometry)
                }
                if geometryCount > 1 {
                    for index in 0..<geometryCount - 1 {
                        Humboldt_OGR_G_StealInteriorRing(geometry, index)
                    }
                }
            } else {
                OGR_G_RemoveGeometry(geometry, -1, 1);
            }
        }

        OGR_G_DestroyGeometry(geometry)
    }
}

/// Makes sure that the given geometry storage is not referenced by more than one object.
func ensureUnique(inout geometryStorage geometryStorage: GeometryStorage) {
    if !isUniquelyReferencedNonObjC(&geometryStorage) {
        geometryStorage = geometryStorage.copy()!
    }
}