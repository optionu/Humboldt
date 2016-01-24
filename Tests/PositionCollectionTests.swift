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
    func testGenerate() {
        let positions = [Position(), Position(x: 1, y: 2), Position(x: 3, y: 4)]
        
        let geometry = OGR_G_CreateGeometry(wkbLineString)
        OGR_G_AddPoint_2D(geometry, positions[0].x, positions[0].y)
        OGR_G_AddPoint_2D(geometry, positions[1].x, positions[1].y)
        OGR_G_AddPoint_2D(geometry, positions[2].x, positions[2].y)
        let geometryStorage = GeometryStorage(geometry: geometry)!

        var numPositions = 0
        let positionsInCollection = PositionCollection(geometryStorage: geometryStorage)
        for position in positionsInCollection {
            XCTAssertEqual(position.x, positions[numPositions].x)
            XCTAssertEqual(position.y, positions[numPositions].y)

            numPositions += 1
        }
        XCTAssertEqual(numPositions, positions.count)
    }
}
