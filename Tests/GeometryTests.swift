//
//  SwiftGISTests.swift
//  SwiftGISTests
//
//  Created by Claus Höfele on 06/01/16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import XCTest
import CGDAL
@testable import Humboldt

class GeometryTests: XCTestCase {
    func testNonNil() {
        let geometry = OGR_G_CreateGeometry(wkbPoint)
        let geometryStorage = GeometryStorage(geometry: geometry, ownsChildGeometries: true)
        XCTAssertNotNil(geometryStorage)
    }

    func testNil() {
        let geometryStorage = GeometryStorage(geometry: nil, ownsChildGeometries: true)
        XCTAssertNil(geometryStorage)
    }
    
    func testClone() {
        let geometry = OGR_G_CreateGeometry(wkbPoint)
        let geometryStorage = GeometryStorage(geometry: geometry, ownsChildGeometries: true)
        let geometryStorageCopy = geometryStorage?.copy()

        XCTAssertNotNil(geometryStorageCopy)
        XCTAssertFalse(geometryStorage === geometryStorageCopy)
        XCTAssertEqual(geometryStorage?.ownsChildGeometries, geometryStorageCopy?.ownsChildGeometries)
    }

    func testCloneOwnsChildGeometries() {
        let geometry = OGR_G_CreateGeometry(wkbPoint)
        let geometryStorage = GeometryStorage(geometry: geometry, ownsChildGeometries: false)
        let geometryStorageCopy = geometryStorage?.copy()

        XCTAssertNotNil(geometryStorageCopy)
        XCTAssertFalse(geometryStorage === geometryStorageCopy)
        XCTAssertEqual(geometryStorage?.ownsChildGeometries, geometryStorageCopy?.ownsChildGeometries)
    }
    
    func testDoesNotOwnChildGeometries() {
        let geometry = OGR_G_CreateGeometry(wkbPolygon)
        let geometryChild = OGR_G_CreateGeometry(wkbLinearRing)
        OGR_G_AddGeometryDirectly(geometry, geometryChild)
        let geometryStorage = GeometryStorage(geometry: geometry, ownsChildGeometries: false)
        XCTAssertNotNil(geometryStorage)
        OGR_G_DestroyGeometry(geometryChild)
    }
    
    //    func testFeature() {
    //        let featureDefinition = OGR_FD_Crea
    //        let geometryStorage = GeometryStorage(feature: nil)
    //        XCTAssertNotNil(geometryStorage)
    ////        XCTAssertEqual(geometryStorage?.geometry, geometryPolygon)
    //    }
    
    //    testFeatureNoGeometry 
    
    
    
//    func testPolygon() {
//        let geometry = OGR_G_CreateGeometry(wkbLinearRing)
//        let x = 0.0, y = 0.0, z = 0.0;
//        OGR_G_AddPoint(geometry, x, y, z)
//        OGR_G_AddPoint(geometry, 1, 0, 0)
//        OGR_G_AddPoint(geometry, 1, 1, 0)
//        OGR_G_AddPoint(geometry, x, y, z)
//
//        let geometryPolygon = OGR_G_CreateGeometry(wkbPolygon)
//        OGR_G_AddGeometryDirectly(geometryPolygon, geometry)
//        XCTAssertTrue(OGR_G_IsValid(geometryPolygon) != 0)
//
//        let geometryStorage = GeometryStorage(geometry: geometryPolygon)
//        XCTAssertNotNil(geometryStorage)
//        XCTAssertEqual(geometryStorage?.geometry, geometryPolygon)
//    }
//
//    func testAnnotations() {
//        let geometry = OGR_G_CreateGeometry(wkbPoint)
//        OGR_G_AddPoint(geometry, 1, 2, 3)
//        OGR_G_AddPoint(geometry, 4, 5, 6)
//        XCTAssertTrue(OGR_G_IsValid(geometry) != 0)
//
//        let geometryStorage = GeometryStorage(geometry: geometry)!
//        let point = Point(geometryStorage: geometryStorage)
//        
//        let annotations = point.annotations()
//        XCTAssertEqual(annotations.count, 1)
//        
//        XCTAssertEqual(point.name, "POINT")
//    }
}
