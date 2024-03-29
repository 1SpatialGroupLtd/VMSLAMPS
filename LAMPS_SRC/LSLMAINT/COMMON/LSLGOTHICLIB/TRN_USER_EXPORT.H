/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:19:46.000000000 +0000
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
#ifndef _TRN_USER_EXPORT
#define _TRN_USER_EXPORT
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    David Miller, 29-Mar-1994					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		   T R N _ U S E R _ E X P O R T 			*/
/*									*/
/* Part of GOTHIC module TRNLIB						*/
/* Version 0.1, David Miller 29-Mar-1994				*/
/************************************************************************/

/* Definitions used to compile external subsampling routines 		*/

/*----------------------------------------------------------------------*/
/* TYPE STRUCT TRN_USER_EXTERNAL					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Data structure used to transfer raster processing information into	*/
/* a user defined pixel subsampling callback function.			*/
/*									*/
/*..FIELDS..............................................................*/
/*									*/
/* user_data		- User specified integer value 			*/
/*			  (e.g. enumerated value).			*/
/*									*/
/* in_unknown		- The unknown value for the input data as a 	*/
/*			  double.					*/
/*									*/
/* in_pack_type		- Data packing type for the input data (i.e.	*/
/*			  byte, short int, etc.).			*/
/*									*/
/* in_nx_pixels		- Number of pixels in the horizontal input	*/
/*			  direction.					*/
/*									*/
/* in_ny_pixels		- Number of pixels in the vertical input	*/
/*			  direction.					*/
/*									*/
/* in_scale1		- Horizontal scale of the input pixels.		*/
/*									*/
/* in_scale2		- Vertical scale of the input pixels.		*/
/*									*/
/* in_tl_coord1		- Horizontal position of the centre of the	*/
/*			  first input pixel.				*/
/*									*/
/* in_tl_coord2		- Vertical position of the centre of the	*/
/*			  first input pixel.				*/
/*									*/
/* out_unknown		- The unknown value for the output data as a	*/
/*			  double.					*/
/*									*/
/* out_coord1		- Horizontal position of the centre of the	*/
/*			  output pixel.					*/
/*									*/
/* out_coord2		- Vertical position of the centre of the	*/
/*			  output pixel.					*/
/*									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef struct
{
   long int     user_data;
   double       in_unknown;
   long int     in_pack_type;
   long int     in_nx_pixels;
   long int     in_ny_pixels;
   double       in_scale1;
   double       in_scale2;
   double       in_tlcoord1;
   double       in_tlcoord2;
   double       out_unknown;
   double       out_coord1;
   double       out_coord2;
} TRN_USER_EXTERNAL, *TRN_USER_EXTERNAL_PTR;

/* end-def */



/*----------------------------------------------------------------------*/
/* PROTOTYPE TRN_USER_EXTERNAL_ROUTINE				        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Prototype for externally defined raster subsampling callback		*/
/* functions.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* in_data_array	-in-	Address of the buffer containing the	*/
/*				input data.				*/
/*									*/
/* out_value		-out-	The subsampled output value.		*/
/*									*/
/* external_data	-in-	Address of a data structure holding	*/
/*				auxiliary information about the		*/
/*				subsampling operation.			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* 0		Function was successful.				*/
/* 1		An error has occurred.					*/
/*									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef long int (*TRN_USER_EXTERNAL_ROUTINE)(
					void                *in_data_array,
					double              *output_value,
					TRN_USER_EXTERNAL   *external_data);
     
/* end-def */

#endif
/* $Header: /gothic/hdr/trnlib/v1-8/RCS/hdr.trn_user_export.h,v 1.9 1995/02/21 18:28:02 clarke Exp $								*/
/* 									*/
