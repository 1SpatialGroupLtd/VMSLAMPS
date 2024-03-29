/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 17:46:56.000000000 +0000
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
#ifndef _COMPRESS_INTRINSICS
#define _COMPRESS_INTRINSICS

/*>>> EXTERN functions from COMPRESS.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN compress_set_callback						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Register a compression algorithm with the compression table		*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* scheme_name -in-  a name identifier for the scheme			*/
/* comp_fn     -in-  the function to do the compression			*/
/* decomp_fn   -in-  the function to do the decompression		*/
/* nvalues     -in-  the numebr of parameters for the scheme		*/
/* types       -in-  the types of those parameters			*/
/* scheme_id   -out- the generated id of the scheme			*/   
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__MALLOC if not enough memory					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  compress_set_callback(GOTH_STRING	      scheme_name,
					  COMPRESS_COMP_FN    comp_fn,
					  COMPRESS_DECOMP_FN  decomp_fn,
					  GOTH_INTEGER	      nvalues,
					  GOTH_DATATYPE	      *types,
					  GOTH_ID	      *scheme_id) ;
/*----------------------------------------------------------------------*/
/* EXTERN compress_get_callback						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Get details of a registered compression algorithm 			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* scheme_name -in-  a name identifier for the scheme			*/
/* comp_fn     -out-  the function to do the compression		*/
/* decomp_fn   -out-  the function to do the decompression		*/
/* nvalues     -out-  the numebr of parameters for the scheme		*/
/* types       -out-  the types of those parameters			*/
/*		      N.B. This array should be freed by caller.	*/
/* scheme_id   -out- the generated id of the scheme			*/   
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__MALLOC if not enough memory					*/
/*  GOTH__NOSUCHCOMPSCHEME if scheme name is not registered		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  compress_get_callback(GOTH_STRING	      scheme_name,
					  COMPRESS_COMP_FN    *comp_fn,
					  COMPRESS_DECOMP_FN  *decomp_fn,
					  GOTH_INTEGER	      *nvalues,
					  GOTH_DATATYPE	      **types,
					  GOTH_ID	      *scheme_id) ;
/*----------------------------------------------------------------------*/
/* EXTERN compress_get_scheme_id					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Get the identifier of a named compression scheme			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* scheme_name -in- the name of the compression scheme			*/
/* scheme_id   -out- the identifier of the compression scheme		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__NOSUCHCOMPSCHEME if scheme name is not registered		*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS compress_get_scheme_id(GOTH_STRING	scheme_name,
					  GOTH_ID 	*scheme_id) ;
/*----------------------------------------------------------------------*/
/* EXTERN compress_get_scheme_name					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Get the scheme name of a compression algorithm from an identifier.	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* scheme_id   -in- the identifier of the compression scheme		*/
/* scheme_name -out- the name of the compression scheme			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__NOSUCHCOMPSCHEME if scheme identifier is not registered	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS compress_get_scheme_name(GOTH_ID 	scheme_id,
					  GOTH_STRING	*scheme_name)
					  ;
/*----------------------------------------------------------------------*/
/* EXTERN compress_comp_buffer						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Compress a buffer of data according to the specified scheme and      */
/* values.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* scheme_id -in- the identifier of the compression scheme to use 	*/
/* decomp_data -in- buffer containing the decompressed data.		*/
/* decomp_data_size -in- the byte size of the decompressed data.	*/
/* allow_quick_abort -in- stop the compresion algorithm if the data     */
/*			  compressed is getting larger than the 	*/
/*			  compressed data.				*/
/* allow_realloc	-in- TRUE if the output buffer can be realloced */
/* values		-in- compression scheme dependent values	*/
/* comp_data		-in/out- the compressed data			*/
/* comp_data_size       -in/out- the byte size of the data buffer	*/
/* used_comp_data_size  -in- the number of bytes used in the buffer     */
/*			     to hold the compressed data.		*/
/* done_quick_abort     -out- TRUE if a quick abort has been done.	*/
/* has_compressed       -out- TRUE if data has actually compressed, that*/
/*			      is less output data than input data.	*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__NOSUCHCOMPSCHEME if scheme identifier is not registered	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS compress_comp_buffer(GOTH_ID 	scheme_id,
					VOID_P		decomp_data,
					GOTH_INTEGER	decomp_data_size,
					GOTH_BOOLEAN	allow_quick_abort,
					GOTH_BOOLEAN	allow_realloc,
					GOTH_VALUE	*values,
					VOID_P		*comp_data,
					GOTH_INTEGER	*comp_data_size,
					GOTH_INTEGER	*used_comp_data_size,
					GOTH_BOOLEAN	*done_quick_abort,
					GOTH_BOOLEAN	*has_compressed) ;


/*----------------------------------------------------------------------*/
/* EXTERN compress_decomp_buffer					*/
/*......................................................................*/
/*									*/
/* Decompress a buffer of data according to the specified scheme and    */
/* values.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* scheme_id -in- the identifier of the compression scheme to use 	*/
/* comp_data		-in- the compressed data			*/
/* comp_data_size       -in- the byte size of the compressed data	*/
/* allow_realloc	-in- TRUE if the output buffer can be realloced */
/* decompressed_size    -in- the decompressed size of the data 		*/
/*                           (if known)					*/
/* values		-in- compression scheme dependent values	*/
/*			      is less output data than input data.	*/
/* decomp_data       -in/out- buffer containing the decompressed data.	*/
/* decomp_data_size  -in/out- the byte size of the decompressed data.	*/
/* used_decomp_data_size  -in- the number of bytes used in the buffer   */
/*			     to hold the decompressed data.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__NOSUCHCOMPSCHEME if scheme identifier is not registered	*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS compress_decomp_buffer(GOTH_ID 	scheme_id,
					VOID_P		comp_data,
					GOTH_INTEGER	comp_data_size,
					GOTH_BOOLEAN	allow_realloc,
					GOTH_INTEGER	decompressed_size,
					GOTH_VALUE	*values,
					VOID_P		*decomp_data,
					GOTH_INTEGER	*decomp_data_size,

					GOTH_INTEGER	*used_decomp_data_size) ;


/*----------------------------------------------------------------------*/
/* EXTERN compress_buffer_write					        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Useful generic routine for writing to a buffer for compression	*/
/* algorithms.								*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* do_blat_value -in - TRUE use memset with blat_value			*/
/* 		       FALSE use memcpy and buffer_in			*/
/* blat_value	 -in-  the value to blat into data			*/
/* buffer_in -in- the buffer to write from				*/
/* max_size  -in-  the maximum amount of data to write			*/
/* max_size_abort -in - TRUE if the routine is to abort if max_size     */
/*			is exceeded.					*/
/* nbytes_write -in- the number of bytes to write			*/
/* allow_realloc -in- the buffer can be reallocated			*/
/* buffer_size_increment -in- the size of any buffer increment.		*/
/* buffer   -in/out- the buffer to write to.				*/
/* buffer_size -in/out- the whole size of buffer                        */
/* used_buffer_size -in/out- the number of bytes used in the buffer.	*/
/* aborted          -out- TRUE if compression has aborted.		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__COMPBUFFERTOOSMALL if buffer cannot be grown			*/
/*  GOTH__MALLOC if not enough memory					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS compress_buffer_write(GOTH_BOOLEAN  do_blat_value,
					 char 	       blat_value,
					 VOID_P        buffer_in,
					 GOTH_INTEGER  max_size,
					 GOTH_BOOLEAN  max_size_abort,
					 GOTH_INTEGER  nbytes_write,
					 GOTH_BOOLEAN	allow_realloc,
					 GOTH_INTEGER  buffer_size_increment,
					 VOID_P	       *buffer,
					 GOTH_INTEGER  *buffer_size,
					 GOTH_INTEGER  *used_buffer_size,
					 GOTH_BOOLEAN  *aborted) ;
#endif


/* $Header: /lslhome/gothic/hdr/compresslib/v1-0/RCS/hdr.compress_intrinsics.h,v 1.1 1993/08/06 15:19:59 davida Exp $								*/
/* 									*/
/* $Log: hdr.compress_intrinsics.h,v $
 * Revision 1.1  1993/08/06  15:19:59  davida
 * Version v1-0 derived from root
 * Initial development
 *								*/
