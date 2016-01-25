//
//  LineStringTests.swift
//  Humboldt
//
//  Created by Claus Höfele on 24.01.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import XCTest
import CGDAL
@testable import Humboldt

class LineStringTests: XCTestCase {
    func testInit() {
//        let lineString = LineString()
//        XCTAssertEqual(lineString.positions.count, 0)
    }
    
    func testCopyOnWrite() {
        let lineString0 = LineString()
        var lineString1 = lineString0
        XCTAssertTrue(lineString0.geometryStorage === lineString1.geometryStorage)
//        XCTAssertEqual(lineString0.position.x, lineString1.position.x)
        
        OGR_G_SetPointCount(lineString1.positions.geometryStorage.geometry, 1)
        lineString1.positions[0] = Position(x: 3, y: 4)
        XCTAssertTrue(lineString0.geometryStorage !== lineString1.geometryStorage)
//        XCTAssertNotEqual(lineString0.positions[0].x, lineString1.position.x)
    }
}
