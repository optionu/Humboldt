//
//  custom_gdal.h
//  Humboldt
//
//  Created by Claus Höfele on 07/02/16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

#ifndef custom_gdal_h
#define custom_gdal_h

#ifdef __cplusplus
extern "C" {
#endif

typedef struct OGRGeometryHS *OGRGeometryH;

OGRGeometryH Humboldt_OGR_G_StealExteriorRing( OGRGeometryH );
OGRGeometryH Humboldt_OGR_G_StealInteriorRing( OGRGeometryH, int );

#ifdef __cplusplus
}
#endif

#endif /* custom_gdal_h */
