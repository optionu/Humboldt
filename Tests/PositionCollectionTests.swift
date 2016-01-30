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
        
        let positionCollection = PositionCollection(geometryStorage: geometryStorage)
        
        XCTAssertEqual(positionCollection.count, positions.count)
        XCTAssertEqual(positionCollection.startIndex, 0)
        XCTAssertEqual(positionCollection.endIndex, positions.count)
        
        for index in 0..<positionCollection.count {
            XCTAssertEqual(positionCollection[index].x, positions[index].x)
            XCTAssertEqual(positionCollection[index].y, positions[index].y)
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
            XCTAssertEqual(positionCollection[index].x, positions[index].x)
            XCTAssertEqual(positionCollection[index].y, positions[index].y)
        }
    }

    func testRangeReplaceableCollectionTypeAppend() {
        let positions = [Position(x: -1, y: -2), Position(x: 1, y: 2)]
        var positionCollection = PositionCollection()
        
        positionCollection.append(positions[0])
        XCTAssertEqual(positionCollection[0].x, positions[0].x)
        XCTAssertEqual(positionCollection[0].y, positions[0].y)
        XCTAssertEqual(positionCollection.count, 1)

        positionCollection.append(positions[1])
        XCTAssertEqual(positionCollection[0].x, positions[0].x)
        XCTAssertEqual(positionCollection[0].y, positions[0].y)
        XCTAssertEqual(positionCollection[1].x, positions[1].x)
        XCTAssertEqual(positionCollection[1].y, positions[1].y)
        XCTAssertEqual(positionCollection.count, 2)
        
        positionCollection.appendContentsOf(positions)
        XCTAssertEqual(positionCollection[0].x, positions[0].x)
        XCTAssertEqual(positionCollection[0].y, positions[0].y)
        XCTAssertEqual(positionCollection[1].x, positions[1].x)
        XCTAssertEqual(positionCollection[1].y, positions[1].y)
        XCTAssertEqual(positionCollection[2].x, positions[0].x)
        XCTAssertEqual(positionCollection[2].y, positions[0].y)
        XCTAssertEqual(positionCollection[3].x, positions[1].x)
        XCTAssertEqual(positionCollection[3].y, positions[1].y)
        XCTAssertEqual(positionCollection.count, 4)
    }

//    func testRangeReplaceableCollectionTypeInsert() {
//        let positions = [Position(x: -1, y: -2), Position(x: 1, y: 2)]
//        var positionCollection = PositionCollection()
//
//        positionCollection.insert(positions[1], atIndex: 0)
//        XCTAssertEqual(positionCollection[0].x, positions[1].x)
//        XCTAssertEqual(positionCollection[0].y, positions[1].y)
//        XCTAssertEqual(positionCollection.count, 1)
//
//        positionCollection.insert(positions[0], atIndex: 0)
//        XCTAssertEqual(positionCollection[0].x, positions[0].x)
//        XCTAssertEqual(positionCollection[0].y, positions[0].y)
//        XCTAssertEqual(positionCollection[1].x, positions[1].x)
//        XCTAssertEqual(positionCollection[1].y, positions[1].y)
//        XCTAssertEqual(positionCollection.count, 2)
//
//        positionCollection.insertContentsOf(positions, at: 1)
//        XCTAssertEqual(positionCollection[0].x, positions[0].x)
//        XCTAssertEqual(positionCollection[0].y, positions[0].y)
//        XCTAssertEqual(positionCollection[1].x, positions[0].x)
//        XCTAssertEqual(positionCollection[1].y, positions[0].y)
//        XCTAssertEqual(positionCollection[2].x, positions[1].x)
//        XCTAssertEqual(positionCollection[2].y, positions[1].y)
//        XCTAssertEqual(positionCollection[3].x, positions[1].x)
//        XCTAssertEqual(positionCollection[3].y, positions[1].y)
//        XCTAssertEqual(positionCollection.count, 4)
//    }
    
//        positionCollection.replaceRange(1...2, with: [positions[1], positions[2]])
//        XCTAssertEqual(positionCollection[0].x, positions[0].x)
//        XCTAssertEqual(positionCollection[0].y, positions[0].y)
//        XCTAssertEqual(positionCollection[1].x, positions[1].x)
//        XCTAssertEqual(positionCollection[1].y, positions[1].y)
//        XCTAssertEqual(positionCollection[2].x, positions[2].x)
//        XCTAssertEqual(positionCollection[2].y, positions[2].y)
//        XCTAssertEqual(positionCollection.count, 3)
//        
//        positionCollection.removeAtIndex(1)
//        XCTAssertEqual(positionCollection[0].x, positions[0].x)
//        XCTAssertEqual(positionCollection[0].y, positions[0].y)
//        XCTAssertEqual(positionCollection[1].x, positions[2].x)
//        XCTAssertEqual(positionCollection[1].y, positions[2].y)
//        XCTAssertEqual(positionCollection.count, 2)
//
////        positionCollection.removeRange(<#T##subRange: Range<Int>##Range<Int>#>)
//
//        positionCollection.removeAll(keepCapacity: true)
//        XCTAssertEqual(positionCollection.count, 0)
//
//        positionCollection.removeAll()
//        XCTAssertEqual(positionCollection.count, 0)
//    }
}
