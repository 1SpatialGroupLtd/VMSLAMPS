/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1994-04-19 18:12:44.000000000 +0100
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
#ifndef _BBD_INTRINSICS
#define _BBD_INTRINSICS

/*>>> EXTERN functions from BBD.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN bbd_build_bbd   		       				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Build a BBD (Block buffer data) and initialise the BBD's buffer      */
/* to a user defined size in bytes.                                     */
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -out- the BBD to be built.                              */
/* buffer_size  -in-  the initial buffer size in bytes for the BBD.     */
/* increment_size -in- the increment size of the BBD			*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__MALLOC if insufficient memory for operation                   */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_build_bbd(GD_BBD      *bbd_id,
				 GOTH_INTEGER buffer_size,
				 GOTH_INTEGER increment_size) ;
/*----------------------------------------------------------------------*/
/* EXTERN bbd_destroy_bbd   		       				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Delete a BBD and all its associated memory. This routine is the      */
/* inverse to <<buffer_build_bbd>>.                                     */
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in- the BBD to be destroyed.                           */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_destroy_bbd(GD_BBD       bbd_id) ;
/*----------------------------------------------------------------------*/
/* EXTERN bbd_write                                              	*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Write a buffer of data into a BBD at the current pointer position.   */
/* The routine will increase the size of the buffer if the write goes   */
/* beyond the end of the current buffer.                                */
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in- the BBD to be write to.                            */
/* nbytes       -in- the number of bytes to be written.                 */
/* data         -in- the data to be written into the buffer.            */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_write(GD_BBD       bbd_id,
			     GOTH_INTEGER nbytes,
			     GOTH_SPECIAL data);
/*----------------------------------------------------------------------*/
/* EXTERN bbd_read                                               	*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Read a buffer of data from a BBD at the current pointer position.    */
/* The routine returns with an error if the read goes beyond the high   */
/* pointer mark of the BBD.                                             */
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in- the BBD to be read from.                           */
/* nbytes       -in- the number of bytes to be read.                    */
/* data         -in- the buffer to be filled with the BBD data read.    */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*  GOTH__BBDREADERROR if the read is beyond the end of the BBD 	*/
/*                        buffer.					*/
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_read(GD_BBD       bbd_id,
			    GOTH_INTEGER nbytes,
			    GOTH_SPECIAL data);
/*----------------------------------------------------------------------*/
/* EXTERN bbd_seek  		                                        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Seek to a given byte offset within the BBD buffer. The routine       */
/* extends the buffer if the seek goes beyond the end of the current    */
/* buffer.								*/
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in- the BBD to seek on.                                */
/* offset       -in- the offset to seek to.                             */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*  GOTH__BBDREADERROR if the read is beyond the end of the BBD 	*/
/*                        buffer.					*/
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_seek(GD_BBD       	bbd_id,
			    GOTH_INTEGER 	offset,
			    BBD_WHEREFROM_TYPE	seek_type) ;
/*----------------------------------------------------------------------*/
/* EXTERN bbd_reset  		                                        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */ 
/* Reset a BBD buffer for a brand new set of reads and writes. This     */
/* routine sets the BBD current pointer and high pointer to the start   */
/* of the BBD buffer.                                                   */
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in- the BBD to reset.                                  */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_reset(GD_BBD       bbd_id);
/*----------------------------------------------------------------------*/
/* EXTERN bbd_used_buffer_size   	                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */ 
/* Get the number of bytes in the BBD buffer which have been used.      */
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in- the BBD whose used buffer size is to be returned.  */
/* used_buffer_size  -out- the number of bytes in the buffer which have */
/*                         been used.                                   */
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_used_buffer_size(GD_BBD       bbd_id,
					GOTH_INTEGER *used_buffer_size);
/*----------------------------------------------------------------------*/
/* EXTERN bbd_tell  		                                        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Return the current byte offset within the BBD buffer of the current  */
/* pointer.                                                             */
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in-  the BBD to seek on.                               */
/* *offset      -out- the offset of the current pointer in the BBD      */
/*                    buffer.                                           */ 
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_tell(GD_BBD       bbd_id,
                            GOTH_INTEGER *offset) ;
/*----------------------------------------------------------------------*/
/* EXTERN bbd_buffer	  		                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Return the pointer to the BBD buffer					*/
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in-  the BBD to seek on.                               */
/* buffer      -out- the pointer to the buffer				*/
/*                    buffer.                                           */ 
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_buffer(GD_BBD       bbd_id,
			      GOTH_SPECIAL *buffer) ;
/*----------------------------------------------------------------------*/
/* EXTERN bbd_current_buffer	  		                        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Return the current pointer to the BBD buffer				*/
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in-  the BBD to seek on.                               */
/* buffer      -out- the pointer to the buffer				*/
/*                    buffer.                                           */ 
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_current_buffer(GD_BBD       bbd_id,
				      GOTH_SPECIAL *buffer) ;
/*----------------------------------------------------------------------*/
/* EXTERN bbd_test_edited	  		                        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Return the current pointer to the BBD buffer				*/
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in-  the BBD to seek on.                               */
/* edited      -out-  flag to see if buffer has been edited		*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_edited(GD_BBD       bbd_id,
			      GOTH_BOOLEAN *edited) ;
/*----------------------------------------------------------------------*/
/* EXTERN bbd_set_buffer_size						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Set the buffer size for the BBD buffer.				*/
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in-  the BBD to seek on.                               */
/* new_size	-in-  the new size for the BBD buffer			*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_set_buffer_size(GD_BBD       bbd_id,
				       GOTH_INTEGER buffer_size) ;

/*----------------------------------------------------------------------*/
/* EXTERN bbd_auto_reset	  		                        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Set the frequency to determine when a buffer should be totally reset */
/* when a buffer is cleared.						*/
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in-  the BBD to set the frequcny on.			*/
/* frequency	-in-  the numebr of resets of the buffer required to 	*/
/*		      cause a total reset of the buffer.		*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_auto_reset(GD_BBD       bbd_id,
				  GOTH_INTEGER frequency);

/*----------------------------------------------------------------------*/
/* EXTERN bbd_set_used_buffer_size				        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Set the used buffer size for the BBD buffer.				*/
/* This is useful where data has been external read into the BBD 	*/
/* buffer,or to truncate the buffer					*/
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in-  the BBD to seek on.                               */
/* used_buffer_size -in-  the size to set for the used buffer		*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_set_used_buffer_size(GD_BBD       bbd_id,
					    GOTH_INTEGER used_buffer_size) ;

/*----------------------------------------------------------------------*/
/* EXTERN bbd_set_increment					        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Set the buffer size increment for the BBD buffer.			*/
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in-  the BBD to seek on.                               */
/* increment	-in-  the increment to use.				*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_set_increment(GD_BBD       bbd_id,
				     GOTH_INTEGER increment) ;


/*----------------------------------------------------------------------*/
/* EXTERN bbd_set_buffer						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* Set the buffer for the BBD buffer.	   			        */
/*                                                                      */ 
/*..ARGUMENTS...........................................................*/
/*                                                                      */
/* bbd_id       -in-  the BBD to seek on.                               */
/* buffer       -in- the new BBD buffer					*/
/* buffer_size	-in-  the new size for the BBD buffer			*/
/* used_buffer_size -in- the used size of the BBD buffer		*/
/*                                                                      */
/*..RETURN-CODES........................................................*/
/*                                                                      */
/*  GOTH__NORMAL if operation completes successfully                    */
/*  GOTH__DESC   if the descriptor is not well defined                  */
/*                                                                      */
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bbd_set_buffer(GD_BBD       bbd_id,
				  VOID_P       buffer,
				  GOTH_INTEGER buffer_size,
				  GOTH_INTEGER used_buffer_size) ;

#endif 
/* $Header: /lslhome/gothic/hdr/bbdlib/v1-0/RCS/hdr.bbd_intrinsics.h,v 1.1 1993/08/10 21:53:13 jon Exp $								*/
/* 									*/
/* $Log: hdr.bbd_intrinsics.h,v $
 * Revision 1.1  1993/08/10  21:53:13  jon
 * Version v1-0 derived from root
 * Initial development
 *								*/
