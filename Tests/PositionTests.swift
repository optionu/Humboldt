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
        let position = Position()
        
        XCTAssertEqual(position.x, 0)
        XCTAssertEqual(position.y, 0)
        XCTAssertEqual(position.altitude, nil)
    }

    func testInitXY() {
        let x = 1.0, y = 2.0, altitude = 3.0
        let position = Position(x: x, y: y, altitude: altitude)

        XCTAssertEqual(position.x, x)
        XCTAssertEqual(position.y, y)
        XCTAssertEqual(position.altitude, altitude)
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

    func testSetXY() {
        let x = 1.0, y = 2.0, altitude = 3.0
        var position = Position()
        position.x = x
        position.y = y
        position.altitude = altitude
        
        XCTAssertEqual(position.x, x)
        XCTAssertEqual(position.y, y)
        XCTAssertEqual(position.altitude, altitude)

        XCTAssertEqual(position.longitude, x)
        XCTAssertEqual(position.latitude, y)

        XCTAssertEqual(position.easting, x)
        XCTAssertEqual(position.northing, y)
    }
    
    func testEqual() {
        XCTAssertEqual(Position(), Position())
        XCTAssertEqual(Position(x: 1.0, y: -3.0), Position(x: 1.0, y: -3.0))
        XCTAssertNotEqual(Position(x: 1.0, y: -3.0), Position(x: 1.0, y: -3.1))
        XCTAssertNotEqual(Position(x: 1.0, y: -3.0), Position(x: 0.9, y: -3.0))

        XCTAssertEqual(Position(x: -1.5, y: 2.7, altitude: 13.14), Position(x: -1.5, y: 2.7, altitude: 13.14))
        XCTAssertNotEqual(Position(x: -1.5, y: 2.7, altitude: 13.14), Position(x: -1.5, y: 2.7, altitude: nil))
        XCTAssertNotEqual(Position(x: -1.5, y: 2.7, altitude: nil), Position(x: -1.5, y: 2.7, altitude: 13-14))
    }
}
