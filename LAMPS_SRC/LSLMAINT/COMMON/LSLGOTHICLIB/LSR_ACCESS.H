/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:11:28.000000000 +0000
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
#ifndef _LSR_ACCESS
#define _LSR_ACCESS
#define LSR_PIXEL_ACCESS_DECLAREI GOTH_INTEGER p_o1,p_o2; 
#define LSR_PIXEL_ACCESS_DECLARER GOTH_REAL p_l1,p_l2 ;





/*----------------------------------------------------------------------*/
/* MACRO LSR_GET_PIXEL_ACCESS_PARAMS					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* MACRO retrieves parameters defining the operation of a 		*/
/* PIXEL_ACCESS_INFO data structure. 					*/
/*									*/
/* Note, this MACRO is used in LSRCLIB in setting up a grid of tile	*/
/* numbers, tile buffer offsets and in-tile pixel coordinates about	*/
/* which to resample. In effect LSRCLIB assumes knowledge of how pixel 	*/
/* data is accessed within PIXEL_ACCESS_INFO data structures (use of	*/
/* the other macros defined within this header file in spatial 		*/
/* resampling produces very inefficient code). This MACRO is therefore	*/
/* really a reminder any changes to the accessing of pixel data can	*/
/* have serious consequences with regard to spatial resampling using	*/
/* LSRCLIB routines.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* pa_p			-in-	Pointer to a PIXEL_ACCESS_INFO data 	*/
/*				structure.				*/
/*									*/
/* low_1		-out-	Lower limit to the first pixel 		*/
/*				coordinate covered by the raster tiles	*/
/*				defined by <<pa_p>>.			*/
/*									*/
/* high_1		-out-	Upper limit to the first pixel 		*/
/*				coordinate covered by the raster tiles	*/
/*				defined by <<pa_p>>.			*/
/*									*/
/* num_tile_1		-out-	Number of tiles in the first 		*/
/*				coordinate direction.			*/
/*									*/
/* tile_size_1		-out-	Dimension of each tile in the first	*/
/*				coordinate direction.			*/
/*									*/
/* low_2		-out-	Lower limit to the second pixel 	*/
/*				coordinate covered by the raster tiles	*/
/*				defined by <<pa_p>>.			*/
/*									*/
/* high_2		-out-	Upper limit to the second pixel 	*/
/*				coordinate covered by the raster tiles	*/
/*				defined by <<pa_p>>.			*/
/*									*/
/* num_tile_2		-out-	Number of tiles in the second 		*/
/*				coordinate direction.			*/
/*									*/
/* tile_size_2		-out-	Dimension of each tile in the second	*/
/*				coordinate direction.			*/
/*									*/
/* tile_array		-out-	Address of the array holding the raster	*/
/*				tiles. Note there will be 		*/
/*				<<num_tile_1 * num_tile_2>> tiles in	*/
/*				this array, stored tile row by tile row.*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

#define LSR_GET_PIXEL_ACCESS_PARAMS(pa_p,		\
				    low_1,		\
				    high_1,		\
				    num_tile_1,		\
				    tile_size_1,	\
				    low_2,		\
				    high_2,		\
				    num_tile_2,		\
				    tile_size_2,	\
				    tile_array)		\
{							\
   (low_1)           = (pa_p)->lpix1;			\
   (high_1)          = (pa_p)->hpix1;			\
   (num_tile_1)      = (pa_p)->ntile1;			\
   (tile_size_1)     = (pa_p)->tilesz1; 		\
   (low_2)           = (pa_p)->lpix2;			\
   (high_2)          = (pa_p)->hpix2;			\
   (num_tile_2)      = (pa_p)->ntile2;			\
   (tile_size_2)     = (pa_p)->tilesz2; 		\
   (tile_array)      = (pa_p)->tiles;			\
}							\



/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_PIXEL(                                                       */
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*               GOTH_INTEGER      p1,                                  */
/*               GOTH_INTEGER      p2,                                  */
/*               unsigned char     *out_ptr,                            */
/*               GOTH_INTEGER      offset)                              */
/*                                                                      */
/* Get data out of a tiled PIXEL_ACCESS_INFO structure                  */
/*                                                                      */
/* This is a general macro to extract data from a tiled                 */
/* PIXEL_ACCESS_INFO structure                                          */
/*                                                                      */
/* The buffer return out_ptr as NULL if the data lies outside the       */
/* range of data held in the PIXEL_ACCESS_INFO structure                */
/*                                                                      */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* p1      -in- the pixel coordinate of the data to retrieve            */
/* p1      -in- the pixel coordinate of the data to retrieve            */
/* p2      -in-                                                         */
/* out_ptr -out- the pointer to the data required to retrieve           */
/* offset  -out- the bit offset of the start of the pixel data for the  */
/*               case when the datatype is not byte aligned             */
/*                                                                      */
/*----------------------------------------------------------------------*/
 
#define LSR_GET_PIXEL(pa,p1,p2,out_ptr,offset)\
\
{\
LSR_PIXEL_ACCESS_DECLAREI ;\
if(((p1)>(pa)->hpix1) || ((p1)<(pa)->lpix1) ||\
((p2)>(pa)->hpix2) || ((p2)<(pa)->lpix2)   ){out_ptr = NULL ;}else{\
p_o1 = (p1) - (pa)->lpix1 ; p_o2 = (p2) - (pa)->lpix2 ;\
(pa)->tile1 = p_o1/(pa)->tilesz1 ; (pa)->tile2 = p_o2/(pa)->tilesz2 ;\
(pa)->pix1 = p_o1%(pa)->tilesz1 ; (pa)->pix2 = p_o2%(pa)->tilesz2 ;\
(pa)->tileoff = ((pa)->tile2*(pa)->ntile1) + (pa)->tile1 ;\
(pa)->rowcalc = (pa)->tilecalc - (pa)->pix2*(pa)->tilesz1 ;\
p_o1 = (pa)->rowcalc +  (pa)->pix1 ;\
if((pa)->nbits == 8){(pa)->ptr = out_ptr = (pa)->tiles[(pa)->tileoff] + p_o1 ;}\
else if((pa)->noff == 0)\
{(pa)->ptr = out_ptr = (pa)->tiles[(pa)->tileoff] + ((pa)->nbs*p_o1) ;}\
else{p_o1 *= (pa)->nbits ;\
(pa)->ptr = out_ptr = (pa)->tiles[(pa)->tileoff] + (p_o1/8) ;\
(pa)->bitoff = offset = p_o1%8 ;}}}

/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_NEXT_PIXEL(pa,out_ptr,offset)                                */
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*               unsigned char     *out_ptr,                            */
/*               GOTH_INTEGER      offset)                              */
/*                                                                      */
/* Get data out of a tiled PIXEL_ACCESS_INFO structure                  */
/*                                                                      */
/* This is a general macro to extract data from a tiled                 */
/* PIXEL_ACCESS_INFO structure. The MACRO must be preceded by a call    */
/* to LSR_GET_PIXEL. It returns the pointer and offset to the next      */
/* pixel in the primary storage direction                               */
/*                                                                      */
/* The MACRO returns out_ptr as NULL if the data lies outside the       */
/* range of data held in the PIXEL_ACCESS_INFO structure                */
/*                                                                      */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* out_ptr -out- the pointer to the data required to retrieve           */
/* offset  -out- the bit offset of the start of the pixel data for the  */
/*               case when the datatype is not byte aligned             */
/*                                                                      */
/*----------------------------------------------------------------------*/
 
#define LSR_GET_NEXT_PIXEL(pa,out_ptr,offset)\
\
{\
LSR_PIXEL_ACCESS_DECLAREI ;\
((pa)->pix1)++ ;\
if(((pa)->pix1>(pa)->hpix1)){out_ptr = NULL;}\
else{if((pa)->pix1 == (pa)->tilesz1){\
(pa)->tileoff++ ;(pa)->tile1++;(pa)->pix1 = 0 ;\
if((pa)->nbits == 8){(pa)->ptr = out_ptr = (pa)->tiles[(pa)->tileoff] + (pa)->rowcalc;}\
else if((pa)->noff == 0){\
(pa)->ptr = out_ptr = (pa)->tiles[(pa)->tileoff]+((pa)->rowcalc*(pa)->nbs);}\
else{p_o1 = (pa)->rowcalc*(pa)->nbits ;\
(pa)->ptr = out_ptr = (pa)->tiles[(pa)->tileoff] + (p_o1/8) ;\
(pa)->bitoff = offset = p_o1%8 ;}}\
else{if((pa)->nbits == 8){out_ptr = (pa)->ptr++ ;}\
else if((pa)->noff == 0){out_ptr = ((pa)->ptr += (pa)->nbs) ;}\
else{(pa)->ptr += (pa)->nbs ;(pa)->bitoff += (pa)->noff ;\
if((pa)->bitoff >= 8){(pa)->ptr++ ;(pa)->bitoff -= 8 ;}\
out_ptr = (pa)->ptr ;offset = (pa)->bitoff ;}}}}
     
/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_PIXEL_NC(                                                    */
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*               GOTH_INTEGER      p1,                                  */
/*               GOTH_INTEGER      p2,                                  */
/*               unsigned char     *out_ptr,                            */
/*               GOTH_INTEGER      offset)                              */
/*                                                                      */
/* Get data out of a tiled PIXEL_ACCESS_INFO structure                  */
/*                                                                      */
/* This is a general macro to extract data from a tiled                 */
/* PIXEL_ACCESS_INFO structure                                          */
/*                                                                      */
/* The buffer return out_ptr as NULL if the data lies outside the       */
/* range of data held in the PIXEL_ACCESS_INFO structure                */
/*                                                                      */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* p1      -in- the pixel coordinate of the data to retrieve            */
/* p1      -in- the pixel coordinate of the data to retrieve            */
/* p2      -in-                                                         */
/* out_ptr -out- the pointer to the data required to retrieve           */
/* offset  -out- the bit offset of the start of the pixel data for the  */
/*               case when the datatype is not byte aligned             */
/*                                                                      */
/*----------------------------------------------------------------------*/
 
#define LSR_GET_PIXEL_NC(pa,p1,p2,out_ptr,offset)\
\
{\
LSR_PIXEL_ACCESS_DECLAREI ;\
p_o1 = (p1) - (pa)->lpix1 ; p_o2 = (p2) - (pa)->lpix2 ;\
(pa)->tile1 = p_o1/(pa)->tilesz1 ; (pa)->tile2 = p_o2/(pa)->tilesz2 ;\
(pa)->pix1 = p_o1-(pa)->tile1*(pa)->tilesz1 ; (pa)->pix2 = p_o2-(pa)->tile2*(pa)->tilesz2 ;\
(pa)->tileoff = ((pa)->tile2*(pa)->ntile1) + (pa)->tile1 ;\
(pa)->rowcalc = (pa)->tilecalc - (pa)->pix2*(pa)->tilesz1 ;\
p_o1 = (pa)->rowcalc +  (pa)->pix1 ;\
if((pa)->nbits == 8){(pa)->ptr = out_ptr = (pa)->tiles[(pa)->tileoff] + p_o1 ;}\
else if((pa)->noff == 0)\
{(pa)->ptr = out_ptr = (pa)->tiles[(pa)->tileoff] + ((pa)->nbs*p_o1) ;}\
else{p_o1 *= (pa)->nbits ;\
(pa)->ptr = out_ptr = (pa)->tiles[(pa)->tileoff] + (p_o1/8) ;\
(pa)->bitoff = offset = p_o1%8 ;}}

/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_NEXT_PIXEL_NC(pa,out_ptr,offset)                             */
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*               unsigned char     *out_ptr,                            */
/*               GOTH_INTEGER      offset)                              */
/*                                                                      */
/* Get data out of a tiled PIXEL_ACCESS_INFO structure                  */
/*                                                                      */
/* This is a general macro to extract data from a tiled                 */
/* PIXEL_ACCESS_INFO structure. The MACRO must be preceded by a call    */
/* to LSR_GET_PIXEL. It returns the pointer and offset to the next      */
/* pixel in the primary storage direction                               */
/*                                                                      */
/* The MACRO returns out_ptr as NULL if the data lies outside the       */
/* range of data held in the PIXEL_ACCESS_INFO structure                */
/*                                                                      */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* out_ptr -out- the pointer to the data required to retrieve           */
/* offset  -out- the bit offset of the start of the pixel data for the  */
/*               case when the datatype is not byte aligned             */
/*                                                                      */
/*----------------------------------------------------------------------*/
 
#define LSR_GET_NEXT_PIXEL_NC(pa,out_ptr,offset)\
\
{\
GOTH_INTEGER  p_o1 ;\
((pa)->pix1)++ ;\
if((pa)->pix1 == (pa)->tilesz1){\
(pa)->tileoff++ ;(pa)->tile1++ ; (pa)->pix1 = 0;\
if((pa)->nbits == 8){(pa)->ptr = out_ptr = (pa)->tiles[(pa)->tileoff] + (pa)->rowcalc;}\
else if((pa)->noff == 0){\
(pa)->ptr = out_ptr = (pa)->tiles[(pa)->tileoff]+((pa)->rowcalc*(pa)->nbs);}\
else{p_o1 = (pa)->rowcalc*(pa)->nbits ;\
(pa)->ptr = out_ptr = (pa)->tiles[(pa)->tileoff] + (p_o1/8) ;\
(pa)->bitoff = offset = p_o1%8 ;}}\
else{if((pa)->nbits == 8){out_ptr = (pa)->ptr++ ;}\
else if((pa)->noff == 0){out_ptr = ((pa)->ptr += (pa)->nbs) ;}\
else{(pa)->ptr += (pa)->nbs ;(pa)->bitoff += (pa)->noff ;\
if((pa)->bitoff >= 8){(pa)->ptr++ ;(pa)->bitoff -= 8 ;}\
out_ptr = (pa)->ptr ;offset = (pa)->bitoff ;}}}
     
/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_BUFFER_PIXEL(                                                */
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*               GOTH_INTEGER      p1,                                  */
/*               GOTH_INTEGER      p2,                                  */
/*               unsigned char     *out_ptr,                            */
/*               GOTH_INTEGER      offset)                              */
/*                                                                      */
/* Get data out of a buffer PIXEL_ACCESS_INFO structure                 */
/*                                                                      */
/* This is a general macro to extract data from a buffer                */
/* PIXEL_ACCESS_INFO structure                                          */
/*                                                                      */
/* The buffer return out_ptr as NULL if the data lies outside the       */
/* range of data held in the PIXEL_ACCESS_INFO structure                */
/*                                                                      */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* p1      -in- the pixel coordinate of the data to retrieve            */
/* p1      -in- the pixel coordinate of the data to retrieve            */
/* p2      -in-                                                         */
/* out_ptr -out- the pointer to the data required to retrieve           */
/* offset  -out- the bit offset of the start of the pixel data for the  */
/*               case when the datatype is not byte aligned             */
/*                                                                      */
/*----------------------------------------------------------------------*/

#define LSR_GET_BUFFER_PIXEL(pa,p1,p2,out_ptr,offset)\
\
{\
LSR_PIXEL_ACCESS_DECLAREI ;\
if(((p1)>(pa)->hpix1) || ((p1)<(pa)->lpix1) ||\
((p2)>(pa)->hpix2) || ((p2)<(pa)->lpix2)   ){out_ptr = NULL ;}else{\
p_o1 = (p1) - (pa)->lpix1 ; p_o2 = (p2) - (pa)->lpix2 ;\
p_o1 += ((pa)->tilecalc - (p_o2*(pa)->npix1)) ;\
if((pa)->nbits == 8){(pa)->ptr = out_ptr = (pa)->bufferp + p_o1 ;}\
else if((pa)->noff == 0)\
{(pa)->ptr = out_ptr = (pa)->bufferp + (pa)->nbs*p_o1 ;}\
else{p_o1 *= (pa)->nbits ;\
(pa)->ptr = out_ptr = (pa)->bufferp + (p_o1/8) ;\
(pa)->bitoff = offset = p_o1%8 ;}}}

/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_NEXT_BUFFER_PIXEL(                                           */
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*               unsigned char     *out_ptr,                            */
/*               GOTH_INTEGER      offset)                              */
/*                                                                      */
/* Get data out of a buffer PIXEL_ACCESS_INFO structure                 */
/*                                                                      */
/* This is a general macro to extract data from a buffer                */
/* PIXEL_ACCESS_INFO structure. The MACRO must be preceded by a call    */
/* to LSR_GET_BUFFER_PIXEL. It returns the pointer and offset to the    */
/* next pixel in the primary storage direction                          */
/*                                                                      */
/* The MACRO returns out_ptr as NULL if the data lies outside the       */
/* range of data held in the PIXEL_ACCESS_INFO structure                */
/*                                                                      */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* out_ptr -out- the pointer to the data required to retrieve           */
/* offset  -out- the bit offset of the start of the pixel data for the  */
/*               case when the datatype is not byte aligned             */
/*                                                                      */
/*----------------------------------------------------------------------*/

#define LSR_GET_NEXT_BUFFER_PIXEL(pa,out_ptr,offset)\
\
{\
((pa)->pix1)++ ;\
if((pa)->pix1 >(pa)->hpix1){out_ptr = NULL ;}else{\
if((pa)->nbits == 8){out_ptr = ++((pa)->ptr) ;}\
else if((pa)->noff == 0)\
{(pa)->ptr = (out_ptr = ((pa)->ptr) + ((pa)->nbs));}\
else{(pa)->ptr += (pa)->nbs ;(pa)->bitoff += (pa)->noff ;\
if((pa)->bitoff >= 8){(pa)->ptr++ ;(pa)->bitoff -= 8 ;}\
out_ptr = (pa)->ptr ;offset = (pa)->bitoff ;}}}
     

/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_BUFFER_PIXEL_NC8(                                            */
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*               GOTH_INTEGER      p1,                                  */
/*               GOTH_INTEGER      p2,                                  */
/*               unsigned char     *out_ptr,                            */
/*               GOTH_INTEGER      offset)                              */
/*                                                                      */
/* Get data out of a buffer PIXEL_ACCESS_INFO structure                 */
/*                                                                      */
/* This MACRO assumes 8 bits per pixel and does not check that the      */
/* the input pixel is within range for the PIXEL_ACCESS_INFO structure  */
/*                                                                      */
/* WARNING - The value of out_ptr returned could cause a crash if p1,p2 */
/*           lies outside the data covered by the PIXEL_ACCESS_INFO     */
/*           structure                                                  */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* p1      -in- the pixel coordinate of the data to retrieve            */
/* p1      -in- the pixel coordinate of the data to retrieve            */
/* p2      -in-                                                         */
/* out_ptr -out- the pointer to the data required to retrieve           */
/* offset  -out- the bit offset of the start of the pixel data for the  */
/*               case when the datatype is not byte aligned             */
/*                                                                      */
/*----------------------------------------------------------------------*/


#define LSR_GET_BUFFER_PIXEL_NC8(pa,p1,p2,out_ptr,offset)\
\
{\
LSR_PIXEL_ACCESS_DECLAREI ;\
p_o1 = (p1) - (pa)->lpix1 ; p_o2 = (p2) - (pa)->lpix2 ;\
p_o1 += ((pa)->tilecalc - p_o2*(pa)->npix1) ;\
(pa)->ptr = out_ptr = (pa)->bufferp + p_o1 ;}

/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_BUFFER_NEXT_PIXEL_NC8(pa,out_ptr,offset)                     */
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*               unsigned char     *out_ptr,                            */
/*               GOTH_INTEGER      offset)                              */
/*                                                                      */
/*                                                                      */
/* Get data out of a buffer PIXEL_ACCESS_INFO structure                 */
/*                                                                      */
/* This MACRO assumes 8 bits per pixel and does not check that the      */
/* the input pixel is within range for the PIXEL_ACCESS_INFO structure  */
/*                                                                      */
/* WARNING - The value of out_ptr returned could cause a crash if p1,p2 */
/*           lies outside the data covered by the PIXEL_ACCESS_INFO     */
/*           structure                                                  */
/*                                                                      */
/* A call to LSR_GET_PIXEL_BUFFER or LSR_GET_PIXEL_BUFFER_NC8 or        */
/* LSR_GET_PIXEL_BUFFER_NC must be called before a call to this routine */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* out_ptr -out- the pointer to the data required to retrieve           */
/* offset  -out- the bit offset of the start of the pixel data for the  */
/*               case when the datatype is not byte aligned             */
/*                                                                      */
/*----------------------------------------------------------------------*/

#define LSR_GET_NEXT_BUFFER_PIXEL_NC8(pa,out_ptr,offset)\
out_ptr = ++((pa)->ptr) ;

/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_BUFFER_PIXEL_NCPTR(                                          */
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*               GOTH_INTEGER      p1,                                  */
/*               GOTH_INTEGER      p2,                                  */
/*		 GOTH_INTEGER      nplanes,				*/
/*               type cast         type,				*/
/*               unsigned char     *out_ptr)                            */
/*                                                                      */
/* Get data out of a buffer PIXEL_ACCESS_INFO structure                 */
/*                                                                      */
/* This MACRO assumes whole bytes per pixel and does not check that the */
/* the input pixel is within range for the PIXEL_ACCESS_INFO structure  */
/*                                                                      */
/* WARNING - The value of out_ptr returned could cause a crash if p1,p2 */
/*           lies outside the data covered by the PIXEL_ACCESS_INFO     */
/*           structure                                                  */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* p1      -in- the pixel coordinate of the data to retrieve            */
/* p1      -in- the pixel coordinate of the data to retrieve            */
/* p2      -in-                                                         */
/* type    -in- the type of out_ptr					*/
/* nplanes -in- the number of planes in the data.			*/
/* out_ptr -out- the pointer to the data required to retrieve           */
/*                                                                      */
/*----------------------------------------------------------------------*/


#define LSR_GET_BUFFER_PIXEL_NCPTR(pa,p1,p2,type,nplanes,out_ptr)\
\
{\
   LSR_PIXEL_ACCESS_DECLAREI ;\
   p_o1 = (p1) - (pa)->lpix1 ;\
   p_o2 = (p2) - (pa)->lpix2 ;\
   p_o1 += ((pa)->tilecalc - p_o2*(pa)->npix1) ;\
   out_ptr = ((type *)((pa)->bufferp))\
      + (p_o1*nplanes) ;\
   (pa)->ptr = (unsigned char *) out_ptr ;\
}\


/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_BUFFER_NEXT_PIXEL_NCPTR(pa,type,nplanes,out_ptr,offset)      */
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*	         type cast         type					*/
/*               GOTH_INTEGER      nplanes,				*/
/*               unsigned char     *out_ptr) 				*/
/*                                                                      */
/*                                                                      */
/* Get data out of a buffer PIXEL_ACCESS_INFO structure                 */
/*                                                                      */
/* This MACRO assumes whole bytes per pixel and does not check that the */
/* the input pixel is within range for the PIXEL_ACCESS_INFO structure  */
/*                                                                      */
/* WARNING - The value of out_ptr returned could cause a crash if p1,p2 */
/*           lies outside the data covered by the PIXEL_ACCESS_INFO     */
/*           structure                                                  */
/*                                                                      */
/* A call LSR_GET_PIXEL_BUFFER_NCPTR or must be called before a call to */
/* this routine							        */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* type    -in- the type of out_ptr					*/
/* nplanes -in- the number of planes in the pixel.			*/
/* out_ptr -out- the pointer to the data required to retrieve           */
/*                                                                      */
/*----------------------------------------------------------------------*/

#define LSR_GET_NEXT_BUFFER_PIXEL_NCPTR(pa,type,nplanes,out_ptr)\
out_ptr = (type *) (pa)->ptr ;\
out_ptr += nplanes ;\
pa->ptr = (unsigned char *) (out_ptr) ;\

/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_BUFFER_NEXT_PIXEL_NCPTR(pa,type,nplanes,out_ptr,offset)      */
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*	         type cast         type					*/
/*               GOTH_INTEGER      nplanes,				*/
/*               unsigned char     *out_ptr) 				*/
/*                                                                      */
/*                                                                      */
/* Get data out of a buffer PIXEL_ACCESS_INFO structure                 */
/*                                                                      */
/* This MACRO assumes whole bytes per pixel and does not check that the */
/* the input pixel is within range for the PIXEL_ACCESS_INFO structure  */
/*                                                                      */
/* WARNING - The value of out_ptr returned could cause a crash if p1,p2 */
/*           lies outside the data covered by the PIXEL_ACCESS_INFO     */
/*           structure                                                  */
/*                                                                      */
/* A call LSR_GET_PIXEL_BUFFER_NCPTR or must be called before a call to */
/* this routine							        */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* type    -in- the type of out_ptr					*/
/* nplanes -in- the number of planes in the pixel.			*/
/* out_ptr -out- the pointer to the data required to retrieve           */
/*                                                                      */
/*----------------------------------------------------------------------*/

#define LSR_GET_NEXT_QBUFFER_PIXEL_NCPTR(pa,type,nplanes,out_ptr)\
out_ptr += nplanes ;\

/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_BUFFER_PIXEL_NC(                                             */
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*               GOTH_INTEGER      p1,                                  */
/*               GOTH_INTEGER      p2,                                  */
/*               unsigned char     *out_ptr,                            */
/*               GOTH_INTEGER      offset)                              */
/*                                                                      */
/* Get data out of a buffer PIXEL_ACCESS_INFO structure                 */
/*                                                                      */
/* This is a general macro to extract data from a buffer                */
/* PIXEL_ACCESS_INFO structure but does not check that the data is      */
/* within the range of the PIXEL_ACCESS_INFO structure                  */
/*                                                                      */
/* The buffer return out_ptr as NULL if the data lies outside the       */
/* range of data held in the PIXEL_ACCESS_INFO structure                */
/*                                                                      */
/*                                                                      */
/* WARNING - The value of out_ptr returned could cause a crash if p1,p2 */
/*           lies outside the data covered by the PIXEL_ACCESS_INFO     */
/*           structure                                                  */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* p1      -in- the pixel coordinate of the data to retrieve            */
/* p1      -in- the pixel coordinate of the data to retrieve            */
/* p2      -in-                                                         */
/* out_ptr -out- the pointer to the data required to retrieve           */
/* offset  -out- the bit offset of the start of the pixel data for the  */
/*               case when the datatype is not byte aligned             */
/*                                                                      */
/*----------------------------------------------------------------------*/

#define LSR_GET_BUFFER_PIXEL_NC(pa,p1,p2,out_ptr,offset)\
\
{\
LSR_PIXEL_ACCESS_DECLAREI ;\
p_o1 = (p1) - (pa)->lpix1 ; p_o2 = (p2) - (pa)->lpix2 ;\
p_o1 += ((pa)->tilecalc - (p_o2*(pa)->npix1)) ;\
if((pa)->nbits == 8){(pa)->ptr = out_ptr = (pa)->bufferp + p_o1 ;}\
else if((pa)->noff == 0)\
{(pa)->ptr = out_ptr = (pa)->bufferp + (pa)->nbs*p_o1 ;}\
else{p_o1 *= (pa)->nbits ;\
(pa)->ptr = out_ptr = (pa)->bufferp + (p_o1/8) ;\
(pa)->bitoff = offset = p_o1%8 ;}}

/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_NEXT_BUFFER_PIXEL_NC(                                        */
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*               unsigned char     *out_ptr,                            */
/*               GOTH_INTEGER      offset)                              */
/*                                                                      */
/* Get data out of a buffer PIXEL_ACCESS_INFO structure                 */
/*                                                                      */
/* This is a general macro to extract data from a buffer                */
/* PIXEL_ACCESS_INFO structure. The MACRO must be preceded by a call    */
/* to LSR_GET_BUFFER_PIXEL or LSR_GET_BUFFER_PIXEL_NC or                */
/* LSR_GET_BUFFER_PIXEL_NC8. It returns the pointer and offset to the   */
/* next pixel in the primary storage direction                          */
/*                                                                      */
/* The MACRO returns out_ptr as NULL if the data lies outside the       */
/* range of data held in the PIXEL_ACCESS_INFO structure                */
/*                                                                      */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* out_ptr -out- the pointer to the data required to retrieve           */
/* offset  -out- the bit offset of the start of the pixel data for the  */
/*               case when the datatype is not byte aligned             */
/*                                                                      */
/*----------------------------------------------------------------------*/

#define LSR_GET_NEXT_BUFFER_PIXEL_NC(pa,out_ptr,offset)\
\
{\
((pa)->pix1)++ ;\
if((pa)->nbits == 8){out_ptr = ++((pa)->ptr) ;}\
else if((pa)->noff == 0)\
{(pa)->ptr = (out_ptr = ((pa)->ptr) + ((pa)->nbs));}\
else{(pa)->ptr += (pa)->nbs ;(pa)->bitoff += (pa)->noff ;\
if((pa)->bitoff >= 8){(pa)->ptr++ ;(pa)->bitoff -= 8 ;}\
out_ptr = (pa)->ptr ;offset = (pa)->bitoff ;}}

/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_PIXEL_FROM_COORD_OFFSET(                                         */
/*                             GOTH_REAL      p1,                       */
/*                             GOTH_REAL      p2,                       */
/*                             GOTH_REAL      origin1,                  */
/*                             GOTH_REAL      origin2,                  */
/*                             GOTH_REAL      scale1,                   */
/*                             GOTH_REAL      scale2,                   */
/*                             GOTH_INTEGER   n1,                       */
/*                             GOTH_INTEGER   n2,                       */
/*                             GOTH_REAL      off1,                     */
/*                             GOTH_REAL      off2,                     */
/*                                                                      */
/* Convert from real geographical coordinates to pixel coordinates      */
/*                                                                      */
/* This MACRO converts from the real geographical coordinates to pixel  */
/* coordinates                                                          */
/*                                                                      */
/* p1      -in- the first geographical coordinate                       */
/* p2      -in- the second geographical coordinate                      */
/* origin1 -in- the absolute tiling origin of the raster dataset        */
/* origin2 -in-                                                         */
/* scale1  -in- the scale of the raster dataset                         */
/* scale2  -in-                                                         */ 
/* n1      -out- the pixel coordinate corresponding to (p1,p2)          */
/* n2      -out- (i.e n1 = (GOTH_INTEGER) (p1-origin1)/scale1)          */
/* off1    -out- the real pixel remainder of the geographical coords    */
/* off2    -out- (i.e off1 = (GOTH_REAL) ((p1-n1)/scale1))              */
/*                                                                      */
/*----------------------------------------------------------------------*/

#define LSR_PIXEL_FROM_COORD_OFFSETR(p1,p2,origin1,origin2,\
                                           scale1,scale2,n1,n2,off1,off2)\
{\
LSR_PIXEL_ACCESS_DECLARER ;\
p_l1 = (p1) - (origin1) ;\
p_l2 = (p2) - (origin2) ;\
if((scale1) == 1.0)\
{\
   n1 = p_l1 ;\
   if(p_l1 < 0) (n1)-- ;\
   off1 = (p_l1 - (n1)) ;\
}\
else\
{\
   p_l1 /= (scale1) ;\
   n1 = p_l1 ;\
   if(p_l1 < 0) (n1)-- ;\
   off1 = (p_l1 - (n1)) ;\
}\
if((scale2) == 1.0)\
{\
   n2 = p_l2 ;\
   if(p_l2 < 0) (n2)-- ;\
   off2 = (p_l2 - (n2)) ;\
}\
else\
{\
   p_l2 /= (scale2) ;\
   n2 = p_l2 ;\
   if(p_l2 < 0) (n2)-- ;\
   off2 = (p_l2 - (n2)) ;\
}}


/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_PIXEL_NCPTR(                                                 */
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*               GOTH_INTEGER      p1,                                  */
/*               GOTH_INTEGER      p2,                                  */
/*               typecast          type,				*/
/*		 GOTH_INTEGER      nplanes,				*/
/*               unsigned char     *out_ptr,                            */
/*                                                                      */
/* Get data out of a tiled PIXEL_ACCESS_INFO structure                  */
/*                                                                      */
/* This is a general macro to extract data from a tiled                 */
/* PIXEL_ACCESS_INFO structure                                          */
/*                                                                      */
/* The macro only works for C Language supported pointer types.		*/
/* The macro does not check if the input pixel coordinate is in range.	*/
/*                                                                      */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* p1      -in- the pixel coordinate of the data to retrieve            */
/* p2      -in-                                                         */
/* type    -in- the type of the pointer.				*/
/* nplanes -in- the number of planes in the data.			*/
/* out_ptr -out- the pointer to the data required to retrieve           */
/*                                                                      */
/*----------------------------------------------------------------------*/
 
#define LSR_GET_PIXEL_NCPTR(pa,p1,p2,type,nplanes,out_ptr)\
\
{\
LSR_PIXEL_ACCESS_DECLAREI ;\
p_o1 = (p1) - (pa)->lpix1 ;\
p_o2 = (p2) - (pa)->lpix2 ;\
(pa)->tile1 = p_o1/(pa)->tilesz1 ;\
(pa)->tile2 = p_o2/(pa)->tilesz2 ;\
(pa)->pix1 = p_o1%(pa)->tilesz1 ;\
(pa)->pix2 = p_o2%(pa)->tilesz2 ;\
(pa)->tileoff = ((pa)->tile2*(pa)->ntile1) + (pa)->tile1 ;\
(pa)->rowcalc = (pa)->tilecalc - (pa)->pix2*(pa)->tilesz1 ;\
p_o1 = (pa)->rowcalc +  (pa)->pix1 ;\
out_ptr = ((type *) (pa)->tiles[(pa)->tileoff]) + (p_o1*nplanes) ;\
(pa)->ptr = (unsigned char *) out_ptr ;\
}\

/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_NEXT_PIXEL_NCPTR(pa,type,nplanes,out_ptr)  			*/
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*               unsigned char     *out_ptr,                            */
/*               GOTH_INTEGER      offset)                              */
/*                                                                      */
/* Get data out of a tiled PIXEL_ACCESS_INFO structure                  */
/*                                                                      */
/* This is a general macro to extract data from a tiled                 */
/* PIXEL_ACCESS_INFO structure. The MACRO must be preceded by a call    */
/* to LSR_GET_PIXEL. It returns the pointer and offset to the next      */
/* pixel in the primary storage direction                               */
/*                                                                      */
/* The macro only works for C Language supported pointer types.		*/
/* The macro does not check if the input pixel coordinate is in range.	*/
/*                                                                      */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* type    -in- the type of the pointer.				*/
/* nplanes -in- the number of planes in the data.			*/
/* out_ptr -out- the pointer to the data required to retrieve           */
/*                                                                      */
/*----------------------------------------------------------------------*/
 
#define LSR_GET_NEXT_PIXEL_NCPTR(pa,type,nplanes,out_ptr)\
\
{\
((pa)->pix1)++ ;\
if((pa)->pix1 == (pa)->tilesz1)\
{\
  (pa)->tileoff++ ;\
  (pa)->tile1++ ;\
  (pa)->pix1 = 0 ; \
  out_ptr = ((type *)(pa)->tiles[(pa)->tileoff]) + ((pa)->rowcalc*nplanes);\
  (pa)->ptr = (unsigned char *) out_ptr ;\
}\
else\
{\
   out_ptr = (type *) (pa)->ptr ;\
   out_ptr += nplanes ;\
   pa->ptr = (unsigned char *) (out_ptr) ;\
}}\

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSR_GET_NEXT_QPIXEL_NCPTR(pa,type,nplanes,out_ptr)  			*/
/*               PIXEL_ACCESS_INFO *pa,                                 */
/*               unsigned char     *out_ptr,                            */
/*               GOTH_INTEGER      offset)                              */
/*                                                                      */
/* Get data out of a tiled PIXEL_ACCESS_INFO structure                  */
/*                                                                      */
/* This is a general macro to extract data from a tiled                 */
/* PIXEL_ACCESS_INFO structure. The MACRO must be preceded by a call    */
/* to LSR_GET_PIXEL. It returns the pointer and offset to the next      */
/* pixel in the primary storage direction                               */
/*                                                                      */
/* The macro only works for C Language supported pointer types.		*/
/* The macro does not check if the input pixel coordinate is in range.	*/
/*                                                                      */
/*                                                                      */
/* pa      -in- the PIXEL_ACCESS_INFO structure                         */
/* type    -in- the type of the pointer.				*/
/* nplanes -in- the number of planes in the data.			*/
/* out_ptr -out- the pointer to the data required to retrieve           */
/*                                                                      */
/*----------------------------------------------------------------------*/
 
#define LSR_GET_NEXT_QPIXEL_NCPTR(pa,type,nplanes,out_ptr)\
\
{\
((pa)->pix1)++ ;\
if((pa)->pix1 == (pa)->tilesz1) \
{\
  (pa)->tileoff++ ;\
  (pa)->pix1 = 0 ; \
  out_ptr = ((type *)(pa)->tiles[(pa)->tileoff]) + ((pa)->rowcalc*nplanes);\
}\
}\


typedef union lsr_pointer_union
{
   GOTH_1U_INTEGER   *bbuffer ;
   GOTH_2U_INTEGER   *suibuffer ;
   GOTH_4U_INTEGER   *uibuffer ;
   GOTH_2S_INTEGER   *sibuffer ;
   GOTH_4S_INTEGER   *ibuffer ;
   GOTH_REAL	     *rbuffer ;
} LSR_POINTER_UNION ;


#define LSRM_NINT(x) (((x)>0) ? (int)((x) + 0.5) : -(int)(-(x) + 0.5))

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSRM_SET_VALUE(RAST_PACK_TYPE         packtype,		        */
/*		       GOTH_REAL/INTEGER answer,		        */
/*		       GOTH_1U_INTEGER	 bbuffer,			*/
/*		       GOTH_2S_INTEGER	 sibuffer,			*/
/*		       GOTH_2U_INTEGER	 suibuffer,			*/
/*		       GOTH_4S_INTEGER	 ibuffer,			*/
/*		       GOTH_4U_INTEGER	 uibuffer) 			*/
/*		       GOTH_REAL	 rbuffer) 			*/
/*									*/
/*   Set the value in the correct element of an assortment of pointer	*/
/*   types and increment the pointer.					*/
/*                                                                      */
/*----------------------------------------------------------------------*/



#define LSRM_SET_VALUE(packtype,answer,bbuffer,sibuffer,\
                       suibuffer,ibuffer,uibuffer,\
		       rbuffer)\
switch(packtype) \
{ \
case RAST_PACK_BYTE:\
   answer = answer + 0.5 ;\
   if(answer > 255) \
   {\
      answer = 255 ;\
   }\
   else if(answer < 0) \
   {\
      answer = 0 ;\
   }\
   *bbuffer++ =  answer ;\
   break ;\
 case RAST_PACK_SINTEGER:\
   answer = LSRM_NINT(answer) ;\
   *sibuffer++ =  answer ;\
   break ;\
 case RAST_PACK_INTEGER:\
   answer = LSRM_NINT(answer) ;\
   *ibuffer++ =  answer ;\
   break ;\
 case RAST_PACK_SUINTEGER:\
   answer = answer + 0.5 ;\
   if(answer > 65535) \
   {\
      answer = 65535 ;\
   }\
   else if(answer < 0) \
   {\
      answer = 0 ;\
   }\
   *suibuffer++ = answer ;\
   break ;\
 case RAST_PACK_UINTEGER:\
   answer = answer + 0.5 ;\
   if(answer < 0) answer = 0;\
   *uibuffer++ = answer ;\
   break ;\
 case RAST_PACK_REAL:\
   *rbuffer++ = answer ;\
   break ;\
 default:\
   break;\
}\

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSRM_SET_VALUEU(RAST_PACK_TYPE          packtype,		        */
/*		       GOTH_REAL/INTEGER   answer,			*/
/*		       LSR_BUFFER_UNION	   buffer_union)		*/
/*									*/
/*   Set the value in the correct element of a pointer	union           */
/*   types and increment the pointer.					*/
/*                                                                      */
/*----------------------------------------------------------------------*/

#define LSRM_SET_VALUEU(packtype,answer,buffer_union)\
switch(packtype) \
{ \
case RAST_PACK_BYTE:\
   answer = answer + 0.5 ;\
   if(answer > 255) \
   {\
      answer = 255 ;\
   }\
   else if(answer < 0) \
   {\
      answer = 0 ;\
   }\
   *((buffer_union).bbuffer)++ =  answer ;\
   break ;\
 case RAST_PACK_SINTEGER:\
   answer = LSRM_NINT(answer) ;\
   *((buffer_union).sibuffer)++ =  answer ;\
   break ;\
 case RAST_PACK_INTEGER:\
   answer = LSRM_NINT(answer) ;\
   *((buffer_union).ibuffer)++ =  answer ;\
   break ;\
 case RAST_PACK_SUINTEGER:\
   answer = answer + 0.5 ;\
   if(answer > 65535) \
   {\
      answer = 65535 ;\
   }\
   else if(answer < 0) \
   {\
      answer = 0 ;\
   }\
   *((buffer_union).suibuffer)++ = answer ;\
   break ;\
 case RAST_PACK_UINTEGER:\
   answer = answer + 0.5 ;\
   if(answer < 0) answer = 0;\
   *((buffer_union).uibuffer)++ = answer ;\
   break ;\
 case RAST_PACK_REAL:\
   *((buffer_union).rbuffer)++ = answer ;\
   break ;\
 default:\
   break;\
}\




/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSRM_GET_VALUE(RAST_PACK_TYPE    packtype,			        */
/*		 GOTH_REAL/INTEGER answer,			        */
/*		 GOTH_1U_INTEGER   bbuffer,				*/
/*		 GOTH_2S_INTEGER   sibuffer,				*/
/*		 GOTH_2U_INTEGER   suibuffer,				*/
/*		 GOTH_4S_INTEGER   ibuffer,				*/
/*		 GOTH_4U_INTEGER   uibuffer) 				*/
/*		 GOTH_REAL	   rbuffer) 			        */
/*                                                                      */
/*   Set the value in the correct element of an assortment of pointer	*/
/*   types and increment the pointer.					*/
/*									*/
/*----------------------------------------------------------------------*/


#define LSRM_GET_VALUE(packtype,answer,bbuffer,sibuffer,\
		       suibuffer,ibuffer,uibuffer,\
		       rbuffer)\
switch(packtype) \
{ \
case RAST_PACK_BYTE:\
   answer = *bbuffer++ ;\
   break ;\
 case RAST_PACK_SINTEGER:\
   answer = *sibuffer++ ;\
   break ;\
 case RAST_PACK_INTEGER:\
   answer = *ibuffer++ ;\
   break ;\
 case RAST_PACK_SUINTEGER:\
   answer = *suibuffer++ ;\
   break ;\
 case RAST_PACK_UINTEGER:\
   answer = *uibuffer++ ;\
   break ;\
 case RAST_PACK_REAL:\
   answer = *rbuffer++ ;\
   break ;\
 default:\
   break;\
}\



/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSRM_GET_VALUEU(RAST_PACK_TYPE    packtype,			        */
/*		   GOTH_REAL/INTEGER answer,			        */
/*                 LSR_BUFFER_UNION  buffer_union			*/   
/*                                                                      */
/*   Get the value in the correct element of a pointer union		*/
/*   types and increment the pointer.					*/
/*									*/
/*----------------------------------------------------------------------*/


#define LSRM_GET_VALUEU(packtype,answer,buffer_union)\
switch(packtype) \
{ \
case RAST_PACK_BYTE:\
   answer = *((buffer_union).bbuffer)++ ;\
   break ;\
 case RAST_PACK_SINTEGER:\
   answer = *((buffer_union).sibuffer)++ ;\
   break ;\
 case RAST_PACK_INTEGER:\
   answer = *((buffer_union).ibuffer)++ ;\
   break ;\
 case RAST_PACK_SUINTEGER:\
   answer = *((buffer_union).suibuffer)++ ;\
   break ;\
 case RAST_PACK_UINTEGER:\
   answer = *((buffer_union).uibuffer)++ ;\
   break ;\
 case RAST_PACK_REAL:\
   answer = *((buffer_union).rbuffer)++ ;\
   break ;\
 default:\
   break;\
}\

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSRM_GET_VALUE_NIU(RAST_PACK_TYPE    packtype,			*/
/*		   GOTH_REAL/INTEGER answer,			        */
/*                 LSR_BUFFER_UNION buffer_union			*/   
/*                                                                      */
/*                                                                      */
/*   Get the value in the correct element of a pointer union		*/
/*   types but do not increment the pointer.				*/
/*									*/
/*----------------------------------------------------------------------*/


#define LSRM_GET_VALUE_NIU(packtype,answer,buffer_union)\
switch(packtype) \
{ \
case RAST_PACK_BYTE:\
   answer = *((buffer_union).bbuffer) ;\
   break ;\
 case RAST_PACK_SINTEGER:\
   answer = *((buffer_union).sibuffer) ;\
   break ;\
 case RAST_PACK_INTEGER:\
   answer = *((buffer_union).ibuffer) ;\
   break ;\
 case RAST_PACK_SUINTEGER:\
   answer = *((buffer_union).suibuffer) ;\
   break ;\
 case RAST_PACK_UINTEGER:\
   answer = *((buffer_union).uibuffer) ;\
   break ;\
 case RAST_PACK_REAL:\
   answer = *((buffer_union).rbuffer) ;\
   break ;\
 default:\
   break;\
}\

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSRM_INITIALISE(RAST_PACK_TYPE  packtype,			        */
/*		 VOID_P		   buffer				*/
/*		 GOTH_1U_INTEGER   bbuffer,				*/
/*		 GOTH_2S_INTEGER   sibuffer,				*/
/*		 GOTH_2U_INTEGER   suibuffer,				*/
/*		 GOTH_4S_INTEGER   ibuffer,				*/
/*		 GOTH_4U_INTEGER   uibuffer) 				*/
/*		 GOTH_REAL	   rbuffer) 			        */
/*                                                                      */
/*   Initialise the correct element of an assortment of pointer	types	*/
/*                                                                      */
/*----------------------------------------------------------------------*/

#define LSRM_INITIALISE(packtype,buffer,bbuffer,sibuffer,\
		        suibuffer,ibuffer,uibuffer,\
		        rbuffer)\
\
switch(packtype)\
{\
case RAST_PACK_BYTE:\
   bbuffer = (GOTH_1U_INTEGER *) buffer ;\
   break ;\
case RAST_PACK_SINTEGER:\
   sibuffer = (GOTH_2S_INTEGER *) buffer ;\
   break ;\
case RAST_PACK_INTEGER:\
   ibuffer = (GOTH_4S_INTEGER *) buffer ;\
   break ;\
case RAST_PACK_SUINTEGER:\
   suibuffer = (GOTH_2U_INTEGER *) buffer ;\
   break ;\
case RAST_PACK_UINTEGER:\
   uibuffer = (GOTH_4U_INTEGER *) buffer ;\
   break ;\
case RAST_PACK_REAL:\
   rbuffer = (GOTH_REAL *) buffer ;\
   break ;\
default:\
   SCH_RETURN(GOTH__ERROR);\
   break;\
}\


/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSRM_INITIALISEU(RAST_PACK_TYPE         packtype,			*/
/*		    VOID_P		   buffer			*/
/*		    LSR_BUFFER_UNION	   buffer_union)		*/
/*                                                                      */
/*   Initialise the correct element of an a pointer union		*/
/*									*/
/*----------------------------------------------------------------------*/

#define LSRM_INITIALISEU(packtype,buffer,buffer_union) \
switch(packtype)\
{\
case RAST_PACK_BYTE:\
   (buffer_union).bbuffer = (GOTH_1U_INTEGER *) buffer ;\
   break ;\
case RAST_PACK_SINTEGER:\
   (buffer_union).sibuffer = (GOTH_2S_INTEGER *) buffer ;\
   break ;\
case RAST_PACK_INTEGER:\
   (buffer_union).ibuffer = (GOTH_4S_INTEGER *) buffer ;\
   break ;\
case RAST_PACK_SUINTEGER:\
   (buffer_union).suibuffer = (GOTH_2U_INTEGER *) buffer ;\
   break ;\
case RAST_PACK_UINTEGER:\
   (buffer_union).uibuffer = (GOTH_4U_INTEGER *) buffer ;\
   break ;\
case RAST_PACK_REAL:\
   (buffer_union).rbuffer = (GOTH_REAL *) buffer ;\
   break ;\
default:\
   SCH_RETURN(GOTH__ERROR);\
   break;\
}\


/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSRM_INCREMENTU(RAST_PACK_TYPE    packtype,			        */
/*		   GOTH_INTEGER	     increment				*/
/*                 LSR_BUFFER_UNION buffer_union			*/
/*                                                                      */
/*   Increment the correct element of an a pointer union		*/
/*									*/
/*----------------------------------------------------------------------*/

#define LSRM_INCREMENTU(packtype,increment,buffer_union)\
\
switch(packtype)\
{\
case RAST_PACK_BYTE:\
   (buffer_union).bbuffer += (increment) ;\
   break ;\
case RAST_PACK_SINTEGER:\
   (buffer_union).sibuffer += (increment) ;\
   break ;\
case RAST_PACK_INTEGER:\
   (buffer_union).ibuffer += (increment) ;\
   break ;\
case RAST_PACK_SUINTEGER:\
   (buffer_union).suibuffer += (increment) ;\
   break ;\
case RAST_PACK_UINTEGER:\
   (buffer_union).uibuffer += (increment) ;\
   break ;\
case RAST_PACK_REAL:\
   (buffer_union).rbuffer += (increment) ;\
   break ;\
default:\
   SCH_RETURN(GOTH__ERROR);\
   break;\
}\

/*----------------------------------------------------------------------*/
/*                                                                      */
/* LSRM_EQUATEU(RAST_PACK_TYPE   packtype,			        */
/*		LSR_BUFFER_UNION obuffer_union,				*/
/*		LSR_BUFFER_UNION ibuffer_union)				*/
/*                                                                      */
/*   Equate the correct fields of two unions of buffer pointers.	*/
/*									*/
/*----------------------------------------------------------------------*/

#define LSRM_EQUATEU(packtype,obuffer_union,ibuffer_union) \
\
switch(packtype)\
{\
case RAST_PACK_BYTE:\
   (obuffer_union).bbuffer = (ibuffer_union).bbuffer ;\
   break ;\
case RAST_PACK_SINTEGER:\
   (obuffer_union).sibuffer = (ibuffer_union).sibuffer ;\
   break ;\
case RAST_PACK_INTEGER:\
   (obuffer_union).ibuffer = (ibuffer_union).ibuffer ;\
   break ;\
case RAST_PACK_SUINTEGER:\
   (obuffer_union).suibuffer = (ibuffer_union).suibuffer ;\
   break ;\
case RAST_PACK_UINTEGER:\
   (obuffer_union).uibuffer = (ibuffer_union).uibuffer ;\
   break ;\
case RAST_PACK_REAL:\
   (obuffer_union).rbuffer = (ibuffer_union).rbuffer ;\
   break ;\
default:\
   SCH_RETURN(GOTH__ERROR);\
   break;\
}\



/* $Header: /gothic/hdr/rasterlib/v1-20a-4/RCS/hdr.lsr_access.h,v 1.26 1995/03/13 11:43:41 clarke Exp $								*/
#endif
