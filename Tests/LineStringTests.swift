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
        let lineString = LineString()
        XCTAssertEqual(lineString.positions.count, 0)
    }
    
    func testCopyOnWrite() {
        let positions = [Position(x: 1, y: 2), Position(x: 3, y: 4)]

        var lineString0 = LineString()
        lineString0.positions.append(positions[0])

        var lineString1 = lineString0
        XCTAssertTrue(lineString0.geometryStorage === lineString1.geometryStorage)
//        XCTAssertEqual(lineString1.positions, lineString1.positions)

        lineString1.positions[0] = Position(x: 3, y: 4)
        XCTAssertTrue(lineString0.geometryStorage !== lineString1.geometryStorage)
//        XCTAssertNotEqual(lineString0.positions[0].x, lineString1.position.x)
    }
}
