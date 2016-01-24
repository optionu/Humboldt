//
//  GeometriesTests.swift
//  Humboldt
//
//  Created by Claus Höfele on 22.01.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import XCTest
@testable import Humboldt

class PointTests: XCTestCase {
    func testInit() {
        let point = Point()
        XCTAssertEqual(point.position.x, 0)
        XCTAssertEqual(point.position.y, 0)
        XCTAssertEqual(point.position.altitude, nil)
        XCTAssertFalse(point.is3D)
    }
    
    func testInitWithCoordinate2D() {
        let point = Point(position: Position(x: 1, y: 2))
        XCTAssertEqual(point.position.x, 1)
        XCTAssertEqual(point.position.y, 2)
        XCTAssertEqual(point.position.altitude, nil)
        XCTAssertFalse(point.is3D)
    }

    func testInitWithCoordinate3D() {
        let point = Point(position: Position(x: 1, y: 2, altitude: 3))
        XCTAssertEqual(point.position.x, 1)
        XCTAssertEqual(point.position.y, 2)
        XCTAssertEqual(point.position.altitude, 3)
        XCTAssertTrue(point.is3D)
    }
    
    func testChangeTo3D() {
        var point = Point(position: Position(x: 1, y: 2))
        XCTAssertFalse(point.is3D)
        point.position = Position(x: 3, y: 4, altitude: 5)
        XCTAssertTrue(point.is3D)
    }
    
    func testSetCoordinate() {
        var point = Point()
        point.position = Position(x: 1, y: 2)
        XCTAssertEqual(point.position.x, 1)
        XCTAssertEqual(point.position.y, 2)
        XCTAssertEqual(point.position.altitude, nil)
    }
    
    func testCopyOnWrite() {
        let point0 = Point()
        var point1 = point0
        XCTAssertTrue(point0.geometryStorage === point1.geometryStorage)
        XCTAssertEqual(point0.position.x, point1.position.x)
        
        point1.position = Position(x: 3, y: 4)
        XCTAssertTrue(point0.geometryStorage !== point1.geometryStorage)
        XCTAssertNotEqual(point0.position.x, point1.position.x)
    }
}
