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
        XCTAssertEqual(point.position, Position())
        XCTAssertFalse(point.is3D)
    }
    
    func testInitWithCoordinate2D() {
        let position = Position(x: 1, y: 2)
        let point = Point(position: position)
        XCTAssertEqual(point.position, position)
        XCTAssertFalse(point.is3D)
    }

    func testInitWithCoordinate3D() {
        let position = Position(x: 1, y: 2, altitude: 3)
        let point = Point(position: position)
        XCTAssertEqual(point.position, position)
        XCTAssertTrue(point.is3D)
    }
    
    func testChangeTo3D() {
        var point = Point(position: Position(x: 1, y: 2))
        XCTAssertFalse(point.is3D)
        point.position = Position(x: 3, y: 4, altitude: 5)
        XCTAssertTrue(point.is3D)
    }
    
    func testSetCoordinate() {
        let position = Position(x: 1, y: 2)
        var point = Point()
        point.position = position
        XCTAssertEqual(point.position, position)
    }
    
    func testCopyOnWrite() {
        let point0 = Point()
        var point1 = point0
        XCTAssertTrue(point0.geometryStorage === point1.geometryStorage)
        XCTAssertEqual(point0.position, point1.position)
        
        point1.position = Position(x: 3, y: 4)
        XCTAssertTrue(point0.geometryStorage !== point1.geometryStorage)
        XCTAssertNotEqual(point0.position, point1.position)
    }
}
