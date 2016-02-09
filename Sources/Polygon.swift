//
//  Polygon.swift
//  Humboldt
//
//  Created by Claus Höfele on 23.01.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import Foundation
import CGDAL

public struct Polygon : Geometry {
    public let geometryStorage: GeometryStorage
    public var exteriorRing: PositionCollection {
        didSet {
            OGR_G_CloseRings(exteriorRing.geometryStorage.geometry)
        }
    }
    public var interiorRings: [PositionCollection]? {
        didSet {
            for interiorRing in interiorRings ?? [PositionCollection]() {
                OGR_G_CloseRings(interiorRing.geometryStorage.geometry)
            }
        }
    }
    
    public init() {
        let geometry = OGR_G_CreateGeometry(wkbPolygon)
        let geometryStorage = GeometryStorage(geometry: geometry)!

        self.init(geometryStorage: geometryStorage)
    }
    
    init(geometryStorage: GeometryStorage) {
        precondition(OGR_G_GetGeometryType(geometryStorage.geometry) == wkbPolygon)
        
        self.geometryStorage = geometryStorage
        let geometryCount = OGR_G_GetGeometryCount(geometryStorage.geometry)
        
        let geometryExteriorRing: OGRGeometryH = {
            if geometryCount > 0 {
                return OGR_G_GetGeometryRef(geometryStorage.geometry, 0)
            } else {
                let geometryExteriorRing = OGR_G_CreateGeometry(wkbLinearRing)
                OGR_G_AddGeometryDirectly(geometryStorage.geometry, geometryExteriorRing)
                return geometryExteriorRing
            }
        }()
        let geometryStorageExteriorRing = GeometryStorage(geometry: geometryExteriorRing)!
        self.exteriorRing = PositionCollection(geometryStorage: geometryStorageExteriorRing)
        
        if geometryCount > 1 {
            var interiorRings = [PositionCollection]()
            for i in 1..<geometryCount {
                let geometryInteriorRing = OGR_G_GetGeometryRef(geometryStorage.geometry, i)
                let geometryStorageInteriorRing = GeometryStorage(geometry: geometryInteriorRing)!
                let positionCollection = PositionCollection(geometryStorage: geometryStorageInteriorRing)
                interiorRings.append(positionCollection)
            }
            self.interiorRings = interiorRings.count > 0 ? interiorRings : nil
        } else {
            self.interiorRings = nil
        }
    }
}