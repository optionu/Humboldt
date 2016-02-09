//
//  custom_gdal.c
//  Humboldt
//
//  Created by Claus Höfele on 07/02/16.
//  Copyright © 2016 Claus Höfele. All rights reserved.
//

#include "custom_gdal.h"

#include <stdio.h>

#include "ogr_geometry.h"
#include "ogr_api.h"

OGRGeometryH Humboldt_OGR_G_StealExteriorRing( OGRGeometryH hGeom )
{
    OGRwkbGeometryType eType = wkbFlatten(((OGRGeometry *) hGeom)->getGeometryType());
    if( OGR_GT_IsSubClassOf(eType, wkbPolygon) )
    {
        return (OGRGeometryH) ((OGRPolygon *)hGeom)->stealExteriorRing();
    }
    else
    {
        return NULL;
    }
}

OGRGeometryH Humboldt_OGR_G_StealInteriorRing( OGRGeometryH hGeom, int index )
{
    OGRwkbGeometryType eType = wkbFlatten(((OGRGeometry *) hGeom)->getGeometryType());
    if( OGR_GT_IsSubClassOf(eType, wkbPolygon) )
    {
        return (OGRGeometryH) ((OGRPolygon *)hGeom)->stealInteriorRing(index);
    }
    else
    {
        return NULL;
    }
}
