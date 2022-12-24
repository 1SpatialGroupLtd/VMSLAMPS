/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 17:48:16.000000000 +0000
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
#ifndef _DIRC_INTRINSICS
#define _DIRC_INTRINSICS

/*>>> EXTERN functions from DIRC.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN dirc_convert_integers						*/
/*......................................................................*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS dirc_convert_integers(GOTH_INTEGER   source_platform,
					 GOTH_INTEGER	dest_platform,
  					 GOTH_INTEGER	*source_ints,
  					 GOTH_INTEGER	*dest_ints,
					 GOTH_INTEGER	num_ints) ;
/*----------------------------------------------------------------------*/
/* EXTERN dirc_convert_integer						*/
/*......................................................................*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS dirc_convert_integer(GOTH_INTEGER   source_platform,
					GOTH_INTEGER   dest_platform,
  					GOTH_INTEGER   source_int,
  					GOTH_INTEGER   *dest_int) ;
/*----------------------------------------------------------------------*/
/* EXTERN dirc_convert_sintegers					*/
/*......................................................................*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS dirc_convert_sintegers(GOTH_INTEGER   source_platform,
					  GOTH_INTEGER	 dest_platform,
  					  short int	 *source_ints,
  					  short int	 *dest_ints,
					  GOTH_INTEGER	 num_ints) ;
/*----------------------------------------------------------------------*/
/* EXTERN dirc_convert_sinteger						*/
/*......................................................................*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS dirc_convert_sinteger(GOTH_INTEGER   source_platform,
					 GOTH_INTEGER   dest_platform,
  					 short int      source_int,
  					 short int      *dest_int) ;
/*----------------------------------------------------------------------*/
/* EXTERN dirc_convert_float 						*/
/*......................................................................*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS dirc_convert_float(GOTH_INTEGER   source_platform,
				      GOTH_INTEGER   dest_platform,
				      unsigned char  *source_float,
				      GOTH_REAL      *dest_real) ;
/*----------------------------------------------------------------------*/
/* EXTERN dirc_convert_real 						*/
/*......................................................................*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS dirc_convert_real(GOTH_INTEGER   source_platform,
				     GOTH_INTEGER   dest_platform,
  				     GOTH_REAL	    source_real,
  				     GOTH_REAL      *dest_real) ;
/*----------------------------------------------------------------------*/
/* EXTERN dirc_convert_reals						*/
/*......................................................................*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS dirc_convert_reals(GOTH_INTEGER   source_platform,
				      GOTH_INTEGER   dest_platform,
  				      GOTH_REAL	     *source_reals,
  				      GOTH_REAL	     *dest_reals,
				      GOTH_INTEGER   num_reals) ;
/*----------------------------------------------------------------------*/
/* EXTERN dirc_convert_real_to_float					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Convert a GOTH_REAL to a 32-bit real (encoded as a stream of bytes)  */
/* for any Gothic platform.  Current implementation is restricted to    */
/* destination platforms which use IEEE floats.			        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS dirc_convert_real_to_float(GOTH_INTEGER	source_plat,
					      GOTH_INTEGER	dest_plat,
					      GOTH_REAL		input_real,
					      unsigned char *	output_float);

#endif
/* $Header: /lslhome/gothic/hdr/dirclib/v1-5a-1/RCS/hdr.dirc_intrinsics.h,v 1.6.1.1 1994/09/29 10:28:40 ianj Exp $								*/
/* 									*/
/* $Log: hdr.dirc_intrinsics.h,v $
 * Revision 1.6.1.1  1994/09/29  10:28:40  ianj
 * Version v1-5a-1 derived from v1-5
 * Fix bug in IEEE to VAX conversion where bits in the output dataset
 * value are not set to zero.
 * WICC 371
 *
 * Revision 1.6  1993/12/22  18:05:34  davida
 * Version v1-5 derived from v1-4
 * WICC 196.
 *
 * Add function dirc_convert_real_to_float for ERDAS.
 *
 * Revision 1.5  1993/08/20  16:40:52  davida
 * Version v1-4 derived from v1-3
 * fix 'dirc_convert_float' to work for all platform combinations
 * see WI/CC 102
 *
 * Revision 1.4  1993/04/14  09:45:31  olivia
 * Version v1-3 derived from v1-2
 * makefile converted to new format
 *
 * Revision 1.3  1993/03/17  22:06:58  jon
 * Version v1-2 derived from v1-1
 * Set the initial value of the output real in dirc_convert_double to be
 * 0.0.
 *
 * Revision 1.2  1993/03/10  19:58:42  jon
 * Version v1-1 derived from v1-0
 * added function 'dirc_convert_float' to handle 4-byte VAX reals
 *
 * Revision 1.1  1992/08/17  09:45:59  davidm
 * Version v1-0 derived from root
 * Get the functionality to enable the conversion of short integers.
 *								*/
