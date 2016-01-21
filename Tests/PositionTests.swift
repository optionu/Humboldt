//
//  CoordinateTests.swift
//  Humboldt
//
//  Created by Claus Höfele on 23.01.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import XCTest
@testable import Humboldt

class PositionTests: XCTestCase {
    func testInit() {
        let x = 1.0, y = 2.0, altitude = 3.0
        let position = Position(x: x, y: y, altitude: altitude)

        XCTAssertEqual(position.x, x)
        XCTAssertEqual(position.y, y)
        XCTAssertEqual(position.altitude, altitude)

        XCTAssertEqual(position.longitude, x)
        XCTAssertEqual(position.latitude, y)

        XCTAssertEqual(position.easting, x)
        XCTAssertEqual(position.northing, y)
    }

    func testInitLongitudeLatitude() {
        let x = 1.0, y = 2.0, altitude = 3.0
        let position = Position(longitude: x, latitude: y, altitude: altitude)
        
        XCTAssertEqual(position.x, x)
        XCTAssertEqual(position.y, y)
        XCTAssertEqual(position.altitude, altitude)
    }

    func testInitLongEastingNorthing() {
        let x = 1.0, y = 2.0, altitude = 3.0
        let position = Position(easting: x, northing: y, altitude: altitude)
        
        XCTAssertEqual(position.x, x)
        XCTAssertEqual(position.y, y)
        XCTAssertEqual(position.altitude, altitude)
    }
}
