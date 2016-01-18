//
//  SwiftGISTests.swift
//  SwiftGISTests
//
//  Created by Claus Höfele on 06/01/16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import XCTest
@testable import Humboldt

class HumboldtTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        let dataSet = DataSet()
        dataSet.readData()
    }
    
    func testGeometryStorage() {
        let geometryStorage = GeometryStorage(geometry: nil)
        XCTAssertNil(geometryStorage)
    }
    
}
