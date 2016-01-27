//
//  PolygonTests.swift
//  Humboldt
//
//  Created by Claus Höfele on 26.01.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import XCTest
import CGDAL
@testable import Humboldt

class PolygonTests: XCTestCase {
    func testInitGeometryStorage() {
        let geometry = OGR_G_CreateGeometry(wkbPolygon)
        let geometryExteriorRing = OGR_G_CreateGeometry(wkbLinearRing)
        OGR_G_AddGeometryDirectly(geometry, geometryExteriorRing)
        let geometryInteriorRing = OGR_G_CreateGeometry(wkbLinearRing)
        OGR_G_AddGeometryDirectly(geometry, geometryInteriorRing)

        let geometryStorage = GeometryStorage(geometry: geometry)!
        let polygon = Humboldt.Polygon(geometryStorage: geometryStorage)
        
        XCTAssertEqual(polygon.exteriorRing.count, 0)
        XCTAssertEqual(polygon.interiorRings?.count, 1)
        XCTAssertEqual(polygon.interiorRings?.first?.count, 0)
    }

    func testInit() {
        let polygon = Humboldt.Polygon()
        XCTAssertEqual(polygon.exteriorRing.count, 0)
        XCTAssertNil(polygon.interiorRings)
    }
    
    func testChangeExteriorRing() {
        var polygon = Humboldt.Polygon()
        
        OGR_G_SetPointCount(polygon.exteriorRing.geometryStorage.geometry, 3)
        polygon.exteriorRing[0] = Position(x: 0, y: 0)
        polygon.exteriorRing[1] = Position(x: 1, y: 0)
        polygon.exteriorRing[2] = Position(x: 0, y: 0)
        XCTAssertEqual(polygon.exteriorRing.count, 3)
    }
    
    func testChangeExteriorRingForceClose() {
        var polygon = Humboldt.Polygon()
        
        OGR_G_SetPointCount(polygon.exteriorRing.geometryStorage.geometry, 2)
        polygon.exteriorRing[0] = Position(x: 0, y: 0)
        polygon.exteriorRing[1] = Position(x: 1, y: 0)
        XCTAssertEqual(polygon.exteriorRing.count, 3)
    }
}
