//
//  PositionCollectionTests.swift
//  Humboldt
//
//  Created by Claus Höfele on 24.01.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import XCTest
import CGDAL
@testable import Humboldt

class PositionCollectionTests: XCTestCase {
    func testSequenceType() {
        let positions = [Position(), Position(x: 1, y: 2), Position(x: 3, y: 4)]
        
        let geometry = OGR_G_CreateGeometry(wkbLineString)
        OGR_G_AddPoint_2D(geometry, positions[0].x, positions[0].y)
        OGR_G_AddPoint_2D(geometry, positions[1].x, positions[1].y)
        OGR_G_AddPoint_2D(geometry, positions[2].x, positions[2].y)
        let geometryStorage = GeometryStorage(geometry: geometry)!

        let positionsInCollection = PositionCollection(geometryStorage: geometryStorage)
        
        var numPositions = 0
        for position in positionsInCollection {
            XCTAssertEqual(position.x, positions[numPositions].x)
            XCTAssertEqual(position.y, positions[numPositions].y)

            numPositions += 1
        }
        XCTAssertEqual(numPositions, positions.count)
    }
    
    func testCollectionType() {
        let positions = [Position(), Position(x: 1, y: 2), Position(x: 3, y: 4)]
        
        let geometry = OGR_G_CreateGeometry(wkbLineString)
        OGR_G_AddPoint_2D(geometry, positions[0].x, positions[0].y)
        OGR_G_AddPoint_2D(geometry, positions[1].x, positions[1].y)
        OGR_G_AddPoint_2D(geometry, positions[2].x, positions[2].y)
        let geometryStorage = GeometryStorage(geometry: geometry)!
        
        let positionsInCollection = PositionCollection(geometryStorage: geometryStorage)
        
        XCTAssertEqual(positionsInCollection.count, positions.count)
        XCTAssertEqual(positionsInCollection.startIndex, 0)
        XCTAssertEqual(positionsInCollection.endIndex, positions.count)
        
        for index in 0..<positionsInCollection.count {
            XCTAssertEqual(positionsInCollection[index].x, positions[index].x)
            XCTAssertEqual(positionsInCollection[index].y, positions[index].y)
        }
    }

    func testMutableCollectionType() {
        let positions = [Position(), Position(x: 1, y: 2), Position(x: 3, y: 4)]
        
        let geometry = OGR_G_CreateGeometry(wkbLineString)
        OGR_G_SetPointCount(geometry, 3)
        let geometryStorage = GeometryStorage(geometry: geometry)!
        
        var positionsInCollection = PositionCollection(geometryStorage: geometryStorage)
        positionsInCollection[0] = positions[0]
        positionsInCollection[1] = positions[1]
        positionsInCollection[2] = positions[2]
        
        XCTAssertEqual(positionsInCollection.count, positions.count)
        for index in 0..<positionsInCollection.count {
            XCTAssertEqual(positionsInCollection[index].x, positions[index].x)
            XCTAssertEqual(positionsInCollection[index].y, positions[index].y)
        }
    }
}
