/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 17:55:18.000000000 +0000
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
#ifndef _GEOM_INTRINSICS
#define _GEOM_INTRINSICS
/* $Header: /gothic/hdr/geomlib/v1-21/RCS/hdr.geom_intrinsics.h,v 1.19.2.3 1995/03/22 16:57:04 ron Exp $								*/

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Ron Russell, 21-Sep-1990					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		   G E O M _ I N T R I N S I C S . H 			*/
/*									*/
/* Part of GOTHIC module GEOMLIB					*/
/* Version 0.1, Ron Russell 21-Sep-1990					*/
/*									*/
/* prototypes for intrinsic functions					*/
/************************************************************************/

#include <X11/Xlib.h>		/* for XPoint definition		*/

/*----------------------------------------------------------------------*/
/*......................................................................*/
/*..INTRODUCTION........................................................*/
/*									*/
/* <<GEOMLIB>> is a library that provides access to dynamic		*/
/* data-structures representing two-dimensional quantities within the	*/
/* <<GOTHIC>> environment. These data-structures are known as		*/
/* <<geometries>>, and they are accessed by users of <<GEOMLIB>> 	*/
/* through the <<goth_descriptor>> mechanism.				*/
/*									*/
/* Geometries have a number of sub-types. These are:			*/
/*@ <<Simple-Point:>> a geometry of type <<_GT_SIMP_POINT>>,		*/
/* contains a single locating coordinate pair.				*/
/*@ << Simple-Line:>> a geometry of type <<_GT_SIMP_LINE>>, 	       	*/
/* contains a single sequence of vertices which may, or may not, be	*/
/* closed. A line will generally not intersect with itself, but since	*/
/* self-intersecting lines may, on occasions, be useful, a routine is	*/
/* provided to allow the user to determine if a line intersects (or 	*/
/* touches) itself.							*/
/*@<<Simple-Area:>> a geometry of type <<_GT_SIMP_AREA>>	       	*/
/* contains a single contiguous area. This is represented by its 	*/
/* boundary. 								*/
/* Each component of the boundary is implemented as a ring, that is a 	*/
/* closed non-intersecting piece of linework. The outer boundary of an	*/
/* area must be anticlockwise, and the internal boundaries clockwise. 	*/
/* An area must have at least one boundary, it can have at most one 	*/
/* outer boundary but may have multiple inner boundaries. Clearly	*/
/* boundaries must not intersect.					*/
/*@<<Complex-Point:>> a geometry of type <<_GT_COMP_POINT>>		*/
/* contains multiple simple-points.					*/
/*@<<Complex-Line:>> a geometry of type <<_GT_COMP_LINE>>		*/
/* contains multiple simple-lines.					*/
/*@<<Complex-Area:>> a geometry of type <<_GT_COMP_AREA>>		*/
/* contains multiple simple-areas.					*/
/*@<<Complex:>> a geometry of type <<_GT_COMPLEX>>			*/
/* contains multiple simple geometries, arranged as lists of points, 	*/
/* lines and areas.							*/
/*									*/
/*<<Marks>>								*/
/*     									*/
/* A mark is an internal pointer carried inside a geometry. A 		*/
/* geometry is able to hold a hard-coded maximum number of marks,	*/
/* accessible through a <<mark_index>>.					*/
/* 									*/
/* Typically marks are used to point to a position on some linework,	*/
/* which itself may be part of the boundary of an area. Additionally	*/
/* marks are internally aware of whether they are pointing to a		*/
/* vertex or not. There are a number of possible types of information	*/
/* that can be retrieved from marks, and these form a hierarchy. A 	*/
/* routine is provided to tell the user if he can retrieve the		*/
/* following information from a geometry through a mark:	      	*/
/*@    _GMT_VERTEX - the vertex that is implicated		       	*/
/*@    _GMT_POSITION - the position that is referred to (this may be an	*/
/*@ 	interpolated position between vertices			       	*/
/*@    _GMT_LINE - the implicated piece of linework (this may be an	*/
/*		area boundary)					       	*/
/*@    _GMT_AREA - the implicated area				       	*/
/*@    _GMT_UNSET						       	*/
/* 									*/
/* Thus, if a mark points to a vertex, then the position of the vertex	*/
/* can be retrieved, in addition the linework containing that vertex	*/
/* is also marked, as is the area for which the linework forms part	*/
/* of a boundary. Obviously there are exceptions, for example the	*/
/* vertex may be the single vertex held by a point, and the linework	*/
/* may not form part of the boundary of an area.			*/
/* 									*/
/* There are a number of routines provided to set up marks on a		*/
/* geometry, and a set of routines to retrieve the marked component of	*/
/* a geometry. It is possible to retrieve a different geometry type	*/
/* from that which was originally marked, providing these observe the	*/
/* hierarchy mentioned above.						*/
/* 									*/
/* For example a position on a piece of line can be marked by using	*/
/* the generic routine to mark the closest piece of line in a geometry	*/
/* to some specified point. Once the position has been marked, then	*/
/* the entire simple-line can be considered marked and retrieved.	*/
/* However a single simple-area in a complex geometry can be marked	*/
/* by using the generic routine that marks the area that includes	*/
/* some specified point. Although the marked area has simple-lines	*/
/* as boundaries, these cannot be retrieved since the mark is not	*/
/* specific enough.							*/
/* 									*/
/* <<Copying between geometries>>					*/
/*									*/
/* The sections of the geometry data-structure that actually contain	*/
/* the coordinate information is quite complex, but isolated from those	*/
/* parts that indicate the geometry type and the like. Thus a piece of 	*/
/* geometry can be added to or removed from another geometry by keeping	*/
/* the coordinate information intact and rearranging the internal 	*/
/* pointers. Thus a simple-line geometry representing a ring can be 	*/
/* added to a a simple-area geometry as its outer boundary. If a 	*/
/* pointer rearrangement is used, then the simple-line geometry 	*/
/* represents a cleared geometry on completion. There are times when	*/
/* this approach is not satisfactory, and the coordinate information 	*/
/* has to be actually copied. Those routines which offer these two	*/
/* alternatives take a <<copy>> argument.		      		*/
/*									*/
/* <<Function naming conventions>>					*/
/*									*/
/* The functions within <<GEOMLIB>> can be divided into several groups	*/
/* either according to the types of geometries that they operate on, or	*/
/* the type of operation they carry out. These groups can be identified	*/
/* by the prefix on the function names as follows:		       	*/
/*@<<geom_m_>> - these functions operate on the marks of geometries.   	*/
/*@<<geom_simp_>> - these functions operate on all simple geometry	*/
/*			 types.					     	*/
/*@<<geom_sp_>> - these functions operate exclusively on simple point	*/
/*			geometries.					*/
/*@<<geom_sl_>> - these functions operate exclusively on simple line	*/
/*			geometries.					*/
/*@<<geom_sa_>> - these functions operate exclusively on simple area	*/
/*			geometries.					*/
/*@<<geom_comp_>> - these functions operate on all complex geometry	*/
/*			types.						*/
/*@<<geom_tb_>> - these functions are connected with tolerance blocks	*/
/* 			used in connection with various operations on	*/
/*			geometries.					*/
/*@<<geom_>> - these functions are either general geometrical routines	*/
/* 			that may be required by other libraries, 	*/
/*			routines that control the <<GEOMLIB>>		*/
/*			environment or routines that operate on all	*/
/*			geometries					*/
/*----------------------------------------------------------------------*/

/*>>> EXTERN functions from GEOM_COMP.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN geom_comp_create						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to create a cleared complex geometry, identified by a 	*/
/* previously allocated descriptor using geom_alloc().			*/
/* 									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id        -in/out- A previously allocated descriptor for a 	*/
/*			   geometry.					*/
/*                                                                      */
/* dimensionality -in-     Determines the type of complex geometry 	*/
/*			   created as follows:			       !*/
/*			   0 for a _GT_COMP_POINT geometry.	       !*/
/*			   1 for a _GT_COMP_LINE  geometry.	       !*/
/*  			   2 for a _GT_COMP_AREA geometry.	       !*/
/*			  -1 for a _GT_COMPLEX geometry.		*/
/*                                                                      */
/* space_id       -in-     A descriptor for the coordinate system	*/
/* 			   that	the data in the geometry will be in.   !*/
/*			   May be NULL, in which case the space of	*/
/*			   coordinate system will be undefined.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id or the space_id descriptor is    	*/
/*			corrupt or of the incorrect type.		*/
/*									*/
/* GOTH__NOVM		There is no virtual memory free for use.	*/
/*									*/
/* GOTH__INVALDIM	The value passed as the dimensionality was not	*/
/*			in the range of -1 to 2.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_comp_create(
				    GD_GEOMETRY		geom_id,
				    GOTH_INTEGER	dimensionality,
				    GD_SPACE	 	space_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_comp_count_simple					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the number of the specified kind of simple 	*/
/* geometries in the geometry comp_geom_id. 				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* comp_geom_id	  -in-	Descriptor for the geometry that is to		*/
/* 			be examined.					*/
/*									*/
/* simp_type	  -in-	The type of simple geometry to count. It should	*/
/*			be one of the following:		       !*/
/*			_GT_SIMP_POINT				       !*/
/*			_GT_SIMP_LINE				       !*/
/*			_GT_SIMP_AREA				        */
/* 									*/
/* ret_num_simple -out-	Number of specified simple geometries present.	*/    
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The comp_geom_id descriptor is corrupt or of	*/
/* 			the incorrect type.				*/
/*									*/
/* GOTH__NOTSIMPLE	The simp_type argument was not one of the types	*/
/*			listed above.				   	*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_comp_count_simple(
					  GD_GEOMETRY	comp_geom_id,
					  GEOMETRY_TYPE	simp_type,
					  GOTH_INTEGER	*ret_num_simple);
/*----------------------------------------------------------------------*/
/* EXTERN geom_comp_add_simple						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to add a simple geometry to a complex geometry.		*/
/* This routine will fail if the complex geometry is not of the same	*/
/* dimensionality as the simple geometry (unless the complex geometry 	*/
/* is of type _GT_COMPLEX).						*/
/*									*/
/* The data may be copied from the simple geometry, leaving it 		*/
/* unaltered, or it may be moved from the simple geometry, leaving it	*/
/* empty. This is controlled by the copy argument.			*/
/*									*/
/* Simple geometries are added to the end of the appropriate		*/
/* list of simple geometries.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* comp_geom_id	-in- 	Descriptor for the destination geometry.	*/
/*									*/
/* simp_geom_id	-in-	Descriptor for the source geometry.    		*/
/* 									*/
/* copy		-in-	TRUE to $$copy$$ the coordinate data from the 	*/
/* 			source geometry.			       !*/
/*			FALSE to move the coordinate data from the 	*/
/*			source to the destination (leaving the source 	*/
/*			geometry clear).				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The comp_geom_id or simp_geom_id descriptor is	*/
/*			corrupt or of the incorrect type.		*/
/*									*/
/* GOTH__NOVM		There is no virtual memory free for use.	*/
/*									*/
/* GOTH__CLRGEOM	The source geometry contains no data.		*/
/*									*/
/* GOTH__NOTCOMPLEX	The destination geometry is not of a complex 	*/
/* 			type.						*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_comp_add_simple(
					GD_GEOMETRY	comp_geom_id,
					GD_GEOMETRY	simp_geom_id,
					GOTH_BOOLEAN	copy);
/*----------------------------------------------------------------------*/
/* EXTERN geom_comp_get_simple						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to extract a simple geometry from a complex geometry. The 	*/
/* simple geometry is identified by its position in the list of 	*/
/* simple geometries of the specified type (the first in the list has 	*/
/* an index of 1) or by a mark.                                         */
/*								       	*/
/* The data may be copied from the original geometry, or removed. This	*/
/* is controlled by the copy argument.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* comp_geom_id	-in- 	Descriptor for the source geometry.		*/
/* 									*/
/* where	-in-	How to identify the simple geometry to be 	*/
/*			extracted. The valid values are:	       !*/
/*			_GC_POINT				       !*/
/*			_GC_LINE				       !*/
/*			_GC_AREA				       !*/
/*			_GC_MARK				        */
/*									*/
/* mark_index	-in-	Meaning depends of value of where:	       !*/
/*			If where is _GC_MARK, then it is the mark 	*/
/*			index to use to identify the simple geometry.  !*/
/*			Otherwise it is the index in the list of simple	*/
/*			geometries of the appropriate type associated 	*/
/*			with the source complex geometry. This index 	*/
/*			starts at 1.					*/
/*									*/
/* copy		-in-	TRUE to $$copy$$ the coordinate data from the 	*/
/*			source geometry.			       !*/
/*			FALSE to move the coordinate data from the 	*/
/*			source geometry to the destination geometry 	*/
/* 			(leaving the source geometry clear).		*/
/*									*/
/* ret_simp_geom_id -out- Descriptor for the destination		*/
/*			  geometry.			     		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The comp_geom_id descriptor is corrupt or of	*/
/*			the incorrect type.				*/
/*									*/
/* GOTH__NOVM		There is no virtual memory free for use.	*/
/*									*/
/* GOTH__CLRGEOM	The source geometry contains no data.		*/
/*									*/
/* GOTH__INVALWHERE	where is not one of the values listed above.	*/
/*									*/
/* GOTH__MARKWRNGTYPE	The specified mark does not point to a simple	*/
/*			point, line, or area.				*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_comp_get_simple(
					GD_GEOMETRY	comp_geom_id,
					GEOMETRY_CONST	where,
					GOTH_INTEGER	mark_index,
					GOTH_BOOLEAN	copy,
					GD_GEOMETRY	*ret_simp_geom_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_comp_remove_simple					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to remove a simple geometry from a complex geometry. The 	*/
/* simple geometry is identified by its position in the list of 	*/
/* simple geometries of the specified type (the first in the list has 	*/
/* an index of 1) or by a mark.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* comp_geom_id	-in- 	Descriptor for the source geometry.		*/
/* 									*/
/* where	-in-    How to identify the simple geometry to be 	*/
/*			removed. This must be one of the following:    !*/
/*			_GC_POINT				       !*/
/*			_GC_LINE				       !*/
/*			_GC_AREA				       !*/
/*			_GC_MARK				        */
/*									*/
/* mark_index	-in-	Meaning depends of value of where:	       !*/
/*			If where is _GC_MARK, then it is the mark 	*/
/*			index to use to identify the simple geometry.  !*/
/*			Otherwise it is the index in the list of simple	*/
/*			geometries of the appropriate type associated 	*/
/*			with the source complex geometry. This index 	*/
/*			starts at 1.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The comp_geom_id descriptor is corrupt or of 	*/
/*			the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The source geometry contains no data.		*/
/*									*/
/* GOTH__INVALWHERE	where is not one of the values listed above.	*/
/*									*/
/* GOTH__MARKWRNGTYPE	The specified mark does not point to a simple	*/
/*			point, line, or area.				*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_comp_remove_simple(
					   GD_GEOMETRY		comp_geom_id,
					   GEOMETRY_CONST	where,
					   GOTH_INTEGER		mark_index);

/*>>> EXTERN functions from GEOM_MARK.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN geom_m_get_coord						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to retrieve the position of a mark. This may be the position */
/* of a vertex, or an interpolated position between two vertices, 	*/
/* depending on the type of the mark.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to	be	*/
/*			examined.					*/
/*									*/
/* mark_index	-in-	Index for the mark of the geometry to be used. !*/
/*			This index starts at 1.				*/
/*									*/
/* ret_x	-out-	The x coordinate of the mark.			*/
/*									*/
/* ret_y	-out-	The y coordinate of the mark.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__MARKNOTSET	The specified mark has not been set up.		*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__MARKWRNGTYPE	The specified mark does not point to a		*/
/*			position.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_m_get_coord(
				    GD_GEOMETRY		geom_id,
				    GOTH_INTEGER	mark_index,
				    GOTH_REAL		*ret_x,
				    GOTH_REAL		*ret_y);
/*----------------------------------------------------------------------*/
/* EXTERN geom_m_get_geom						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to retrieve a simple geometry specified by a mark.		*/
/*									*/
/* Note that:								*/
/*@ a point may be retrieved from a complex point geometry.		*/
/*@ a line may be retrieved from a complex line geometry.		*/
/*@ a line may also be retrieved from a simple or complex area.		*/
/*@ an area may be retrieved from a complex area geometry.		*/
/*									*/
/* The type of geometry retrieved depends on the dimensionality		*/
/* argument, which is:							*/
/*@ 0 for a _GT_SIMP_POINT.						*/
/*@ 1 for a _GT_SIMP_LINE.						*/
/*@ 2 for a _GT_SIMP_AREA.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	  -in-	Descriptor for the source geometry (this may be	*/
/*			a simple or complex geometry).	 		*/
/*									*/
/* mark_index	  -in-	Index for the mark of the geometry to be used. !*/
/*			This index starts at 1.				*/
/*									*/
/* dimensionality -in-	The type of simple geometry to extract.		*/
/*									*/
/* copy		  -in-	TRUE to $$copy$$ the coordinate data from the 	*/
/*			source geometry.			       !*/
/*			FALSE to move the coordinate data from the 	*/
/*			source geometry to the destination geometry 	*/
/* 			(leaving the source geometry clear).		*/
/*									*/
/* ret_simp_id	  -out-	Descriptor for the output geometry.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__NOVM		There is no free virtual memory.		*/
/*									*/
/* GOTH__CLRGEOM	The source geometry contains no data.		*/
/*									*/
/* GOTH__INVALDIM	The value passed as the dimensionality was not	*/
/*			in the range of 0 to 2.				*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__MARKWRNGTYPE	The specified mark does not point to a simple	*/
/*			point, line, or area.				*/
/*									*/
/*----------------------------------------------------------------------*/
extern GOTH_STATUS geom_m_get_geom(
				   GD_GEOMETRY		geom_id,
				   GOTH_INTEGER		mark_index,
				   GOTH_INTEGER		dimensionality,
				   GOTH_BOOLEAN		copy,
				   GD_GEOMETRY		*ret_simp_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_m_nearest_vertex						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to mark the nearest vertex of a geometry from a given point 	*/
/* with the mark specified.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to	be	*/
/*			marked.						*/
/*									*/
/* mark_index	-in-	Index for the mark of the geometry to be used. !*/
/*			This index starts at 1.				*/
/*									*/
/* in_x		-in-	The x coordinate of the given point.		*/
/*									*/
/* in_y		-in-	The y coordinate of the given point.		*/
/*									*/
/* min_dist	-out-	The distance from the given point to the marked */
/*			point.						*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__CLRGEOM	The source geometry contains no data.		*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_m_nearest_vertex(
					 GD_GEOMETRY		geom_id,
					 GOTH_INTEGER		mark_index,
					 GOTH_REAL		in_x,
					 GOTH_REAL		in_y,
					 GOTH_REAL		*min_dist);
/*----------------------------------------------------------------------*/
/* EXTERN geom_m_farthest_vertex					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to mark the farthest vertex of a geometry from a given point	*/
/* with the mark specified and return the distance from the given point	*/
/* to the marked point.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to	be	*/
/*			marked.						*/
/*									*/
/* mark_index	-in-	Index for the mark of the geometry to be used. !*/
/*			This index starts at 1.				*/
/*									*/
/* in_x		-in-	The x coordinate of the given point.		*/
/*									*/
/* in_y		-in-	The y coordinate of the given point.		*/
/*									*/
/* max_dist	-out-	The distance from the given point to the marked */
/*			point.						*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__CLRGEOM	The source geometry contains no data.		*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_m_farthest_vertex(
					  GD_GEOMETRY		geom_id,
					  GOTH_INTEGER		mark_index,
					  GOTH_REAL		in_x,
					  GOTH_REAL		in_y,
					  GOTH_REAL		*max_dist);
/*----------------------------------------------------------------------*/
/* EXTERN geom_m_nearest_position					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to mark the nearest position on a geometry from a given point*/
/* with the mark specified.						*/
/*									*/
/* This is not necessarily a vertex, but is either the coordinate of a 	*/
/* point geometry, or on the linework of a line, or an area geometry.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to	be	*/
/*			marked.						*/
/*									*/
/* mark_index	-in-	Index for the mark of the geometry to be used. !*/
/*			This index starts at 1.				*/
/*									*/
/* in_x		-in-	The x coordinate of the given point.		*/
/*									*/
/* in_y		-in-	The y coordinate of the given point.		*/
/*									*/
/* min_dist	-out-	The distance from the given point to the marked */
/*			position.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__CLRGEOM	The source geometry contains no data.		*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_m_nearest_position(
					   GD_GEOMETRY	geom_id,
					   GOTH_INTEGER	mark_index,
					   GOTH_REAL	in_x,
					   GOTH_REAL	in_y,
					   GOTH_REAL	*min_dist);
/*----------------------------------------------------------------------*/
/* EXTERN geom_m_test_type						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to test the type of a mark against a required type.		*/
/*									*/
/* This routine is used to determine if a mark can be used to recover	*/
/* information of the required type, thus a mark that holds a position	*/
/* may well (but not necessarily) also point to a vertex and also to a	*/
/* line and perhaps an area, or else to a point.			*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to	be	*/
/*			examined.					*/
/*									*/
/* mark_index	-in-	Index for the mark of the geometry to be used. !*/
/*			This index starts at 1.				*/
/*									*/
/* mark_type	-in-	The required type of mark. This is one of the 	*/
/*			following:				       !*/
/*			_GMT_VERTEX				       !*/
/*			_GMT_POSITION				       !*/
/*			_GMT_LINE				       !*/
/*			_GMT_AREA				       !*/
/*			_GMT_UNSET				        */
/*									*/
/* ret_equivalent -out-	TRUE if the mark is of required type.	       !*/
/*			FALSE if the mark is not of required type.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__MARKWRNGTYPE	The specified mark type is not one of those	*/
/*			listed above.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_m_test_type(
				    GD_GEOMETRY		geom_id,
				    GOTH_INTEGER	mark_index,
				    GEOMETRY_MARK_TYPE	mark_type,
				    GOTH_BOOLEAN	*ret_equivalent);
/*----------------------------------------------------------------------*/
/* EXTERN geom_m_clear							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to clear a specified mark.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in- Descriptor for the geometry that has the mark	*/
/*		     to be cleared.					*/
/*									*/
/* mark_index	-in- Index of the mark for the geometry to be cleared. !*/
/*		     This index starts at 1.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__MARKWRNGTYPE	The specified mark does not point to a simple	*/
/*			point, line, or area.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_m_clear(
				GD_GEOMETRY	geom_id,
				GOTH_INTEGER	mark_index);
/*----------------------------------------------------------------------*/
/* EXTERN geom_m_step_vertex						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to change the vertex that a mark points at by the specified	*/
/* number of vertices. The step may be forward (positive) or backward	*/
/* (negative).								*/
/*									*/
/* The resulting mark always points to a vertex. When the original mark	*/
/* points to a position between vertices, then a step of -1 will move	*/
/* to the previous vertex and a step of +1 will move to the next vertex.*/
/* A step of 0 is illegal.						*/
/*									*/
/* It is not possible to $$step$$ pass the end of an open piece of 	*/
/* linework. Any number of vertices can be stepped in a ring.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be used.	*/
/*									*/
/* mark_index	-in-	Index for the mark of the geometry to be used. !*/
/*			This index starts at 1.				*/
/*									*/
/* step		-in-	The number of vertices to $$step$$. A $$step$$ 	*/
/*			of 0 is	illegal.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__CLRGEOM	The source geometry contains no data.		*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__MARKPTSWRONG	The specified mark does not point to a position	*/
/*			on a piece of line work.			*/
/*									*/
/* GOTH__NOZEROSTEP	Steps of 0 are not allowed.			*/
/*									*/
/* GOTH__NOTENOUGHDATA	The linework does not contain enough points to 	*/
/*			$$step$$ over by the specified number of 	*/
/*			vertices.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_m_step_vertex(
				      GD_GEOMETRY	geom_id,
				      GOTH_INTEGER	mark_index,
				      GOTH_INTEGER	step);
/*----------------------------------------------------------------------*/
/* EXTERN geom_m_copy							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to copy a mark. Any data in the new mark is lost.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	     -in- Descriptor for the geometry that is to be	*/
/*			  operated upon.				*/
/*									*/
/* from_m_index      -in- Index for the source mark of the geometry.	*/
/*			  This index starts at 1.			*/
/*									*/
/* to_m_index        -in- Index for the target mark of the geometry.	*/
/*			  This index starts at 1.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_m_copy(
			       GD_GEOMETRY	geom_id,
			       GOTH_INTEGER	from_m_index,
			       GOTH_INTEGER	to_m_index);
/*----------------------------------------------------------------------*/
/* EXTERN geom_m_update_by_position					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to move a mark from its current position to the point on the */
/* line closest to the specified coordinate. It does this in such a way	*/
/* that as the mark moves along the linework, the distance from the 	*/
/* marked position to the specified coordinate always decreases.	*/
/* This ensures that the marked position is constrained to the linework.*/
/* The mark will not move from one piece of linework to	another. This	*/
/* routine does not work on geometries that have duplicated points.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to have	*/
/*			its mark updated.				*/
/*									*/
/* mark_index	-in-	Index for the mark of the geometry to be used. !*/
/*			This index starts at 1.				*/
/*									*/
/* in_x		-in-	The x coordinate of the target point.		*/
/*									*/
/* in_y		-in-	The y coordinate of the target point.		*/
/*									*/
/* ret_x	-out-	The x coordinate of the updated marked point.	*/
/*									*/
/* ret_y	-out-	The y coordinate of the updated marked point.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__CLRGEOM	The source geometry contains no data.		*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__MARKPTSWRNG	The specified mark does not point to a position	*/
/*			on a piece of linework.				*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_m_update_by_position(
					     GD_GEOMETRY	geom_id,
					     GOTH_INTEGER	mark_index,
					     GOTH_REAL		in_x,
					     GOTH_REAL		in_y,
					     GOTH_REAL		*ret_x,
					     GOTH_REAL		*ret_y);

/*>>> EXTERN functions from GEOM_PROFILES.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_mark_x_or_y						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to mark a simple line geometry where it crosses a particular */
/* x or y value. It marks the first such point it comes across.		*/
/*									*/
/* This routine is a specialised routine for use when the geometry is	*/
/* being used to represent a profile.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			marked.						*/
/*									*/
/* mark_index	-in-	Index for the mark of the geometry to be used. !*/
/*			This index starts at 1.				*/
/*									*/
/* x_or_y 	-in- 	0 to mark the x axis.				*/
/*			1 to mark the y axis.				*/
/*									*/
/* coord	-in-	The x or y value where geom_id is to be marked.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/* GOTH__INVALMARK	The mark_index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id is not a simple line geometry.	*/
/*									*/
/* GOTH__NOINTERSECT	There is no vector which crosses this coord in	*/
/* 			the geometry.					*/
/*									*/
/* GOTH__ERROR		Invalid value for x_or_y - must be 0 or 1.	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_mark_x_or_y(
				       GD_GEOMETRY	geom_id,
				       GOTH_INTEGER	mark_index,
				       GOTH_INTEGER	x_or_y,
				       GOTH_REAL	coord);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_update_mark_x_or_y					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to move a mark on a simple line geometry (being used as a 	*/
/* graph or profile) by a distance along the x or y axis.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to	be	*/
/*			marked.						*/
/*									*/
/* mark_index	-in-	Index for the mark of the geometry to be used. !*/
/*			This index starts at 1.				*/
/*									*/
/* x_or_y 	-in- 	Direction to move:			       !*/
/*			0 for the x axis.			       !*/
/*			1 for the y axis.				*/
/*									*/
/* dist		-in-	The x or y distance to move by.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/* GOTH__INVALMARK	The mark_index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id is not a simple line geometry.	*/
/*									*/
/* GOTH__NOINTERSECT	There is no vector in the geometry which crosses*/
/*			the coordinate specified.			*/
/*									*/
/* GOTH__ERROR		Invalid value for x_or_y, must be 0 or 1.	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_update_mark_x_or_y(
					      GD_GEOMETRY	geom_id,
					      GOTH_INTEGER	mark_index,
					      GOTH_INTEGER	x_or_y,
					      GOTH_REAL		dist);

/*>>> EXTERN functions from GEOM_SIMP.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN geom_simp_create						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to create a cleared simple geometry, pointed at by a 	*/
/* previously allocated descriptor for a geometry created by 		*/
/* geom_alloc().							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id        -in/out- A previously allocated descriptor for a 	*/
/*			   geometry.					*/
/*                                                                      */
/* dimensionality -in-     Type of simple geometry to create:	       !*/
/*                         0 -- for a _GT_SIMP_POINT geometry.	       !*/
/*                         1 -- for a _GT_SIMP_LINE  geometry.	       !*/
/*                         2 -- for a _GT_SIMP_AREA geometry.	        */
/*                                                                      */
/* space_id       -in-     A descriptor for the coordinate system	*/
/* 			   that	the data in the geometry will be in.   !*/
/*			   May be NULL, in which case the space of	*/
/*			   coordinate system will be undefined.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id or the space_id descriptor is    	*/
/*			corrupt or of the incorrect type.		*/
/*									*/
/* GOTH__NOVM		There is no virtual memory free for use.	*/
/*									*/
/* GOTH__INVALDIM	The value passed as the dimensionality was not	*/
/*			in the range of 0 to 2.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_simp_create(
				    GD_GEOMETRY		geom_id,
				    GOTH_INTEGER	dimensionality,
				    GD_SPACE	   	space_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_simp_test_vector_intersect				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to test if the specified geometry intersects with the vector */
/* (xlo,ylo)-(xhi,yhi).							*/
/*									*/
/* This routine returns the following results for the different types	*/
/* of simple geometries:					        */
/* @ _GT_SIMP_POINT						       !*/
/*   _GIT_NONE 	      - The point does not lie on the vector.	       !*/
/*   _GIT_POINT_TOUCH - The point lies within the vector.		*/
/*                                                                      */
/* @ _GT_SIMP_LINE						       !*/
/*   _GIT_NONE 	      - There is no intersection.		       !*/
/*   _GIT_POINT_TOUCH - An end of the vector lies on a piece of 	*/
/*			linework.		                       !*/
/*   _GIT_LINE_TOUCH  - The vector is coincident with part of the 	*/
/*			linework of the geometry.		       !*/
/*   _GIT_INTERSECT   - The vector crosses the linework of the 		*/
/*			geometry.			                */
/*                                                                      */
/* @ _GT_SIMP_AREA						       !*/
/*   Same as for _GT_SIMP_LINE, treating each boundary as a piece of 	*/
/*   linework.				                                */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	 -in-	Descriptor for the geometry to be used.		*/
/*                                                                      */
/* xlo		 -in-	The x coordinate of the start of the vector.	*/
/*                                                                      */
/* ylo		 -in-	The y coordinate of the start of the vector.	*/
/*                                                                      */
/* xhi		 -in-	The x coordinate of the end of the vector.	*/
/*                                                                      */
/* yhi		 -in-	The y coordinate of the end of the vector.	*/
/*                                                                      */
/* ret_intersect -out-	Result of the intersection test. This should	*/
/*			be one of the following: 		       !*/
/*			_GIT_NONE				       !*/
/*			_GIT_POINT_TOUCH			       !*/
/*			_GIT_LINE_TOUCH				       !*/
/*			_GIT_INTERSECT				        */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not of a simple type.		*/
/*									*/
/* GOTH__VECTZERO	The two ends of the vector are coincident.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS
   geom_simp_test_vector_intersect(
				   GD_GEOMETRY			geom_id,
				   GOTH_REAL			xlo,
				   GOTH_REAL			ylo,
				   GOTH_REAL			xhi,
				   GOTH_REAL			yhi,
				   GEOMETRY_INTERSECT_TYPE	*ret_intersect);
/*----------------------------------------------------------------------*/
/* EXTERN geom_simp_test_region_intersect				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to test if the specified geometry intersects with the	*/
/* rectangular region defined by (xlo,ylo)-(xhi,yhi).			*/
/*									*/
/* This routine returns the following results for the different types	*/
/* of simple geometries:						*/
/* @ _GT_SIMP_POINT:						       !*/
/* _GIT_NONE - The point does not lie on the region boundary.          !*/
/* _GIT_POINT_TOUCH - The point lies on the region boundary.            */
/*                                                                      */
/* @ _GT_SIMP_LINE:						       !*/
/* _GIT_NONE - There is no intersection with the region boundary.      !*/
/* _GIT_POINT_TOUCH - A vertex of the linework of the geometry lies on 	*/
/*		      the region, but does not lie along it or cross it.!*/
/* _GIT_LINE_TOUCH  - Part of the linework of the geometry is coincident*/
/*		      with part of the region boundary.	               !*/
/* _GIT_INTERSECT   - The linework of the geometry crosses the region 	*/
/*		      boundary.					        */
/*                                                                      */
/* @ _GT_SIMP_AREA:						       !*/
/* Same as for _GT_SIMP_LINE, treating each boundary as a piece of 	*/
/* linework.				                                */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	 -in-	Descriptor for the geometry to be used.		*/
/*                                                                      */
/* xlo		 -in-	The x coordinate of the lower left corner of 	*/
/*			the region.					*/
/*                                                                      */
/* ylo		 -in-	The y coordinate of the lower left corner of 	*/
/*			the region.					*/
/*                                                                      */
/* xhi		 -in-	The x coordinate of the upper right corner of 	*/
/*			the region.					*/
/*                                                                      */
/* yhi		 -in-	The y coordinate of the upper right corner of 	*/
/*			the region.					*/
/*                                                                      */
/* ret_intersect -out-	Result of the intersection test. This should	*/
/*			be one of the following: 		       !*/
/*			_GIT_NONE				       !*/
/*			_GIT_POINT_TOUCH			       !*/
/*			_GIT_LINE_TOUCH				       !*/
/*			_GIT_INTERSECT				        */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not of a simple type.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__INVALRECT	The lower corner of the rectangle is not less	*/
/*			than the higher corner.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS
   geom_simp_test_region_intersect(
				   GD_GEOMETRY			geom_id,
				   GOTH_REAL			xlo,
				   GOTH_REAL			ylo,
				   GOTH_REAL			xhi,
				   GOTH_REAL			yhi,
				   GEOMETRY_INTERSECT_TYPE	*ret_intersect);
/*----------------------------------------------------------------------*/
/* EXTERN geom_simp_test_geom_intersect					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to test if two geometries intersect. If there is no 		*/
/* intersection between the geometries, this routine will return 	*/
/* _GIT_NONE. Otherwise, the various combinations of geometry types 	*/
/* return are:								*/
/*									*/
/* POINT + POINT returns _GIT_POINT_TOUCH if points coincident.        !*/
/* POINT + LINE  returns _GIT_POINT_TOUCH if point lies on line.       !*/
/* POINT + AREA  returns _GIT_POINT_TOUCH if point lies on boundary.   !*/
/* PONIT + AREA  returns _GIT_INTERSECT   if point lies within area.    */
/*                                                                      */
/* LINE + LINE   returns _GIT_POINT_TOUCH if vertex of one line lies on */
/*               other line.		                               !*/
/* LINE + LINE   returns _GIT_LINE_TOUCH  part of linework is coincident*/
/* 		 somewhere.			                       !*/
/* LINE + LINE   returns _GIT_INTERSECT   if lines cross one another.  !*/
/* LINE + AREA   returns the same as for LINE + LINE, treating the area */
/*		 boundary as a series of lines.                         */
/*                                                                      */
/* AREA + AREA   returns the same as for lines, comparing each area 	*/
/*		 boundary in the first geometry with each area boundary */
/*		 in second geometry.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom1_id	-in-	Descriptor for the first geometry.		*/
/*                                                                      */
/* geom2_id	-in-	Descriptor for the second geometry.		*/
/*                                                                      */
/* ret_intersect -out-	Result of the intersection test. This should	*/
/*			be one of the following: 		       !*/
/*			_GIT_NONE				       !*/
/*			_GIT_POINT_TOUCH			       !*/
/*			_GIT_LINE_TOUCH				       !*/
/*			_GIT_INTERSECT				        */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom1_id or the geom2_id descriptor is    	*/
/*			corrupt or of the incorrect type.		*/
/*									*/
/* GOTH__CLRGEOM	One or other geometry contains no data.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__INVALGEOMTYPE	One or other geometry is not of a simple type.	*/
/*									*/
/* GOTH__INVALGEOMCOMBS	Invalid combination of geometry types for this	*/
/*			operation.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS
   geom_simp_test_geom_intersect(
				 GD_GEOMETRY		geom1_id,
				 GD_GEOMETRY		geom2_id,
				 GEOMETRY_INTERSECT_TYPE *ret_intersect);
/*----------------------------------------------------------------------*/
/* EXTERN geom_simp_get_extremes					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to return the nearest and farthest points on the specified	*/
/* geometry from the specified point.				       	*/
/*									*/
/*@ For _GT_SIMP_POINT geometries, the locating point is returned	*/
/*      for both the nearest and farthest point.			*/
/*									*/
/*@ For _GT_SIMP_LINE geometries, the nearest and farthest points	*/
/*      on the linework are returned. Note that the farthest point is	*/
/*	always on a vertex.						*/
/*									*/
/*@ For _GT_SIMP_AREA geometries, the farthest point is the vertex on	*/
/*	the boundary farthest from the locating point. If the point 	*/
/*	lies within the geometry, then the point itself is the nearest	*/
/*	point, otherwise the nearest point is the nearest point on the	*/
/*	boundary from the locating point.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the geometry to be used.		*/
/*                                                                      */
/* target_x	-in-	The x coordinate of the specified point.	*/
/*                                                                      */
/* target_y	-in-	The y coordinate of the specified point.	*/
/*                                                                      */
/* ret_near_x	-out-	The x coordinate of the nearest point on the 	*/
/*			geometry.					*/
/*                                                                      */
/* ret_near_y	-out-   The y coordinate of the nearest point on the 	*/
/*			geometry.					*/
/*                                                                      */
/* ret_min_dist	-out-	Minimum distance from the point	to the geometry.*/
/*                                                                      */
/* ret_far_x	-out-	The x coordinate of the farthest point on the 	*/
/*			geometry.					*/
/*                                                                      */
/* ret_far_y	-out-	The y coordinate of the farthest point on the 	*/
/*			geometry.					*/
/*                                                                      */
/* ret_max_dist	-out-	Maximum distance from the point to the geometry.*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not of a simple type.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_simp_get_extremes(
					  GD_GEOMETRY	geom_id,
					  GOTH_REAL	target_x,
					  GOTH_REAL	target_y,
					  GOTH_REAL	*ret_near_x,
					  GOTH_REAL	*ret_near_y,
					  GOTH_REAL	*ret_min_dist,
					  GOTH_REAL	*ret_far_x,
					  GOTH_REAL	*ret_far_y,
					  GOTH_REAL	*ret_max_dist);
/*----------------------------------------------------------------------*/
/* EXTERN geom_simp_fetch_point						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return a point that is guaranteed to lie on the 		*/
/* specified geometry.							*/
/*@ For _GT_SIMP_POINT geometries the locating point itself is returned.*/
/*@ For _GT_SIMP_LINE  geometries a point on the line (which is		*/
/*	not a vertex) is returned.					*/
/*@ For _GT_SIMP_AREA  geometries a point that is guaranteed to		*/
/*	to lie within the boundaries of the area is returned.	      	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the geometry to be used.		*/
/*                                                                      */
/* ret_x	-out-	The x coordinate of the returned point.		*/
/*                                                                      */
/* ret_y	-out-	The y coordinate of the returned point.		*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not of a simple type.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that have duplicated points.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_simp_fetch_point(
					 GD_GEOMETRY	geom_id,
					 GOTH_REAL	*ret_x,
					 GOTH_REAL	*ret_y);
/*----------------------------------------------------------------------*/
/* EXTERN geom_simp_buffer_create					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return a buffer zone that surrounds an existing simple 	*/
/* geometry. This routine will not work on geometries which contain	*/
/* duplicate points.							*/
/*									*/
/* This routine will produce a simple area geometry.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	 -in-	Descriptor for the source geometry.		*/
/*                                                                      */
/* offset_dist	 -in-	Distance from the source geometry at which to 	*/
/*			generate the buffer zone boundary.		*/
/*                                                                      */
/* vector_length -in-	Length of the vectors to use when generating 	*/
/*			curves around convex corners in the source 	*/
/*			geometry.					*/
/*									*/
/* buffer_id	-out-	Descriptor for the generated buffer		*/
/*			zone geometry.					*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not of a simple type.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__NOOUTERRING	A geometry has been formed that has no outer	*/
/*			ring. Vector length is probably too long to	*/
/*			adequately describe circle arc.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_simp_buffer_create(
					   GD_GEOMETRY	geom_id,
					   GOTH_REAL	offset_dist,
					   GOTH_REAL	vector_length,
					   GD_GEOMETRY	*buffer_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_simp_angle_square					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to carry out angle squaring on geometries that do not contain*/
/* duplicate points. See the GEOMLIB introduction for details of the 	*/
/* algorithm. 								*/
/*									*/
/* If within_tol is FALSE, messages will have been put on the message	*/
/* stack with details of the points outside tolerance.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the geometry to be squared.	*/
/*                                                                      */
/* method	-in-	Way of selecting the base. It is one of:       !*/
/*			1 - method_param contains angle (in radians)   	*/
/*			of specified angle.			       !*/
/*			2 - use longest side (method_param ignored).   !*/
/*			3 - method_param contains mark index of a mark	*/
/*			pointing to a side or corner to be used for	*/
/*			the base.					*/
/*									*/
/* method_param	-in-	Value (depends on method).			*/
/*                                                                      */
/* tb_sq_id	-in-	Descriptor for the squaring tolerance block.	*/
/*                                                                      */
/* within_tol	-out-	TRUE if squared	geometry squared_id has 	*/
/*			satisfied the criteria in the squaring 		*/
/*			tolerance block.			       !*/
/*			FALSE if squared geometry did not satisfy the	*/
/*			squaring tolerance block criteria.		*/
/*                                                                      */
/* squared_id	-out-	Descriptor for the squared geometry.		*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not of a simple type.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_simp_angle_square(
					  GD_GEOMETRY	geom_id,
					  GOTH_INTEGER	method,
					  GOTH_VALUE	method_param,
					  GD_TB_SQ	tb_sq_id,
					  GOTH_BOOLEAN	*within_tol,
					  GD_GEOMETRY	*squared_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_simp_side_square						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to carry out side squaring on geometries that do not contain */
/* duplicate points. See the GEOMLIB introduction for details of the 	*/
/* algorithm.								*/
/*									*/
/* If within_tol is FALSE, messages will have been put on the message	*/
/* stack with details of the points outside the tolerance.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the geometry to be squared.	*/
/*                                                                      */
/* part_square	-in-	TRUE for part squaring algorithm.	       !*/
/*			FALSE for whole squaring algorithm.	        */
/*                                                                      */
/* no_bases	-in-	The number of $$bases$$ supplied.		*/
/*                                                                      */
/* bases	-in-	An array of angles to square to (in radians).	*/
/*									*/
/* tb_sq_id	-in-	Descriptor for the squaring tolerance block.	*/
/*                                                                      */
/* within_tol	-out-	TRUE if squared	geometry squared_id has 	*/
/*			satisfied the criteria in the squaring		*/
/*			tolerance block.			       !*/
/*			FALSE if squared geometry has not satisfied the */
/*			squaring tolerance block criteria.		*/
/*                                                                      */
/* squared_id	-out-	Descriptor for the squared geometry.		*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not of a simple type.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* If within_tol is FALSE, messages will have been put on the message	*/
/* stack with details of the points outside tolerance.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_simp_side_square(
					 GD_GEOMETRY	geom_id,
					 GOTH_BOOLEAN	part_square,
					 GOTH_INTEGER	no_bases,
					 GOTH_REAL	bases[],
					 GD_TB_SQ	tb_sq_id,
					 GOTH_BOOLEAN	*within_tol,
					 GD_GEOMETRY	*squared_id);

/*>>> EXTERN functions from GEOM_SIMP_AREA.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN geom_sa_add_outer_ring					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to add a closed simple line to form the outer boundary of a 	*/
/* simple area. A simple area geometry may only have one outer ring, and*/
/* it must not cross any of the rings forming the inner boundaries.	*/
/*									*/
/* Outer boundaries must be digitised in an anti-clockwise direction.   */
/*									*/
/* The copy argument indicates whether the coordinate information should*/
/* be taken from the ring_id, leaving it in a cleared state, or whether	*/
/* a $$copy$$ of the coordinate data should be made.			*/
/*									*/
/* The check argument indicates whether a geometric check should be	*/
/* made on the new geometry. These checks look at the direction of the 	*/
/* ring, whether individual boundary components intersect and for 	*/
/* correct inclusion. The lines being added are not checked for self	*/
/* intersection. This can be done with a call to			*/
/* geom_sl_test_self_intersect().					*/
/*									*/
/* If check is TRUE then reverse_on_fail can be set to TRUE to		*/
/* indicate that the routine should reverse the direction of the ring	*/
/* if necessary.							*/
/*									*/
/* When adding rings to a geometry, the marks on the ring are lost.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the area geometry.		*/
/*                                                                      */
/* ring_id	-in-	Descriptor for the closed line geometry to add	*/
/*			to the area geometry.				*/
/*                                                                      */
/* copy		-in-	TRUE to $$copy$$ the coordinate data from the 	*/
/*			source geometry.			       !*/
/*			FALSE to move the coordinate data from the  	*/
/*		        source geometry to the destination geometry 	*/
/* 			(leaving the source geometry clear).		*/
/*									*/
/* check	-in-	TRUE to carry out geometrical checks on 	*/
/*			the ring_id before adding it.		       !*/
/*			FALSE not to carry out checks.			*/
/*                                                                      */
/* reverse_on_fail -in-	TRUE to reverse the direction of ring_id if it 	*/
/*			is in wrong direction for an outer ring (only 	*/
/*			valid if check is TRUE).		       !*/
/*			FALSE not to reverse the direction if required. */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for either of geom_id or ring_id	*/
/*			is corrupt or of the incorrect type.		*/
/*									*/
/* GOTH__CLRGEOM	The ring_id contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	geom_id is not a simple area, or ring_id is not	*/
/*			a simple line.					*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__OUTEREXISTS	The area geom_id already has an outer ring.	*/
/*									*/
/* GOTH__OPENLINE	The ring_id is not a closed line.		*/
/*									*/
/* GOTH__RINGINTERSECT	The ring_id intersects with an existing ring in	*/
/*			the area geom_id.				*/
/*									*/
/* GOTH__WRNGINCLUSION	The ring_id lies inside an existing inner	*/
/*			boundary in the geom_id.			*/
/*									*/
/* GOTH__WRNGDIRECTION 	The ring_id has not been digitised in an	*/
/*			anticlockwise direction.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sa_add_outer_ring(
					  GD_GEOMETRY	geom_id,
					  GD_GEOMETRY	ring_id,
					  GOTH_BOOLEAN	copy,
					  GOTH_BOOLEAN	check,
					  GOTH_BOOLEAN	reverse_on_fail);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sa_add_inner_ring					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to add a closed simple line to form an inner boundary of a 	*/
/* simple area. A simple area geometry may have several 		*/
/* (non-intersecting) inner rings, none of which may cross the outer 	*/
/* boundary.								*/
/*									*/
/* These inner rings are held as a list and they are always added to the*/
/* end of this list.							*/
/*									*/
/* Inner boundaries must be digitised in an clockwise direction.	*/
/*									*/
/* The copy argument indicates whether the coordinate information should*/
/* be taken from the ring_id, leaving it in a cleared state, or whether	*/
/* a $$copy$$ of the coordinate data should be made.			*/
/*									*/
/* The check argument indicates whether a geometric $$check$$ should be	*/
/* made on the new geometry. These checks look at the direction of the 	*/
/* ring, whether individual boundary components intersect and for 	*/
/* correct inclusion. The lines being added are not checked for self	*/
/* intersection. This can be done with a call to			*/
/* geom_sl_test_self_intersect().					*/
/*									*/
/* If check is TRUE then reverse_on_fail can be set to TRUE to		*/
/* indicate that the routine should reverse the direction of the ring	*/
/* if necessary.							*/
/*									*/
/* When adding rings to a geometry, the marks on the ring are lost.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the area geometry.		*/
/*                                                                      */
/* ring_id	-in-	Descriptor for the closed line geometry to add	*/
/*			to the area geometry.				*/
/*                                                                      */
/* copy		-in-	TRUE to $$copy$$ the coordinate data from the 	*/
/*			source geometry.			       !*/
/*			FALSE to move the coordinate data from the 	*/
/*			source geometry to the destination geometry 	*/
/* 			(leaving the source geometry clear).		*/
/*									*/
/* check	-in-	TRUE to carry out geometrical checks on 	*/
/*			the ring_id before adding it.		       !*/
/*			FALSE not to carry out checks.			*/
/*                                                                      */
/* reverse_on_fail -in-	TRUE to reverse the direction of ring_id if it 	*/
/*			is in wrong direction for an outer ring (only 	*/
/*			valid if check is TRUE).		       !*/
/*			FALSE not to reverse the direction if required.	*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for either of geom_id or ring_id	*/
/*			is corrupt or of the incorrect type.		*/
/*									*/
/* GOTH__CLRGEOM	The ring_id contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	geom_id is not a simple area, or ring_id is not	*/
/*			a simple line.					*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__OPENLINE	The ring_id is not a closed line.		*/
/*									*/
/* GOTH__RINGINTERSECT	The ring_id intersects with an existing ring in	*/
/*			the area geom_id.				*/
/*									*/
/* GOTH__WRNGINCLUSION	The ring_id lies inside an existing inner	*/
/*			boundary in the geom_id, or outside the outer	*/
/*			boundary.					*/
/*									*/
/* GOTH__WRNGDIRECTION 	The ring_id has not been digitised in a		*/
/*			clockwise direction.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sa_add_inner_ring(
					  GD_GEOMETRY	geom_id,
					  GD_GEOMETRY	ring_id,
					  GOTH_BOOLEAN	copy,
					  GOTH_BOOLEAN	check,
					  GOTH_BOOLEAN	reverse_on_fail);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sa_test_outer_ring					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to test if a simple area geometry has an outer boundary.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the geometry to be tested.	*/
/*                                                                      */
/* ret_outer_ring_present -out-	TRUE if the simple area geometry has an */
/*				outer boundary.			       !*/
/* 				FALSE if no outer boundary exists.	*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not a simple area type.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sa_test_outer_ring(
				   GD_GEOMETRY     geom_id,
				   GOTH_BOOLEAN	       *ret_outer_ring_present);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sa_count_inner_ring					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the number of inner rings in a simple area 	*/
/* geometry.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the geometry to be used.		*/
/*                                                                      */
/* ret_num_inner_ring -out- Number of inner rings (this may be 0).	*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not of a simple area type.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sa_count_inner_ring(
				    GD_GEOMETRY	geom_id,
				    GOTH_INTEGER	*ret_num_inner_ring);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sa_get_ring						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to retrieve a ring from a simple area geometry.		*/
/*									*/
/* The inner rings are maintained as a list. Marks can be used to mark	*/
/* an individual boundary (either inner or outer). Alternatively, a ring*/
/* can be specified as an outer or inner ring and the ring $$index$$ 	*/
/* specifies $$which$$ ring. The allowed combinations are:		*/
/*									*/
/* If which equals _GC_OUTER then index is NULL.                       !*/
/* If which equals _GC_MARK then index is the mark_index.              !*/
/* If which equals _GC_INNER then index is the ring_index.              */
/*									*/
/* The ring $$index$$ must be in the range of 1 to the number of inner  */
/* rings (as returned by geom_sa_count_inner_ring()). The mapping	*/
/* between a ring $$index$$ and a particular inner ring varies as inner */
/* rings are added or removed. Thus, repeatedly removing inner ring 	*/
/* number 1 will eventually remove all inner rings. Alternatively, all 	*/
/* the rings can be copied out by cycling through all the ring numbers, */
/* providing no rings are added/removed during the task.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the geometry to be used.		*/
/*                                                                      */
/* which	-in-	Type of ring required:			       !*/
/*			_GC_OUTER				       !*/
/*			_GC_MARK				       !*/
/*			_GC_INNER				        */
/*                                                                      */
/* index	-in-	Depends on value of which. Either the		*/
/*			mark_index, the ring_index, or NULL.		*/
/*									*/
/* copy		-in-	TRUE to $$copy$$ the coordinate data from the 	*/
/*			source geometry. 			       !*/
/*			FALSE to move the coordinate data from the 	*/
/*			source geometry to the destination geometry 	*/
/* 			(leaving the source geometry clear).		*/
/*                                                                      */
/* ret_ring_id	-out-	Descriptor of the geometry $$which$$ holds the	*/
/*			simple closed line geometry.			*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the area geometry is corrupt	*/
/*			or of the incorrect type.			*/
/*									*/
/* GOTH__CLRGEOM	The source geometry contains no data.		*/
/*									*/
/* GOTH__NOVM		There is no virtual memory free for use.	*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not of simple area type.*/
/*									*/
/* GOTH__NOTENOUGHDATA	There are no rings of the requested type in the	*/
/*			area geometry.					*/
/*									*/
/* GOTH__MARKNOTSET	The specified mark has not been set.		*/
/*									*/
/* GOTH__MARKPTSWRONG	The specified mark does not point to a ring.	*/
/*									*/
/* GOTH__INVALWHERE    	When using _GC_INNER, index is < 0.		*/
/*									*/
/* GOTH__INVALRINGINDEX	When using _GC_INNER, index is greater than the	*/
/*			number of rings.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sa_get_ring(GD_GEOMETRY	geom_id,
				    GEOMETRY_CONST	which,
				    GOTH_INTEGER	index,
				    GOTH_BOOLEAN	copy,
				    GD_GEOMETRY	*ret_ring_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sa_remove_ring						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to remove (delete) a ring from a simple area geometry.	*/
/*									*/
/* The inner rings are maintained as a list. Marks can be used to mark	*/
/* an individual boundary (either inner or outer). Alternatively, a ring*/
/* can be specified as an outer or inner and a ring $$index$$ to 	*/
/* specifies $$which$$ ring. The allowed combinations are:	     	*/
/*									*/
/* If which equals _GC_OUTER then index is NULL.                       !*/
/* If which equals _GC_MARK then index is the mark_index.              !*/
/* If which equals _GC_INNER then index is the ring_index.              */
/*									*/
/* The ring $$index$$ must be in the range 1 to the number of inner rings*/
/* (as returned by geom_sa_count_inner_ring()). The mapping between	*/
/* a ring $$index$$ and a particular inner ring varies as inner rings	*/
/* are added or removed. Thus, repeatedly removing inner ring number 1	*/
/* will eventually remove all inner rings.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the geometry to be used.		*/
/*                                                                      */
/* which	-in-	Type of ring to remove:			       !*/
/*			_GC_OUTER				       !*/
/*			_GC_MARK				       !*/
/*			_GC_INNER				        */
/*                                                                      */
/* index	-in-	Depends on value of <<which>>. Either the	*/
/*			mark_index, ring_index, or NULL.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the area geometry is corrupt	*/
/*			or of the incorrect type.			*/
/*									*/
/* GOTH__CLRGEOM	The source geometry contains no data.		*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not of simple area type.*/
/*									*/
/* GOTH__NOTENOUGHDATA	There are no rings of the requested type in the	*/
/*			area geometry.					*/
/*									*/
/* GOTH__MARKNOTSET	The specified mark has not been set.		*/
/*									*/
/* GOTH__MARKPTSWRONG	The specified mark does not point to a ring.	*/
/*									*/
/* GOTH__INVALWHERE    	When using _GC_INNER, index is < 0.		*/
/*									*/
/* GOTH__INVALRINGINDEX	When using _GC_INNER, index is greater than the	*/
/*			number of rings.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sa_remove_ring(
				       GD_GEOMETRY	geom_id,
				       GEOMETRY_CONST	which,
				       GOTH_INTEGER	index);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sa_count_vertices					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the number of vertices in a specified ring of	*/
/* a simple area. See geom_sa_get_ring() for details of how to specify 	*/
/* rings.								*/
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the geometry to be used.		*/
/*                                                                      */
/* which	-in-	Type of required ring:			       !*/
/*			_GC_OUTER				       !*/
/*			_GC_MARK				       !*/
/*			_GC_INNER				        */
/*                                                                      */
/* index	-in-	Depends on value of <<which>>. Either the	*/
/*			mark_index, the ring_index, or NULL.		*/
/*                                                                      */
/* ret_num_vertices -out- Number of vertices in the specified ring.	*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not of a simple area type.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sa_count_vertices(
					  GD_GEOMETRY  geom_id,
					  GEOMETRY_CONST   which,
					  GOTH_INTEGER     index,
					  GOTH_INTEGER    *ret_num_vertices );
/*----------------------------------------------------------------------*/
/* EXTERN geom_sa_test_contain						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Routine to test whether the specified simple area geometry contains 	*/
/* the specified point. It returns the following values in ret_contain:	*/
/*									*/
/* @  0 if the point lies on the boundary of the specified area. 	*/
/*									*/
/* @  1 if the point is contained within the specified area. 		*/
/*									*/
/* @ -1 if the point lies outside the specified area. 			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the simple area geometry to be 	*/
/*			tested.						*/
/*                                                                      */
/* target_x	-in-	The x coordinate of the specified point.	*/
/*                                                                      */
/* target_y	-in-	The y coordinate of the specified point.	*/
/*                                                                      */
/* ret_contain	-out-	The result of the test, should be one of the 	*/
/*			following :				       !*/
/* 			0 if the point lies on the boundary of the	*/
/*			specified area.				       !*/
/*              	1 if the point is contained within the 		*/
/*			specified area.				       !*/
/*                  	-1 if the point lies outside the		*/
/*			specified area.		 			*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not a simple area type.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sa_test_contain(
					GD_GEOMETRY	geom_id,
					GOTH_REAL	target_x,
					GOTH_REAL	target_y,
					GOTH_INTEGER	*ret_contain);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sa_extract_points					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Specialised routine to return the data from a ring of a simple area	*/
/* as an array of XPoints						*/
/*									*/
/* <<NOTE: space for array is provided by the calling routine>>		*/
/*									*/
/* Used by <<displib>>. Not available in LULL.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* space_tree_id -in-	Descriptor for the space tree to use for	*/
/*			any transformation to use. May be <<NULL>>.	*/
/* 									*/
/* geom_id	-in-	Descriptor for the simple area geometry.	*/
/* 									*/
/* new_space_id	-in-	Descriptor for the space the returned points 	*/
/*			are required to be in. 			       !*/
/*								       !*/
/*			Note, if either <<new_space_id>> is <<NULL>>,	*/
/*			or the space descriptor attached to <<geom_id>>	*/
/*			is NULL (no space assigned to the geometry),	*/
/*			then the returned points will be as defined	*/
/*			within <<geom_id>>, no space transformation	*/
/*			will have been applied to the points.		*/
/* 									*/
/* which	-in-	Ring from which to extract points. May be:     !*/
/*			_GC_OUTER				       !*/
/*			_GC_MARK				       !*/
/*			_GC_INNER				       !*/
/*			see <<geom_sa_get_ring()>>		       	*/
/* 									*/
/* index	-in-	Depends on value of <<which>> - either the 	*/
/*			mark_index or the ring_index.			*/
/* 									*/
/* pixel_width	-in-	The x extent of a pixel.			*/
/* 									*/
/* pixel_height	-in-	The y extent of a pixel.			*/
/* 									*/
/* xlo		-in-	The x coordinate of the lower left corner of	*/
/*			the window.					*/
/* 									*/
/* ylo		-in-	The y coordinate of the lower left corner of	*/
/*			the window.					*/
/* 									*/
/* xhi		-in-	The x coordinate of the upper right corner of	*/
/*			the window.					*/
/* 									*/
/* yhi		-in-	The y coordinate of the upper right corner of	*/
/*			the window.					*/
/* 									*/
/* array_start	-in-	A pointer to the start of the array of XPoints.!*/
/*			<<NOTE: an array of appropriate size must have 	*/
/*			been already malloc'd.>>			*/
/* 									*/
/* num_points	-out-	A pointer to a variable to receive the number	*/
/*			of points returned.				*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not a simple area type.		*/
/*									*/
/* GOTH__INVALRECT	The lower left of the window is not below and	*/
/* 			to the left of the upper right of the window.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sa_extract_points(
					  GD_SPACE_TREE	space_tree_id,
					  GD_GEOMETRY   geom_id,
					  GD_SPACE	new_space_id,
					  GEOMETRY_CONST which,
					  GOTH_INTEGER	index,
					  GOTH_INTEGER  pixel_width,
					  GOTH_INTEGER  pixel_height,
					  GOTH_REAL     xlo,
					  GOTH_REAL     ylo,
					  GOTH_REAL     xhi,
					  GOTH_REAL     yhi,
					  XPoint        *array_start,
					  GOTH_INTEGER  *num_points);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sa_get_data						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the length of the boundaries and the area of a	*/
/* simple area geometry.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the geometry to be examined.	*/
/*                                                                      */
/* perimeter	-out-	The total length of boundary (both outer and 	*/
/*			inner) in the simple area.			*/
/*                                                                      */
/* total_area	-out-	The total area of the geometry geom_id.		*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not a simple area type.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sa_get_data(
				    GD_GEOMETRY	geom_id,
				    GOTH_REAL  	*perimeter,
				    GOTH_REAL	*total_area);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sa_verify						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to check that the linework of an area geometry is valid. This*/
/* routine checks that none of the rings in an area self-intersect,	*/
/* that they are all digitised in the correct direction, that none of	*/
/* the rings intersect, that all the inner rings lie inside the 	*/
/* outer ring, and that no inner ring lies inside another inner ring.	*/
/*									*/
/* This routine will do a lot of processing for complicated		*/
/*       geometries and should not be called unnecessarily.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to be examined.	*/
/*                                                                      */
/* ok		-out-	TRUE if all the above conditions are met,	*/
/*                      FALSE otherwise.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not a simple area type.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sa_verify(
				  GD_GEOMETRY	geom_id,
				  GOTH_BOOLEAN	*ok);



/*>>> EXTERN functions from GEOM_SIMP_LINE.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_set_mark						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to set a _GMT_POSITION mark on a simple line geometry. The	*/
/* mark can be set at either end of the geometry, or at any		*/
/* position in between.							*/
/*									*/
/* The argument <<where>> specifies the position on the geometry to 	*/
/* place the mark. Using _GC_START and _GC_END specifies the end points */
/* of the geometry to be marked. When using _GC_POSITION, the argument	*/
/* mark_position indicates, through its integer part, the vertex before */
/* the mark, and the fractional part indicates the fraction between the */
/* two vertices at which the mark is to be placed. Obviously a zero 	*/
/* fractional part means the mark is pointing at a vertex.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			marked.						*/
/*									*/
/* mark_index	-in-	Index for the mark of the geometry to be used. !*/
/*			This index starts at 1.				*/
/*									*/
/* where	-in-	Position to mark. Must be one of:	       !*/
/*			_GC_START				       !*/
/*			_GC_POSITION				       !*/
/*			_GC_END					        */
/*									*/
/* mark_position -in-	Used when <<where>> is _GC_POSITION. 		*/
/*                      The integer part specifies vertex before the 	*/
/*			mark and the fractional part specifies the 	*/
/*			fraction between the two vertices at which to 	*/
/*			place the mark.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/* GOTH__INVALMARK	The mark_index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id is not a simple line geometry.	*/
/*									*/
/* GOTH__POSNOTEXIST	When using _GC_POSITION, the specified 		*/
/*			mark_position does not exist.			*/
/*									*/
/* GOTH__INVALWHERE	where was not one of values specified above.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_set_mark(
				    GD_GEOMETRY		geom_id,
				    GOTH_INTEGER	mark_index,
				    GEOMETRY_CONST	where,
				    GOTH_REAL		mark_position);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_add_vertex						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to add the specified vertex to the required position	in a 	*/
/* simple line geometry.						*/
/*									*/
/* Points may be added at the start or end of an open geometry, or at	*/
/* any marked position. In this case the mark must not point to a 	*/
/* vertex and the new vertex is added between the two vertices that  	*/
/* bound the mark.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to have a	*/
/*			point added.					*/
/*									*/
/* where	-in-	Position in geometry to add point to:	       !*/
/*			_GC_START - at start of geometry.	       !*/
/*			_GC_MARK  - between vertices that specified	*/
/*			mark lies between.			       !*/
/*			_GC_END - at end of geometry.		       	*/
/*									*/
/* mark_index	-in-	When <<where>> is _GC_MARK, the index of the	*/
/*			mark of geom_id to use in setting the new 	*/
/*			vertex.						*/
/*									*/
/* point_x	-in-	The x coordinate of the point to add to the	*/
/*			geometry.					*/
/*									*/
/* point_y	-in-	The y coordinate of the point to add to the	*/
/*			geometry.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__NOVM		There is no free virtual memory to use.		*/
/*									*/
/* GOTH__DUPLICATEDPT	Adding the specified point would have caused	*/
/*			a duplication with an existing point. The point	*/
/*			has not been added. (This code will not be 	*/
/*			returned if geom_id has been flagged to accept	*/
/*			duplicates).					*/
/*									*/
/* GOTH__INVALWHERE	where is not one of values specified above.	*/
/*									*/
/* GOTH__INVALGEOMTYPE	geom_id is not a simple line type.		*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__MARKNOTSET	The specified mark has not been set up.		*/
/*									*/
/* GOTH__MARKPTSWRONG	The mark points to a vertex. Should point	*/
/*			between vertices.				*/
/*									*/
/* GOTH__CLOSEDLINE	Cannot add point to start or end of closed line.*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_add_vertex(
				      GD_GEOMETRY	geom_id,
				      GEOMETRY_CONST	where,
				      GOTH_INTEGER	mark_index,
				      GOTH_REAL		point_x,
				      GOTH_REAL		point_y);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_remove_vertex						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to remove the specified vertex from a simple line geometry.	*/
/*									*/
/* Vertices may be removed from the start or end of open geometries,	*/
/* or any marked vertex may be removed. In the last case, the mark must	*/
/* point to a vertex and not between vertices.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry from which the 	*/
/*			point is to be removed.				*/
/*									*/
/* where	-in-	Point to be removed. One of:	       	       !*/
/*			_GC_START - the first point of the geometry.   !*/
/*			_GC_MARK  - a marked vertex of the geometry 	*/
/*			(must not point between vertices).	       !*/
/*			_GC_END - the last point of the geometry.	*/
/*									*/
/* mark_index	-in-	When <<where>> is _GC_MARK, the index of the	*/
/*			mark of geom_id to use in determining which	*/
/*			vertex to remove.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__DUPLICATEDPT	Removing the specified point would have caused	*/
/*			a duplication with an existing point. The point	*/
/*			has not been removed. (This code will not be 	*/
/*			returned if geom_id has been flagged to accept	*/
/*			duplicates).					*/
/*									*/
/* GOTH__INVALWHERE	where is not one of values specified above.	*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/* GOTH__INVALMARK	The mark_index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__MARKNOTSET	The specified mark has not been set up.		*/
/*									*/
/* GOTH__MARKPTSWRONG	The mark does not point to a vertex.		*/
/*									*/
/* GOTH__CLOSEDLINE	Cannot remove point from the start or end of a  */
/*			closed line.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_remove_vertex(
					 GD_GEOMETRY	geom_id,
					 GEOMETRY_CONST	where,
					 GOTH_INTEGER	mark_index);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_move_vertex						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to move the specified vertex in a simple line geometry to the*/
/* specified position.							*/
/* 									*/
/* If the vertex to be moved is selected by a mark, then the mark must	*/
/* point to a vertex, not between vertices. Marks are unaffected by this*/
/* routine.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be 	*/
/*			altered.					*/
/*									*/
/* where	-in-	Point to be moved. One of:	       	       !*/
/*			_GC_START - first vertex of geometry.	       !*/
/*			_GC_MARK  - a marked vertex of geometry (must  	*/
/*			not point between vertices).		       !*/
/*			_GC_END - last vertex of geometry.	       	*/
/*									*/
/* mark_index	-in-	When <<where>> is _GC_MARK, the index of the	*/
/*			mark of geom_id to use in determining which	*/
/*			vertex to move.					*/
/*									*/
/* x_new	-in-	The x coordinate of the updated position.	*/
/*									*/
/* y_new	-in-	The y coordinate of the updated position.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__DUPLICATEDPT	Repositioning the specified point would have 	*/
/*			caused a duplication with an existing point. 	*/
/*			The point has not been moved. (This code will  	*/
/*			not be returned if geom_id has been flagged to 	*/
/*			accept duplicates).				*/
/*									*/
/* GOTH__INVALWHERE	where is not one of values specified above.	*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/* GOTH__INVALMARK	The mark_index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__MARKNOTSET	The specified mark has not been set up.		*/
/*									*/
/* GOTH__MARKPTSWRONG	The mark does not point to a vertex.		*/
/*									*/
/* GOTH__CLOSEDLINE	Closed lines do not have start and end points.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_move_vertex(
				       GD_GEOMETRY	geom_id,
				       GEOMETRY_CONST	where,
				       GOTH_INTEGER	mark_index,
				       GOTH_REAL	x_new,
				       GOTH_REAL	y_new);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_get_coord						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the coordinates of the specified point from a 	*/
/* simple line geometry.						*/
/*									*/
/* If a mark is used to identify the position, then an interpolated	*/
/* position may be returned. It is also possible to retrieve the	*/
/* coordinates of the end points of open lines.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the line geometry that is to 	*/
/*			be used. 					*/
/*									*/
/* where	-in-	Point to be retrieved. May be one of:	       !*/
/*			_GC_START - point at start of geometry.	       !*/
/*			_GC_MARK  - point specified by mark (may be	*/
/*			between vertices).			       !*/
/*			_GC_END - point at end of geometry.	       	*/
/*									*/
/* mark_index	-in-	When <<where>> is _GC_MARK, the index of the	*/
/*			mark in geom_id to use in determining which	*/
/*			point on the line geometry to return.		*/
/*									*/
/* ret_x	-out-	The x coordinate of the specified point.	*/
/*									*/
/* ret_y	-out-	The y coordinate of the specified point.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/* GOTH__INVALWHERE	where is not one of values specified above.	*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__MARKNOTSET	The specified mark has not been set up.		*/
/*									*/
/* GOTH__MARKWRNGTYPE	The mark does not specify a position.		*/
/*									*/
/* GOTH__CLOSEDLINE	Closed lines do not have start and end points.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_get_coord(
				     GD_GEOMETRY	geom_id,
				     GEOMETRY_CONST	where,
				     GOTH_INTEGER	mark_index,
				     GOTH_REAL		*ret_x,
				     GOTH_REAL		*ret_y);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_close_ring						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to convert an open simple line geometry into a closed ring. 	*/
/* If the last point is not the same as the first point, the geometry is*/
/* closed by connecting the last point to the first, thus introducing	*/
/* an additional vector.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			closed.						*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	geom_id is not a simple line type.		*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/* GOTH__CLOSEDLINE	geom_id is already closed.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_close_ring(
				      GD_GEOMETRY	geom_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_merge_end_vertex					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine that closes a simple line geometry by moving either the first*/
/* vertex to where the last vertex is, or by moving the last vertex to 	*/
/* the first vertex's position. This alters the geometry of the original*/
/* feature by changing the opening or closing vector.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			closed.						*/
/*									*/
/* first_to_last -in-	TRUE to move the first point to the last 	*/
/*			point.					       !*/
/*			FALSE to move the last point to the first	*/
/*			point.						*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/* GOTH__CLOSEDLINE	The geom_id geometry is already closed.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_merge_end_vertex(
					    GD_GEOMETRY		geom_id,
					    GOTH_BOOLEAN	first_to_last);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_test_ring						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to test if a simple line geometry is opened or closed.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the line geometry that is to be	*/
/*			tested.						*/
/*									*/
/* ret_closed	-out-	TRUE if the line geometry is closed.	       !*/
/*			FALSE if the line geometry is open.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type. */
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_test_ring(
				     GD_GEOMETRY	geom_id,
				     GOTH_BOOLEAN	*ret_closed);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_open_ring						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to convert a closed simple line geometry into an open one. 	*/
/* The line is opened at the specified marked position.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			opened.						*/
/*									*/
/* mark_index	-in-	The index of the mark to use.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type. */
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__INVALMARK	The mark_index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__MARKNOTSET	The specified mark has not been set up.		*/
/*									*/
/* GOTH__MARKWRNGTYPE	The mark does not specify a position.		*/
/*									*/
/* GOTH__OPENLINE	Geometry is already open.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_open_ring(
				     GD_GEOMETRY	geom_id,
				     GOTH_INTEGER	mark_index);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_count_vertices					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the number of vertices in a simple line geometry.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			examined.					*/
/*									*/
/* ret_num_vertices -out- The number of vertices.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_count_vertices(
					  GD_GEOMETRY	geom_id,
					  GOTH_INTEGER	*ret_num_vertices);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_test_self_intersect					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to test if a simple line geometry intersects itself.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			tested.						*/
/*									*/
/* ret_intersect -out-	Result of the test. This should be one of the	*/
/*			following:					*/
/*			_GIT_NONE - does not intersect.		       !*/
/*			_GIT_POINT_TOUCH - a point touches a vertex.   !*/
/*			_GIT_LINE_TOUCH - two lines touch but do not	*/
/*					  intersect.		       !*/
/*			_GIT_INTERSECT - geometry intersects itself.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_test_self_intersect(
			GD_GEOMETRY		geom_id,
			GEOMETRY_INTERSECT_TYPE	*ret_intersect);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_reverse						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to reverse the order of coordinates in a simple line 	*/
/* geometry.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			reversed.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_reverse(
				   GD_GEOMETRY	geom_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_split							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to split a geometry into two at the specified mark. The first*/
/* half of the geom_id geometry is left there, whilst the second half is*/
/* put in the new geometry new_id.					*/
/*									*/
/* A closed ring cannot be split. It must be opened at some point 	*/
/* before it can be split into two parts.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			split.					       !*/
/*			This geometry retains the first part of the	*/
/*			original geometry.				*/
/*									*/
/* mark_index	-in-	Index of mark to specify split position.	*/
/*									*/
/* new_id	-out-	Descriptor for the second half of the geometry. */
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__NOVM		There is no free virtual memory available.	*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__CLOSEDLINE	The geometry is a ring, and cannot be split in	*/
/*			two.						*/
/*									*/
/* GOTH__INVALMARK	The mark_index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__MARKWRNGTYPE	The mark does not mark a position.	      	*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_split(
				 GD_GEOMETRY	geom_id,
				 GOTH_INTEGER	mark_index,
				 GD_GEOMETRY	*new_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_join							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to join two open line geometries together. The second	*/
/* geometry is appended to the first.					*/
/*									*/
/* The copy argument indicates if coordinate data can be taken directly	*/
/* from the second geometry, leaving it empty, or whether the		*/
/* coordinate data should be copied, leaving the second geometry intact.*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom1_id	-in-	Descriptor for the geometry that is to form	*/
/*		     	the start of the new geometry.			*/
/*									*/
/* geom2_id	-in-	Descriptor for the geometry to append to the	*/
/*			first geometry.					*/
/*									*/
/* copy		-in-	TRUE to $$copy$$ the coordinate data from the 	*/
/*			second geometry.			       !*/
/*			FALSE to move the coordinate data from the 	*/
/*			from the second to the first geometry 		*/
/* 			(leaving the second geometry clear).		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom1_id descriptor or the geom2_id 	*/
/*			descriptor is corrupt or of the incorrect type. */
/*									*/
/* GOTH__INVALGEOMTYPE	geom1_id or geom2_id is not a simple line type.	*/
/*									*/
/* GOTH__CLRGEOM	The geom1_id or geom2_id geometry contains no	*/
/*			data.						*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__CLOSEDLINE	One or other of the geometries is closed.	*/
/*									*/
/* GOTH__NOSELFJOIN	An attempt has been made to join a geometry to	*/
/*			itself.						*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_join(
				GD_GEOMETRY	geom1_id,
				GD_GEOMETRY	geom2_id,
				GOTH_BOOLEAN	copy);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_copy_part						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to copy part of a geometry into a new geometry.		*/
/*									*/
/* The data can be reversed while it is being copied if 		*/
/* start_where is nearer the end of the source geometry than		*/
/* end_where. This means that the routine cannot work on rings, as	*/
/* there is no way of indicating which part of the ring is to be 	*/
/* copied.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* from_id	-in-	Descriptor for the source geometry.		*/
/*									*/
/* start_where	-in-	Position in the geometry to start copying from:!*/
/*			_GC_START - at start of geometry.	       !*/
/*			_GC_MARK  - marked position on geometry.       !*/
/*			_GC_END   - at end of geometry.			*/
/*									*/
/* start_index	-in-	When start_where is _GC_MARK, mark in from_id	*/
/*			to use.						*/
/*									*/
/* end_where	-in-	Position in geometry to copy up to:	       !*/
/*			_GC_START - at start of geometry.	       !*/
/*			_GC_MARK  - marked position on geometry.       !*/
/*			_GC_END   - at end of geometry.		       	*/
/*									*/
/* end_index	-in-	When end_where is _GC_MARK, mark in from_id	*/
/*			to use.						*/
/*									*/
/* to_id	-out-	Descriptor for a geometry to			*/
/*			receive the copied part of the source geometry.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The from_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__NOVM		There is no free virtual memory available for	*/
/*			this operation.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	from_id is not a simple line type.		*/
/*									*/
/* GOTH__CLRGEOM	The from_id geometry contains no data.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__INVALWHERE	start_where or end_where is not one of the 	*/
/*			values specified above.				*/
/*									*/
/* GOTH__INVALMARK	start_index or end_index is not within the	*/
/*			range of marks available. A message with the	*/
/*			available range will have been put on the	*/
/*			message stack.					*/
/*									*/
/* GOTH__MARKNOTSET	A specified mark has not been set up.		*/
/*									*/
/* GOTH__MARKWRNGTYPE	A mark does not point to a position.		*/
/*									*/
/* GOTH__CLOSEDLINE	Cannot copy parts of closed lines.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_copy_part(
				     GD_GEOMETRY	from_id,
				     GEOMETRY_CONST	start_where,
				     GOTH_INTEGER	start_index,
				     GEOMETRY_CONST	end_where,
				     GOTH_INTEGER	end_index,
				     GD_GEOMETRY	*to_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_replace						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to replace the specified part of a geometry with the whole of*/
/* another geometry. The data from the source geometry may be copied 	*/
/* into the target geometry, or it may be moved by redirecting pointers,*/
/* leaving the source geometry clear.					*/
/*									*/
/* This routine only operates with open lines.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the target geometry that is to 	*/
/*			have a part replaced.				*/
/*									*/
/* start_where	-in-	Position in geom_id geometry to start replacing	*/
/*			at:					       !*/
/*			_GC_START - at start of geometry.	       !*/
/*			_GC_MARK  - marked position on geometry.       !*/
/*			_GC_END   - at end of geometry.			*/
/*									*/
/* start_index	-in-	When start_where is _GC_MARK, mark in geom_id	*/
/*			to use.						*/
/*									*/
/* end_where	-in-	End of part to be replaced:		       !*/
/*			_GC_START - at start of geometry.	       !*/
/*			_GC_MARK  - marked position on geometry.       !*/
/*			_GC_END   - at end of geometry.		       	*/
/*									*/
/* end_index	-in-	When end_where is _GC_MARK, mark in geom_id	*/
/*			to use.						*/
/*									*/
/* with_id	-in-	Descriptor for the source geometry which is to	*/
/*			replace part of geom_id.			*/
/*									*/
/* copy		-in-	TRUE to $$copy$$ the coordinate data from the 	*/
/*			with_id geometry.			       !*/
/*			FALSE to move the coordinate data from the 	*/
/*			with_id geometry to the geom_id	geometry 	*/
/*			(leaving the with_id geometry clear).		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		Either the geom_id or the with_id descriptor is */
/*			corrupt or of the incorrect type.		*/
/*									*/
/* GOTH__INVALGEOMTYPE	Either geom_id or with_id is not a simple line 	*/
/*			type geometry.					*/
/*									*/
/* GOTH__CLRGEOM	Either the geom_id or with_id geometry contains	*/
/*			no data.					*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__INVALWHERE	start_where or end_where is not one of values	*/
/*			specified above.				*/
/*									*/
/* GOTH__INVALMARK	start_index or end_index is not within the	*/
/*			range of marks available. A message with the	*/
/*			available range will have been put on the	*/
/*			message stack.					*/
/*									*/
/* GOTH__MARKNOTSET	A specified mark has not been set up.		*/
/*									*/
/* GOTH__MARKWRNGTYPE	A mark does not point to a position.		*/
/*									*/
/* GOTH__CLOSEDLINE	Either the geom_id geometry or the with_id 	*/
/*			geometry is closed.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_replace(
				   GD_GEOMETRY		geom_id,
				   GEOMETRY_CONST	start_where,
				   GOTH_INTEGER		start_index,
				   GEOMETRY_CONST	end_where,
				   GOTH_INTEGER		end_index,
				   GD_GEOMETRY		with_id,
				   GOTH_BOOLEAN		copy);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_add_array						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to add an array of points to a geometry. If the first or	*/
/* last points result in two coincident points in the geometry		*/
/* then they are ignored.						*/
/*									*/
/* Points may be added at the start or end of an open geometry, or at	*/
/* any marked position. In this case the mark must not point to a 	*/
/* vertex and the new vertex is added between the two vertices that  	*/
/* bound the mark.							*/
/*								       	*/
/* When called from C, the points are of type GEOM_COORD_PAIR in the 	*/
/* array pointed at by point_array.					*/
/*									*/
/* When called from Lull, the array of points is a single dimension	*/
/* array of reals with 2 * num_pts_in_array elements, in the order x1,y1*/
/* ,x2,y2...								*/
/*									*/
/* If the check_for_duplicates argument is TRUE, the points are checked	*/
/* for duplicates and the call fails if any are found.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to receive	*/
/*			the array of points.				*/
/*									*/
/* where	-in-	Position in the geometry to add points to:     !*/
/*			_GC_START - at start of geometry.	       !*/
/*			_GC_MARK  - between vertices that specified	*/
/*			mark lies between.			       !*/
/*			_GC_END - at end of geometry.		       	*/
/*									*/
/* mark_index	-in-	When <<where>> is _GC_MARK, the index of the 	*/
/*			mark in geom_id to use.				*/
/*									*/
/* num_pts_in_array -in- Number of coordinate pairs to add.		*/
/*									*/
/* point_array	-in-	+array+ Array of points to add.			*/
/*									*/
/* check_for_duplicates -in- TRUE to check the coordinates for 		*/
/*			     adjacent duplicates. The call fails if any */
/*			     are found.				       !*/
/*			     FALSE not to check for duplicates. 	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__NOVM		There is no free virtual memory to use.		*/
/*									*/
/* GOTH__INVALWHERE	where is not one of values specified above.	*/
/*									*/
/* GOTH__INVALGEOMTYPE	geom_id is not a simple line type.		*/
/*									*/
/* GOTH__INVALMARK	The mark index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__MARKNOTSET	The specified mark has not been set up.		*/
/*									*/
/* GOTH__MARKPTSWRONG	The mark points to a vertex. Should point	*/
/*			between vertices.				*/
/*									*/
/* GOTH__CLOSEDLINE	Cannot add point to start or end of closed line.*/
/*									*/
/* GOTH__DUPLICATEDPT	Two adjacent points in the point_array were the	*/
/*			same.						*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_add_array(
				     GD_GEOMETRY	geom_id,
				     GEOMETRY_CONST    	where,
				     GOTH_INTEGER	mark_index,
				     GOTH_INTEGER	num_pts_in_array,
				     GEOM_COORD_PAIR    *point_array,
				     GOTH_BOOLEAN	check_for_duplicates);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_get_array						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the coordinate data of a simple line geometry as an*/
/* array of coordinate pairs. If the simple line is closed, the first 	*/
/* point will be duplicated at the end of the array.			*/
/*									*/
/* If the array is too small (as indicated by num_pts_in_array) to	*/
/* hold all the coordinates, then it will be extended (and 		*/
/* num_pts_in_array updated). In either case the number of coordinate	*/
/* pairs transferred is returned in n_pts.				*/
/*									*/
/* When called from C, the points are of type GEOM_COORD_PAIR in the 	*/
/* array pointed at by point_array. Note that point_array may be	*/
/* the address of a pointer that has been set to NULL, with 		*/
/* the integer pointed to by num_pts_in_array being 0.			*/
/*									*/
/* When called from Lull, the array of points is a single dimension	*/
/* array of reals with 2 * num_pts_in_array elements, in the order x1,y1*/
/* ,x2,y2...								*/
/*								       	*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the source geometry.		*/
/*									*/
/* num_pts_in_array -in/out- The size of point_array, before and after 	*/
/*			     the call.					*/
/*									*/
/* point_array	-out-	+array+ Array of returned coordinates.		*/
/*									*/
/* n_pts	-out-	The number of coordinate pairs returned.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__NOVM		There is no free virtual memory to use.		*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry geom_id is not a simple line type.	*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_get_array(
				     GD_GEOMETRY	geom_id,
				     GOTH_INTEGER      *num_pts_in_array,
				     GEOM_COORD_PAIR   **point_array,
				     GOTH_INTEGER      *n_pts);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_extract_points					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Specialised routine to return the data from a ring of a simple line	*/
/* as an array of XPoints						*/
/*									*/
/* Where the line is closed, duplicated first and last points are	*/
/* produced.								*/
/*									*/
/* <<NOTE>>: space for array is provided by the calling routine. No 	*/
/* checking for overflow or extension is carried out.			*/
/*									*/
/* Used by <<displib>>. Not available in LULL.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* space_tree_id -in-	Descriptor for the space tree to use for	*/
/*			any transformation to use. May be <<NULL>>.	*/
/* 									*/
/* geom_id	-in-	Descriptor for the simple line geometry.	*/
/* 									*/
/* new_space_id	-in-	Descriptor for the space the returned points 	*/
/*			are required to be in. 			       !*/
/*								       !*/
/*			Note, if either <<new_space_id>> is <<NULL>>,	*/
/*			or the space descriptor attached to <<geom_id>>	*/
/*			is NULL (no space assigned to the geometry),	*/
/*			then the returned points will be as defined	*/
/*			within <<geom_id>>, no space transformation	*/
/*			will have been applied to the points.		*/
/* 									*/
/* pixel_width	-in-	The x extent of a pixel.			*/
/* 									*/
/* pixel_height	-in-	The y extent of a pixel.			*/
/* 									*/
/* xlo		-in-	The x coordinate of the lower left corner of	*/
/*			the window.					*/
/* 									*/
/* ylo		-in-	The y coordinate of the lower left corner of	*/
/*			the window.					*/
/* 									*/
/* xhi		-in-	The x coordinate of the upper right corner of	*/
/*			the window.					*/
/* 									*/
/* yhi		-in-	The y coordinate of the upper right corner of	*/
/*			the window.					*/
/* 									*/
/* array_start	-in-	A pointer to the start of the array of XPoints.!*/
/*			<<NOTE: an array of appropriate size must have 	*/
/*			been already malloc'd.>>			*/
/* 									*/
/* num_points	-out-	A pointer to a variable to receive the number	*/
/*			of points returned.				*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data			*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not a simple type.		*/
/*									*/
/* GOTH__INVALRECT	The lower left of the window is not below and	*/
/* 			to the left of the upper right of the window.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_extract_points(
					  GD_SPACE_TREE	space_tree_id,
					  GD_GEOMETRY	geom_id,
					  GD_SPACE	new_space_id,
					  GOTH_INTEGER	pixel_width,
					  GOTH_INTEGER	pixel_height,
					  GOTH_REAL	xlo,
					  GOTH_REAL	ylo,
					  GOTH_REAL	xhi,
					  GOTH_REAL	yhi,
					  XPoint	*array_start,
					  GOTH_INTEGER	*num_points);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_mark_intersect					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to find the intersection point between two geometries. It	*/
/* returns the intersection point and sets the corresponding values in	*/
/* the marks specified for each geometry. Where there is more than one	*/
/* intersection between the geometries, the one nearest the input point */
/* <<(near_x, near_y)>> is chosen.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id_1	-in-	Descriptor for the first geometry.		*/
/*									*/
/* geom_id_2	-in-	Descriptor for the second geometry.		*/
/*									*/
/* mark_index_1	-in-	Index of the mark in geom_id_1 to set.		*/
/*									*/
/* mark_index_2	-in-	Index of the mark in geom_id_2 to set.		*/
/*									*/
/* near_x	-in-	The x coordinate of the input point.		*/
/*									*/
/* near_y	-in-	The y coordinate of the input point.		*/
/*									*/
/* ret_x	-out-	The x coordinate of the point of intersection	*/
/*			of the two geometries.				*/
/*									*/
/* ret_y	-out-	The y coordinate of the point of intersection	*/
/*			of the two geometries.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__NOINTERSECT	The geometries do not intersect.		*/
/*									*/
/* GOTH__DESC		One of the geometry descriptors is corrupt or  	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__INVALGEOMTYPE	One of the input geometries is not a simple	*/
/*			line type.					*/
/*									*/
/* GOTH__CLRGEOM	One of the geometries contains no data.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__NOTENOUGHDATA	The geometries must have at least two points.	*/
/*									*/
/* GOTH__INVALMARK	One of the mark index's is not within the range */
/*			of marks available. A message with the available*/
/* 			range will have been put on the message stack.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_mark_intersect(
					  GD_GEOMETRY	geom_id_1,
					  GD_GEOMETRY	geom_id_2,
					  GOTH_INTEGER	mark_index_1,
					  GOTH_INTEGER	mark_index_2,
					  GOTH_REAL	near_x,
					  GOTH_REAL	near_y,
					  GOTH_REAL	*ret_x,
					  GOTH_REAL	*ret_y);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_mark_extension					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to find the intersection between an end vector of one 	*/
/* geometry and another geometry.					*/
/*									*/
/* The intersection may take place within the first or last vector of	*/
/* the first geometry, or on the invisible extension from the free end 	*/
/* of this vector.							*/
/*									*/
/* Where there is more than one intersection point, the point nearest	*/
/* the input point (near_x,near_y) is returned.				*/
/*									*/
/* The intersection point is returned as:				*/
/*@ The fraction of the end vector of the first geometry where the 	*/
/*  intersection occurs.						*/
/*@ A mark on the second geometry.					*/
/*@ The coordinates of the intersection point.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id_1	-in-	Descriptor for the geometry that is to have an	*/
/*			end vector used for intersection.		*/
/*									*/
/* geom_id_2	-in-	Descriptor for the geometry to be intersected.	*/
/*									*/
/* where_1	-in-	Which vector of geom_id_1 to use. May be:      !*/
/*			_GC_START for first vector.		       !*/
/*			_GC_END   for last vector.			*/
/*									*/
/* frac_1	-out-	The fraction of	the end vector of geom_id_1 	*/
/*			where the intersection occurs.			*/
/*									*/
/* mark_index_2	-in-	Index of the mark in geom_id_2 to set.		*/
/*									*/
/* near_x	-in-	The x coordinate of the input point.		*/
/*									*/
/* near_y	-in-	The y coordinate of the input point.		*/
/*									*/
/* ret_x	-out-	The x coordinate of the point of intersection	*/
/*			of the extended end vector of <<geom_id_1>>	*/
/*			with the geometry <<geom_id_2>>.		*/
/*									*/
/* ret_y	-out-	The y coordinate of the point of intersection	*/
/*			of the extended end vector of <<geom_id_1>>	*/
/*			with the geometry <<geom_id_2>>.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__NOINTERSECT	The specified vector or geom_id_1, or its	*/
/*			extension does not intersect with geom_id_2.	*/
/*									*/
/* GOTH__DESC	     	The geom_id_1 or geom_id_2 descriptor is 	*/
/*			corrupt or of the incorrect type.		*/
/*									*/
/* GOTH__INVALGEOMTYPE	One of the geometries is not a simple line.	*/
/*									*/
/* GOTH__CLRGEOM	One of the geometries  contains no data.	*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__NOTENOUGHDATA	The geometries must have at least two points.	*/
/*									*/
/* GOTH__CLOSEDLINE	geom_id_1 is closed, and so does not have an	*/
/*			end vector.					*/
/* GOTH__INVALWHERE	where_1 is not one of the two values allowed	*/
/* 			(see arguments).				*/
/*									*/
/* GOTH__INVALMARK	The mark_index_2 is not within the range of 	*/
/*			marks available. A message with the available 	*/
/* 		      	range will have been put on the message stack.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_mark_extension(
					  GD_GEOMETRY	  geom_id_1,
					  GD_GEOMETRY	  geom_id_2,
					  GEOMETRY_CONST  where_1,
					  GOTH_REAL       *frac_1,
					  GOTH_INTEGER    mark_index_2,
					  GOTH_REAL       near_x,
					  GOTH_REAL       near_y,
					  GOTH_REAL       *ret_x,
					  GOTH_REAL       *ret_y);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_enable_duplicates					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to allow duplicate points in a geometry. This restricts the	*/
/* operations allowed on the geometry.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			allowed duplicates.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_enable_duplicates(
					     GD_GEOMETRY	geom_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_remove_duplicates					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to go through a geometry removing duplicate points, and then	*/
/* clearing the 'allow duplicates' flag.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to have	*/
/*			duplicates removed.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/* GOTH__NOTENOUGHDATA	Removing duplicate points from a closed ring	*/
/* 			would leave less than 3 points.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_remove_duplicates(
					     GD_GEOMETRY	geom_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_test_duplicates					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to test whether a geometry is flagged for accepting 		*/
/* duplicates.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			tested.						*/
/*									*/
/* ret_allowed	-out-	TRUE if geom_id is flagged to accept duplicates.!*/
/*			FALSE if geom_id is no flagged to accept 	*/
/*			duplicates.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_test_duplicates(
					   GD_GEOMETRY		geom_id,
					   GOTH_BOOLEAN	       *ret_allowed);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_get_data						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return information on the linework in a simple line 	*/
/* geometry. This consists of the length of the linework, if the line is*/
/* closed, and if it is closed, the area surrounded by the linework.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the line geometry to be 		*/
/*			examined.					*/
/*									*/
/* line_length	-out-	The returned length of the linework.		*/
/*									*/
/* is_ring	-out-	TRUE if the line geometry is closed.	       !*/
/*			FALSE if the line geometry is open.		*/
/*									*/
/* line_area	-out-	The area surrounded by the linework if is_ring 	*/
/*			is TRUE.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type. */
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_get_data(
				    GD_GEOMETRY		geom_id,
				    GOTH_REAL		*line_length,
				    GOTH_BOOLEAN	*is_ring,
				    GOTH_REAL		*line_area);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_mark_analyse						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to determine if a mark on a simple line geometry points to an*/
/* end, and if so which end.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			tested.						*/
/*									*/
/* mark_index	-in-	The mark that is to be analysed.		*/
/*									*/
/* on_end	-out-	TRUE if the mark points to an end vertex.      !*/
/*			FALSE if the mark does not point to an end 	*/
/*			vertex.						*/
/*									*/
/* which_end	-out-	_GC_START or _GC_END to indicate which		*/
/*			end of the geometry that the mark points to.    */
/*			This is only set if on_end is TRUE.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/* GOTH__INVALMARK	The mark_index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_mark_analyse(
					GD_GEOMETRY	geom_id,
					GOTH_INTEGER	mark_index,
					GOTH_BOOLEAN	*on_end,
					GEOMETRY_CONST	*which_end);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_mark_at_distance					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to set a mark at a specific distance from an end of a 	*/
/* geometry.								*/
/*									*/
/* If the distance is positive, then the distance from the start of the	*/
/* geometry is marked. If negative, then the distance from the end of 	*/
/* the geometry is marked.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			marked.						*/
/*									*/
/* mark_index	-in-	Index of the mark to set			*/
/*									*/
/* distance_along -in-	Distance along geometry to set the mark at. If	*/
/*			distance_along is positive, then the distance	*/
/*			from the start of the geometry is used, 	*/
/* 			otherwise the distance from the end is used.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__DISTTOOBIG	distance_along is greater than total length of	*/
/*			geom_id.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/* GOTH__INVALMARK	The mark_index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/* GOTH__CLOSEDLINE	This routine is not valid on closed lines.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_mark_at_distance(
					    GD_GEOMETRY		geom_id,
					    GOTH_INTEGER	mark_index,
					    GOTH_REAL		distance_along);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_get_marked_distance					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the distance of a mark from the start of a 	*/
/* geometry.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			measured.					*/
/*									*/
/* mark_index	-in-	Index of the mark to be measured.		*/
/*									*/
/* ret_distance	-out-   The distance from the start of the geometry to 	*/
/*			the mark specified.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/* GOTH__INVALMARK	The mark_index is not within the range of marks	*/
/*			available. A message with the available range	*/
/* 		      	will have been put on the message stack.	*/
/*									*/
/* GOTH__MARKNOTSET	The specified mark has not been set up.		*/
/*									*/
/* GOTH__MARKWRNGTYPE	The mark does not point to a position on the	*/
/*			linework.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_get_marked_distance(
					       GD_GEOMETRY	geom_id,
					       GOTH_INTEGER	mark_index,
					       GOTH_REAL	*ret_distance);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_add_arc						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to add a circle arc, described by 3 coordinate pairs, to the */
/* start (_GC_START) or end (_GC_END) of a simple line geometry. The 	*/
/* type of arc is defined by the GEOMETRY_ARC_TYPE type, which specifies*/
/* either a clockwise arc, an anticlockwise arc, a circum arc, or a 	*/
/* circum circle. The length of the generated vectors is specified using*/
/* the vector_length argument.						*/
/* 									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			extended.					*/
/*									*/
/* where	-in-	Position in geometry to add points to:	       !*/
/*			_GC_START - at start of geometry.	       !*/
/*			_GC_END - at end of geometry.		       	*/
/*									*/
/* x1		-in- 	The x coordinate of the first point defining 	*/
/*			the arc.					*/
/*									*/
/* y1		-in-	The y coordinate of the first point defining	*/
/*			the arc.					*/
/*									*/
/* x2		-in- 	The x coordinate of the second point defining	*/
/*			the arc.					*/
/*									*/
/* y2		-in-	The y coordinate of the second point defining 	*/
/*			the arc.					*/
/*									*/
/* x3		-in- 	The x coordinate of the third point defining	*/
/*			the arc.					*/
/*									*/
/* y3		-in-	The y coordinate of the third point defining	*/
/*			the arc.					*/
/*									*/
/* arc_type	-in-	Type of arc to add. Must be one of the 		*/
/*			following:				       !*/
/*			_GAT_CLOCK_ARC				       !*/
/*			_GAT_ANTI_CLOCK_ARC			       !*/
/*			_GAT_CIRCUM_ARC				       !*/
/*			_GAT_CIRCUM_CIRCLE				*/
/* 									*/
/* vector_length -in-	The length of the vectors to be generated.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	geom_id is not a simple line type.		*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__INVALWHERE	where was not one of values specified above.	*/
/*									*/
/* GOTH__CLOSEDLINE	Cannot add points to start or end of closed	*/
/*			line.						*/
/*									*/
/* GOTH__BADCIRCLE	Two adjacent defining points are identical.	*/
/*									*/
/* GOTH__COLLINEAR	The defining points do not define a circle or	*/
/*			arc of the specified type.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_add_arc(
				   GD_GEOMETRY		geom_id,
				   GEOMETRY_CONST	where,
				   GOTH_REAL		x1,
				   GOTH_REAL		y1,
				   GOTH_REAL		x2,
				   GOTH_REAL		y2,
				   GOTH_REAL		x3,
				   GOTH_REAL		y3,
				   GEOMETRY_ARC_TYPE	arc_type,
				   GOTH_REAL		vector_length);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_displace						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to displace a line by the specified amount. The displaced 	*/
/* line is offset to the right of the original line by the distance 	*/
/* offset_dist.	The vector_length is the maximum length of vector to 	*/
/* generate around curves.						*/
/*									*/
/* If offset_dist is greater than vector_length, this routine may 	*/
/* produce loops in the output geometry.	       			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			displaced.					*/
/*									*/
/* offset_dist	-in-	Distance to offset geom_id by. 			*/
/*									*/
/* vector_length -in-	Length of vectors in curves that are generated	*/
/*			around obtuse angles in the original geometry.	*/
/*									*/
/* displaced_id	-out-	Descriptor for the displaced geometry.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__NOVM		There is no free virtual memory to use.		*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple line type.	*/
/*									*/
/* GOTH__CLRGEOM	The geom_id geometry contains no data.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_displace(
				    GD_GEOMETRY		geom_id,
				    GOTH_REAL		offset_dist,
				    GOTH_REAL		vector_length,
				    GD_GEOMETRY		*displaced_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_test_match						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to test if two open line geometries are coincident. The ends */
/* of the geometries are presumed to be coincident, but the vertices are*/
/* considered coincident if they are within the tolerance rad_tolerance */
/* of each other.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_1_id	  -in-	Descriptor for the first geometry.		*/
/*									*/
/* geom_2_id	  -in-	Descriptor for the second geometry.		*/
/*									*/
/* same_direction -in-	TRUE if the geometries are in the same 		*/
/*			direction.					*/
/*									*/
/* rad_tolerance  -in-  The radial tolerance to use.			*/
/*									*/
/* ret_matching	 -out-	TRUE if all the vertices of one geometry lie on	*/
/*			other geometry, and vice versa.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		A geometry descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__NOVM		There is no free virtual memory to use.		*/
/*									*/
/* GOTH__INVALGEOMTYPE	One of the geometries is not a simple line type.*/
/*									*/
/* GOTH__CLRGEOM	One of the geometries contains no data.		*/
/*									*/
/* GOTH__CLOSEDLINE	One of the geometries is a closed line.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_test_match(
				      GD_GEOMETRY	geom_1_id,
				      GD_GEOMETRY	geom_2_id,
				      GOTH_BOOLEAN	same_direction,
				      GOTH_REAL		rad_tolerance,
				      GOTH_BOOLEAN	*ret_matching);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_test_lines_approach					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* 									*/
/* To test if two lines approach each other (within the tolerance)	*/
/* anywhere along their length.						*/
/* 									*/
/* Note that if the lines intersect, then the result will be be TRUE	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id_1	  -in-	Descriptor for the first geometry.		*/
/*									*/
/* geom_id_2	  -in-	Descriptor for the second geometry.		*/
/*									*/
/* tolerance      -in-  The radial $$tolerance$$ to use.		*/
/*									*/
/* include_ends_1 -in-	Include the ends of geom_id_1, even if they	*/
/* 			leave the influence of geom_id_2 before the 	*/
/*			end of the first vector				*/
/*									*/
/* include_ends_2 -in-	Include the ends of geom_id_2, even if they	*/
/* 			leave the influence of geom_id_1 before the 	*/
/*			end of first vector				*/
/*									*/
/* ret_are_near	 -out-	TRUE if the geometries come within tolerance of	*/
/* 			each other					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_test_lines_approach(
					       GD_GEOMETRY	geom_id_1,
					       GD_GEOMETRY	geom_id_2,
					       GOTH_REAL	tolerance,
					       GOTH_BOOLEAN	include_ends_1,
					       GOTH_BOOLEAN	include_ends_2,
					       GOTH_BOOLEAN	*ret_are_near);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sl_get_approach_points					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* To find the points where two lines approach each other.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id_1	-in-	Descriptor for the first geometry. 		*/
/*									*/
/* geom_id_2	-in-	Descriptor for the second geometry. 		*/
/*									*/
/* tolerance	-in-	The approach $$tolerance$$ to use.		*/
/*									*/
/* list_1	-out-	The list of distances of entry/exit points for	*/
/*			geom_id_1.					*/
/*									*/
/* list_2	-out-	The list of distances of entry/exit points for	*/
/*			geom_id_2.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__GEOMTOOCOMPLIC	Parts of geometries that approach each other	*/
/*			do not map onto each other in a 1 to 1 way.    !*/
/*			In this case empty lists are returned.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sl_get_approach_points(
					       GD_GEOMETRY	geom_id_1,
					       GD_GEOMETRY	geom_id_2,
					       GOTH_REAL	tolerance,
					       GD_COLLECTION	*list_1,
					       GD_COLLECTION	*list_2);

/*>>> EXTERN functions from GEOM_SIMP_POINT.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN geom_sp_set_coord						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to set the coordinate in a simple point geometry.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the point geometry.		*/
/*									*/
/* point_x	-in-	The x coordinate of the point to set.		*/
/*									*/
/* point_y	-in-	The y coordinate of the point to set.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple point type.*/
/*									*/
/* GOTH__NOVM		No free virtual memory to use.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sp_set_coord(
				     GD_GEOMETRY	geom_id,
				     GOTH_REAL		point_x,
				     GOTH_REAL		point_y);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sp_get_coord						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to retrieve the coordinates from a simple point geometry.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the point geometry.		*/
/*									*/
/* point_x	-out-	The x coordinate of the point.			*/
/*									*/
/* point_y	-out-	The y coordinate of the point.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geom_id geometry is not a simple point type.*/
/*									*/
/* GOTH_CLRGEOM		The point has never been set.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sp_get_coord(
				     GD_GEOMETRY	geom_id,
				     GOTH_REAL		*ret_x,
				     GOTH_REAL		*ret_y);
/*----------------------------------------------------------------------*/
/* EXTERN geom_sp_extract_point						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Specialised routine to return coordinate XPoint from a simple point	*/
/* geometry								*/
/*									*/
/* Used by <<displib>>. Not available in LULL.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* space_tree_id -in-	Descriptor for the space tree to use for	*/
/*			any transformation to use. May be <<NULL>>.	*/
/* 									*/
/* geom_id	-in-	Descriptor for the simple point geometry.	*/
/* 									*/
/* new_space_id	-in-	Descriptor for the space the returned point	*/
/*			is required to be in. 			       !*/
/*								       !*/
/*			Note, if either <<new_space_id>> is <<NULL>>,	*/
/*			or the space descriptor attached to <<geom_id>>	*/
/*			is NULL (no space assigned to the geometry),	*/
/*			then the returned point will be as defined	*/
/*			within <<geom_id>>, no space transformation	*/
/*			will have been applied to the point.		*/
/* 									*/
/* pixel_width	-in-	The x extent of a pixel.			*/
/* 									*/
/* pixel_height	-in-	The y extent of a pixel.			*/
/* 									*/
/* xlo		-in-	The x coordinate of the lower left corner of	*/
/*			the window.					*/
/* 									*/
/* ylo		-in-	The y coordinate of the lower left corner of	*/
/*			the window.					*/
/* 									*/
/* xhi		-in-	The x coordinate of the upper right corner of	*/
/*			the window.					*/
/* 									*/
/* yhi		-in-	The y coordinate of the upper right corner of	*/
/*			the window.					*/
/* 									*/
/* XPoint_xy	-out-	A pointer to a variable to receive the result.	*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not a simple point type.	*/
/*									*/
/* GOTH__INVALRECT	The lower left of the window is not below and	*/
/* 			to the left of the upper right of the window.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_sp_extract_point(
					 GD_SPACE_TREE	space_tree_id,
					 GD_GEOMETRY	geom_id,
					 GD_SPACE	new_space_id,
					 GOTH_INTEGER	pixel_width,
					 GOTH_INTEGER   pixel_height,
					 GOTH_REAL      xlo,
					 GOTH_REAL      ylo,
					 GOTH_REAL      xhi,
					 GOTH_REAL      yhi,
					 XPoint         *XPoint_xy);

/*>>> EXTERN functions from GEOM_TB.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN geom_tb_sq_build						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to create a squaring tolerance block.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* tb_sq_id	-out-	Descriptor to receive the squaring tolerance 	*/
/*			block.						*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__NOVM		No free virtual memory to use.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_tb_sq_build(
				    GD_TB_SQ	*tb_sq_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_tb_sq_destroy						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to destroy a squaring tolerance block (both its data 	*/
/* structure and its GOTH_DESCRIPTOR).					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* tb_sq_id	-in-   Descriptor for the squaring tolerance block	*/
/*		       to destroy.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The tb_sq_id descriptor is corrupt or of the 	*/
/*			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_tb_sq_destroy(GD_TB_SQ	tb_sq_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_tb_sq_set_values						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to set the values in a squaring tolerance block. See the	*/
/* introduction for meanings of the entries with the various types of 	*/
/* squaring.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* tb_sq_id	-in-	Descriptor for the squaring tolerance block.	*/
/*									*/
/* side_max_move -in-	Distance to control choice of sides to square. !*/
/* 			If movement is less than this amount, the line	*/
/* 			is marked for squaring on this pass.		*/
/*									*/
/* side_min_len	-in-	Minimum length of side to be considered for 	*/
/*			squaring.					*/
/*									*/
/* base_max_move -in-	Distance to control choice of sides to square 	*/
/* 			when using based squaring.		       !*/
/* 			If movement is less than this amount, the line	*/
/* 			is marked for squaring on this pass.		*/
/*									*/
/* base_min_len -in-	Minimum length of side to be considered for 	*/
/*			squaring when using based squaring.		*/
/*									*/
/* angle_sq_limit -in-	Tolerance (in degrees) for angle squaring.	*/
/*									*/
/* warn_limit	-in-	Issue a warning if points are moved by more than*/
/*			this amount.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The tb_sq_id descriptor is corrupt or of the 	*/
/*			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_tb_sq_set_values(
					 GD_TB_SQ	tb_sq_id,
					 GOTH_REAL	side_max_move,
					 GOTH_REAL	side_min_len,
					 GOTH_REAL	base_max_move,
					 GOTH_REAL	base_min_len,
					 GOTH_REAL	angle_sq_limit,
					 GOTH_REAL	warn_limit);
/*----------------------------------------------------------------------*/
/* EXTERN geom_tb_sq_get_values						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to retrieve the values currently set in a squaring tolerance */
/* block. See the introduction for the meanings of the entries below.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* tb_sq_id	-in-	Descriptor for a squaring tolerance block.	*/
/*									*/
/* side_max_move -out-	Distance to control choice of sides to square.  */
/* 			If movement is less than this amount, the line	*/
/* 			is marked for squaring on this pass.		*/
/*									*/
/* side_min_len	-out-	Minimum length of side to be considered for 	*/
/*			squaring.					*/
/*									*/
/* base_max_move -out-	Distance to control choice of sides to square 	*/
/* 			when using based squaring.		        */
/* 			If movement is less than this amount, the line	*/
/* 			is marked for squaring on this pass		*/
/*									*/
/* base_min_len -out-	Minimum length of side to be considered for 	*/
/*			squaring when using based squaring.		*/
/*									*/
/* angle_sq_limit -out-	Tolerance (in degrees) for angle squaring.	*/
/*									*/
/* warn_limit	-out-	A warning message is issued if points are moved */
/*			by more than this amount.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The tb_sq_id descriptor is corrupt or of the 	*/
/*			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_tb_sq_get_values(
					 GD_TB_SQ	tb_sq_id,
					 GOTH_REAL	*side_max_move,
					 GOTH_REAL	*side_min_len,
					 GOTH_REAL	*base_max_move,
					 GOTH_REAL	*base_min_len,
					 GOTH_REAL	*angle_sq_limit,
					 GOTH_REAL	*warn_limit);

/*>>> EXTERN functions from GEOMLIB.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN geom_alloc							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to create a descriptor block typed for a geometry.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GD_GEOMETRY	Descriptor for the geometry.			       !*/
/*		If NULL, no free virtual memory available.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GD_GEOMETRY geom_alloc();
/*----------------------------------------------------------------------*/
/* EXTERN geom_free							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to free up a descriptor block typed for a geometry. This 	*/
/* routine fails if the descriptor is pointing to a geometry.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to free.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is pointing to a valid 	*/
/*			geometry.					*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_free(
			     GD_GEOMETRY	geom_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_delete							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Function to clear a geometry of all its data and then free up its	*/
/* allocated space.							*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to clear.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is already free.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_delete(
			       GD_GEOMETRY	geom_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_destroy							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to delete a geometry and free its descriptor.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to destroy.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_destroy(
				GD_GEOMETRY	geom_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_clear							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Function to clear a geometry so it no longer has any coordinate data.*/
/* This returns it to the same state as if one of a similar type has 	*/
/* just been created.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to clear.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_clear(
			      GD_GEOMETRY	geom_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_test_clear						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to test if a geometry has any data in it.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to test.		*/
/*									*/
/* ret_geom_clear -out-	TRUE if the geometry has no data.	       !*/
/*			FALSE if the geometry has data.		    	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_test_clear(
				   GD_GEOMETRY	geom_id,
				   GOTH_BOOLEAN	*ret_geom_clear);
/*----------------------------------------------------------------------*/
/* EXTERN geom_test_built						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to test if a GD_GEOMETRY points to a geometry.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to test.		*/
/*									*/
/* ret_geom_built -out-	TRUE if the geometry has been created.	       !*/
/*			FALSE if the geometry has not been created.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_test_built(
				   GD_GEOMETRY	geom_id,
				   GOTH_BOOLEAN	*ret_geom_built );
/*----------------------------------------------------------------------*/
/* EXTERN geom_copy							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to create a new geometry and copy the information in the	*/
/* original geometry into it.						*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the original geometry.		*/
/*									*/
/* ret_geom_id	-out-	Descriptor for the copied geometry.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__NOVM		No free virtual memory to available.		*/
/*									*/
/* GOTH__NOTCLRGEOM   	The target geometry already contains data.	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_copy(
			     GD_GEOMETRY	geom_id,
			     GD_GEOMETRY	*ret_geom_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_overwrite						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Function to overwrite a geometry with a copy of another geometry.	*/
/* The function fails if the two geometries are not of the same type.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* overwritten_geom_id 	-in- Descriptor for the geometry to overwrite.	*/
/*									*/
/* original_geom_id 	-in- Descriptor for the geometry to copy.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		One of the geometry descriptors is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The original_geom_id contains no data.		*/
/*									*/
/* GOTH__DIFFGEOMTYPES	The geometries are of different types.		*/
/*									*/ 
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_overwrite(
				  GD_GEOMETRY	overwritten_geom_id,
				  GD_GEOMETRY	original_geom_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_get_MBR							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* This function retrieves the bounding box of a geometry.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to be interrogated.	*/
/*									*/
/* ret_xlo	-out-	Minimum x coordinate of the bounding box.	*/
/*									*/
/* ret_ylo	-out-	Minimum y coordinate of the bounding box.	*/
/*									*/
/* ret_xhi	-out-	Maximum x coordinate of the bounding box.	*/
/*									*/
/* ret_yhi	-out-	Maximum y coordinate of the bounding box.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/* GOTH__CLRGEOM	geom_id contains no data.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_get_MBR(
				GD_GEOMETRY	geom_id,
				GOTH_REAL	*ret_xlo,
				GOTH_REAL       *ret_ylo,
				GOTH_REAL       *ret_xhi,
				GOTH_REAL       *ret_yhi );
/*----------------------------------------------------------------------*/
/* EXTERN geom_get_type							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the type of a geometry.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to interrogate.	*/
/*									*/
/* ret_geom_type -out-	Returned type, which will be one of the         */
/*			following:				       !*/
/*			_GT_SIMP_POINT				       !*/
/*			_GT_SIMP_LINE				       !*/
/*			_GT_SIMP_AREA				       !*/
/*			_GT_COMP_POINT				       !*/
/*			_GT_COMP_LINE				       !*/
/*			_GT_COMP_AREA				       !*/
/*			_GT_COMPLEX					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_get_type(
				 GD_GEOMETRY	geom_id,
				 GEOMETRY_TYPE	*ret_geom_type);
/*----------------------------------------------------------------------*/
/* EXTERN geom_set_bucket_size						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to allow the size of buckets to be set.			*/
/*									*/
/* This routine may only be called once.				*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* bucket_size	-in-	Number of coordinate pairs to be held in each	*/
/*			bucket.						*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__ERROR		Either a bucket_size less than 1 has been	*/
/*			supplied, or the routine has already been	*/
/*			called. A message on the message stack will	*/
/*			indicate the cause of the error.		*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_set_bucket_size(GOTH_INTEGER	bucket_size);
/*----------------------------------------------------------------------*/
/* EXTERN geom_get_size							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the storage taken up by a geometry	(in bytes).	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to retrieve the 	*/
/*			size of.					*/
/*									*/
/* ret_size	-out-	Size, in bytes, of the geometry defined by	*/
/*			<<geom_id>>.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_get_size(
				 GD_GEOMETRY	geom_id,
				 GOTH_INTEGER	*ret_size);
/*----------------------------------------------------------------------*/
/* EXTERN geom_offset							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to move a geometry by the offset <<(dx,dy)>>.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to offset.		*/
/*									*/
/* dx		-in-	Distance in x to move by.			*/
/*									*/
/* dy		-in-	Distance in y to move by.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_offset(GD_GEOMETRY	geom_id,
			       GOTH_REAL	dx,
			       GOTH_REAL	dy);
/*----------------------------------------------------------------------*/
/* EXTERN geom_rotate							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Function rotates a geometry about the point <<(x_cen, y_cen)>>	*/
/* through an angle <<rot_angle>>. The angle specified must be in 	*/
/* radians. 								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to rotate.		*/
/*									*/
/* x_cen	-in-	The x coordinate of the point to rotate about.	*/
/*									*/
/* y_cen	-in-	The y coordinate of the point to rotate about.	*/
/*									*/
/* rot_angle	-in-	The rotation angle in radians. Note :	       !*/
/*			If positive, the direction of rotation will be 	*/
/*			anticlockwise.				       !*/
/*			If negative, the direction of rotation will be 	*/
/*			clockwise. 					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_rotate(
			       GD_GEOMETRY	geom_id,
			       GOTH_REAL	x_cen,
			       GOTH_REAL	y_cen,
			       GOTH_REAL	rot_angle);
/*----------------------------------------------------------------------*/
/* EXTERN geom_scale							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to scale a geometry about the point <<(x_cen,y_cen)>> by a 	*/
/* specified scaling factor.						*/
/*									*/
/* This routine will set the `allow duplicates' flag if the		*/
/* transformation has resulted in adjacent duplicated points in 	*/
/* linework.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to scale.		*/
/*									*/
/* x_cen	-in-	The x coordinate of the point to scale about.	*/
/*									*/
/* y_cen	-in-	The y coordinate of the point to scale about.	*/
/*									*/
/* scale_factor	-in-	The scale factor.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_scale(
			      GD_GEOMETRY	geom_id,
			      GOTH_REAL		x_cen,
			      GOTH_REAL		y_cen,
			      GOTH_REAL		scale_factor);
/*----------------------------------------------------------------------*/
/* EXTERN geom_scale_and_rotate						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to scale and rotate a geometry about the point 		*/
/* <<(x_cen,y_cen)>> by a specified scaling factor and rotation.	*/
/*									*/
/* This routine will set the `allow duplicates' flag if the		*/
/* transformation has resulted in adjacent duplicated points in 	*/
/* linework.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to scale and 	*/
/*			rotate.						*/
/*									*/
/* x_cen	-in-	The x coordinate of the point to scale and 	*/
/*			rotate about.					*/
/*									*/
/* y_cen	-in-	The y coordinate of the point to scale and 	*/
/*			rotate about.					*/
/*									*/
/* scale_factor	-in-	The scale factor.				*/
/*									*/
/* rot_angle	-in-	The rotation angle in radians. Note :	       !*/
/*			If positive, the direction of rotation will be 	*/
/*			anticlockwise.				       !*/
/*			If negative, the direction of rotation will be 	*/
/*			clockwise. 					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_scale_and_rotate(
					 GD_GEOMETRY	geom_id,
					 GOTH_REAL	x_cen,
					 GOTH_REAL	y_cen,
					 GOTH_REAL	scale_factor,
					 GOTH_REAL	rot_angle);
/*----------------------------------------------------------------------*/
/* EXTERN geom_check_vector_region					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* General geometric routine to check if a vector <<(x0,y0) - (x1,y1)>> */
/* cuts a rectangle <<(xlo,ylo) -> (xhi,yhi)>>.			        */
/* It returns TRUE if the vector cuts (or touches) any side of the	*/
/* rectangle, or if the vector lies entirely within the rectangle.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* x0	-in-	The x coordinate of the first point of the vector.	*/
/*									*/
/* y0	-in-	The y coordinate of the first point of the vector.	*/
/*									*/
/* x1	-in-	The x coordinate of the last point of the vector.	*/
/*									*/
/* y1	-in-	The y coordinate of the last point of the vector.	*/
/*									*/
/* xlo	-in-	The minimum x extent of the rectangle.			*/
/*									*/
/* ylo	-in-	The minimum y extent of the rectangle.			*/
/*		 							*/
/* xhi	-in-	The maximum x extent of the rectangle.			*/
/*									*/
/* yhi	-in-	The maximum y extent of the rectangle.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH_BOOLEAN		TRUE if vector cuts (or touches) any side of  	*/
/*			the rectangle, or if the vector lies entirely	*/
/*			within the rectangle.		     		*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_BOOLEAN geom_check_vector_region(
					     GOTH_REAL	x0,
					     GOTH_REAL	y0,
					     GOTH_REAL	x1,
					     GOTH_REAL	y1,
					     GOTH_REAL	xlo,
					     GOTH_REAL	ylo,
					     GOTH_REAL	xhi,
					     GOTH_REAL	yhi);
/*----------------------------------------------------------------------*/
/* EXTERN geom_scrub							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to produce a "scrubbed" copy of a geometry, that is, a	*/
/* geometry with the original lines replaced by a zig-zag pattern.      */
/* Each vector in the original geometry will be cut by at least one 	*/
/* scrubbing vector, and the scrubbed geometry will contain all the 	*/
/* vertices in the original geometry.					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to "scrub".		*/
/*									*/
/* offset	-in-	Offset distance from the vectors in geom_id to 	*/
/*			the end	points of the scrubbed vectors. This 	*/
/*			defines how wide the zig-zag pattern should be.	*/
/*									*/
/* scrubbed_geom_id -out- Descriptor for the "scrubbed" geometry.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_scrub(
			      GD_GEOMETRY	geom_id,
			      GOTH_REAL		offset,
			      GD_GEOMETRY	*scrubbed_geom_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_get_space_id						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to retrieve the coordinate space that the coordinate data	*/
/* of a geometry is in.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to interrogate.	*/
/*									*/
/* ret_space_id	-out-	Descriptor for the space that the coordinates 	*/
/*			of the geometry are in.				*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_get_space_id(
				     GD_GEOMETRY	geom_id,
				     GD_GEOMETRY	*ret_space_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_overwrite_space_id					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* This function sets the space_id of a geometry.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry having its space	*/
/*			set.						*/
/*									*/
/* space_id	-in-	Descriptor for the space to set in geom_id.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor or the space_id 		*/
/*			descriptor is corrupt or of the incorrect type.	*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_overwrite_space_id(
					   GD_GEOMETRY	geom_id,
					   GD_GEOMETRY	space_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_transform_space						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to transform a geometry (of any type) from its current space */
/* to a new coordinate space. It uses the transformations held in the 	*/
/* database to do this. The current relationship between the current 	*/
/* space and the new space may be held in a space tree in the database.	*/
/*									*/
/* This routine will set the `allow duplicates' flag if the		*/
/* transformation has resulted in adjacent duplicated points in 	*/
/* linework.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	 -in-	Descriptor for the geometry to transform.	*/
/*									*/
/* space_tree_id -in-	Descriptor for the space tree to use with the	*/
/*			transformation (maybe NULL).			*/
/*									*/
/* new_space_id	 -in-	Descriptor for the space the geometry is to be	*/
/*			transformed to.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		One of the geom_id descriptors is corrupt or of	*/
/*			the incorrect type.				*/
/* 									*/
/* SPACELIB		Errors returned by space_transform_point()     !*/
/*			and space_transform_coord_MBR().		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_transform_space(
					GD_GEOMETRY	geom_id,
					GD_SPACE_TREE	space_tree_id,
					GD_SPACE	new_space_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_get_circum_circle					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the centre point and radius of the circle defined 	*/
/* by three points lying on it.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* pt_1_x	-in-	The x coordinate of the first point.		*/
/*									*/
/* pt_1_y	-in-	The y coordinate of the first point.		*/
/*									*/
/* pt_2_x	-in-	The x coordinate of the second point.		*/
/*									*/
/* pt_2_y	-in-	The y coordinate of the second point.		*/
/*									*/
/* pt_3_x	-in-	The x coordinate of the third point.		*/
/*									*/
/* pt_3_y	-in-	The y coordinate of the third point.		*/
/*									*/
/* centre_x	-out-	The x coordinate of the centre of the circle.	*/
/*									*/
/* centre_y	-out-	The y coordinate of the centre of the circle.	*/
/*									*/
/* c_radius	-out-	The radius of the circle.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__COLLINEAR	Points do not define a circle.			*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_get_circum_circle(
					  GOTH_REAL	pt_1_x,
					  GOTH_REAL	pt_1_y,
					  GOTH_REAL	pt_2_x,
					  GOTH_REAL	pt_2_y,
					  GOTH_REAL	pt_3_x,
					  GOTH_REAL	pt_3_y,
					  GOTH_REAL	*centre_x,
					  GOTH_REAL	*centre_y,
					  GOTH_REAL	*c_radius);
/*----------------------------------------------------------------------*/
/* EXTERN geom_get_vector_intersection					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to get the intersection of two vectors (defined by two points*/
/* on each vector).							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* start_1_x	-in-	The x coordinate of the start point of the 	*/
/*			first vector.					*/
/* 									*/
/* start_1_y	-in-	The y coordinate of the start point of the 	*/
/*			first vector.					*/
/* 									*/
/* end_1_x	-in-	The x coordinate of the end point of the 	*/
/*			first vector.					*/
/* 									*/
/* end_1_y	-in-	The y coordinate of the end point of the 	*/
/*			first vector.					*/
/* 									*/
/* start_2_x	-in-	The x coordinate of the start point of the 	*/
/*			second vector.					*/
/* 									*/
/* start_2_y	-in-	The y coordinate of the start point of the 	*/
/*			second vector.					*/
/* 									*/
/* end_2_x	-in-	The x coordinate of the end point of the 	*/
/*			second vector.					*/
/* 									*/
/* end_2_y	-in-	The y coordinate of the end point of the 	*/
/*			second vector.					*/
/*									*/
/* int_x	-out-	The x coordinate of the	point of intersection.	*/
/*									*/
/* int_y	-out-	The y coordinate of the	point of intersection.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__NOINTERSECT	Vectors are parallel.				*/
/*									*/
/* GOTH__VECTZERO	Points defining one of the vectors are 		*/
/*			coincident.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_get_vector_intersection(
						GOTH_REAL	start_1_x,
						GOTH_REAL	start_1_y,
						GOTH_REAL	end_1_x,
						GOTH_REAL	end_1_y,
						GOTH_REAL	start_2_x,
						GOTH_REAL	start_2_y,
						GOTH_REAL	end_2_x,
						GOTH_REAL	end_2_y,
						GOTH_REAL	*int_x,
						GOTH_REAL	*int_y);
/*----------------------------------------------------------------------*/
/* EXTERN geom_set_debug_flags						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to set the status of 5 debug flags for GEOMLIB.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* value1	-in-							*/
/* value2	-in- 							*/
/* value3	-in-							*/
/* value4	-in-							*/
/* value5	-in-							*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		This routine always succeeds.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_set_debug_flags(
					GOTH_BOOLEAN	value_1,
					GOTH_BOOLEAN	value_2,
					GOTH_BOOLEAN	value_3,
					GOTH_BOOLEAN	value_4,
					GOTH_BOOLEAN	value_5);
/*----------------------------------------------------------------------*/
/* EXTERN geom_set_debug_stream						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to set the output stream for debug output from GEOMLIB.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* stream_id	-in-	Descriptor for the required output stream.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_set_debug_stream(
					 GOTH_DESCRIPTOR	stream_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_min_number_for_decomposition				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* When intersecting geometries, (and when creating buffer zones) the	*/
/* geometries are decomposed to parts that lie within rectangular	*/
/* regions, and comparisons are only carried out between parts within	*/
/* the same region.						        */
/*									*/
/* This routine allows the user to set the maximum number of vectors to	*/
/* lie within each region. If there are more, the region will be 	*/
/* farther decomposed. The default is 10 vectors.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* num_of_vectors -in-	Maximum number of vectors within each region.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL	 Normal, successful completion.				*/
/* GOTH__ERROR	 num_of_vectors is less than 2.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_min_number_for_decomposition(
					      GOTH_INTEGER num_of_vectors);
/*----------------------------------------------------------------------*/
/* EXTERN geom_combine							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to combine two geometries to produce a third geometry. The   */
/* following combinations are allowed:					*/
/* @ A combination of 2 areas produces either a simple area or		*/
/* a complex area.						        */
/* @ A combination of a line with an area produces a simple or complex 	*/
/* line.							        */
/* @ A combination of a point with an area produces a simple or complex */
/* point.							        */
/* @ A combination of a line with a line produces a simple or complex 	*/
/* point.							        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_a_id	-in-	Descriptor for the first geometry.		*/
/*									*/
/* geom_b_id	-in-	Descriptor for the second geometry.		*/
/*									*/
/* comb_type	-in-	Combination type. 				*/
/*			Must be one of the following:		       !*/
/*			_GCT_OR					       !*/
/*			_GCT_AND				       !*/
/*			_GCT_XOR				       !*/
/*			_GCT_AND_NOT				       !*/
/*			_GCT_NOT_AND				       	*/
/*									*/
/* geom_comb_id	-out-	Descriptor for the geometry which contains the	*/
/*			combined geometry.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for one of the input geometries	*/
/*			is corrupt or of the incorrect type.		*/
/* 									*/
/* GOTH__CLRGEOM	One of the input geometries contains no data.	*/
/* 									*/
/* GOTH__INVALGEOMCOMBS	The comb_type is not supported for this		*/
/*			selection of input geometries.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_combine(
				GD_GEOMETRY			geom_a_id,
				GD_GEOMETRY			geom_b_id,
				GEOMETRY_COMBINATION_TYPE	comb_type,
				GD_GEOMETRY			*geom_comb_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_area_test_contain					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to test whether the specified area geometry contains the 	*/
/* specified point. It returns the following values in ret_contain:    	*/
/*									*/
/* @  0 if the point lies on the boundary of the specified area. 	*/
/*									*/
/* @  1 if the point is contained within the specified area. 		*/
/*									*/
/* @ -1 if the point lies outside the specified area. 			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the area geometry to be tested.	*/
/*                                                                      */
/* target_x	-in-	The x coordinate of the specified point.	*/
/*                                                                      */
/* target_y	-in-	The y coordinate of the specified point.	*/
/*                                                                      */
/* ret_contain	-out-	The result of the test, should be one of the 	*/
/*			following :				       !*/
/* 			0 if the point lies on the boundary of the	*/
/*			specified area.				       !*/
/*              	1 if the point is contained within the 		*/
/*			specified area.				       !*/
/*                  	-1 if the point lies outside the		*/
/*			specified area.		 			*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__INVALGEOMTYPE	The geometry is not an area type.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_area_test_contain(
					  GD_GEOMETRY	geom_id,
					  GOTH_REAL	target_x,
					  GOTH_REAL	target_y,
					  GOTH_INTEGER	*ret_contain);
/*----------------------------------------------------------------------*/
/* EXTERN geom_test_vector_intersect					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to test if the specified geometry intersects with the	*/
/* vector <<(xlo,ylo) - (xhi,yhi)>>.					*/
/*									*/
/* This routine returns the following results for the different types	*/
/* of geometries:						       !*/
/*									*/
/* @ Points:							       !*/
/* _GIT_NONE - The point does not lie on the vector.          	       !*/
/* _GIT_POINT_TOUCH - The point lies within the vector.            	*/
/*									*/
/* @ Lines:							       !*/
/* _GIT_NONE - There is no intersection.			       !*/
/* _GIT_POINT_TOUCH - An end of the vector lies on a piece of linework.!*/
/* _GIT_LINE_TOUCH  - The vector is coincident with part of the 	*/
/*		      linework of the geometry.			       !*/
/* _GIT_INTERSECT   - The vector crosses the linework of the geometry.	*/
/*									*/
/* @ Areas:							       !*/
/* As for LINES, treating each boundary as a piece of linework.         */
/*                                                                    	*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	 -in-	Descriptor for the geometry to be tested.	*/
/*                                                                      */
/* xlo		 -in-	The x coordinate of the start of the vector.	*/
/*                                                                      */
/* ylo		 -in-	The y coordinate of the start of the vector.	*/ 
/*                                                                      */
/* xhi		 -in-	The x coordinate of the end of the vector.	*/
/*                                                                      */
/* yhi		 -in-	The y coordinate of the end of the vector.	*/
/*                                                                      */
/* ret_intersect -out-	The result of the test, should be one of the 	*/
/*			following :				       !*/
/*			_GIT_NONE				       !*/
/*			_GIT_POINT_TOUCH			       !*/
/*			_GIT_LINE_TOUCH				       !*/
/*			_GIT_INTERSECT				        */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__VECTZERO	The two ends of the vector are coincident.	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_test_vector_intersect(
					      GD_GEOMETRY	geom_id,
					      GOTH_REAL		xlo,
					      GOTH_REAL		ylo,
					      GOTH_REAL		xhi,
					      GOTH_REAL		yhi,
				      GEOMETRY_INTERSECT_TYPE	*ret_intersect);
/*----------------------------------------------------------------------*/
/* EXTERN geom_test_region_intersect					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine that tests if the specified geometry intersects with the	*/
/* rectangular region <<(xlo,ylo) - (xhi,yhi)>>.			*/
/*									*/
/* This routine returns the following results for the different types	*/
/* of geometries:	 						*/
/*									*/
/* @ Points:							       !*/
/* _GIT_NONE - The point does not lie on the region boundary.          !*/
/* _GIT_POINT_TOUCH - The point lies on the region boundary.            */
/*									*/
/* @ Lines:							       !*/
/* _GIT_NONE - There is no intersection with the region boundary.      !*/
/* _GIT_POINT_TOUCH - A vertex of the linework of the geometry 		*/
/*                    lies on the region, but does not lie along it 	*/
/*                    or cross it.				       !*/
/* _GIT_LINE_TOUCH  - Part of the linework of the geometry is		*/
/*                    coincident with part of the region boundary.     !*/
/* _GIT_INTERSECT   - The linework of the geometry crosses the region 	*/
/*		      boundary.					     	*/
/*									*/
/* @ Areas:							       !*/
/* As for LINES, treating each boundary as a piece of linework.         */
/*                                                                      */
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	 -in-	Descriptor for the geometry to be tested.	*/
/*                                                                      */
/* xlo		 -in-	The x coordinate of the lower left corner of 	*/
/*			the region.					*/
/*                                                                      */
/* ylo		 -in-	The y coordinate of the lower left corner of	*/
/*			the region.					*/
/*                                                                      */
/* xhi		 -in-	The x coordinate of the upper right corner of	*/
/*			the region.					*/
/*                                                                      */
/* yhi		 -in-	The y coordinate of the upper right corner of	*/
/*			the region.					*/
/*                                                                      */
/* ret_intersect -out-	The result of the test, should be one of the 	*/
/*			following :				       !*/
/*			_GIT_NONE				       !*/
/*			_GIT_POINT_TOUCH			       !*/
/*			_GIT_LINE_TOUCH				       !*/
/*			_GIT_INTERSECT				        */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__INVALRECT	The lower corner of the rectangle is not less	*/
/*			than the higher corner.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS
   geom_test_region_intersect(
			      GD_GEOMETRY		geom_id,
			      GOTH_REAL			xlo,
			      GOTH_REAL			ylo,
			      GOTH_REAL			xhi,
			      GOTH_REAL			yhi,
			      GEOMETRY_INTERSECT_TYPE	*ret_intersect);
/*----------------------------------------------------------------------*/
/* EXTERN geom_test_geom_intersect					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to test if two geometries intersect.				*/
/*									*/
/* If there is no intersection between the geometries, then this	*/
/* routine will return _GIT_NONE. Otherwise the various combinations	*/
/* of geometry types return:						*/
/*									*/
/* POINT + POINT returns _GIT_POINT_TOUCH if points coincident.        !*/
/* POINT + LINE  returns _GIT_POINT_TOUCH if point lies on line.       !*/
/* POINT + AREA  returns _GIT_POINT_TOUCH if point lies on boundary.   !*/
/* POINT + AREA  returns _GIT_INTERSECT   if point lies within area.    */
/*                                                                      */
/* LINE + LINE   returns _GIT_POINT_TOUCH if vertex of one line lies on */
/*		 other line.		                               !*/
/* LINE + LINE   returns _GIT_LINE_TOUCH  if part of linework is 	*/
/*		 coincident somewhere.                                 !*/
/* LINE + LINE   returns _GIT_INTERSECT   if lines cross one another.  !*/
/* LINE + AREA   returns same as for LINE + LINE, treating area boundary*/
/*               as series of lines.	                                */
/*                                                                      */
/* AREA + AREA   returns same as for lines, comparing each area boundary*/
/*               in first geometry with each area boundary in second.   */
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom1_id	-in-	Descriptor for the first geometry.		*/
/*                                                                      */
/* geom2_id	-in-	Descriptor for the second geometry.		*/
/*                                                                      */
/* ret_intersect -out-	The result of the test, should be one of the 	*/
/*			following :				       !*/
/*			_GIT_NONE				       !*/
/*			_GIT_POINT_TOUCH			       !*/
/*			_GIT_LINE_TOUCH				       !*/
/*			_GIT_INTERSECT				        */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom1_id or the geom2_id descriptor is    	*/
/*			corrupt or of the incorrect type.		*/
/*									*/
/* GOTH__CLRGEOM	One or other geometry contains no data.		*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__INVALGEOMCOMBS	Invalid combination of geometry types for this	*/
/*			operation.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS
   geom_test_geom_intersect(
			    GD_GEOMETRY			geom1_id,
			    GD_GEOMETRY			geom2_id,
			    GEOMETRY_INTERSECT_TYPE	*ret_intersect);
/*----------------------------------------------------------------------*/
/* EXTERN geom_get_extremes						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Function to return the nearest and furthest points on the specified	*/
/* geometry from the specified point.				       	*/
/*									*/
/*@ For POINT geometries the locating point is returned			*/
/*      for both the nearest and farthest point				*/
/*									*/
/*@ For LINE geometries the nearest and farthest point			*/
/*      on the linework is returned. Note that the farthest point is	*/
/*	always on a vertex.						*/
/*									*/
/*@ For AREA geometries the farthest point is the vertex on		*/
/*	the boundary farthest from the locating point. If the point 	*/
/*	lies within the geometry, then the point itself is the nearest	*/
/*	point, otherwise the nearest point is the nearest point on the	*/
/*	boundary from the locating point.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	-in-	Descriptor for the geometry to be used.		*/
/*                                                                      */
/* target_x	-in-	The x coordinate of the specified point.	*/
/*                                                                      */
/* target_y	-in-	The y coordinate of the specified point.	*/
/*                                                                      */
/* ret_near_x	-out-	The x coordinate of the nearest point on the 	*/
/*			geometry.					*/
/*                                                                      */
/* ret_near_y	-out-	The y coordinate of the nearest point on the 	*/
/*			geometry.					*/
/*                                                                      */
/* ret_min_dist	-out-	Minimum distance from the point			*/
/*			to the geometry.				*/
/*                                                                      */
/* ret_far_x	-out-	The x coordinate of the farthest		*/
/*			point on the geometry.				*/
/*                                                                      */
/* ret_far_y	-out-	The y coordinate of the farthest		*/
/*			point on the geometry.				*/
/*                                                                      */
/* ret_max_dist	-out-	Maximum distance from the point			*/
/*			to the geometry.				*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_get_extremes(
				     GD_GEOMETRY	geom_id,
				     GOTH_REAL		target_x,
				     GOTH_REAL		target_y,
				     GOTH_REAL		*ret_near_x,
				     GOTH_REAL		*ret_near_y,
				     GOTH_REAL		*ret_min_dist,
				     GOTH_REAL		*ret_far_x,
				     GOTH_REAL		*ret_far_y,
				     GOTH_REAL		*ret_max_dist);
/*----------------------------------------------------------------------*/
/* EXTERN geom_buffer_create						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to return a buffer zone that surrounds an existing geometry.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/* geom_id	 -in-	Descriptor for the source geometry.		*/
/*                                                                      */
/* offset_dist	 -in-	Distance from source geometry at which to 	*/
/*			generate the buffer zone boundary.		*/
/*                                                                      */
/* vector_length -in-	Length of vectors to use when generating curves	*/
/*			around convex corners in the source geometry.	*/
/*									*/
/* buffer_id	-out-	Descriptor for the generated buffer zone 	*/
/*			geometry.					*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/* GOTH__NOOUTERRING	A geometry has been formed that has no outer	*/
/*			ring. Vector length is probably too long to	*/
/*			adequately describe the circle arc.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_buffer_create(
				      GD_GEOMETRY	geom_id,
				      GOTH_REAL		offset_dist,
				      GOTH_REAL		vector_length,
				      GD_GEOMETRY	*buffer_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_smash_against_geom					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to break a geometry up into its component parts where it	*/
/* crosses another geometry.						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	 -in-	Descriptor for the source geometry.		*/
/*                                                                      */
/* against_geom_id -in-	Descriptor for the geometry to clip to.		*/
/*                                                                      */
/* smashed_geom_id -out- Descriptor for the geometry that		*/
/*			 contains the component parts of geom_id.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for one of the input geometries	*/
/*			is corrupt or of the incorrect type.		*/
/* 									*/
/* GOTH__CLRGEOM	One of the input geometries contains no data.	*/
/* 									*/
/* GOTH__INVALGEOMCOMBS	This routine does not support the types of 	*/
/*			geometry supplied to it.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_smash_against_geom(GD_GEOMETRY	geom_id,
					   GD_GEOMETRY	against_geom_id,
					   GD_GEOMETRY	*smashed_geom_id);
/*----------------------------------------------------------------------*/
/* EXTERN geom_set_displacement_optimisation				*/
/*......................................................................*/
/*..HIDE................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to set one of the local optimisations available for use	*/
/* when displacing a line. These are:					*/
/*									*/
/*@ 0 - no optimisation							*/
/*									*/
/*@ 1 - thought to be correct - but may be over the top. It only 	*/
/*      intersects offset vectors when the bits to be discarded are 	*/
/*      certainly within the buffer zone. Construction line is also	*/
/*      discarded.							*/
/*									*/
/*@ 2 - quite good - has not gone wrong yet. When offset vectors 	*/
/*      intersect, parts are discarded (with their construction lines)	*/
/*									*/
/*@ 3 - fast, but occasionally goes wrong - intersects and discards	*/
/*      offset lines and construction lines - whole OFFSET lines may be	*/
/* 	discarded.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* opt	-in-	option in range 0 - 3. Default 2 at present.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__ERROR		Invalid option passed as argument.		*/
/* 									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_set_displacement_optimisation(
						      GOTH_INTEGER	opt);
/*----------------------------------------------------------------------*/
/* EXTERN geom_decompose_area						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to decompose the simple areas of a geometry until they 	*/
/* consist of less than a specified number of vertices. For this 	*/
/* purpose, the	rings of a geometry are considered to have a closing	*/
/* point at the end that duplicates the opening point, and each 	*/
/* additional ring adds a point to allow for duplicated (invisible) 	*/
/* vectors that will join the rings together.				*/
/* 									*/
/* If only_outer is set to TRUE, then the areas will be decomposed	*/
/* until they contain no inner boundaries.				*/
/* 									*/
/* This is a destructive routine. The original geometry is 		*/
/* irrecoverably $$altered$$. Geometries of type _GT_SIMP_AREA may have	*/
/* their type changed to _GT_COMP_AREA.					*/
/*									*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in/out- Descriptor for the geometry that is to be 	*/
/*			 decomposed.					*/
/*									*/
/* num_pts	-in-	 Maximum number of points allowed in any simple	*/
/*			 geometry.					*/
/*									*/
/* only_outer	-in-	 Decompose until areas are simple rings?	*/
/*									*/
/* altered	-out-	 TRUE if the original geometry has been		*/
/*			 changed in any way.				*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry contains no data.			*/
/*									*/
/* GOTH__NODUPLALLOWED	This operation is not allowed on geometries	*/
/*			that may have duplicated points.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_decompose_area(
				       GD_GEOMETRY	geom_id,
				       GOTH_INTEGER	num_pts,
				       GOTH_BOOLEAN	only_outer,
				       GOTH_BOOLEAN	*altered);
/*----------------------------------------------------------------------*/
/* EXTERN geom_smooth							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to smooth the line work in a geometry, according to a 	*/
/* specified algorithm.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* sm_algorithm -in- The name of the smoothing algorithm (previously	*/
/*		     registered with GEOMLIB with a call to 		*/
/*		     geom_register_smooth_func()).			*/
/*									*/
/* geom_id	-in-  Descriptor for the geometry to smooth.		*/
/*									*/
/* smoothed_id	-out- Descriptor for the smoothed geometry (if the	*/
/*                    smoothing succeeded).				*/
/*									*/
/* num_params	-in-  The number of parameters passed in params.	*/
/*									*/
/* params	-in- +list+An array of parameters to use for smoothing.	*/
/*			  The number and datatype of these parameters	*/
/* 			  depends on the smoothing algorithm being used.*/
/*			  In Lull, the parameters are passed as a list	*/
/* 			  of arguments.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The descriptor for the geometry is corrupt or 	*/
/*			of the incorrect type.				*/
/*									*/
/* GOTH__CLRGEOM	The geometry geom_id contains no data.		*/
/*									*/
/* GOTH__SMOOTHERROR	Smoothing has produced an invalid geometry. No	*/
/*			smoothed geometry has been produced.		*/
/*									*/
/* GOTH__NOVM		No free virtual memory to use.			*/
/*									*/
/* GOTH__WRNGNUMPARAMS	The number of parameters passed is not the same	*/
/* 			as was registered for this algorithm.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_smooth(
			       GOTH_STRING		sm_algorithm,
			       GD_GEOMETRY		geom_id,
			       GD_GEOMETRY		*smoothed_id,
			       GOTH_INTEGER		num_params,
			       GOTH_VALUE		params[]);
/*----------------------------------------------------------------------*/
/* EXTERN geom_register_smooth_func					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to register a smoothing function with GEOMLIB.		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* sm_algorithm	-in-	Name of the smoothing algorithm to register.	*/
/*									*/
/* smooth_func	-in-	The address of the smoothing function to call.	*/
/* 									*/
/* n_params	-in-	The number of parameters that the algorithm	*/
/*			takes.						*/
/* 									*/
/* param_types	-in-	An array of the types of parameters that the	*/
/*			algorithm takes.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__NOVM		No free virtual memory to use.			*/
/*									*/
/* GOTH__SMOOTHFUNCEXISTS The sm_algorithm has already been registered 	*/
/*			  with GEOMLIB.					*/
/*									*/
/* COLNLIB		Error codes returned by COLNLIB.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_register_smooth_func(
					     GOTH_STRING	sm_algorithm,
					     GEOM_SMOOTH_FUNC	smooth_func,
					     GOTH_INTEGER	n_params,
					     GOTH_DATATYPE	param_types[]);
/*----------------------------------------------------------------------*/
/* EXTERN geom_get_smooth_funcs						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to return the set of smoothing functions that have been 	*/
/* registered with GEOMLIB.						*/
/* If no functions have been registered, set_of_funcs will be an empty	*/
/* set.									*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* set_of_funcs	-out-	Descriptor for the set of algorithm names.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* COLNLIB		Error codes returned by COLNLIB.		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_get_smooth_funcs(
					 GD_COLLECTION	*set_of_funcs);
/*----------------------------------------------------------------------*/
/* EXTERN geom_set_X_limits						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to set the maximum values that can be used for XPoint values.*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* xlo	-in-	The minimum x value.					*/
/*									*/
/* ylo	-in-	The minimum y value.					*/
/*									*/
/* xhi	-in-	The maximum x value.					*/
/*									*/
/* yhi	-in-	The maximum y value.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_set_X_limits(
				     GOTH_INTEGER	xlo,
				     GOTH_INTEGER	ylo,
				     GOTH_INTEGER	xhi,
				     GOTH_INTEGER	yhi);
/*----------------------------------------------------------------------*/
/* EXTERN geom_use_X_limits						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to set/unset the flag to use use XPoint limits.		*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* use	-in-	Whether to force Xpoints into range or not.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_use_X_limits(
				     GOTH_BOOLEAN	use);
/*----------------------------------------------------------------------*/
/* EXTERN geom_extract_point_sets					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*  Get all the arrays of points associated with a geometry.		*/
/*  N.B. the point data is returned in a number of arrays. These arrays */
/*  should not be freed by the user as they refer to static memory in   */
/*  the routine. However the contents of the point_set array should be 	*/
/*  freed.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	       	-in-  Descriptor for the geometry to decompose.	*/
/*									*/
/* npoint_sets		-out- The number of points into which the 	*/
/*			      geometry decomposed.			*/
/*									*/
/* npoints_set		-out- An array of integers giving the number of */
/*			      points in each point set. (N.B. closed	*/
/*			      sets do have the last point twice in the	*/
/*			      point_set array, but npoints_set does not */
/*			      count the point twice.			*/
/*			      N.B. This array should not be freed.	*/
/*									*/
/* closed_set		-out- An array of booleans which are TRUE or 	*/
/*			      FALSE according to whether the point set  */
/* 			      closed or open.				*/
/*			      N.B. This array should not be freed.	*/
/*									*/
/* point_set		-out- An array of pointers to an array of reals */
/*			      containing the point coordinates.		*/
/*			      N.B. the contents of the arrays should be */
/*			      freed by the user, but the array holding  */
/*			      the pointers should not be freed.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__ERROR  	Problem encountered, more information on 	*/
/*			message stack.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_extract_point_sets(GD_GEOMETRY  geom_id,
					   GOTH_INTEGER *npoint_sets,
					   GOTH_INTEGER **npoints_set,
					   GOTH_BOOLEAN **closed_set,
					   GOTH_REAL    ***point_set);
/*----------------------------------------------------------------------*/
/* EXTERN geom_store_geometry						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* UES callback to store a simple geometry.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* ues_arg	-in-	Argument passed to UESLIB routines.		*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to be stored. 	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__ERROR  	Problem encountered, more information on 	*/
/*			message stack.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_store_geometry(
				       GD_UES_INTERNAL	ues_arg,
				       GD_GEOMETRY	geom_id );
/*----------------------------------------------------------------------*/
/* EXTERN geom_load_geometry						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* UES callback to load a simple geometry.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* ues_arg	-in-	Argument passed to UESLIB routines.		*/
/*									*/
/* ret_geom_id	-out-	Descriptor for the loaded geometry.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__ERROR  	Problem encountered, more information on 	*/
/*			message stack.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_load_geometry(
				      GD_UES_INTERNAL	ues_arg,
				      GD_GEOMETRY	*ret_geom_id );
/*----------------------------------------------------------------------*/
/* EXTERN geom_transform_affine						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to apply an affine transformation to a geometry.		*/
/*									*/
/* This routine will set the `allow duplicates' flag if the 		*/
/* transformation has resulted in adjacent duplicated points in the 	*/
/* linework.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry to transform.	*/
/*									*/
/* x1_in	-in-	The x coordinate of the first point in the	*/
/*			existing space.					*/
/* y1_in	-in-	The y coordinate of the first point in the	*/
/*			existing space.					*/
/*									*/
/* x2_in	-in-	The x coordinate of the second point in the	*/
/*			existing space.					*/
/* y2_in	-in-	The y coordinate of the second point in the	*/
/*			existing space.					*/
/*									*/
/* x3_in	-in-	The x coordinate of the third point in the	*/
/*			existing space.					*/
/* y3_in	-in-	The y coordinate of the third point in the	*/
/*			existing space.					*/
/*									*/
/* x1_out	-in-	The x coordinate of the first point in the	*/
/*			target space.					*/
/* y1_out	-in-	The y coordinate of the first point in the	*/
/*			target space.					*/
/*									*/
/* x2_out	-in-	The x coordinate of the second point in the	*/
/*			target space.					*/
/* y2_out	-in-	The y coordinate of the second point in the	*/
/*			target space.					*/
/*									*/
/* x3_out	-in-	The x coordinate of the third point in the	*/
/*			target space.					*/
/* y3_out	-in-	The y coordinate of the third point in the	*/
/*			target space.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__BADCONDITION	The input points do not describe a triangle, so	*/
/* 			the transformation is undefined.		*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_transform_affine(
					 GD_GEOMETRY	geom_id,
					 GOTH_REAL	x1_in,
					 GOTH_REAL	y1_in,
					 GOTH_REAL	x2_in,
					 GOTH_REAL	y2_in,
					 GOTH_REAL	x3_in,
					 GOTH_REAL	y3_in,
					 GOTH_REAL	x1_out,
					 GOTH_REAL	y1_out,
					 GOTH_REAL	x2_out,
					 GOTH_REAL	y2_out,
					 GOTH_REAL	x3_out,
					 GOTH_REAL	y3_out);
/*----------------------------------------------------------------------*/
/* EXTERN geom_test_duplicates						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Routine to test whether a geometry is flagged for accepting 		*/
/* duplicates.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to be	*/
/*			tested.						*/
/*									*/
/* ret_allowed	-out-	TRUE if geom_id is flagged to accept duplicates.!*/
/*			FALSE if geom_id is not flagged to accept 	*/
/*			duplicates.					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_test_duplicates(
					GD_GEOMETRY		geom_id,
					GOTH_BOOLEAN	       *ret_allowed);
/*----------------------------------------------------------------------*/
/* EXTERN geom_remove_duplicates					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/* Routine to go through a geometry removing duplicate points, and then	*/
/* clearing the `allow duplicates' flag.				*/
/*									*/
/* This routine will always attempt to return a valid geometry, with   	*/
/* points that are more than the tolerance apart. It does this as	*/
/* follows:								*/
/*									*/
/*@ For open lines it removes duplicates, and if only one point is 	*/
/*  left, returns a short horizontal line.				*/
/*									*/
/*@ For closed lines it does the same as above. If reduced to one point,*/
/*  it produces a small square. If reduced to two points, it produces a */
/*  small rectangle about the line.					*/
/*									*/
/*@ For areas it reduces individual linear parts as for closed lines.   */
/*  If the outer ring becomes degenerate, then a small square is 	*/
/*  generated and all the inner rings are discarded.		        */
/*  Any inner ring that is left that becomes degenerate is discarded.	*/
/*    									*/
/* Under exceptional circumstances (areas with no outer 		*/
/* boundary but one or more inner boundaries) the resulting geometry	*/
/* may be clear.							*/
/*									*/
/* Note that this result differs from that obtained by a call to	*/
/* geom_sl_remove_duplicates().						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* geom_id	-in-	Descriptor for the geometry that is to have	*/
/*			duplicates removed.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/*									*/
/* GOTH__DESC		The geom_id descriptor is corrupt or of	the 	*/
/*			incorrect type.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geom_remove_duplicates(
					     GD_GEOMETRY	geom_id);
/*----------------------------------------------------------------------*/
/* EXTERN geomlib_initialise						*/
/*......................................................................*/
/*..HIDE................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* To initialise the geomlib library. This will normally be called from	*/
/* `geom_init_data_types' when frontend is started			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS geomlib_initialise();
/*----------------------------------------------------------------------*/
/* EXTERN geom_y_topix							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Convert y coordinate from reals to pixels.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*  y_real    -in- the y coordinate					*/
/*  y_lo      -in- the y origin						*/
/*  y_factor  -in- the inverse scale factor				*/
/*  pixel_height -in- the number of pixels in slab height		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_INTEGER geom_y_topix(GOTH_REAL    y_real,
				 GOTH_REAL    y_lo,
				 GOTH_REAL    y_factor,
				 GOTH_INTEGER pixel_height) ;
/*----------------------------------------------------------------------*/
/* EXTERN geom_x_topix							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Convert x coordinate from reals to pixels.				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*  x_real    -in- the x coordinate					*/
/*  x_lo      -in- the x origin						*/
/*  x_factor  -in- the inverse scale factor				*/
/*  pixel_width -in- the number of pixels in slab width			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_INTEGER geom_x_topix(GOTH_REAL    x_real,
				 GOTH_REAL    x_lo,
				 GOTH_REAL    x_factor,
				 GOTH_INTEGER pixel_width) ;

#endif

