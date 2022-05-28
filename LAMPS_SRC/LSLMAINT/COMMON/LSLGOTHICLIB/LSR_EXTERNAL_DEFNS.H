/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 19:11:36.000000000 +0000
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
#ifndef _LSR_EXTERNAL_DEFNS
#define _LSR_EXTERNAL_DEFNS

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    David Miller, 13-May-1994					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		  L S R _ E X T E R N A L _ D E F N S 			*/
/*									*/
/* Part of GOTHIC module LSRLIB						*/
/* Version 0.1, David Miller 13-May-1994				*/
/************************************************************************/


typedef GOTH_STATUS (*LSR_EXTERNAL_ACCESS_FUNC)(GD_RAC         rac_id,
						GOTH_BOOLEAN   *exists,
						GOTH_BOOLEAN   *readable,
						GOTH_BOOLEAN   *writable,
						GOTH_INTEGER   ndata_params,
						GOTH_DATATYPE  *data_types,
						GOTH_VALUE	   *data_params) ;

typedef GOTH_STATUS (*LSR_EXTERNAL_SIZE_FUNC)(GD_RAC           rac_id,
					      GOTH_REAL	       *size,
					      GOTH_INTEGER     ndata_params,
					      GOTH_DATATYPE    *data_types,
					      GOTH_VALUE       *data_params) ;

typedef GOTH_STATUS (*LSR_EXTERNAL_DELETE_FUNC)(GD_RAC         rac_id,
						GOTH_INTEGER   ndata_params,
						GOTH_DATATYPE  *data_types,
						GOTH_VALUE     *data_params) ;


typedef GOTH_STATUS (*LSR_EXTERNAL_FREE_FUNC)(GD_RAC           rac_id,
					      GOTH_INTEGER     ndata_params,
					      GOTH_DATATYPE    *data_types,
					      GOTH_VALUE       *data_params) ;

typedef GOTH_STATUS (*LSR_EXTERNAL_INDEX_FUNC)(GD_RAC          rac_id,
					       GOTH_REAL       low1,
					       GOTH_REAL       low2,
					       GOTH_REAL       high1,
					       GOTH_REAL       high2,
					       GOTH_BOOLEAN    *exists,
					       GOTH_INTEGER    ndata_params,
					       GOTH_DATATYPE   *data_types,
					       GOTH_VALUE      *data_params) ;

typedef GOTH_STATUS (*LSR_EXTERNAL_CLEAR_FUNC)(GD_RAC        rac_id,
				               GOTH_INTEGER  ndata_params,
				               GOTH_DATATYPE *data_types,
				               GOTH_VALUE    *data_params) ;

typedef GOTH_STATUS (*LSR_EXTERNAL_CHACCESS_FUNC)(GD_RAC         rac_id,
						  RAST_LOCK_TYPE access_mode,
						  GOTH_INTEGER   ndata_params,
						  GOTH_DATATYPE  *data_types,
						  GOTH_VALUE     *data_params) ;

typedef GOTH_STATUS (*LSR_EXTERNAL_COPY_FUNC)(GD_RAC         rac_id,
					      GOTH_BOOLEAN   overwrite,
					      GOTH_BOOLEAN   delete,
					      GOTH_INTEGER   ncopy_params,
					      GOTH_DATATYPE  *copy_types,
					      GOTH_VALUE     *copy_params,
					      GOTH_INTEGER   ndata_params,
					      GOTH_DATATYPE  *data_types,
					      GOTH_VALUE     *data_params) ;

typedef GOTH_STATUS (*LSR_EXTERNAL_UNLOCK_FUNC)(GD_RAC         rac_id,
						GOTH_INTEGER   ndata_params,
						GOTH_DATATYPE  *data_types,
						GOTH_VALUE     *data_params) ;

typedef GOTH_STATUS (*LSR_EXTERNAL_PREPARE_FUNC)(GD_RAC         rac_id,
						 GOTH_INTEGER   resource_id,
						 GOTH_INTEGER   *resource_size,
						 GOTH_INTEGER   ndata_params,
						 GOTH_DATATYPE  *data_types,
						 GOTH_VALUE	*data_params) ;
     
typedef GOTH_STATUS (*LSR_EXTERNAL_READ_FUNC)(GD_RAC         rac_id,
					      GOTH_INTEGER   resource_id,
					      GOTH_INTEGER   resource_size,
					      VOID_P         resource_buffer,
					      GOTH_INTEGER   ndata_params,
					      GOTH_DATATYPE  *data_types,
					      GOTH_VALUE     *data_params) ;






/*----------------------------------------------------------------------*/
/* PROTOTYPE LSR_EXTERNAL_SET_VALUE_FUNC				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Prototype for a callback function for setting a named external data	*/
/* value via a RAC.							*/
/*									*/
/* Note, this callback function is registered with a RAC by the		*/
/* function <<lsr_set_external_rac_callbacks()>>.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* rac_id		-in-	Descriptor for the RAC.			*/
/*									*/
/* value_name		-in-	Identifier name for the data value. 	*/
/*				Note, this name must be known to the 	*/
/*				module within which the callback 	*/
/*				function is defined.			*/
/*									*/
/* nextern_params	-in-	Number of external parameters 		*/
/*				registered, along with the callback 	*/
/*				function, within the RAC.		*/
/*									*/
/* extern_types[]	-in-	Array of external parameter datatypes 	*/
/*				registered, along with the callback 	*/
/*				function, within the RAC.		*/
/*									*/
/* extern_values[]	-in-	Array of external parameter values	*/
/*				registered, along with the callback	*/
/*				function, within the RAC.		*/
/*									*/
/* value		-in-	The data value to set.			*/
/*									*/
/* value_type		-in-	Datatype of the data value.		*/
/*									*/
/* is_null		-in-	If TRUE, the data value is undefined.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

typedef GOTH_STATUS (*LSR_EXTERNAL_SET_VALUE_FUNC)(
					   GD_RAC        rac_id,
					   GOTH_STRING   value_name,
					   GOTH_INTEGER  nextern_params,
					   GOTH_DATATYPE extern_types[],
					   GOTH_VALUE    extern_params[],
					   GOTH_VALUE    value,
					   GOTH_DATATYPE value_type,
					   GOTH_BOOLEAN  is_null);



/*----------------------------------------------------------------------*/
/* PROTOTYPE LSR_EXTERNAL_GET_VALUE_FUNC				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Prototype for a callback function for retrieving a named external	*/
/* data value via a RAC.						*/
/*									*/
/* Note, this callback function is registered with a RAC by the		*/
/* function <<lsr_set_external_rac_callbacks()>>.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* rac_id		-in-	Descriptor for the RAC.			*/
/*									*/
/* value_name		-in-	Identifier name for the data value. 	*/
/*				Note, this name must be known to the 	*/
/*				module within which the callback 	*/
/*				function is defined.			*/
/*									*/
/* nextern_params	-in-	Number of external parameters 		*/
/*				registered, along with the callback 	*/
/*				function, within the RAC.		*/
/*									*/
/* extern_types[]	-in-	Array of external parameter datatypes 	*/
/*				registered, along with the callback 	*/
/*				function, within the RAC.		*/
/*									*/
/* extern_values[]	-in-	Array of external parameter values	*/
/*				registered, along with the callback	*/
/*				function, within the RAC.		*/
/*									*/
/* value		-out-	Retrieved data value.			*/
/*									*/
/* value_type		-out-	Datatype of the retrieved value.	*/
/*									*/
/* is_null		-out-	TRUE if the data value is undefined,	*/
/*				FALSE otherwise.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

typedef GOTH_STATUS (*LSR_EXTERNAL_GET_VALUE_FUNC)(
					   GD_RAC         rac_id,
					   GOTH_STRING    value_name,
					   GOTH_INTEGER   nextern_params,
					   GOTH_DATATYPE  extern_types[],
					   GOTH_VALUE     extern_params[],
					   GOTH_VALUE    *value,
					   GOTH_DATATYPE *value_type,
					   GOTH_BOOLEAN  *is_null);
     


#endif
/* $Header: /gothic/hdr/rasterlib/v1-20a-4/RCS/hdr.lsr_external_defns.h,v 1.26 1995/03/13 11:44:43 clarke Exp $								*/
/* 									*/
/* $Header: /gothic/hdr/rasterlib/v1-20a-4/RCS/hdr.lsr_external_defns.h,v 1.26 1995/03/13 11:44:43 clarke Exp $								*/
/* 									*/
