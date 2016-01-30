//
//  Coordinate.swift
//  Humboldt
//
//  Created by Claus Höfele on 23.01.16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import Foundation

public struct Position {
    public var x, y: Double
    public var altitude: Double?
    
    public var longitude: Double { return x }
    public var latitude: Double { return y }
    public var easting: Double { return x }
    public var northing: Double { return y }
    
    public init(x: Double = 0, y: Double = 0, altitude: Double? = nil) {
        self.x = x
        self.y = y
        self.altitude = altitude
    }
    
    public init(longitude: Double, latitude: Double, altitude: Double? = nil) {
        self.init(x: longitude, y: latitude, altitude: altitude)
    }
    
    public init(easting: Double, northing: Double, altitude: Double? = nil) {
        self.init(x: easting, y: northing, altitude: altitude)
    }
}

extension Position : Equatable {}

public func ==(lhs: Position, rhs: Position) -> Bool {
    func equal(a: Double?, _ b: Double?) -> Bool {
        switch (a, b) {
        case (.None, .None):
            return true
        case let (a?, b?):
            return abs(a - b) < 1.0e-5
        default:
            return false
        }
    }
    
    return equal(lhs.x, rhs.x) && equal(lhs.y, rhs.y) && equal(lhs.altitude, rhs.altitude)
}