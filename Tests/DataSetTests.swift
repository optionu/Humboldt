//
//  DataSetTests.swift
//  Humboldt
//
//  Created by Claus Höfele on 23.01.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import XCTest
@testable import Humboldt

class DataSetTests: XCTestCase {
    func testExample() {
        let dataSet = DataSet()
        let geometries = dataSet.readData()
        if let point = geometries.first as? Point {
            print("\(point.position)")
        }
        
        XCTAssertEqual(geometries.count, 1)
    }
    
    func testDriverNames() {
        let dataSet = DataSet()
        let driverNames = dataSet.driverNames
        XCTAssertGreaterThan(driverNames.count, 0)
    }
}
