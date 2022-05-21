/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1998-06-17 14:09:38.000000000 +0100
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
/************************************************************************/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England    */
/* Author    R.W. Russell    October-1993			        */
/************************************************************************/ 

#module	lites2geom_routines	"17JN98"

/************************************************************************/ 
/*									*/
/*                    Geometry Routines					*/
/*									*/
/* These routines implement certain Gothic geometry handling facilities	*/
/* and make them available to FORTRAN programs in the form of a 	*/
/* shareable image.							*/
/*									*/
/************************************************************************/ 
/* header files for accessing external libraries			*/
#include <math.h>
#include <stddef.h>
#include <stdio.h>

#include "goth_config.h"
#include "goth_datatypes.h"
#include "gothic_status_codes.h"
#include "goth_defns.h"
#include "goth_streams.h"
#include "sch_functions.h"

#include "geom_defns.h"
#include "geom_intrinsics.h"
#include "coln_defns.h"
#include "coln_functions.h"


/* some definitions to ease the interface with the FORTRAN calls	*/

#define BOOLEAN		unsigned int	/* general logical value */
#define NULL		0


/* global variables and definitions					*/

/* coordinates are passed from LAMPS programs as real*4 2 dimensional	*/
/* arrays. The following typdef eases this passing.			*/

typedef	float 	COORD_PAIR[2];		

/* (keep all the global data in a structure - 			     	*/
/* then only need one psect for it)					*/

typedef	struct
{
   /* working storage used while converting features to geometries	*/
   /* and vice versa							*/

   int			num_pts,max_pts;
   int			dimension;
   COORD_PAIR		*pts;
   char			*flags;
   int			current_index;
   GEOM_COORD_PAIR	*point_array;
   GOTH_INTEGER		array_size;

} GLOBAL_DATA;

GLOBAL_DATA	geom_data = { 0,0,0,NULL,NULL,0,NULL,0};


/*----------------------------------------------------------------------*/
/* EXTERN shared_init							*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern void shared_init(
			int	*ret_code)
{
   GOTH_STATUS	status;

   status = shared_initialise();
   if (status != GOTH__NORMAL)
      *ret_code = status;
   else
      *ret_code = 0;

   return;
}

/*----------------------------------------------------------------------*/
/* EXTERN geom_message							*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern void geom_message(
			 int		in_status,
			 int		*ret_code)
{
   GOTH_STATUS	in_st = (GOTH_STATUS)in_status,status;

   *ret_code = 0;

   status = lsr_print_message(in_st);
   if (status != GOTH__NORMAL)
      *ret_code = status;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN start_geometry						*/
/*......................................................................*/
/*									*/
/* Start a new (simple) geometry - initialise the global data           */
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for no virtual memory					*/
/*            -2 for invalid dimension (must be 0, 1 or 2)		*/
/*            >0 Gothic status code					*/
/*									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL START_GEOMETRY(GEOM_PTR,%VAL(DIMENSION),RET_CODE)		*/
/*									*/
/*----------------------------------------------------------------------*/

extern void start_geometry(
			   VOID_P	*geom_ptr,
			   int		dimension,
			   int		*ret_code)
{
   GOTH_STATUS		status;
   GD_GEOMETRY		input_geom;

   input_geom = geom_alloc();
   if (input_geom == NULL)
   {
      *ret_code = -1;
      return;
   }
   
   status = geom_simp_create(input_geom,dimension,NULL);
   if (status != GOTH__NORMAL)
   {
      if (status == GOTH__NOVM)
	 *ret_code = -1;
      else if (status == GOTH__INVALDIM)
	 *ret_code = -2;
      else 
	 *ret_code = status;

      return;
   }
   
   geom_data.dimension = dimension;
   geom_data.num_pts = 0;
   if (geom_data.pts == NULL || geom_data.flags == NULL)
      geom_data.max_pts = 0;

   *geom_ptr = input_geom;
   *ret_code = 0;
   
   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN add_points_to_geometry					*/
/*......................................................................*/
/*									*/
/* To add a buffer of points to the geometry being built		*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for no virtual memory					*/
/*            >0 Gothic status code					*/
/*									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL ADD_PTS_TO_GEOMETRY(%VAL(GEOM_PTR),%VAL(NPTS),XY,FLAGS,RET_CODE)*/
/*									*/
/*----------------------------------------------------------------------*/

extern void add_points_to_geometry(
				   VOID_P	geom_ptr,
				   int		npts,
				   COORD_PAIR	xy[],
				   char		flags[],
				   int		*ret_code)
{
   int	 	i;
   size_t	t;
   GOTH_STATUS	status;
   
   /* for points, just set the coordinate of the point			*/

   /* for lines, just add the coordinates one at a time.		*/

   /* note: check for duplicate points - geomlib's ideas of duplicates	*/
   /* are a bit more restrictive than lites2 (at the momemnt it checks 	*/
   /* against 0.0001)							*/
   
   /* for areas, need to keep copy of all the points, and generate area	*/
   /* when finished							*/
   
   switch (geom_data.dimension)
   {
   case 0:
      status = geom_sp_set_coord(geom_ptr,
				 (GOTH_REAL)xy[0][0],
				 (GOTH_REAL)xy[0][1]);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = status;
	 return;
      }
      break;
      
   case 1:
      for (i = 0; i < npts; i++)
      {
	 status = geom_sl_add_vertex(geom_ptr,
				     _GC_END,
				     0,
				     (GOTH_REAL)xy[i][0],
				     (GOTH_REAL)xy[i][1]);
	 if ((status != GOTH__NORMAL) && (status != GOTH__DUPLICATEDPT))
	 {
	    if (status == GOTH__NOVM)
	       *ret_code = -1;
	    else
	       *ret_code = status;
	    
	    return;
	 }
      }
      break;
      
   case 2:
      i = geom_data.num_pts;
      geom_data.num_pts += npts;

      if (geom_data.num_pts > geom_data.max_pts)
      {
	 t = sizeof(COORD_PAIR);
	 t *= geom_data.num_pts;
	 
	 if (geom_data.pts == NULL)
	    geom_data.pts = malloc(t);
	 else
	    geom_data.pts = realloc(geom_data.pts,t);
	 
	 if (geom_data.pts == NULL)
	 {
	    *ret_code = -1;
	    return;
	 }

	 t = sizeof(char);
	 t *= geom_data.num_pts;

	 if (geom_data.flags == NULL)
	       geom_data.flags =  malloc(t);
	    else
	       geom_data.flags = 
		  realloc(geom_data.flags,t);

	 if (geom_data.flags == NULL)
	 {
	    *ret_code = -1;
	    return;
	 }

	 geom_data.max_pts = geom_data.num_pts;
      }
      
      /* copy the input coordinates into the end of the array		*/

      t = sizeof(COORD_PAIR) * npts;
      memcpy((VOID_P)geom_data.pts[i],
	     (VOID_P)xy,
	     t);

      /* and do the same for the flags					*/


      /* copy the input flags into the end of the array			*/

      t = sizeof(char) * npts;
      memcpy((VOID_P)(&geom_data.flags[i]),
	     (VOID_P)flags,
	     t);

      break;
   }
   
   *ret_code = 0;
   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN complete_geometry						*/
/*......................................................................*/
/*									*/
/* To finish building the current geometry, after all the data has 	*/
/* been passed								*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 failed to generate valid area geometry			*/
/*            -2 no data in geometry					*/
/*            -3 inner boundary self intersects				*/
/*            -4 outer boundary self intersects				*/
/*	      -5 ring intersects with existing one			*/
/*	      -6 wrong inclusion of rings				*/
/*            >0 Gothic status code					*/
/*									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL COMPLETE_GEOMETRY(%VAL(GEOM_PTR),%VAL(CHECK),			*/
/*			  ERROR_XY,RET_CODE)				*/
/*									*/
/*----------------------------------------------------------------------*/

extern void complete_geometry(
			      VOID_P		geom_ptr,
			      BOOLEAN		check,
			      COORD_PAIR	*error_xy,
			      int		*ret_code)
{
   GOTH_STATUS		status;
   GOTH_REAL		x1,y1,x2,y2;
   GOTH_INTEGER		num_points;

   /* for point geometries, nothing to do				*/

   /* for line geometries, check if first and last point are the same,	*/
   /* and if so close the geometry. This is only way that IFF knows	*/
   /* about closure							*/

   /* for area geometries, create area geometry from the input arrays	*/
   
   switch (geom_data.dimension)
   {
   case 0:
      break;
      
   case 1:
      status = geom_sl_get_coord(geom_ptr,_GC_START,0,&x1,&y1);
      if (status != GOTH__NORMAL)
      {
	 if (status == GOTH__CLRGEOM)
	    *ret_code = -2;
	 else
	    *ret_code = status;
	 return;
      }
      status = geom_sl_get_coord(geom_ptr,_GC_END,0,&x2,&y2);
      if (status != GOTH__NORMAL)
      {
	 if (status == GOTH__CLRGEOM)
	    *ret_code = -2;
	 else
	    *ret_code = status;
	 return;
      }

      if (x1 == x2 && y1 == y2)
      {
	 status = geom_sl_count_vertices(geom_ptr,&num_points);
	 if (status != GOTH__NORMAL)
	 {
	    *ret_code = status;
	    return;
	 }
	 
	 /* close ring, if valid ring					*/

	 if (num_points > 3)
	 {
	    status = geom_sl_close_ring(geom_ptr);
	    if (status != GOTH__NORMAL)
	    {
	       *ret_code = status;
	       return;
	    }
	 }

	 /* remove a point to create valid, non self-intersecting line	*/

	 else if (num_points == 3)
	 {
	    status = geom_sl_remove_vertex(geom_ptr,_GC_END,0);
	    if (status != GOTH__NORMAL)
	    {
	       *ret_code = status;
	       return;
	    }
	 }
      }      
      break;
      
   case 2:
      status = read_area_geometry(geom_ptr,
				  check,
				  geom_data.num_pts,
				  geom_data.pts,
				  geom_data.flags,
				  error_xy);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = status;
	 return;
      }
	 
      break;
   }
   
   *ret_code = 0;
   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN get_geometry_type						*/
/*......................................................................*/
/*									*/
/* To return the type of a geometry					*/
/*									*/
/* The type = 0 for a  point geometry					*/
/*          = 1 for a  line  geometry					*/
/*          = 2 for an area geometry					*/
/*									*/
/* A geometry can be simple (representable as a single feature) 	*/
/* or complex (ie represented by several features)			*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for invalid geometry					*/
/*            -2 for complex geometry - lites2geom_routines does not	*/
/*               use complex geometries					*/
/*            >0 Gothic status code					*/
/* 									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL GET_GEOMETRY_TYPE(%VAL(GEOM_PTR),TYPE,NUMBER,RET_CODE)		*/
/*									*/
/*----------------------------------------------------------------------*/

extern void get_geometry_type(
			      VOID_P		geom_ptr,
			      int		*type,
			      int		*number,
			      int		*ret_code)
{
   GOTH_STATUS		status;
   GEOMETRY_TYPE	geom_type,simp_type;

   /* assume success							*/

   *ret_code = 0;

   status = geom_get_type((GD_GEOMETRY)geom_ptr,&geom_type);
   if (status != GOTH__NORMAL)
   {
      *ret_code = ( status == GOTH__DESC ) ? -1 : status ;
      return;
   }
   
   switch (geom_type)
   {
   case _GT_SIMP_POINT:
   case _GT_COMP_POINT:
      simp_type = _GT_SIMP_POINT;
      *type = 0;
      break;

   case _GT_SIMP_LINE:
   case _GT_COMP_LINE:
      simp_type = _GT_SIMP_LINE;
      *type = 1;
      break;

   case _GT_SIMP_AREA:
   case _GT_COMP_AREA:
      simp_type = _GT_SIMP_AREA;
      *type = 2;
      break;

   default:
      *ret_code = -2;
      break;
   }

   status = geom_comp_count_simple((GD_GEOMETRY)geom_ptr,simp_type,number);
   if (status != GOTH__NORMAL)
   {
      *ret_code = ( status == GOTH__DESC ) ? -1 : status ;
      return;
   }

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN get_pts_from_geometry						*/
/*......................................................................*/
/*									*/
/* To return the next array of points from the geometry.		*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for invalid geometry					*/
/*            -2 for complex geometry - lites2geom_routines does not	*/
/*               use complex geometries					*/
/*	      -3 for invalid geometry count				*/
/*            -4 not enough virtual memory				*/
/*            >0 Gothic status code					*/
/*									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL GET_PTS_FROM_GEOMETRY(%VAL(GEOM_PTR),%VAL(GEOM_COUNT),		*/
/*     &                      %VAL(START),%VAL(MAX_PTS),		*/
/*     &                      NPTS,XY,FLAGS,FINISHED,RET_CODE)		*/
/*----------------------------------------------------------------------*/

extern void get_pts_from_geometry(
				  VOID_P	geom_ptr,
				  int		geom_count,
				  BOOLEAN	start,
				  int		max_pts,
				  int		*npts,
				  COORD_PAIR	xy[],
				  char		flags[],
				  BOOLEAN	*finished,
				  int		*ret_code)
{
   GOTH_STATUS		status;
   GD_GEOMETRY		simp_geom;
   GEOMETRY_CONST	where;
   GEOMETRY_TYPE	geom_type;
   int			type,number;
   GOTH_INTEGER		num_pts;
   size_t		t;

   if (start)
   {
      /* get the coordinates into arrays				*/

      get_geometry_type(geom_ptr,&type,&number,ret_code);
      if (*ret_code != 0)
	 return;

      if (geom_count < 1 || geom_count > number)
      {
	 *ret_code = -3;
	 return;
      }
      
      if (type == 0)
	 {
	    where = _GC_POINT;
	    geom_type = _GT_SIMP_POINT;
	 }
      else if (type == 1)
	 {
	    where = _GC_LINE;
	    geom_type = _GT_SIMP_LINE;
	 }
      else
	 {
	    where = _GC_AREA;
	    geom_type = _GT_SIMP_AREA;
	 }
      
      /* get the simple geometry					*/

      status = geom_comp_get_simple((GD_GEOMETRY)geom_ptr,
				    where,
				    geom_count,
				    TRUE,
				    &simp_geom);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = ( status == GOTH__DESC ) ? -1 : status ;
	 return;
      }
      
      status = fill_output_data_structure(simp_geom,geom_type);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = status;
	 return;
      }
      
      status = geom_destroy(simp_geom);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = status;
	 return;
      }
      geom_data.current_index = 0;
   }

   /* number of points left to return					*/

   *npts = geom_data.num_pts - geom_data.current_index;
   *npts = min(*npts,max_pts);

   t = sizeof(COORD_PAIR) * *npts;
   memcpy((VOID_P)xy,
	  (VOID_P)&(geom_data.pts[geom_data.current_index]),
	  t);

   t = sizeof(char) * *npts;
   memcpy((VOID_P)flags,
	  (VOID_P)&(geom_data.flags[geom_data.current_index]),
	  t);

   geom_data.current_index += *npts;
   
   *finished = (geom_data.current_index >= geom_data.num_pts);
   *ret_code = 0;
   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN geometry_cancel						*/
/*......................................................................*/
/*									*/
/* To delete a geometry. The geom_ptr is set to NULL			*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for invalid geometry					*/
/*            >0 Gothic status code					*/
/* 									*/
/*									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL GEOMETRY_CANCEL(GEOM_PTR,RET_CODE)				*/
/*									*/
/*----------------------------------------------------------------------*/

extern void geometry_cancel(
			    VOID_P		*geom_ptr,
			    int			*ret_code)
{
   GOTH_STATUS		status;
   GD_GEOMETRY		geom_id = (GD_GEOMETRY)*geom_ptr;

   status = geom_destroy(geom_id);

   if (status != GOTH__NORMAL)
   {
      if (status == GOTH__DESC)
	 *ret_code = -1;
      else
	 *ret_code = status;
	    return;
   }
   
   *geom_ptr = NULL;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN geometry_copy							*/
/*......................................................................*/
/*									*/
/* To copy one geometry into another					*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for invalid geometry					*/
/*            >0 Gothic status code					*/
/*									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL GEOMETRY_COPY(%VAL(GEOM_1_PTR),GEOM_2_PTR,RET_CODE)		*/
/*									*/
/*----------------------------------------------------------------------*/

extern void geometry_copy(
			  VOID_P		geom_1_ptr,
			  VOID_P		*geom_2_ptr,
			  int			*ret_code)
{
   GOTH_STATUS		status;

   status = geom_copy(geom_1_ptr,
		      geom_2_ptr);

   if (status != GOTH__NORMAL)
   {
      *ret_code = (status == GOTH__DESC) ? -1 : status;
      return;
   }

   *ret_code = 0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN geometry_add							*/
/*......................................................................*/
/*									*/
/* To add the first geometry into the second. The option is given of 	*/
/* copying the data not.						*/
/*									*/
/* The geometries must be of the same type for this operation, the	*/
/* second one being complex. 						*/
/* If the second geometry is NULL, ie has  not been built, then it will */
/* be built with a suitable dimension.					*/
/* If the second geometry is simple, it will be replaced by a complex	*/
/* one of the same dimension						*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for invalid geometry					*/
/*            -2 for geometries not of the same dimension	       	*/
/*            -3 for geometry 1 is not simple                           */
/*            >0 Gothic status code					*/
/* 									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL GEOMETRY_ADD(%VAL(GEOM_1_PTR),GEOM_2_PTR,%VAL(COPY),RET_CODE)	*/
/*									*/
/*----------------------------------------------------------------------*/

extern void geometry_add(
			 VOID_P			geom_1_ptr,
			 VOID_P			*geom_2_ptr,
			 BOOLEAN		copy,
			 int			*ret_code)
{
   GOTH_STATUS		status;
   GOTH_INTEGER		dimension;
   int			type_1,type_2;
   int			simple_1,simple_2;
   GEOMETRY_TYPE	g_type;
   GOTH_BOOLEAN		complex_2;
   GD_GEOMETRY		comp_geom_id,geom_2_id = (GD_GEOMETRY)*geom_2_ptr;

   /* get the type of the first geometry				*/
   
   get_geometry_type((VOID_P)geom_1_ptr,&type_1,&simple_1,ret_code);
   
   if (*ret_code != 0)
      return;

   if (simple_1 != 1)
   {
      *ret_code = -3;
      return;
   }
   
   /* if the second geometry does not exist just copy the first into it	*/
   /* and finish							*/

   if (geom_2_id == NULL)
   {
      (void)geometry_copy(geom_1_ptr,geom_2_ptr,ret_code);
      return;
   }
   else
   {
      /* get the type of the second geometry				*/

      get_geometry_type(geom_2_id,&type_2,&simple_2,ret_code);
      if (*ret_code != 0)
	 return;
      
      if (type_1 != type_2)
      {
	 *ret_code = -2;
	 return;
      }
      
      /* if the second geometry is not complex, create a new one that is*/
      /* and add the second one to it. Then replace the second with the	*/
      /* new one							*/
      
      status = geom_get_type(geom_2_id,&g_type);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = status;
	 return;
      }

      if (g_type != _GT_COMP_POINT && g_type != _GT_COMP_LINE &&
	  g_type != _GT_COMP_AREA)
      {
	 comp_geom_id = geom_2_id;

	 geom_2_id = geom_alloc();
	 if (geom_2_id == NULL)
	 {
	    *ret_code = GOTH__MALLOC;
	    return;
	 }
	 status = geom_comp_create(geom_2_id,type_1,NULL);
	 
	 if (status != GOTH__NORMAL)
	 {
	    *ret_code = status;
	       return;
	 }
	 status = geom_comp_add_simple(geom_2_id,
				       comp_geom_id,
				       FALSE);
	 if (status != GOTH__NORMAL)
	 {
	    *ret_code = status;
	    return;
	 }
	 
	 status = geom_destroy(comp_geom_id);
	 if (status != GOTH__NORMAL)
	 {
	    *ret_code = status;
	    return;
	 }
	 *geom_2_ptr = (VOID_P)geom_2_id;
      }
   }
   
   /* now add the first to the second					*/
   
   status = geom_comp_add_simple(geom_2_id,
				 (GD_GEOMETRY)geom_1_ptr,
				 copy);
   if (status != GOTH__NORMAL)
   {	
      *ret_code = status;
      return;
   }
   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN geometry_buffer						*/
/*......................................................................*/
/*									*/
/* To create a buffer zone around a geometry			       	*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for invalid geometry					*/
/*            -2 for no valid geometry created (probably vector length	*/
/*               too long)						*/
/*            >0 Gothic status code					*/
/*									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL GEOMETRY_BUFFER(%VAL(GEOM_1_PTR),GEOM_2_PTR,%VAL(OFFSET),	*/
/*      &               %VAL(VECTOR_LEN),RET_CODE)			*/
/*									*/
/*----------------------------------------------------------------------*/

extern void geometry_buffer(
			    VOID_P		geom_1_ptr,
			    VOID_P		*geom_2_ptr,
			    float		offset,
			    float		vector_len,
			    int			*ret_code)
{
   GOTH_STATUS		status;
   GOTH_BOOLEAN		has_outer;
   GD_GEOMETRY		buffer_id;
   GOTH_REAL		offset_dist = (GOTH_REAL)offset;
   GOTH_REAL		vector_length = (GOTH_REAL)vector_len;
   GEOMETRY_TYPE	type;

   *geom_2_ptr = NULL;
   buffer_id   = NULL;

   status = geom_buffer_create(geom_1_ptr,
			       offset_dist,
			       vector_length,
			       &buffer_id);
   if (status != GOTH__NORMAL)
   {
      if (status == GOTH__NOOUTERRING)
      {
	 if (buffer_id != NULL)
	 {
	    status = geom_destroy(buffer_id);
	    if (status != GOTH__NORMAL)
	    {
	       *ret_code = (status == GOTH__DESC) ? -1 : status;
	       return;
	    }
	 }
	 sch_clear_message_stack();
	 *ret_code = -2;
	 return;
      }
      else
      {
	 *ret_code = (status == GOTH__DESC) ? -1 : status;
	 return;
      }
   }

   status = geom_get_type(buffer_id,&type);
   if (status != GOTH__NORMAL)
   {
      *ret_code = (status == GOTH__DESC) ? -1 : status;
      return;
   }

   if (type == _GT_SIMP_AREA)
   {
      status = geom_sa_test_outer_ring(buffer_id,&has_outer);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = (status == GOTH__DESC) ? -1 : status;
	 return;
      }
      
      if (!has_outer)
      {
	 status = geom_destroy(buffer_id);
	 if (status != GOTH__NORMAL)
	 {
	    *ret_code = (status == GOTH__DESC) ? -1 : status;
	    return;
	 }
	 *ret_code = -2;
	 return;
      }
   }
   
   *geom_2_ptr = buffer_id;
   *ret_code   = 0;
   
   return;
}

/*----------------------------------------------------------------------*/
/* EXTERN dev_test							*/
/*......................................................................*/
/*									*/
/* geometry testing routine						*/
/*									*/
/*									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL DEV_TEST(GEOM_1_PTR,GEOM_2_PTR,					*/
/*      &        GEOM_3_PTR,%VAL(PARAM),RET_CODE)			*/
/* 									*/
/*----------------------------------------------------------------------*/

extern void dev_test(
		     VOID_P	*geom_1_ptr,
		     VOID_P	*geom_2_ptr,
		     VOID_P	*geom_3_ptr,
		     float	param,
		     int	*ret_code)
{
   GOTH_STATUS	status;
   GOTH_REAL	vect_length = 1414.213;

   *ret_code = 0;

   if (*geom_2_ptr != NULL)
   {
      status = geom_destroy(*geom_2_ptr);
   }
   
   if (*geom_3_ptr != NULL)
   {
      status = geom_destroy(*geom_3_ptr);
   }
   
   status = geom_sl_displace(*geom_1_ptr,
			     (GOTH_REAL)param,
			     vect_length,
			     geom_2_ptr);
   if (status != GOTH__NORMAL)
   {
      sch_stack_message(status);
      sch_print_message_stack();
      goth_printf(goth_stdout,"\n\n");
      return;
   }
   
   status = geom_sl_displace(*geom_1_ptr,
			     -(GOTH_REAL)param,
			     vect_length,
			     geom_3_ptr);
   if (status != GOTH__NORMAL)
   {
      sch_stack_message(status);
      sch_print_message_stack();
      goth_printf(goth_stdout,"\n\n");
      return;
   }

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN geometry_combine						*/
/*......................................................................*/
/*									*/
/* To combine two geometries together					*/
/*									*/
/* comb_type = 1  - OR							*/
/*           = 2  - AND							*/
/*           = 3  - XOR							*/
/*           = 4  - AND_NOT						*/
/*           = 5  - NOT_AND						*/
/*									*/
/* A combination of two areas produces a simple or complex area		*/
/* A combination of a line with an area produces a simple or complex	*/
/* line									*/
/* A combination of a point with an area produces a simple or complex	*/
/* point								*/
/* A combination of two lines produces a simple or complex point	*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for invalid geometry					*/
/*            -2 for invalid comb_type					*/
/*            -3 for one of geometries is clear				*/
/*            -4 for invalid types of geometry for combination		*/
/*            >0 Gothic status code					*/
/*									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL GEOMETRY_COMBINE(%VAL(GEOM_1_PTR),%VAL(GEOM_2_PTR),		*/
/*      &               %VAL(COMB_TYPE),				*/
/*      &               GEOM_COMB_PTR,RET_CODE)				*/
/*									*/
/*----------------------------------------------------------------------*/

extern void geometry_combine(
			     VOID_P	geom_1_ptr,
			     VOID_P	geom_2_ptr,
			     int	comb_type,
			     VOID_P	*geom_comb_ptr,
			     int	*ret_code)
{
   GOTH_STATUS			status;
   GEOMETRY_COMBINATION_TYPE	geom_comb_type;
   GD_GEOMETRY			comb_geom;

   /* convert the combination type to one that GEOMLIB knows about	*/

   switch (comb_type)
   {
   case 1:
      geom_comb_type = _GCT_OR;
      break;
   case 2:
      geom_comb_type = _GCT_AND;
      break;
   case 3:
      geom_comb_type = _GCT_XOR;
      break;
   case 4:
      geom_comb_type = _GCT_AND_NOT;
      break;
   case 5:
      geom_comb_type = _GCT_NOT_AND;
      break;
   default:
      *ret_code = -2;
      return;
   }

   status = geom_combine((GD_GEOMETRY)geom_1_ptr,
			 (GD_GEOMETRY)geom_2_ptr,
			 geom_comb_type,
			 &comb_geom);
   if (status != GOTH__NORMAL)
   {
      if (status ==  GOTH__DESC)
	 *ret_code = -1;
      else if (status == GOTH__CLRGEOM)
	 *ret_code = -3;
      else if ((status == GOTH__INVALGEOMCOMBS) ||
               (status == GOTH__INVALCOMBTYPE))
	 *ret_code = -4;
      else if (status == GOTH__ERROR)
      {
	 sch_clear_message_stack();
	 *geom_comb_ptr = NULL;
	 *ret_code = 0;
      }
      else
	 *ret_code = status;
      
      return;
   }
   
   *geom_comb_ptr = comb_geom;
   *ret_code = 0;
   
   return;
}

/*----------------------------------------------------------------------*/
/* EXTERN test_geometry_clear						*/
/*......................................................................*/
/*									*/
/* To test if there is any data in a geometry				*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for invalid geometry					*/
/*            >0 Gothic status code					*/
/*									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL TEST_GEOMETRY_CLEAR(%VAL(GEOM_PTR),				*/
/*      &                       IS_CLEAR,RET_CODE)			*/
/*									*/
/*----------------------------------------------------------------------*/

extern void test_geometry_clear(
				VOID_P		geom_ptr,
				BOOLEAN		*is_clear,
				int		*ret_code)
{
   GOTH_STATUS	status;

   /* if geom_ptr is NULL, then geometry is clear			*/

   *is_clear = TRUE;

   if (geom_ptr != NULL)
   {
      status = geom_test_clear(geom_ptr,is_clear);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = ( status == GOTH__DESC ) ? -1 : status ;
	 return;
      }
   }
   
   *ret_code = 0;
   return;
}

  

/*----------------------------------------------------------------------*/
/* LOCAL test_point_wrt_area						*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

static void test_point_wrt_area(
				GD_GEOMETRY	geom_a,
				GD_GEOMETRY	geom_b,
				GEOMETRY_TYPE	b_type,
				GOTH_INTEGER	*int_type,
				GOTH_INTEGER	*ret_code)
{
   GOTH_STATUS		status;
   GD_GEOMETRY		geom_c;
   GOTH_REAL		x,y;
   GOTH_INTEGER		i,num_simp,num_in,num_out,num_on;
   GOTH_INTEGER		contain;

   /* for points							*/

   /* get all the points and test each one against A			*/
   /* if some are in, and some are out - intersection		       	*/
   /* if only some out and some on     - outside			*/
   /* if only some in and some on      - inside				*/
   /* if all on 			  - on				*/

   if (b_type == _GT_SIMP_POINT)
   {
      status = geom_sp_get_coord(geom_b,&x,&y);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = status;
	 return;
      }
      
      status = geom_area_test_contain(geom_a,x,y,&contain);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = status;
	 return;
      }

      if (contain == 0)
	 *int_type = 4;
      else if(contain == 1)
	 *int_type = 1;
      else
	 *int_type = 2;

      *ret_code = 0;
      return;
   }

   /* otherwise must be _GT_COMP_POINT					*/

   /* get all the points, and compare them to area			*/
   
   num_in = num_on = num_out = 0;
   
   status = geom_comp_count_simple(geom_b,_GT_SIMP_POINT,&num_simp);
   if (status != GOTH__NORMAL)
   {
      *ret_code = status;
      return;
   }
   
   for (i = 0; i < num_simp; i++)
   {
      status = geom_comp_get_simple(geom_b,_GC_POINT,1,FALSE,&geom_c);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = status;
	 return;
      }
      
      status = geom_sp_get_coord(geom_c,&x,&y);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = status;
	 return;
      }
      
      status = geom_comp_add_simple(geom_b,geom_c,FALSE);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = status;
	 return;
      }
      
      status = geom_destroy(geom_c);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = status;
	 return;
      }
      
      status = geom_area_test_contain(geom_a,x,y,&contain);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = status;
	 return;
      }
      
      switch (contain)
      {
      case -1:
	 num_out++;
	 break;
      case 0:
	 num_on++;
	 break;
      case 1:
	 num_in++;
	 break;
      default:
	 break;
      }
   }	 
	    
   /* now we can return result						*/
   
   if (num_on == num_simp)
      *int_type = 4;
   else if (num_in == 0)
      *int_type = 2;			/* outside			*/
   else if (num_out == 0)
      *int_type = 1;			/* inside			*/
   else
      *int_type = 3;			/* cutting			*/
   
   *ret_code = 0;
   return;
}


/*----------------------------------------------------------------------*/
/* LOCAL get_line_geom_data						*/
/*......................................................................*/
/*									*/
/* to return the area and boundary length of an area geometry		*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for invalid geometry					*/
/*            -2 for not an area geometry				*/
/*            -3 for geometry is clear					*/
/*            >0 Gothic status code					*/
/*									*/
/*----------------------------------------------------------------------*/

static void get_line_geom_data(
			       GD_GEOMETRY	geom_ptr,
			       GOTH_REAL	*length,
			       GOTH_INTEGER	*ret_code)
{
   GOTH_STATUS		status;
   GOTH_REAL		local_area,local_length;
   GOTH_BOOLEAN		is_ring;
   GOTH_INTEGER		num_simp,i;
   GD_GEOMETRY		temp_geom;
   GEOMETRY_TYPE	geom_type;

   status = geom_get_type((GD_GEOMETRY)geom_ptr,&geom_type);
   if (status != GOTH__NORMAL)
   {
      *ret_code = ( status == GOTH__DESC ) ? -1 : status ;
      return;
   }
   
   switch (geom_type)
   {
   case _GT_SIMP_LINE:
      status = geom_sl_get_data(geom_ptr,length,&is_ring,&local_area);
      if (status == GOTH__NORMAL)
	 *ret_code = 0;
      else if (status == GOTH__CLRGEOM)
	 *ret_code = -3;
      else
	 *ret_code = status;
      break;

   case _GT_COMP_LINE:

      *length = 0.0;

      /* get the number of simple geometries			*/

      status = geom_comp_count_simple(geom_ptr,_GT_SIMP_LINE,&num_simp);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = status;
	 return;
      }
   
      for (i = 0; i < num_simp; i++)
      {
	 status = geom_comp_get_simple(geom_ptr,
				       _GC_LINE,
				       1,
				       FALSE,
				       &temp_geom);
	 if (status != GOTH__NORMAL)
	 {
	    *ret_code = status;
	    return;
	 }
      
	 status = geom_sl_get_data(temp_geom,&local_length,
				   &is_ring,&local_area);
	 if (status != GOTH__NORMAL)
	 {
	    *ret_code = status;
	    return;
	 }
      
	 status = geom_comp_add_simple(geom_ptr,temp_geom,FALSE);
	 if (status != GOTH__NORMAL)
	 {
	    *ret_code = status;
	    return;
	 }
      
	 status = geom_destroy(temp_geom);
	 if (status != GOTH__NORMAL)
	 {
	    *ret_code = status;
	    return;
	 }
	 *length += local_length;
      }
      *ret_code = 0;
      break;

   default:
      *ret_code = -2;
      break;
   }
   
   return;
}



/*----------------------------------------------------------------------*/
/* LOCAL get_area_geom_data						*/
/*......................................................................*/
/*									*/
/* to return the area and boundary length of an area geometry		*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for invalid geometry					*/
/*            -2 for not an area geometry				*/
/*            -3 for geometry is clear					*/
/*            >0 Gothic status code					*/
/*									*/
/* Call from FORTRAN:							*/
/* 									*/
/*----------------------------------------------------------------------*/

static void get_area_geom_data(
			       GD_GEOMETRY	geom_ptr,
			       GOTH_REAL	*area,
			       GOTH_REAL	*length,
			       GOTH_INTEGER	*ret_code)
{
   GOTH_STATUS		status;
   GOTH_REAL		local_area,local_length;
   GOTH_INTEGER		num_simp,i;
   GD_GEOMETRY		temp_geom;
   GEOMETRY_TYPE	geom_type;

   status = geom_get_type((GD_GEOMETRY)geom_ptr,&geom_type);
   if (status != GOTH__NORMAL)
   {
      *ret_code = ( status == GOTH__DESC ) ? -1 : status ;
      return;
   }
   
   switch (geom_type)
   {
   case _GT_SIMP_AREA:
      status = geom_sa_get_data(geom_ptr,length,area);
      if (status == GOTH__NORMAL)
	 *ret_code = 0;
      else if (status == GOTH__CLRGEOM)
	 *ret_code = -3;
      else
	 *ret_code = status;
      break;

   case _GT_COMP_AREA:

      *area = *length = 0.0;

      /* get the number of simple geometries			*/

      status = geom_comp_count_simple(geom_ptr,_GT_SIMP_AREA,&num_simp);
      if (status != GOTH__NORMAL)
      {
	 *ret_code = status;
	 return;
      }
   
      for (i = 0; i < num_simp; i++)
      {
	 status = geom_comp_get_simple(geom_ptr,
				       _GC_AREA,
				       1,
				       FALSE,
				       &temp_geom);
	 if (status != GOTH__NORMAL)
	 {
	    *ret_code = status;
	    return;
	 }
      
	 status = geom_sa_get_data(temp_geom,&local_length,&local_area);
	 if (status != GOTH__NORMAL)
	 {
	    *ret_code = status;
	    return;
	 }
      
	 status = geom_comp_add_simple(geom_ptr,temp_geom,FALSE);
	 if (status != GOTH__NORMAL)
	 {
	    *ret_code = status;
	    return;
	 }
      
	 status = geom_destroy(temp_geom);
	 if (status != GOTH__NORMAL)
	 {
	    *ret_code = status;
	    return;
	 }
	 *area += local_area;
	 *length += local_length;
      }
      *ret_code = 0;
      break;

   default:
      *ret_code = -2;
      break;
   }
   
   return;
}



/*----------------------------------------------------------------------*/
/* EXTERN test_geometry_intersect					*/
/*......................................................................*/
/*									*/
/* To test how to geometries lie with respect to one another. The first	*/
/* geometry must be an area						*/
/*									*/
/* int_type = 1 for B lies inside A					*/
/*          = 2 for B lies outside A					*/
/*          = 3 for B intersects with A					*/
/*          = 4 for points of B all lie on boundary of A (B point or	*/
/*		line only)						*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for invalid geometry					*/
/*            -2 for A is not an area					*/
/* 	      -3 for one of geometries is clear				*/
/*            >0 Gothic status code					*/
/*									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL TEST_GEOMETRY_INTERSECT(%VAL(GEOM_1_PTR),%VAL(GEOM_2_PTR),	*/
/*      &                       INT_TYPE,RET_CODE)			*/
/*									*/
/*----------------------------------------------------------------------*/

extern void test_geometry_intersect(
				    VOID_P	geom_a,
				    VOID_P	geom_b,
				    int		*int_type,
				    int		*ret_code)
{
   GOTH_STATUS			status;
   GEOMETRY_INTERSECT_TYPE	ret_intersect;
   GEOMETRY_TYPE		a_type,b_type;
   GOTH_REAL			axlo,aylo,axhi,ayhi;
   GOTH_REAL			bxlo,bylo,bxhi,byhi;
   GD_GEOMETRY			geom_c;
   GOTH_REAL			b_area,c_area;
   GOTH_REAL			b_length,c_length;
   GOTH_BOOLEAN			is_clear;

   /* check that geom_a is an area					*/

   status = geom_get_type(geom_a,&a_type);
   if (status != GOTH__NORMAL)
   {
      *ret_code = ( status == GOTH__DESC ) ? -1 : status ;
      return;
   }
   if (a_type != _GT_SIMP_AREA && a_type != _GT_COMP_AREA)
   {
      *ret_code = -2;
      return;
   }
   
   /* get bounding boxes for each geometry				*/

   status = geom_get_MBR(geom_a,&axlo,&aylo,&axhi,&ayhi);
   if (status != GOTH__NORMAL)
   {
      *ret_code = ( status == GOTH__CLRGEOM ) ? -3 : status ;
      return;
   }

   status = geom_get_MBR(geom_b,&bxlo,&bylo,&bxhi,&byhi);
   if (status != GOTH__NORMAL)
   {
      if (status == GOTH__DESC)
	 *ret_code = -1;
      else if ( status == GOTH__CLRGEOM ) 
	 *ret_code = -3;
      else
	 *ret_code =  status;
      return;
   }

   /* check bounding boxes for no intersection				*/

   if (bxlo > axhi || bylo > ayhi ||
       bxhi < axlo || byhi < aylo)
   {      
      *int_type = 2;
      *ret_code = 0;
      return;
   }
   
   /* What we do now depends on the type of geometry B			*/

   status = geom_get_type(geom_b,&b_type);
   if (status != GOTH__NORMAL)
   {
      *ret_code = ( status == GOTH__DESC ) ? -1 : status ;
      return;
   }

   if (b_type == _GT_SIMP_POINT || b_type == _GT_COMP_POINT)
   {
      test_point_wrt_area(geom_a,geom_b,b_type,int_type,ret_code);
      return;
   }
   
   /* now left with lines and areas - check if linework intersects 	*/
   /* if it does we have a solution					*/

   status = geom_test_geom_intersect(geom_a,geom_b,&ret_intersect);
   if (status != GOTH__NORMAL)
   {
      *ret_code = status;
      return;
   }
   
   /* only have solution if we have a definite intersection		*/

   if (ret_intersect == _GIT_INTERSECT)
   {
      *int_type = 3;
      *ret_code = 0;
      return;
   }
   
   /* greater and greater problems!					*/

   /* AND geom_b with geom_a. If a clear geometry is created, then	*/
   /* geom_b lies outside geom_a. Point/line touching may be a problem	*/
   /* but that is really a problem in geomlib				*/

   status = geom_combine(geom_b,geom_a,_GCT_AND,&geom_c);
   if (status != GOTH__NORMAL)
   {
      *ret_code = status;
      return;
   }

   status = geom_test_clear(geom_c,&is_clear);
   if (status != GOTH__NORMAL)
   {
      *ret_code = status;
      return;
   }

   if (is_clear)
   {
      status = geom_destroy(geom_c);

      *int_type = 2;
      *ret_code = 0;
      return;
   }
   
   if (b_type == _GT_SIMP_AREA || b_type == _GT_COMP_AREA)
   {
      get_area_geom_data(geom_c,&c_area,&c_length,ret_code);
      if (*ret_code  != 0)
	 return;
   }      
   else
   {
      get_line_geom_data(geom_c,&c_length,ret_code);
      if (*ret_code  != 0)
	 return;
   }      

   status = geom_destroy(geom_c);


   /* get area/length of geom_b, and compare it with geom_c		*/

   if (b_type == _GT_SIMP_AREA || b_type == _GT_COMP_AREA)
   {
      get_area_geom_data(geom_b,&b_area,&b_length,ret_code);
      if (*ret_code  != 0)
	 return;
      
      /* if the area of B == area of C , B lies inside A		*/
      
      if (goth_abs(b_area - c_area) < 0.01)
	 *int_type = 1;
      else
	 *int_type = 3;
   }
   else   
   {
      get_line_geom_data(geom_b,&b_length,ret_code);
      if (*ret_code  != 0)
	 return;
      
      /* if the length of B == length of C , B lies inside A		*/
      
      if (goth_abs(b_length - c_length) < 0.01)
	 *int_type = 1;
      else
	 *int_type = 3;
   }

   *ret_code = 0;
   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN test_geometry_intersect_vector				*/
/*......................................................................*/
/*									*/
/* To test if a vector cuts a geometry					*/
/* int_type = 0 for No intersection					*/
/*          = 1 for Point Touch						*/
/*          = 2 for Line  Touch						*/
/*          = 3 for Intersecting line work				*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for invalid geometry					*/
/*            -2 for geometry is clear					*/
/*            >0 Gothic status code					*/
/*									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL TEST_GEOMETRY_INTERSECT_VECTOR(%VAL(GEOM_1_PTR),		*/
/*      &                              %VAL(X1),%VAL(Y1),		*/
/*      &                              %VAL(X2),%VAL(Y2),		*/
/*      &                              INT_TYPE,RET_CODE)		*/
/*									*/
/*----------------------------------------------------------------------*/

extern void test_geometry_intersect_vector(
					   VOID_P	geom_ptr,
					   float	x1,
					   float	y1,
					   float	x2,
					   float	y2,
					   int		*int_type,
					   int		*ret_code)
{
   GOTH_STATUS			status;
   GEOMETRY_INTERSECT_TYPE	ret_intersect;

   status = geom_test_vector_intersect((GD_GEOMETRY)geom_ptr,
				       (GOTH_REAL)x1,
				       (GOTH_REAL)y1,
				       (GOTH_REAL)x2,
				       (GOTH_REAL)y2,
				       &ret_intersect);
   if (status != GOTH__NORMAL)
   {
      if (status ==  GOTH__DESC)
	 *ret_code = -1;
      else if (status == GOTH__CLRGEOM)
	 *ret_code = -2;
      else
	 *ret_code = status;
      
      return;
   }
   
   switch (ret_intersect)
   {
   case _GIT_NONE:
      *int_type = 0;
      break;
   case _GIT_POINT_TOUCH:
      *int_type = 1;
      break;
   case _GIT_LINE_TOUCH:
      *int_type = 2;
      break;
   case _GIT_INTERSECT:
      *int_type = 3;
      break;
   default:
      sch_stack_string("Unknown intersect type %ld",ret_intersect);
      *ret_code = GOTH__ERROR;
      return;
   }
   
   *ret_code = 0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN test_point_in_geometry					*/
/*......................................................................*/
/*									*/
/* To test if point lies within an area geometry			*/
/*									*/
/* ret_contain =  0 for point is on boundary				*/
/*             =  1 for point is within area				*/
/*             = -1 for point is outside area				*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for invalid geometry					*/
/*            -2 for geometry is clear					*/
/*            -3 geometry is not an area				*/
/*            >0 Gothic status code					*/
/*									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL TEST_POINT_IN_GEOMETRY(%VAL(AREA_GEOM_PTR),			*/
/*      &                      %VAL(X1),%VAL(Y1),			*/
/*      &                      RET_CONTAIN,RET_CODE)			*/
/*									*/
/*----------------------------------------------------------------------*/

extern void test_point_in_geometry(
				   VOID_P	area_geom_ptr,
				   float	x,
				   float	y,
				   int		*ret_contain,
				   int		*ret_code)
{
   GOTH_STATUS		status;
   GOTH_INTEGER		contain;

   status = geom_area_test_contain((GD_GEOMETRY)area_geom_ptr,
				   (GOTH_REAL)x,
				   (GOTH_REAL)y,
				   &contain);
   if (status != GOTH__NORMAL)
   {
      if (status ==  GOTH__DESC)
	 *ret_code = -1;
      else if (status == GOTH__CLRGEOM)
	 *ret_code = -2;
      else if (status == GOTH__INVALGEOMTYPE)
	 *ret_code = -3;
      else
	 *ret_code = status;
      
      return;
   }

   *ret_contain = (int)contain;
   *ret_code = 0;
   
   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN get_point_from_geometry					*/
/*......................................................................*/
/*									*/
/* To return a point from a geometry					*/
/*									*/
/* For Point geometries will return a locating point			*/
/* For Line  geometries will return a point on the line work (but not	*/
/*			a vertex)					*/
/* For Area  geometries will return a point that is guaranteed to lie	*/
/*                      within the boundaries of the area		*/
/*									*/
/* ret_code =  0 for success						*/
/*            -1 for invalid geometry					*/
/*            -2 for complex geometry - lites2geom_routines does not	*/
/*               use complex geometries					*/
/*            -3 for clear geometry					*/
/*            >0 Gothic status code					*/
/* 									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL GET_POINT_FROM_GEOMETRY(%VAL(GEOM_PTR),				*/
/*      &                       RET_X,RET_Y,				*/
/*      &                       RET_CODE)				*/
/*									*/
/*----------------------------------------------------------------------*/

extern void get_point_from_geometry(
				    VOID_P	geom_ptr,
				    float	*ret_x,
				    float	*ret_y,
				    int		*ret_code)
{
   GOTH_STATUS		status;
   GEOMETRY_TYPE	geom_type;
   GEOMETRY_CONST	where;
   GD_GEOMETRY		simp_geom;
   GOTH_BOOLEAN		delete = FALSE;
   GOTH_REAL		x,y;

   /* assume success							*/

   *ret_code = 0;

   status = geom_get_type((GD_GEOMETRY)geom_ptr,&geom_type);
   if (status != GOTH__NORMAL)
   {
      *ret_code = ( status == GOTH__DESC ) ? -1 : status ;
      return;
   }
   
   switch (geom_type)
   {
      /* simple geometries can be dealt with directly by geomlib	*/

   case _GT_SIMP_POINT:
   case _GT_SIMP_LINE:
   case _GT_SIMP_AREA:
      simp_geom = (GD_GEOMETRY)geom_ptr;
      break;

   case _GT_COMP_POINT:
   case _GT_COMP_LINE:
   case _GT_COMP_AREA:

      /* complex geometries need a simple geometry extracted. Copy the	*/
      /* data, so as not to upset the original geometry			*/

      switch(geom_type)
      {
      case _GT_COMP_POINT:
	 where = _GC_POINT;
	 break;
      case _GT_COMP_LINE:
	 where = _GC_LINE;
	 break;
      case _GT_COMP_AREA:
	 where = _GC_AREA;
	 break;
      }
      status = geom_comp_get_simple((GD_GEOMETRY)geom_ptr,
				    where,
				    1,
				    TRUE,
				    &simp_geom);
      if (status != GOTH__NORMAL)
      {
	 if (status == GOTH__DESC)
	    *ret_code = -1;
	 else if (status == GOTH__CLRGEOM)
	    *ret_code = -3;
	 else
	    *ret_code = status;
	 return;
      }

      delete = TRUE;		/* need to delete this geometry		*/

      break;

   default:
      *ret_code = -2;
      return;
   }

   status = geom_simp_fetch_point(simp_geom,&x,&y);

   if (delete)
      (void)geom_destroy(simp_geom);

   if (status != GOTH__NORMAL)
   {
      if (status == GOTH__DESC)
	 *ret_code = -1;
      else if (status == GOTH__CLRGEOM)
	 *ret_code = -3;
      else
	 *ret_code = status;
	    return;
   }
   
   /* truncate the doubles to floats					*/

   *ret_x = (float)x;
   *ret_y = (float)y;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN clear_working_space						*/
/*......................................................................*/
/*									*/
/* to free up malloc'ed working space. This routine should be called	*/
/* when an unexpected error occurs, or when finished with geometries	*/
/* 									*/
/* Call from FORTRAN:							*/
/* 									*/
/* CALL CLEAR_WORKING_SPACE						*/
/*									*/
/*----------------------------------------------------------------------*/

extern void clear_working_space()
{
   if (geom_data.pts != NULL)
      free(geom_data.pts);
   if (geom_data.flags != NULL)
      free(geom_data.flags);
   if (geom_data.point_array != NULL)
      free(geom_data.point_array);
   
   geom_data.num_pts =
      geom_data.max_pts =
	 geom_data.dimension =
	    geom_data.current_index =
	       geom_data.array_size = 0;

   geom_data.pts =
      geom_data.flags =
	 geom_data.point_array = NULL;

   return;
}


/*----------------------------------------------------------------------*/
/* Local Routine prototypes						*/
/*----------------------------------------------------------------------*/

/*>>> LOCAL functions from LITES2GEOM_ROUTINES.C <<<*/

static GOTH_STATUS add_ring_to_set(GD_GEOMETRY		*ring_id,
				   GD_COLLECTION	set_of_rings);

static GOTH_STATUS read_next_ring(
				  GD_COLLECTION	set_of_rings,
				  GD_GEOMETRY	from_ring_id,
				  GD_GEOMETRY	*this_ring_id,
				  GOTH_INTEGER	*curr_index,
				  GOTH_INTEGER	top_index,
				  COORD_PAIR	xy[],
				  char		flags[]);

static GOTH_STATUS add_rings_to_geom(
				     GD_GEOMETRY	area_geom_id,
				     GOTH_BOOLEAN	check,
				     GD_COLLECTION	set_of_rings,
				     COORD_PAIR		*error_xy);

static GOTH_STATUS read_area_geometry(GD_GEOMETRY	geom_id,
				      BOOLEAN		check,
				      GOTH_INTEGER	num_input_pts,
				      COORD_PAIR	input_pts[],
				      char		input_flags[],
				      COORD_PAIR	*error_xy);

static GOTH_STATUS fill_output_data_structure(
					      GD_GEOMETRY	geom_id,
					      GEOMETRY_TYPE	type);


/*----------------------------------------------------------------------*/
/* Local Utility Routines						*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/* LOCAL add_ring_to_set						*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS add_ring_to_set(GD_GEOMETRY		*ring_id,
				   GD_COLLECTION	set_of_rings)
{
   GOTH_STATUS			status;
   GOTH_BOOLEAN			is_closed;
   GOTH_REAL			x,y;
   GOTH_VALUE			gv;

   status = geom_sl_test_ring(*ring_id,&is_closed);
   if (status != GOTH__NORMAL)
      return status;
   
   if (!is_closed)
   {
      status = geom_sl_close_ring(*ring_id);
      if (status == GOTH__NOTENOUGHDATA)
      {
         (void)geom_destroy(*ring_id);
         *ring_id = NULL;
         return GOTH__NORMAL;
      }
      if (status != GOTH__NORMAL)
	 return status;
   }
   
   gv.descriptor = *ring_id;
   status = coln_add_element_to_set(set_of_rings,gv);
   if (status != GOTH__NORMAL)
      return status;

   *ring_id = NULL;
   
   return GOTH__NORMAL;
}



/*----------------------------------------------------------------------*/
/* LOCAL read_next_ring							*/
/*......................................................................*/
/*									*/
/* This routine reads arrays of coordinates and flags, and adds any	*/
/* rings it finds to the set of rings					*/
/*									*/
/* It makes certain assumptions about the feature:			*/
/*	 Invisible moves imply a jump to another ring			*/
/*									*/
/* NOTE: If the data does not form a `proper' geometry, the routine will*/
/*       fail.								*/
/*									*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS read_next_ring(
				  GD_COLLECTION	set_of_rings,
				  GD_GEOMETRY	from_ring_id,
				  GD_GEOMETRY	*this_ring_id,
				  GOTH_INTEGER	*curr_index,
				  GOTH_INTEGER	top_index,
				  COORD_PAIR	xy[],
				  char		flags[])
{
   GOTH_STATUS	status;
   GD_GEOMETRY	ring_id = *this_ring_id,empty_ring = NULL;
   BOOLEAN	ok;
   
   while (*curr_index <= top_index)
   {
      if (flags[*curr_index] == 0)
      {
	 if (ring_id == NULL)
	 {
	    ring_id = geom_alloc();
	    status = geom_simp_create(ring_id,1,NULL);
	    if (status != GOTH__NORMAL)
	       return status;
	 }
	 else
	 {
	    /* are we returning to where we came from (in which case we	*/
	    /* have finished this ring and can output it) or are we 	*/
	    /* going somewhere new (in which case we recurse)		*/
	    /* We find out by adding this point to the geometry that we	*/
	    /* have come from - if it is a duplicated point, then we	*/
	    /* came from there						*/
	    
	    if (from_ring_id != NULL)
	    {
	       status = geom_sl_add_vertex(from_ring_id,
					   _GC_END,
					   0,
					   (double)xy[*curr_index][0],
					   (double)xy[*curr_index][1]);
	       if (status == GOTH__DUPLICATEDPT)
	       {
		  status = add_ring_to_set(&ring_id,
					   set_of_rings);
		  *this_ring_id = NULL;
		  
		  return status;
	       }
	       else
	       {
		  if (status != GOTH__NORMAL)
		     return status;
		  
		  status = geom_sl_remove_vertex(from_ring_id,_GC_END,0);
		  if (status != GOTH__NORMAL)
		     return status;
	       }
	    }
	    
	    /* recurse							*/
	    
	    status = read_next_ring(set_of_rings,
				    ring_id,
				    &empty_ring,
				    curr_index,
				    top_index,
				    xy,
				    flags);
	    
	    if (empty_ring != NULL)	/* this should not happen	*/
	    {
	       (void)geom_destroy(empty_ring);
	       empty_ring = NULL;
	    }
	    
	    if (status != GOTH__NORMAL)
	       return status;
	 }
      }
      
      /* add this point to the current ring				*/
      
      status = geom_sl_add_vertex(ring_id,
				  _GC_END,
				  0,
				  (double)xy[*curr_index][0],
				  (double)xy[*curr_index][1]);
      if (status != GOTH__DUPLICATEDPT && status != GOTH__NORMAL)
	 return status;
      
      (*curr_index)++;
   }
   
   /* add the last ring to the area					*/
   
   status = add_ring_to_set(&ring_id,
			    set_of_rings);
   *this_ring_id = NULL;
   
   return status;
}


/*----------------------------------------------------------------------*/
/* LOCAL add_rings_to_geom						*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS add_rings_to_geom(
				     GD_GEOMETRY	area_geom_id,
				     GOTH_BOOLEAN	check,
				     GD_COLLECTION	set_of_rings,
				     COORD_PAIR		*error_xy)
{
   GD_GEOMETRY			ring_id = NULL;
   GOTH_REAL			x,y,area,length,biggest_area = -1.0;
   GOTH_INTEGER			i,num_rings;
   GOTH_STATUS			status,ret_status = GOTH__NORMAL;
   GOTH_VALUE			value,count;
   GOTH_BOOLEAN			is_ring,had_error = FALSE;
   GEOMETRY_INTERSECT_TYPE	ret_intersect;
   
   status = coln_number_of_elements(set_of_rings,&num_rings);
   if (status != GOTH__NORMAL)
      return status;
   
   /* find the largest ring						*/
   
   for (count.integer = 1; count.integer <= num_rings; count.integer++)
   {
      status = coln_get_value_of_element(set_of_rings,
					 CPT_POSITION,
					 count,
					 &value);
      if (status != GOTH__NORMAL)
	 return status;
      
      status = geom_sl_get_data(value.descriptor,&length,&is_ring,&area);
      if (status != GOTH__NORMAL)
	 return status;
      
      if (area < 0.0)
	 area = -area;
      
      if (area > biggest_area)
      {
	 biggest_area = area;
	 ring_id = value.descriptor;
      }
   }      
   
   if (ring_id == NULL)
      return GOTH__NORMAL;
   
   /* check to see if there is a self intersection			*/
   /* allow point touch in outer ring					*/
	   
   if (check)
   {
      status = geom_sl_test_self_intersect(ring_id,&ret_intersect);
      if (status != GOTH__NORMAL)
	 return status;
      
      if ((ret_intersect != _GIT_NONE) && (ret_intersect != _GIT_POINT_TOUCH))
      {
	 status = geom_simp_fetch_point(ring_id,&x,&y);
	 if (status != GOTH__NORMAL)
	    return status;
	 
	 (*error_xy)[0] = x;
	 (*error_xy)[1] = y;
	 had_error = TRUE;
	 ret_status = -4;
      }
   }
   
   /* so add the geometry with the biggest area as the outer ring, and	*/
   /* remove it from the set of rings					*/
   
   if (!had_error)
   {
      status = geom_sa_add_outer_ring(area_geom_id,
				      ring_id,
				      FALSE,
				      check,
				      TRUE);
      if (status != GOTH__NORMAL)
	 return status;
   }
   
   status = geom_destroy(ring_id);
   if (status != GOTH__NORMAL)
      return status;

   value.descriptor = ring_id;
   status = coln_remove_element_from_set(set_of_rings,value);
   if (status != GOTH__NORMAL)
      return status;

   /* now add all the other rings in the set, as inner rings		*/

   status = coln_number_of_elements(set_of_rings,&num_rings);
   if (status != GOTH__NORMAL)
      return status;

   for (count.integer = 1; count.integer <= num_rings; count.integer++)
   {
      status = coln_get_value_of_element(set_of_rings,
					 CPT_POSITION,
					 count,
					 &value);
      if (status != GOTH__NORMAL)
	 return status;
      
      ring_id = value.descriptor;

      /* check to see if there is a self intersection			*/

      if (!had_error)
      {
	 if (check)
	 {
	    status = geom_sl_test_self_intersect(ring_id,&ret_intersect);
	    if (status != GOTH__NORMAL)
	       return status;

	    /* allow point touch on inner rings				*/
	    
	    if ((ret_intersect != _GIT_NONE) && 
		(ret_intersect != _GIT_POINT_TOUCH))
	    {
	       status = geom_simp_fetch_point(ring_id,&x,&y);
	       if (status != GOTH__NORMAL)
		  return status;
	       
	       (*error_xy)[0] = x;
	       (*error_xy)[1] = y;
	       had_error = TRUE;
	       ret_status = -3;
	    }
	 }
      }      

      if (!had_error)
      {
	 status = geom_sa_add_inner_ring(area_geom_id,
					 ring_id,
					 FALSE,
					 check,
					 TRUE);
      
	 if (status != GOTH__NORMAL)
	 {
	    if (status == GOTH__RINGINTERSECT)
	    {
	       had_error = TRUE;
	       ret_status = -5;
	    }
	    else if (status == GOTH__WRNGINCLUSION)
	    {
	       had_error = TRUE;
	       ret_status = -6;
	    }	 
	    else
	       return status;
	 }      
      }
      (void)geom_destroy(ring_id);
   }   
   return ret_status;
}


/*----------------------------------------------------------------------*/
/* LOCAL read_area_geometry						*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS read_area_geometry(GD_GEOMETRY	geom_id,
				      BOOLEAN		check,
				      GOTH_INTEGER	num_input_pts,
				      COORD_PAIR	input_pts[],
				      char		input_flags[],
				      COORD_PAIR	*error_xy)
{
   GD_GEOMETRY		dumm_geom = NULL;
   GOTH_INTEGER		n_pts;
   GD_COLLECTION 	set_of_rings;
   GOTH_STATUS		status,ret_status;

   status = coln_build_set(&set_of_rings,DT_DESCRIPTOR,DDT_GEOMETRY);
   if (status != GOTH__NORMAL)
      return status;

   n_pts = 0;
   status = read_next_ring(set_of_rings,
			   NULL,
			   &dumm_geom,
			   &n_pts,
			   num_input_pts - 1,
			   input_pts,
			   input_flags);
   if (status != GOTH__NORMAL)
   {
      (void)coln_destroy_collection(set_of_rings);
      return status;
   }
   
   ret_status = add_rings_to_geom(geom_id,check,set_of_rings,error_xy);
     
   status = coln_destroy_collection(set_of_rings);
   if (status != GOTH__NORMAL)
      return status;
      
   if (dumm_geom != NULL)
   {
      status = geom_destroy(dumm_geom);
      dumm_geom = NULL;
   }
   
   return ret_status;
}


/*----------------------------------------------------------------------*/
/* LOCAL fill_output_data_structure					*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

static GOTH_STATUS fill_output_data_structure(
					      GD_GEOMETRY	geom_id,
					      GEOMETRY_TYPE	type)
{
   GOTH_STATUS		status;
   GOTH_INTEGER		num_pts,npts,num_inner,i,j,index;
   GOTH_BOOLEAN		is_closed;
   GEOM_COORD_PAIR	last_pt,last_but_one_pt;
   size_t		t;
   GD_GEOMETRY		ring_id;

   /* get the number of points to return				*/

   switch (type)
   {
   case _GT_SIMP_POINT:
      num_pts = 1;
      break;
   case _GT_SIMP_LINE:
      status = geom_sl_count_vertices(geom_id,&num_pts);
      if (status != GOTH__NORMAL)
	 return status;
      status = geom_sl_test_ring(geom_id,&is_closed);
      if (status != GOTH__NORMAL)
	 return status;
      if (is_closed)
	 num_pts++;
      break;
   case _GT_SIMP_AREA:
      status = geom_sa_count_vertices(geom_id,_GC_OUTER,0,&num_pts);
      if (status != GOTH__NORMAL)
	 return status;
      
      num_pts++;	/* plus one for ring			*/

      status = geom_sa_count_inner_ring(geom_id,&num_inner);
      if (status != GOTH__NORMAL)
	 return status;

      /* each inner ring add number of points in line, + 2 	*/
      /* (1 for ring, and one for invisible move)		*/

      for (i = 1; i <= num_inner; i++)
      {
	 status = geom_sa_count_vertices(geom_id,_GC_INNER,i,&npts);
	 if (status != GOTH__NORMAL)
	    return status;
	 
	 num_pts = num_pts + npts + 2;
      }
      break;
   }

   /* get the space for the xy arrays and the flags		*/

   if (num_pts > geom_data.max_pts)
   {
      t = sizeof(COORD_PAIR);
      t *= num_pts;
      
      if (geom_data.pts == NULL)
	 geom_data.pts = malloc(t);
      else
	 geom_data.pts = realloc(geom_data.pts,t);
      
      if (geom_data.pts == NULL)
	 return -4;
      
      t = sizeof(char);
      t *= num_pts;
      
      if (geom_data.flags == NULL)
	 geom_data.flags =  malloc(t);
      else
	 geom_data.flags =  realloc(geom_data.flags,t);
      
      if (geom_data.flags == NULL)
	 return -4;
      
      geom_data.max_pts = num_pts;
   }
   
   geom_data.num_pts = num_pts;

   /* now fill in the requisite number of points			*/

   switch (type)
   {
   case _GT_SIMP_POINT:
      status = geom_sp_get_coord(geom_id,&last_pt[0],&last_pt[1]);
      if (status != GOTH__NORMAL)
	 return GOTH__NORMAL;
      geom_data.pts[0][0] = last_pt[0];
      geom_data.pts[0][1] = last_pt[1];
      geom_data.flags[0] = 0;
      break;

   case _GT_SIMP_LINE:

      /* get all the coordinates from the line			*/

      status = geom_sl_get_array(geom_id,
				 &(geom_data.array_size),
				 &(geom_data.point_array),
				 &npts);
      if (status != GOTH__NORMAL)
      {
	 if (status == GOTH__NOVM)
	    return -4;
	 else
	    return status;
      }
      
      for (i = 0; i < npts; i++)
      {
	 geom_data.pts[i][0] = (float)geom_data.point_array[i][0];
	 geom_data.pts[i][1] = (float)geom_data.point_array[i][1];
	 if (i == 0)
	    geom_data.flags[i] = 0;
	 else
	    geom_data.flags[i] = 1;
      }
      break;

   case _GT_SIMP_AREA:

      /* get the points for the outer ring				*/

      status = geom_sa_get_ring(geom_id,_GC_OUTER,1,FALSE,&ring_id);
      if (status != GOTH__NORMAL)
	 return status;

      status = geom_sl_get_array(ring_id,
				 &(geom_data.array_size),
				 &(geom_data.point_array),
				 &npts);
      if (status != GOTH__NORMAL)
      {
	 if (status == GOTH__NOVM)
	    return -4;
	 else
	    return status;
      }

      status = geom_sa_add_outer_ring(geom_id,ring_id,FALSE,FALSE,FALSE);
      if (status != GOTH__NORMAL)
	 return status;

      status = geom_destroy(ring_id);
      if (status != GOTH__NORMAL)
	 return status;

      /* remember the last and second last point			*/

      last_pt[0] = geom_data.point_array[npts-1][0];
      last_pt[1] = geom_data.point_array[npts-1][1];
      last_but_one_pt[0] = geom_data.point_array[npts-2][0];
      last_but_one_pt[1] = geom_data.point_array[npts-2][1];
      
      /* add all but last point to our arrays				*/

      for (i = 0, index = 0; i < (npts - 1); i++, index++)
      {
	 geom_data.pts[index][0] = (float)geom_data.point_array[i][0];
	 geom_data.pts[index][1] = (float)geom_data.point_array[i][1];
	 if (i == 0)
	    geom_data.flags[index] = 0;
	 else
	    geom_data.flags[index] = 1;
      }	 

      /* now add all the inner rings, starting with a invisible move	*/
      /* to the first point, and then an invisible move to the last but	*/
      /* one point							*/

      for (j = 0; j < num_inner; j++)
      {
	 status = geom_sa_get_ring(geom_id,_GC_INNER,1,FALSE,&ring_id);
	 if (status != GOTH__NORMAL)
	    return status;

	 status = geom_sl_get_array(ring_id,
				    &(geom_data.array_size),
				    &(geom_data.point_array),
				    &npts);
	 if (status != GOTH__NORMAL)
	 {
	    if (status == GOTH__NOVM)
	       return -4;
	    else
	       return status;
	 }

	 status = geom_sa_add_inner_ring(geom_id,ring_id,FALSE,FALSE,FALSE);
	 if (status != GOTH__NORMAL)
	    return status;

	 status = geom_destroy(ring_id);
	 if (status != GOTH__NORMAL)
	    return status;
      
	 /* add points to our arrays					*/

	 for (i = 0; i < npts; i++, index++)
	 {
	    geom_data.pts[index][0] = (float)geom_data.point_array[i][0];
	    geom_data.pts[index][1] = (float)geom_data.point_array[i][1];
	    if (i == 0)
	       geom_data.flags[index] = 0;
	    else
	       geom_data.flags[index] = 1;
	 }	 

	 /* add invisible move to the last point but one	     	*/

	 geom_data.pts[index][0] = (float)last_but_one_pt[0];
	 geom_data.pts[index][1] = (float)last_but_one_pt[1];
	 geom_data.flags[index] = 0;
	 index++;
      }
      
      /* add a visible move to the last point				*/

      geom_data.pts[index][0] = (float)last_pt[0];
      geom_data.pts[index][1] = (float)last_pt[1];
      geom_data.flags[index] = 1;
      
      break;
   }
   
   return GOTH__NORMAL;
}

