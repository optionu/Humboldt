//
//  FileManager.swift
//  SwiftGIS
//
//  Created by Claus Höfele on 06/01/16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

import Foundation
import CGDAL

final class GeometryStorage {
    private let geometry: OGRGeometryH
    private var name: String {
        return String.fromCString(OGR_G_GetGeometryName(geometry)) ?? ""
    }
    
    init?(geometry: OGRGeometryH) { // throws?
        // In Swift <2.2, classes must initialize stored properties before returning nil
        self.geometry = geometry

        if (geometry == nil) {
            return nil
        }
    }
    
    deinit {
        OGR_G_DestroyGeometry(geometry)
    }
    
}

final public class DataSet {
    public var geometriesCollection: String

    convenience public init(fileName: String) {
        self.init(geometriesCollection: "")
    }

    convenience public init() {
        self.init(geometriesCollection: "")
    }

    public init(geometriesCollection: String) {
        self.geometriesCollection = ""
    }
    
    public func readData1() {
        // http://gdal.org/1.11/ogr/ogr__api_8h.html
        
        OGRRegisterAll()
        
        let geoJSON = "{\"type\": \"Feature\",\"geometry\": {\"type\": \"Point\", \"coordinates\": [125.6, 10.1]},\"properties\": {\"name\": \"Dinagat Islands\"}}"
        let geoJSONData = geoJSON.dataUsingEncoding(NSUTF8StringEncoding)!

        let fileName = "/vsimem/\(NSUUID().UUIDString)"
        let file = VSIFileFromMemBuffer(fileName, UnsafeMutablePointer<UInt8>(geoJSONData.bytes), UInt64(geoJSONData.length), 0)
        VSIFCloseL(file)

        let dataSet = OGROpen(fileName, 0, nil)
        let count = OGR_DS_GetLayerCount(dataSet)
        print(count)
        
        OGRReleaseDataSource(dataSet)
    }
    
    public func readData() {
        // http://www.gdal.org/ogr__api_8h.html
        // http://www.gdal.org/gdal_8h.html
        // http://www.gdal.org/ogr_apitut.html
        // https://github.com/OSGeo/gdal
        // http://pcjericks.github.io/py-gdalogr-cookbook/#
        // http://ankit.im/swift/2016/01/02/creating-value-type-generic-stack-in-swift-with-pointers-and-copy-on-write/
        
        GDALAllRegister();
        
        let geoJSON = "{\"type\": \"Feature\",\"geometry\": {\"type\": \"Point\", \"coordinates\": [125.6, 10.1]},\"properties\": {\"name\": \"Dinagat Islands\"}}"
        let geoJSONData = geoJSON.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let fileName = "/vsimem/\(NSUUID().UUIDString)"
        let file = VSIFileFromMemBuffer(fileName, UnsafeMutablePointer<UInt8>(geoJSONData.bytes), UInt64(geoJSONData.length), 0)
        VSIFCloseL(file)
        
        let dataset = GDALOpenEx(fileName, UInt32(GDAL_OF_VECTOR), nil, nil, nil)
        for layerIndex in 0..<GDALDatasetGetLayerCount(dataset) {
            let layer = GDALDatasetGetLayer(dataset, layerIndex)
            let layerName = String.fromCString(OGR_L_GetName(layer))
            print("Layer \(layerIndex): \(layerName)")
            
            OGR_L_ResetReading(layer)
            var feature = OGR_L_GetNextFeature(layer)
            while feature != nil {
                let geometry = OGR_F_StealGeometry(feature)
                if let geometryStorage = GeometryStorage(geometry: geometry) {
                    print("Geometry: \(geometryStorage.name)")
                }
                
                OGR_F_Destroy(feature)

                feature = OGR_L_GetNextFeature(layer)
            }
        }

        GDALClose(dataset)
    }
}