//
//  FileManager.swift
//  SwiftGIS
//
//  Created by Claus Höfele on 06/01/16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import Foundation
import CGDAL

/// Finish data set reading
// ToDo: Handle OGR_G_IsValid as warning/errors, check wkb type
// ToDo: Use throws for GeometryStorage instead of init?
// ToDo: possible to hide geometryStorage property?

/// Geometry/-Storage
// Fix 3D when creating geometries?

/// LineString
// Add tests
// Unduplicate setting/getting positions code

/// Polygon
// ensure uniqueness (polygon instead of point collection)
// init and test interiorRings

/// PositionCollection
// ArrayLiteralConvertible
// append, insert -> ExtensibleCollectionType (http://nshipster.com/swift-collection-protocols/)
// use append in tests

// MapKit functionality + tests

// ToDo: Why does wkbLinearRing need >= 4 points
// ToDo: wkbLineString ok for Polygon? (avoid duplicate point)
// ToDo: provide debug description

//////////////////////////////////////

final public class DataSet {
    public init() {
        if GDALGetDriverCount() == 0 {
            GDALAllRegister()
        }
    }
    
//    public var driverNames: [String] {
//        var driverNames = [String]()
//        for i in 0..<GDALGetDriverCount() {
//            let driver = GDALGetDriver(i)
//            if let driverName = String.fromCString(GDALGetDriverShortName(driver)) {
//                driverNames.append(driverName)
//            } else {
//                assert(false)
//            }
//        }
//        
//        return driverNames
//    }
    
    public var driverNames: [String] {
        var driverNames = [String]()
        for i in 0..<OGRGetDriverCount() {
            let driver = OGRGetDriver(i)
            if let driverName = String.fromCString(OGR_Dr_GetName(driver)) {
                driverNames.append(driverName)
            } else {
                assert(false)
            }
        }
        
        return driverNames
    }
    
    public func readData() -> [Geometry] {
        // http://www.gdal.org/ogr__api_8h.html
        // http://www.gdal.org/gdal_8h.html
        // http://www.gdal.org/ogr_apitut.html
        // https://github.com/OSGeo/gdal
        // http://pcjericks.github.io/py-gdalogr-cookbook/#
        // http://ankit.im/swift/2016/01/02/creating-value-type-generic-stack-in-swift-with-pointers-and-copy-on-write/
        
        let geoJSON = "{\"type\": \"Feature\",\"geometry\": {\"type\": \"Point\", \"coordinates\": [125.6, 10.1]},\"properties\": {\"name\": \"Dinagat Islands\"}}"
        let data = geoJSON.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let fileName = "/vsimem/\(NSUUID().UUIDString)"
        let file = VSIFileFromMemBuffer(fileName, UnsafeMutablePointer<UInt8>(data.bytes), UInt64(data.length), 0)
        VSIFCloseL(file)
        
        let dataset = GDALOpenEx(fileName, UInt32(GDAL_OF_VECTOR), nil, nil, nil)
        defer {
            GDALClose(dataset)
        }
        
        var geometries = [Geometry]()
        for layerIndex in 0..<GDALDatasetGetLayerCount(dataset) {
            let layer = GDALDatasetGetLayer(dataset, layerIndex)
            let layerName = String.fromCString(OGR_L_GetName(layer))
            print("Layer \(layerIndex): \(layerName)")
            
            OGR_L_ResetReading(layer)
            var feature = OGR_L_GetNextFeature(layer)
            while feature != nil {
                defer {
                    OGR_F_Destroy(feature)
                    feature = OGR_L_GetNextFeature(layer)
                }

                guard let geometry = createGeometryFromFeature(feature) else {
                    continue
                }
                
                print("Geometry: \(geometry)")
                geometries.append(geometry)
            }
        }
        
        return geometries
    }
}

func createGeometryFromFeature(feature: OGRFeatureH) -> Geometry? {
    let geometry = OGR_F_StealGeometry(feature)
    guard geometry != nil else {
        return nil
    }

    let geometryType = OGR_G_GetGeometryType(geometry)
    switch geometryType {
    case wkbPoint, wkbPoint25D:
        return Point(geometry: geometry)
    default:
        return nil
    }
}