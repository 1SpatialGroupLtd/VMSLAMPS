/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:55:16.000000000 +0000
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see http://www.gnu.org/licenses/.
 */
#ifndef _GEOM_DEFNS
#define _GEOM_DEFNS
/* $Header: /gothic/hdr/geomlib/v1-21/RCS/hdr.geom_defns.h,v 1.19.2.3 1995/03/22 16:56:53 ron Exp $								*/
/* 									*/

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Ron Russell, 21-Sep-1990					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*			G E O M _ D E F N S . H 			*/
/*									*/
/* Part of GOTHIC module GEOMLIB					*/
/* Version 0.1, Ron Russell 21-Sep-1990					*/
/*									*/
/* Enumerations and constants used by GEOMLIB intrinsic functions	*/
/************************************************************************/


/*----------------------------------------------------------------------*/
/* TYPE GEOM_COORD_PAIR							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* This is a two element array that holds an x and y coordinate pair.	*/
/*									*/
/* It is not available in Lull.						*/
/*									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef	GOTH_REAL 	GEOM_COORD_PAIR[2];

/* end-def */

/*----------------------------------------------------------------------*/
/* TYPE ENUM GEOMETRY_TYPE						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Geometries have a number of sub-types. These are identified by the	*/
/* type of data that they contain (points, lines, or areas).		*/
/* 									*/
/* 									*/
/*..ELEMENTS............................................................*/
/* _GT_SIMP_POINT	- Contains a single locating coordinate pair.	*/
/* _GT_SIMP_LINE	- Contains a single sequence of vertices that	*/
/*			  may, or may not, be closed.			*/
/* _GT_SIMP_AREA	- Contains a single contiguous area. This is	*/
/*			  represented by its boundary, each component	*/
/*			  of which is implemented as a ring. The outer	*/
/*			  boundary of an area must be anticlockwise,	*/
/*			  and the internal boundaries clockwise. There	*/
/*			  may only be one outer boundary, but there may	*/
/* 			  be several inner boundaries. Boundaries must	*/
/* 			  not intersect.				*/
/* _GT_COMP_POINT	- Contains multiple simple points.		*/
/* _GT_COMP_LINE	- Contains multiple simple lines.		*/
/* _GT_COMP_AREA	- Contains multiple simple areas.		*/
/* _GT_COMPLEX		- Contains multiple simple geometries, arranged	*/
/*			  as lists of points, lines, and areas.		*/
/*									*/
/*----------------------------------------------------------------------*/

/* begin-def */


enum _geometry_types
{
   _GT_SIMP_POINT,
   _GT_SIMP_LINE,
   _GT_SIMP_AREA,
   _GT_COMP_POINT,
   _GT_COMP_LINE,
   _GT_COMP_AREA,
   _GT_COMPLEX
};

typedef enum _geometry_types GEOMETRY_TYPE;

/* end-def */

/*----------------------------------------------------------------------*/
/* TYPE ENUM GEOMETRY_CONST						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Constants used to identify which part of a geometry is being referred*/
/* to, or how geometries are marked.					*/
/* 									*/
/*..ELEMENTS............................................................*/
/* _GC_MARK	- Use a mark to identify the part of the geometry.	*/
/*		  There will be an associated <<mark_index>> to 	*/
/*		  identify the mark to use.				*/
/* _GC_OUTER	- Use the outer boundary of an area.			*/
/* _GC_INNER	- Use an inner boundary of an area. There will be an	*/
/*		  associated <<ring_index>> to identify the particular	*/
/*		  boundary.						*/
/* _GC_START	- Use the start of an open line geometry.		*/
/* _GC_END	- Use the end of an open line geometry.			*/
/* _GC_POSITION	- Use a position identified by a vertex number and a	*/
/*		  fraction along the vector out from that vertex.	*/
/* _GC_POINT	- Use the point identified by a mark.			*/
/* _GC_LINE	- Use the piece of linework identified by a particular	*/
/*		  mark.							*/
/* _GC_AREA	- Use the simple area identified by a particular mark.	*/
/*----------------------------------------------------------------------*/

/* begin-def */


enum _geometry_consts
{
   _GC_MARK,
   _GC_OUTER,
   _GC_INNER,
   _GC_START,
   _GC_END,
   _GC_POSITION,
   _GC_POINT,
   _GC_LINE,
   _GC_AREA
};

typedef enum _geometry_consts GEOMETRY_CONST;

/* end-def */


/*----------------------------------------------------------------------*/
/* TYPE ENUM GEOMETRY_MARK_TYPE						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Constants used to describe the information held by a mark.		*/
/* 									*/
/*..ELEMENTS............................................................*/
/* _GMT_VERTEX		- A particular vertex can be identified.	*/
/* _GMT_POSITION	- A position (maybe interpolated between	*/
/*			  vertices) can be identified.			*/
/* _GMT_LINE		- A piece of linework can be identified. This 	*/
/*			  may be in a line type geometry, or a boundary	*/
/*			  in an area.					*/
/* _GMT_AREA		- A simple area can be identified. This may be	*/
/*			  an element in a complex area.			*/
/* _GMT_UNSET		- The mark has not been set.			*/
/*----------------------------------------------------------------------*/


/* begin-def */


enum _geometry_mark_types
{
   _GMT_VERTEX,
   _GMT_POSITION,
   _GMT_LINE,
   _GMT_AREA,
   _GMT_UNSET
};

typedef enum _geometry_mark_types GEOMETRY_MARK_TYPE;

/* end-def */



/*----------------------------------------------------------------------*/
/* TYPE ENUM GEOMETRY_INTERSECT_TYPE					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* When testing if lines intersect, there are various possibilities. If	*/
/* one line crosses another then they obviously intersect. However, they*/
/* can also lie along each other for part of their lengths or have 	*/
/* vertices that lie on the other line. This enumeration describes	*/
/* these possibilities.							*/
/* 									*/
/* There are slightly different interpretations when using		*/
/* point type geometries (see the documentation on the intersect 	*/
/* routines for these details).						*/
/*									*/
/*..ELEMENTS............................................................*/
/* _GIT_NONE		- There is no contact between the geometries.	*/
/* _GIT_POINT_TOUCH	- A vertex on one geometry lies on the linework	*/
/*			  of the second geometry.			*/
/* _GIT_LINE_TOUCH	- Part of the linework of one geometry is 	*/
/*			  coincident with part of the linework of the	*/
/*			  other geometry, but when it leaves it, it	*/
/*			  does so on the same side as it joined it from.*/
/* _GIT_INTERSECT	- The line work of one geometry crosses from	*/
/*			  one side of the second geometry to the other	*/
/*			  side.						*/
/*----------------------------------------------------------------------*/

/* begin-def */

enum _geometry_intersect_types
{
   _GIT_NONE,
   _GIT_POINT_TOUCH,
   _GIT_LINE_TOUCH,
   _GIT_INTERSECT
};

typedef enum _geometry_intersect_types GEOMETRY_INTERSECT_TYPE;

/* end-def */




/*----------------------------------------------------------------------*/
/* TYPE ENUM GEOMETRY_ARC_TYPE						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* A circle arc can be described using three points in a number of 	*/
/* different ways. There are four types of circle arc presently defined.*/
/*								        */
/*..ELEMENTS............................................................*/
/*  									*/
/* _GAT_CLOCK_ARC		- Clockwise circle arc.		       !*/
/*				  Defined by a start, centre, and 	*/
/*				  end point.				*/
/* _GAT_ANTI_CLOCK_ARC		- Anticlockwise circle arc.            !*/
/*				  Defined by start, centre, and 	*/
/*				  end point.				*/
/* _GAT_CIRCUM_ARC		- Circumcircle arc.                    !*/
/*				  Defined by a start, any edge,		*/
/*				  and end point.			*/
/* _GAT_CIRCUM_CIRCLE		- Full circumcircle.                   !*/
/*				  Defined by any 3 edge points.		*/
/* 									*/
/*----------------------------------------------------------------------*/


/* begin-def */


enum _arc_types
{
   _GAT_CLOCK_ARC,
   _GAT_ANTI_CLOCK_ARC,
   _GAT_CIRCUM_ARC,
   _GAT_CIRCUM_CIRCLE
};

typedef enum _arc_types GEOMETRY_ARC_TYPE;

/* end-def */



/*----------------------------------------------------------------------*/
/* TYPE ENUM GEOMETRY_COMBINATION_TYPE					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Constants used to describe the possible types of geometry combination.*/
/* 									*/
/* The interpretation of the combination depends on the data type of	*/
/* the geometries involved. Reference should be made to the		*/
/* documentation of GEOMLIB routines for this interpretation.		*/
/* 									*/
/*..ELEMENTS............................................................*/
/* _GCT_OR	- The data is combined using a logical OR. 		*/
/* _GCT_XOR	- The data is combined using a logical exclusive-OR.	*/
/* _GCT_AND	- The data is combined using a logical AND.		*/
/* _GCT_AND_NOT	- The resultant data is the data of the first geometry	*/
/*		  with the exclusion of any data that is also in the	*/
/*		  second geometry.					*/
/* _GCT_NOT_AND	- The resultant data is the data of the second geometry	*/
/* 		  with the exclusion of any data that is also in the	*/
/*		  first geometry.					*/
/*----------------------------------------------------------------------*/


/* begin-def */

enum _geometry_combination_types
{
   _GCT_OR,
   _GCT_XOR,
   _GCT_AND,
   _GCT_AND_NOT,
   _GCT_NOT_AND
}; 

typedef enum _geometry_combination_types GEOMETRY_COMBINATION_TYPE;


/* end-def */

/*----------------------------------------------------------------------*/
/* TYPE ENUM GEOMETRY_NESTING_ALGORITHM					*/
/*......................................................................*/
/*..HIDE................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* constants used to describe the possible types of nesting algorithm	*/
/* 									*/
/*..ELEMENTS............................................................*/
/* _GNA_SIMPLE		- one outer and possibly several inner rings	*/
/* _GNA_COMBINED	- several outer rings - need to sort out nesting*/
/* _GNA_ALL		- all lines					*/
/*----------------------------------------------------------------------*/

enum _geometry_nesting_types
{
   _GNA_SIMPLE,		/* one outer, and possible several inner rings	*/
   _GNA_COMBINED,
   _GNA_ALL
}; 

typedef enum _geometry_nesting_types GEOMETRY_NESTING_ALGORITHM;



typedef GOTH_STATUS (*GEOM_SMOOTH_FUNC)(
					GOTH_BOOLEAN	array_closed,
					GOTH_INTEGER	*array_length,
					GEOM_COORD_PAIR	**xy_array,
					GOTH_INTEGER	num_pts,
					GOTH_INTEGER	*smoothed_num_pts,
					GOTH_INTEGER	num_params,
					GOTH_VALUE	params[]);


#endif
