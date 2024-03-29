/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:11:34.000000000 +0000
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
#ifndef _LSR_EXTERNAL_CACHE_DEFNS
#define _LSR_EXTERNAL_CACHE_DEFNS

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    David Miller, 13-May-1994					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		  L S R _ E X T E R N A L _ C A C H E _ D E F N S       */
/*									*/
/* Part of GOTHIC module LSRLIB						*/
/* Version 0.1, David Miller 13-May-1994				*/
/************************************************************************/



typedef GOTH_STATUS (*LSR_CACHE_DELETE_FUNC)(GD_RAC          rac_id,
 					     GOTH_INTEGER    nextern_cache_params,
					     GOTH_DATATYPE   *extern_cache_types,
					     GOTH_VALUE	    *extern_cache_values) ;


typedef GOTH_STATUS (*LSR_CACHE_GET_FUNC)(GD_RAC        rac_id,
					  GOTH_INTEGER	tile1,
					  GOTH_INTEGER	tile2,
					  GOTH_BOOLEAN	read_for_read,
					  GOTH_BOOLEAN	memory_read_only,
					  VOID_P	*buffer,
					  GOTH_BOOLEAN	*tile_unknown,
					  GOTH_INTEGER  nextern_cache_params,
					  GOTH_DATATYPE *extern_cache_types,
					  GOTH_VALUE	*extern_cache_values) ;

typedef GOTH_STATUS (*LSR_CACHE_PUT_FUNC)(GD_RAC        rac_id,
					  GOTH_INTEGER	tile1,
					  GOTH_INTEGER	tile2,
					  VOID_P	buffer,
					  GOTH_INTEGER  nextern_cache_params,
					  GOTH_DATATYPE *extern_cache_types,
					  GOTH_VALUE	*extern_cache_values) ;


typedef GOTH_STATUS (*LSR_CACHE_LOCK_FUNC)(GD_RAC          rac_id,
					   GOTH_INTEGER	   tile1,
					   GOTH_INTEGER    tile2,
					   GOTH_INTEGER	   nextern_cache_params,
					   GOTH_DATATYPE   *extern_cache_types,
					   GOTH_VALUE	   *extern_cache_values) ;

typedef GOTH_STATUS (*LSR_CACHE_UNLOCK_FUNC)(GD_RAC          rac_id,
					     GOTH_INTEGER    tile1,
					     GOTH_INTEGER    tile2,
					     GOTH_INTEGER    nextern_cache_params,
					     GOTH_DATATYPE   *extern_cache_types,
					   GOTH_VALUE	   *extern_cache_values) ;

typedef GOTH_STATUS (*LSR_CACHE_ALTER_FUNC)(GD_RAC          rac_id,
					    GOTH_INTEGER    tile1,
					    GOTH_INTEGER    tile2,
 					    GOTH_INTEGER    nextern_cache_params,
					    GOTH_DATATYPE   *extern_cache_types,
					    GOTH_VALUE	    *extern_cache_values) ;


typedef GOTH_STATUS (*LSR_CACHE_FLUSH_FUNC)(GD_RAC          rac_id,
 					    GOTH_INTEGER    nextern_cache_params,
					    GOTH_DATATYPE   *extern_cache_types,
					    GOTH_VALUE	    *extern_cache_values) ;

typedef GOTH_STATUS (*LSR_CACHE_FREE_FUNC)(GD_RAC          rac_id,
 					    GOTH_INTEGER    nextern_cache_params,
					    GOTH_DATATYPE   *extern_cache_types,
					    GOTH_VALUE	    *extern_cache_values) ;

typedef GOTH_STATUS (*LSR_CACHE_DESTROY_FUNC)(GD_RAC          rac_id,
					      GOTH_INTEGER    nextern_cache_params,
					      GOTH_DATATYPE   *extern_cache_types,
					      GOTH_VALUE	    *extern_cache_values) ;

#endif
/* $Header: /gothic/hdr/rasterlib/v1-20a-4/RCS/hdr.lsr_external_cache_defns.h,v 1.26 1995/03/13 11:44:36 clarke Exp $								*/
/* 									*/
/* $Header: /gothic/hdr/rasterlib/v1-20a-4/RCS/hdr.lsr_external_cache_defns.h,v 1.26 1995/03/13 11:44:36 clarke Exp $								*/
/* 									*/
