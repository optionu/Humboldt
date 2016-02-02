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
        
        let positionCollection = PositionCollection(geometryStorage: geometryStorage)
        
        var numPositions = 0
        for position in positionCollection {
            XCTAssertEqual(position, positions[numPositions])

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
        
        let positionCollection = PositionCollection(geometryStorage: geometryStorage)
        
        XCTAssertEqual(positionCollection.count, positions.count)
        XCTAssertEqual(positionCollection.startIndex, 0)
        XCTAssertEqual(positionCollection.endIndex, positions.count)
        
        for index in 0..<positionCollection.count {
            XCTAssertEqual(positionCollection[index], positions[index])
        }
    }

    func testMutableCollectionType() {
        let positions = [Position(), Position(x: 1, y: 2), Position(x: 3, y: 4)]
        
        let geometry = OGR_G_CreateGeometry(wkbLineString)
        OGR_G_SetPointCount(geometry, 3)
        let geometryStorage = GeometryStorage(geometry: geometry)!
        
        var positionCollection = PositionCollection(geometryStorage: geometryStorage)
        positionCollection[0] = positions[0]
        positionCollection[1] = positions[1]
        positionCollection[2] = positions[2]
        
        XCTAssertEqual(positionCollection.count, positions.count)
        for index in 0..<positionCollection.count {
            XCTAssertEqual(positionCollection[index], positions[index])
        }
    }

    func testRangeReplaceableCollectionTypeAppend() {
        let positions = [Position(x: -1, y: -2), Position(x: 1, y: 2)]
        var positionCollection = PositionCollection()
        
        positionCollection.append(positions[0])
        XCTAssertEqual(positionCollection[0], positions[0])
        XCTAssertEqual(positionCollection.count, 1)

        positionCollection.append(positions[1])
        XCTAssertEqual(positionCollection[0], positions[0])
        XCTAssertEqual(positionCollection[1], positions[1])
        XCTAssertEqual(positionCollection.count, 2)
        
        positionCollection.appendContentsOf(positions)
        XCTAssertEqual(positionCollection[0], positions[0])
        XCTAssertEqual(positionCollection[1], positions[1])
        XCTAssertEqual(positionCollection[2], positions[0])
        XCTAssertEqual(positionCollection[3], positions[1])
        XCTAssertEqual(positionCollection.count, 4)
    }

    func testRangeReplaceableCollectionTypeInsert() {
        let positions = [Position(x: -1, y: -2), Position(x: 1, y: 2)]
        var positionCollection = PositionCollection()

        positionCollection.insert(positions[1], atIndex: 0)
        XCTAssertEqual(positionCollection[0], positions[1])
        XCTAssertEqual(positionCollection.count, 1)

        positionCollection.insert(positions[0], atIndex: 0)
        XCTAssertEqual(positionCollection[0], positions[0])
        XCTAssertEqual(positionCollection[1], positions[1])
        XCTAssertEqual(positionCollection.count, 2)

        positionCollection.insertContentsOf(positions, at: 1)
        XCTAssertEqual(positionCollection[0], positions[0])
        XCTAssertEqual(positionCollection[1], positions[0])
        XCTAssertEqual(positionCollection[2], positions[1])
        XCTAssertEqual(positionCollection[3], positions[1])
        XCTAssertEqual(positionCollection.count, 4)
    }

    func testRangeReplaceableCollectionTypeRemove() {
        let positions = [Position(x: -1, y: -2), Position(x: 1, y: 2), Position(x: 3, y: 4), Position(x: -10, y: 3)]
        var positionCollection = PositionCollection()
        positionCollection.appendContentsOf(positions)

        positionCollection.removeAtIndex(1)
        XCTAssertEqual(positionCollection[0], positions[0])
        XCTAssertEqual(positionCollection[1], positions[2])
        XCTAssertEqual(positionCollection[2], positions[3])
        XCTAssertEqual(positionCollection.count, 3)

        positionCollection.removeRange(0...1)
        XCTAssertEqual(positionCollection[0], positions[3])
        XCTAssertEqual(positionCollection.count, 1)

        positionCollection.removeAll(keepCapacity: true)
        XCTAssertEqual(positionCollection.count, 0)

        positionCollection.removeAll()
        XCTAssertEqual(positionCollection.count, 0)
    }

    func testRangeReplaceableCollectionTypeReplace() {
        let positions = [Position(x: -1, y: -2), Position(x: 1, y: 2), Position(x: 3, y: 4), Position(x: -10, y: 3)]
        var positionCollection = PositionCollection()

        positionCollection.replaceRange(0..<0, with: [positions[0], positions[1]])
        XCTAssertEqual(positionCollection[0], positions[0])
        XCTAssertEqual(positionCollection[1], positions[1])
        XCTAssertEqual(positionCollection.count, 2)

        positionCollection.replaceRange(0..<2, with: [positions[1], positions[0]])
        XCTAssertEqual(positionCollection[0], positions[1])
        XCTAssertEqual(positionCollection[1], positions[0])
        XCTAssertEqual(positionCollection.count, 2)

        positionCollection.replaceRange(1..<2, with: [])
        XCTAssertEqual(positionCollection[0], positions[1])
        XCTAssertEqual(positionCollection.count, 1)
    }

    func testEqual() {
        var positionCollection0 = PositionCollection()
        positionCollection0.appendContentsOf([Position(), Position(x: 1, y: 2)])

        let positionCollection1 = positionCollection0
        XCTAssertEqual(positionCollection0, positionCollection0)
        XCTAssertEqual(positionCollection0, positionCollection1)

        var positionCollection2 = PositionCollection()
        positionCollection2.appendContentsOf([Position()])
        XCTAssertNotEqual(positionCollection0, positionCollection2)

        var positionCollection3 = PositionCollection()
        positionCollection3.appendContentsOf([Position(), Position(x: 1, y: 2.2)])
        XCTAssertNotEqual(positionCollection0, positionCollection3)
    }

    func testCopyOnWriteSetter() {
        var positionCollection0 = PositionCollection()
        positionCollection0.append(Position())

        var positionCollection1 = positionCollection0
        XCTAssertEqual(positionCollection0, positionCollection1)

        positionCollection1[0] = Position(x: 3, y: 4)
        XCTAssertNotEqual(positionCollection0, positionCollection1)
    }

    func testCopyOnWriteReplaceRange() {
        var positionCollection0 = PositionCollection()
        positionCollection0.append(Position())

        var positionCollection1 = positionCollection0
        XCTAssertEqual(positionCollection0, positionCollection1)

        positionCollection1.append(Position())
        XCTAssertNotEqual(positionCollection0, positionCollection1)
    }
}
