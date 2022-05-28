/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 19:11:30.000000000 +0000
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
#ifndef _LSR_DEFNS
#define _LSR_DEFNS


#include <stdio.h> 

#include <math.h>

#if USE_PLATFORM != PLAT_VMS

#include <memory.h>

#endif

#include <string.h>


#include "goth_config.h"
#include "goth_datatypes.h"
#include "goth_defns.h"
#include "gothic_status_codes.h"
#include "tran_defns.h"

/**************************************************************************/
/*                                                                        */
/*  DATATYPES DATATYPES DATATYPES DATATYPES DATATYPES DATATYPES DATATYPES */
/*                                                                        */
/**************************************************************************/


/*----------------------------------------------------------------------*/
/* TYPE ENUM RAST_DATA_TYPE                                             */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines the variety of data types supported by the  */
/* the raster handling library.                                         */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/* RAST_BINARY          -       The data represents a binary data type, */
/*                              that is pixel values are either on or   */
/*                              off.                                    */
/* RAST_GREYSCALE       -       The data represents greyscale data,     */
/*                              that is the value of the data has some  */
/*                              direct relevance.                       */
/* RAST_CODE            -       The data represents a coded data type , */
/*                              that is the value of the data has no    */
/*                              direct relevance, but is a coded value. */
/* RAST_RGB             -       The data represents an array of three   */
/*                              greyscale values.                       */
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum 
{
   RAST_DATA_NOT_DEFINED,
   RAST_BINARY,
   RAST_GREYSCALE,
   RAST_CODE,
   RAST_RGB
} RAST_DATA_TYPE ;

/* end-def */

/*----------------------------------------------------------------------*/
/* TYPE ENUM RAST_PACK_TYPE                                             */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines the variety of ways in which the data types */
/* may be storage packed in the raster handling library.                */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/* RAST_PACK_BYTE       -       Pixels are arranged so that pixel       */
/*                              boundaries occur on byte boundaries.    */
/* RAST_PACK_BIT        -       Pixels are bit packed.                  */
/* RAST_PACK_INTEGER    -       Pixels are packed into long integers    */
/* RAST_PACK_UINTEGER   -       Pixels are packed into unsigned long    */
/*                              integers.                               */
/* RAST_PACK_REAL       -       Pixels are packed into double real      */
/*                              values.                                 */
/* RAST_PACK_SINTEGER   -       Pixels are packed into short integers.  */
/* RAST_PACK_SUINTEGER  -       Pixels are packed into unsigned short   */
/*                              integers.                               */
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum 
{
   RAST_PACK_NOT_DEFINED,
   RAST_PACK_BYTE,
   RAST_PACK_BIT,
   RAST_PACK_INTEGER,
   RAST_PACK_UINTEGER,
   RAST_PACK_REAL,
   RAST_PACK_SINTEGER,
   RAST_PACK_SUINTEGER
} RAST_PACK_TYPE ;

/* end-def */
/**************************************************************************/
/*                                                                        */
/*  CACHES CACHES CACHES CACHES CACHES CACHES CACHES CACHES CACHES CACHES */
/*                                                                        */
/**************************************************************************/

/*----------------------------------------------------------------------*/
/* TYPE ENUM RAST_CACHE_TYPE                                            */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines the variety of ways in which data may be    */
/* cached within the raster handling library.                           */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/*  RAST_CACHE_ONE_TILE    - the raster dataset only caches one tile.   */
/*                           This method is often useful when creating a*/
/*                           raster dataset as the data is entered into */
/*                           the dataset one tile at a time and then    */
/*                           never subsequently accessed.               */  
/*  RAST_CACHE_GLOBAL      - the raster dataset caches all tiles in a   */
/*                           global cache used by all open raster       */
/*                           datasets. This is the most commmonly used  */
/*                           cache and must be used when processes      */
/*                           require simultaneous access to more than   */
/*                           one tile (e.g. many transform racs) .      */
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum 
{
   RAST_CACHE_NOT_DEFINED,
   RAST_CACHE_NO_CACHE,   
   RAST_CACHE_ONE_TILE,
   RAST_CACHE_GLOBAL
} RAST_CACHE_TYPE ;

/* end-def */

/**************************************************************************/
/*                                                                        */
/*  RASTER RASTER RASTER RASTER RASTER RASTER RASTER RASTER RASTER RASTER */
/*                                                                        */
/**************************************************************************/

/*----------------------------------------------------------------------*/
/* TYPE ENUM RAC_TYPE                                                   */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines the variety of ways in which raster data    */
/* may be accessed and combined .                                       */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/*  RAST_DATA   -     the raster dataset corresponds to a LSR file.     */
/*  RAST_TILED  -     the raster dataset is composed from raster        */
/*                    datasets of the same data types but over different*/
/*                    real world extents which have been tiled together */
/*                    to form a single raster dataset of larger extent. */
/*  RAST_LAYERED  -   the raster dataset is composed from raster        */
/*                    datasets of different data types but over possibly*/
/*                    the same real world extent which have been        */
/*                    convoluted to create a single raster dataset      */
/*                    over the common extent.                           */
/*  RAST_TRANSFORMED  -  the raster dataset is derived from the data    */
/*                       within a single source dataset. The derivation */
/*                       may be either per pixel (e.g. packing) or      */
/*                       spatial (e.g. a rotation or filter).           */
/*  RAST_EXTERNAL     -  the raster dataset is constructed from data    */
/*                       derived outside the raster handling data.      */
/*                       The data may be an external raster format or   */
/*                       non-raster data.                               */
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum 
{
   RAST_DATA,
   RAST_TILED,
   RAST_LAYERED,
   RAST_TRANSFORMED,
   RAST_TYPE_NOT_DEFINED,
   RAST_EXTERNAL,
   RAST_GENTRANS,
   RAST_VERSION
} RAC_TYPE ;

/* end-def */

/*----------------------------------------------------------------------*/
/* TYPE ENUM RAC_LOCK_TYPE                                              */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines the variety of ways in which raster data    */
/* may be locked.                                                       */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/* RAST_READ_ONLY    - the raster dataset is open for read only.        */
/* RAST_READ_ONLY_WRITE_ATTACH - the raster dataset is open for         */
/*                               read only but can be attached to a     */
/*                               dataset with write access.		*/
/* RAST_WRITE        - the raster dataset is open for read and write.   */
/* RAST_WRITE_READ_ATTACH - the raster dataset is open for read and     */
/*                          write and can be attached to a dataset with */
/*                          read access.			    	*/
/* RAST_WRITE_WRITE_ATTACH - the raster dataset is open for read and    */
/*                           write and can be attached to a dataset with*/
/*                           write access.			    	*/
/* RAST_WRITE_ONLY   - the raster dataset is open for write only.       */
/* RAST_WRITE_ONLY_READ_ATTACH - the raster dataset is open for write   */
/*                                 only but can be attached to a        */
/*                                 dataset with read access.            */
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum
{
   RAST_LOCK_NOT_DEFINED,
   RAST_READ_ONLY,
   RAST_READ_ONLY_WRITE_ATTACH,
   RAST_WRITE,
   RAST_WRITE_READ_ATTACH,
   RAST_WRITE_WRITE_ATTACH,
   RAST_WRITE_ONLY,
   RAST_WRITE_ONLY_READ_ATTACH
} RAST_LOCK_TYPE ;

/* end-def */

/*----------------------------------------------------------------------*/
/* TYPE ENUM RAST_TL_LOCK_TYPE                                          */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines the variety of ways in which raster data    */
/* may be locked within a tiling or layering RAC.                       */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/* RAST_TL_READ_X_WRITE_RW - No read on read and read/write on write    */
/* RAST_TL_READ_R_WRITE_RW - Read on read and read/write on write       */
/* RAST_TL_READ_R_WRITE_XX - Read on read and no read/write on write    */
/* RAST_TL_READ_R_WRITE_RX - Read on read and on write, but no write    */
/*			     write.					*/
/* RAST_TL_READ_X_WRITE_RX - No read on read, but read on write, but no */
/*                           write write.				*/
/* RAST_TL_READ_X_WRITE_XX - No read on read and no read/write on write */
/* RAST_TL_READ_X_WRITE_NW - No read on read and null-read/write on     */
/*			     write. A null-read returns uninitialised   */
/*                           memory and is useful when a tile is going  */
/*                           to be totally overwritten by the raster    */
/*                           call-back anyway.				*/
/* RAST_TL_READ_R_WRITE_NW - Read on read and null-read/write on write  */
/* RAST_TL_READ_E_WRITE_RW - Edit read on read and read/write on write. */
/*			     An edit read marks the tile edited by the  */
/*			     read call-back. This is useful for 	*/
/*			     callbacks which want to create multiple    */
/*			     editable outputs.				*/
/* RAST_TL_READ_E_WRITE_XX - Edit read on read and no read/write on 	*/
/*			     write    					*/
/* RAST_TL_READ_E_WRITE_RX - Edit read on read and on write, but no 	*/
/*                           write write.				*/	
/* RAST_TL_READ_E_WRITE_NW - Edit read on read and null-read/write on   */
/*			     write  					*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum
{
   RAST_TL_NOT_DEFINED,
   RAST_TL_READ_X_WRITE_RW,
   RAST_TL_READ_R_WRITE_RW,
   RAST_TL_READ_R_WRITE_XX,
   RAST_TL_READ_R_WRITE_RX,
   RAST_TL_READ_X_WRITE_RX,
   RAST_TL_READ_X_WRITE_XX,
   RAST_TL_READ_X_WRITE_NW,
   RAST_TL_READ_R_WRITE_NW,
   RAST_TL_READ_E_WRITE_RW,
   RAST_TL_READ_E_WRITE_XX,
   RAST_TL_READ_E_WRITE_RX,
   RAST_TL_READ_E_WRITE_NW
} RAST_TL_LOCK_TYPE ;

/* end-def */

/*----------------------------------------------------------------------*/
/* TYPE ENUM RAC_STORAGE_TYPE                                           */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines the variety of ways in which raster data    */
/* may be accessed from files.                                          */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/* RAST_STORAGE_NORMAL - the raster dataset is accessed through the     */
/*                       standard C runtime I/0 library.                */
/* RAST_STORAGE_MAPPED - the raster dataset is accessed through         */
/*                       files mapped into memory (only on VMS at       */
/*                       present).                                      */
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum
{
   RAST_STORAGE_NOT_DEFINED,
   RAST_STORAGE_NORMAL,
   RAST_STORAGE_MAPPED
} RAST_STORAGE_TYPE ;

/* end-def */

/**************************************************************************/
/*                                                                        */
/*  GRID GRID GRID GRID GRID GRID GRID GRID GRID GRID GRID GRID GRID GRID */ 
/*                                                                        */
/**************************************************************************/


/*----------------------------------------------------------------------*/
/* TYPE ENUM RAST_POINT_TYPE                                            */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines the variety of ways in which raster data    */
/* pixels may be interpreted.                                           */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/* RAST_BY_POINT - the raster dataset pixels are considered to be       */
/*                 representative of a value at a particular point.     */
/* RAST_BY_AREA  - the raster dataset pixels are considered to be       */
/*                 representative of the area covered by a pixel.       */
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum
{
   RAST_POINT_NOT_DEFINED,
   RAST_BY_POINT,
   RAST_BY_AREA
} RAST_POINT_TYPE ;

/* end-def */

/*----------------------------------------------------------------------*/
/* TYPE ENUM RAST_PIXACC_TYPE                                           */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* When using spatial transforms with transform racs data is abstracted */
/* from an internally created buffer structure. This structure can be   */
/* made to be either an exactly defined contiguous buffer, a tile       */
/* aligned contiguous buffer or a collection of pointers to tiles in    */
/* the tile cahce. The following enumeration desribes the way in which  */
/* the buffer structure is created.                                     */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/* RAST_ACCESS_POINTER - the buffer structure consists of an array of   */
/*                       pointers to tiles in the tile cache. This      */
/*                       method is most suitable when large scale       */
/*                       resamping is necessary.                        */
/* RAST_ACCESS_TILE_BUFFER - the buffer structure consists of a         */
/*                           contiguous buffer whose edges are tile     */
/*                           aligned to contain the region specified by */
/*                           the minimum bounding rectangle.            */
/* RAST_ACCESS_BUFFER - the buffer structure consists of a              */
/*                      contiguous buffer whose edges are exactly those */
/*                      determined by the minimum bounding rectangle.   */
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum
{
   PIXEL_ACCESS_NOT_DEFINED,
   PIXEL_ACCESS_POINTER,
   PIXEL_ACCESS_TILE_BUFFER,
   PIXEL_ACCESS_BUFFER,
   PIXEL_ACCESS_OFFSET
} RAST_PIXACC_TYPE ;

/* end-def */

typedef enum
{
   RAST_EDGE_NOT_DEFINED,
   RAST_EDGE_UNKNOWN
} RAST_EDGE_TYPE ;

typedef struct pixel_access_info
{
   RAST_PIXACC_TYPE  type ;
   RAST_EDGE_TYPE    edge ;
   GOTH_INTEGER pix1 ;  
   GOTH_INTEGER pix2 ;
   GOTH_INTEGER tile1 ; 
   GOTH_INTEGER tile2 ;
   GOTH_INTEGER ntile1 ;
   GOTH_INTEGER ntile2 ;
   GOTH_INTEGER tileoff ;
   GOTH_INTEGER bitoff ;
   GOTH_INTEGER lpix1 ;
   GOTH_INTEGER lpix2 ;
   GOTH_INTEGER hpix1 ;
   GOTH_INTEGER hpix2 ;
   GOTH_INTEGER npix1 ;
   GOTH_INTEGER npix2 ;
   GOTH_INTEGER tilesz1 ;
   GOTH_INTEGER tilesz2 ;
   GOTH_INTEGER nbits ;
   GOTH_INTEGER nbs ;
   GOTH_INTEGER noff ;
   unsigned char *ptr ;
   GOTH_INTEGER tilecalc ;
   GOTH_INTEGER rowcalc ;
   GOTH_INTEGER ntiles ;
   unsigned char **tiles ;
   GOTH_INTEGER  buffer_size ;
   unsigned char *bufferp ;
   GOTH_REAL     low1 ;
   GOTH_REAL     low2 ;
   GOTH_REAL     high1 ;
   GOTH_REAL     high2 ;
} PIXEL_ACCESS_INFO ;

/**************************************************************************/
/*                                                                        */
/*  DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA DATA */
/*                                                                        */
/**************************************************************************/

/* Tiling ordering scheme values                    */

/*------------------------------------------------------------------------------*/
/* TYPE ENUM TILE_ORDER_TYPE                                            	*/
/*..............................................................................*/
/*..DESCRIPTION.................................................................*/
/*                                                                     	        */
/* This enumeration defines the variety of ways tiles may be stored     	*/
/* within a raster dataset. This enumeration only has meaning for       	*/
/* uncompressed datasets, as tiles in compressed datasets are stored in 	*/
/* the order that they are entered into the dataset.                    	*/
/*                                                                      	*/
/*..ELEMENTS....................................................................*/
/*                                                                      	*/
/* TILE_ORDER_NOT_DEFINED - Tile ordering undefined				*/
/* TILE_ORDER_TL_H - Tile ordering starts from the top-left (TL) of the 	*/
/*                   dataset and continues in the horizontal(H)         	*/
/*                   direction  						*/
/* TILE_ORDER_TL_V - Tile ordering starts from the top-left (TL) of the 	*/
/*                   dataset and continues in the vertical(V)           	*/
/*                   direction  						*/
/* TILE_ORDER_TR_H - Tile ordering starts from the top-right (TR) of the	*/
/*                   dataset and continues in the horizontal(H)         	*/
/*                   direction  						*/
/* TILE_ORDER_TR_V - Tile ordering starts from the top-right (TR) of the 	*/
/*                   dataset and continues in the vertical(V)           	*/
/*                   direction  						*/
/* TILE_ORDER_BL_H - Tile ordering starts from the bottom-left (BL) of the 	*/
/*                   dataset and continues in the horizontal(H)         	*/
/*                   direction  						*/
/* TILE_ORDER_BL_V - Tile ordering starts from the bottom-left (BL) of the 	*/
/*                   dataset and continues in the vertical(V)           	*/
/*                   direction  						*/
/* TILE_ORDER_BR_H - Tile ordering starts from the bottom-right (BR) of the 	*/
/*                   dataset and continues in the horizontal(H)        		*/
/*                   direction  						*/
/* TILE_ORDER_BR_V - Tile ordering starts from the bottom-right (BR) of the 	*/
/*                   dataset and continues in the vertical(V)  		      	*/
/*                   direction  						*/
/*------------------------------------------------------------------------------*/

/* begin-def */

typedef enum
{
   TILE_ORDER_NOT_DEFINED,
   TILE_ORDER_TL_H,
   TILE_ORDER_TL_V,
   TILE_ORDER_TR_H,
   TILE_ORDER_TR_V,
   TILE_ORDER_BL_H,
   TILE_ORDER_BL_V,
   TILE_ORDER_BR_H,
   TILE_ORDER_BR_V
} TILE_ORDER_TYPE ;

/* end-def */ 

/* Pixel ordering scheme values                    */

/*----------------------------------------------------------------------*/
/* TYPE ENUM PIXEL_ORDER_TYPE                                           */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines the variety of ways pixels may be stored    */
/* within tiles.                                                        */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/* PIXEL_ORDER_TL_H - Pixel ordering starts from the top-left (TL) of   */
/*                    the tile and continues in the horizontal(H)       */
/*                    direction. 					*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum
{
   PIXEL_ORDER_NOT_DEFINED,
   PIXEL_ORDER_TL_H,
   PIXEL_ORDER_TL_V,
   PIXEL_ORDER_TR_H,
   PIXEL_ORDER_TR_V,
   PIXEL_ORDER_BL_H,
   PIXEL_ORDER_BL_V,
   PIXEL_ORDER_BR_H,
   PIXEL_ORDER_BR_V
} PIXEL_ORDER_TYPE ;

/* end-def */

/**************************************************************************/
/*                                                                        */
/*  REGION REGION REGION REGION REGION REGION REGION REGION REGION REGION */
/*                                                                        */
/**************************************************************************/

/*----------------------------------------------------------------------*/
/* TYPE ENUM REGION_TYPE                                                */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines the variety of ways in which regions may be */
/* created.                                                             */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/* REGION_COPY - The region has its own internal buffer or is provided  */
/*               with a buffer externally by which data is transferred  */
/*               to and from the raster dataset. This type of region    */
/*               should be used if the data is being edited.            */
/* REGION_PTR  - The region has returns pointers to tiles held within   */
/*               the tile cache. This type of region is often used      */
/*               within a loop returning a tile for each loop execution.*/
/*               This type of region is suitable for rapid file access  */
/*               but not data editing.                                  */
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum
{
   REGION_TYPE_NOT_DEFINED,
   REGION_COPY,
   REGION_PTR
} REGION_TYPE ;

/* end-def */

/*----------------------------------------------------------------------*/
/* TYPE ENUM REGION_ALIGNMENT_TYPE                                      */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines the variety of ways in which the data placed*/
/* within the region buffer of a copy-type region is determined by the  */
/* in extent of the region.                                             */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/* REGION_TILE_EXTENDED  - tile aligned region including whole 		*/
/*                         area of the in-extent fo the region.		*/
/* REGION_TILE_REDUCED   - tile aligned region contained within 	*/
/*                         area of the in-extent fo the region.		*/
/* REGION_PIXEL_EXTENDED - pixel aligned region including whole 	*/
/*                         area of the in-extent fo the region.		*/
/* REGION_PIXEL_REDUCED  - pixel aligned region contained within 	*/
/*                         area of the in-extent fo the region.		*/
/* REGION_LEFT_EXTENDED  - pixel and byte aligned region containing 	*/
/*                         whole area of in-extent fo the region by     */
/*                         left extension				*/
/* REGION_RIGHT_EXTENDED - pixel and byte aligned region containing	*/
/*                         whole area of in-extent fo the region by     */
/*			   right extension				*/
/* REGION_LR_EXTENDED    - pixel and byte aligned region containing	*/
/*                         whole area of in-extent of the region with   */
/*			   pixel offset within bytes the same as        */
/*                         storage 					*/
/*                         offset.					*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum
{
   REGION_ALIGNMENT_NOT_DEFINED,
   REGION_TILE_EXTENDED,
   REGION_TILE_REDUCED,
   REGION_PIXEL_EXTENDED,
   REGION_PIXEL_REDUCED,
   REGION_LEFT_EXTENDED,
   REGION_RIGHT_EXTENDED,
   REGION_LR_EXTENDED
} REGION_ALIGNMENT_TYPE ;

/* end-def */

/**************************************************************************/
/*                                                                        */
/*  COMPRESSION COMPRESSION COMPRESSION COMPRESSION COMPRESSION COMPRESSIO*/
/*                                                                        */
/**************************************************************************/

/*----------------------------------------------------------------------*/
/* TYPE ENUM COMPRESSION_TYPE                                           */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*                                                                      */
/* This enumeration defines the variety of compression schemes which may*/
/* be applied to raster data on a per tile basis.                       */
/*                                                                      */
/*..ELEMENTS............................................................*/
/*                                                                      */
/* COMPRESSION_UNCOMPRESSED - do not compress the data. In this		*/
/*                            case no index file is needed. Note	*/
/*                            that if this option is used the 		*/
/*                            LSR format file cannot presently be	*/
/*                            altered so that it can later accept      	*/
/*                            compressed data.				*/
/* COMPRESSION_SINGLE_VALUE - look for tiles with only			*/
/*                            one data value				*/
/* COMPRESSION_BYTE_INDEX_WHITE - remove white (0) bytes from		*/
/*                                the data				*/
/* COMPRESSION_BYTE_INDEX_BLACK - remove black (255) bytes		*/
/*                                from the data				*/
/* COMPRESSION_BYTE_INDEX - remove either white or black 		*/
/*                          bytes from the data depending		*/
/*                          on the best policy				*/
/* COMPRESSION_PACK       - pack a datatype so that only its		*/
/*                          significant bits are stored. 		*/
/* COMPRESSION_PACKBITS   - PACKBITS scheme based on SUN		*/
/*                          image compression scheme			*/
/* COMPRESSION_PACKBITS2  - PACKBITS scheme based on 			*/
/*                          MACINTOSH compression scheme		*/
/* COMPRESSION_PACKBITS2_PACK  - PACKBITS scheme based on 		*/
/*                               MACINTOSH compression scheme		*/
/*                               with literal runs of pixels		*/
/*                               packed. Datatype must be		*/
/*                               one byte in size unpacked.		*/
/* COMPRESSION_PACKBASE   - byte based compression scheme 		*/
/*                          to find run lengths of similar 		*/
/*                          values using byte bit patterns		*/
/* COMPRESSION_PACKBASE_PACK   - byte based compression scheme 		*/
/*                               to find run lengths of similar        	*/
/*                               values using byte bit patterns		*/
/*                               with literal runs of pixels		*/
/*                               packed. Datatype must be one		*/
/*                               byte in size when unpacked.		*/
/* COMPRESSION_PACKBASE2  - byte based compression scheme 		*/
/*                          to find run lengths of similar		*/
/*                          values using numerical values		*/
/* COMPRESSION_PACKBASE2_PACK  - byte based compression scheme 		*/
/*                               to find run lengths of similar		*/
/*                               values using numerical values		*/
/*                               with literal runs of pixels		*/
/*                               packed. Datatype must be		*/
/*                               one byte in size when unpacked.       	*/
/* COMPRESSION_BYTE_INDEX_VALUE - remove bytes of one value from the    */
/*                                data, calculating best byte to remove	*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum
{
   COMPRESSION_UNCOMPRESSED,
   COMPRESSION_SINGLE_VALUE,
   COMPRESSION_BYTE_INDEX_WHITE,
   COMPRESSION_NOT_DEFINED,
   COMPRESSION_BYTE_INDEX_BLACK,
   COMPRESSION_BYTE_INDEX,
   COMPRESSION_PACKBITS,
   COMPRESSION_PACKBITS2,
   COMPRESSION_PACKBASE,
   COMPRESSION_PACKBASE2,
   COMPRESSION_BYTE_INDEX_VALUE,
   COMPRESSION_PACK,
   COMPRESSION_PACKBITS2_PACK,
   COMPRESSION_PACKBASE_PACK,
   COMPRESSION_PACKBASE2_PACK,
   COMPRESSION_PACKBITS2BV_PACK,
   COMPRESSION_PACKBASE2BV_PACK,
   COMPRESSION_PACKBASE2BV,
   COMPRESSION_PACKBITS2BV,
   COMPRESSION_NOCOMPRESSION,
   COMPRESSION_QBYTE_INDEX
} COMPRESSION_TYPE ;

/* end-def */

#endif








/* $Header: /gothic/hdr/rasterlib/v1-20a-4/RCS/hdr.lsr_defns.h,v 1.26 1995/03/13 11:43:51 clarke Exp $								*/
/* 									*/
/* $Log: hdr.lsr_defns.h,v $
 * Revision 1.26  1995/03/13  11:43:51  clarke
 * Version v1-20a-4 derived from v1-20a-3
 * Need to include LSR_GET_PIXEL_ACCESS_PARAMS macro in lsr_access.h
 * because it is required by lsrclib v1-16 and later.
 *
 * Revision 1.25  1995/02/23  15:24:13  clarke
 * Version v1-20a-3 derived from v1-20a-2
 * Optimisation in lsr_access.h which was found be be much faster on VAX
 * and Alpha AXP (VMS)
 * See WICC 479. incorporate optimisation developed on VAX.
 *
 * Revision 1.23  1995/01/06  11:34:01  andyb
 * Version v1-20a-2 derived from v1-20a-1
 *
 * GOTHIC WICC 436.
 *
 * Fix problem in 'mbr_map' function in lsr.c where extra parameters
 * are assigned for 'lsrc_subsample_mbr_map()' and 'lsrc_affine_mbr_map()'
 * when not required resulting in an array bounds write. See GOTHIC error
 * log 477 for details.
 *
 * NB. Also requires lsrclib/v1-15. Copied lsr_external_defns.h and
 * lsr_external_cache_defns.h from rasterlib/v1-21 so lsrclib/v1-15
 * compiles against this version of rasterlib.
 *
 * Revision 1.22  1994/09/06  08:50:50  euanc
 * Version v1-20a-1 derived from v1-20
 * Make the tile hashing function independent of the RAC of the
 * tile to which it is attached. This is good policy anyway and
 * gets around the problem of having index blocks hanging around in the
 * cache which have no corresponding RAC then using the hash function to
 * delete themselves from the hash table.
 * WICC 321.
 * Implement writing through tiled rasters.
 * Fix bug in LSR_GET_NEXT_PIXEL.... macros when the next pixel is in a
 * new tile. The intile pixel position should be updated to the next tile.
 * Fix bug in subsampling of point rasters so that extra pixels are
 * pulled in at the high end of the the input range.
 * Frozen prior to CDCO system tests.
 *
 * Revision 1.21  1994/05/06  08:28:52  davidm
 * Version v1-20 derived from v1-19
 * Include interface to allow general transformation functions.
 * Fix jacket for lsr_set_rac_layered to stop seg falut if no
 * arguments.
 * WICC 284.
 *
 * Revision 1.20  1994/03/14  10:47:02  davida
 * Version v1-19 derived from v1-18
 * Fix a bug in the reference count for the unknown tile of a raster.
 * The reference count should not be decremented when the unknown value
 * for a tile is reset but the raster has not yet been initialised.
 * WICC 269 Error log 148
 *
 * Revision 1.16.1.7  1994/02/16  18:39:10  olivia
 * Version v1-18 derived from v1-17
 * Allow rasters which are input to raster call-backs to be edited within
 * a read call-back. This amounts to calling cache_value_altered for this
 * tile after the call-back has executed. The input raster must be
 * writeable,and it is the responsibility of the call-back to do
 * the editing and to ensure that it doesn't edit the unknown tile etc,etc.
 * WICC 163
 * Update header version number to 7, indicating use of SPAM files.
 * Tidy up tile locking structure to ease development of the side effect
 * editing.
 * Ensure that correct conversion is performed when writing out to files.
 * FIx bug in replication of tile buffers when pixels and tile edges are not
 * coincident.
 *
 * Revision 1.16.1.3  1993/10/07  16:07:25  davidm
 * Version v1-17 derived from v1-16
 * Develop lsr_get_reg_ptr to read the tiles in orders other than
 * top left horizontal
 * WICC 124
 * Replace the option RAST_TL_READ_X_WRITE_XW - that is on write dont do
 * a cache read but do a cache write (??????) with the correct option
 * RAST_TL_READ_X_WRITE_RX - that is the layering callback does a read on
 * a tile,but not a write.
 *
 * Revision 1.16.1.2  1993/08/11  09:34:37  davidr
 * Version v1-16 derived from v1-15
 * WIC 71 - Include FSM calls in the ``lsr_size...'' routines
 * which are altered to return reals.
 * Include new macros in lsr_access.h to deal with a union
 * containing the pointer types supported by reasterlib.
 * Include call to lsr_get_rac_unknown_real to return the
 * unknown value of a raster.
 *
 * Revision 1.16.1.1  1993/07/07  12:48:52  davidr
 * Version v1-15 derived from v1-14
 * Allow conversion of other datatypes to binary bit packed data.
 * .,
 *
 * Revision 1.16  1993/03/10  20:31:26  jon
 * Version v1-14 derived from v1-13
 * Fix a bug in lsr_copy and insert lsr_rename
 *
 * Revision 1.15  1993/02/08  16:45:46  davidm
 * Version v1-13 derived from v1-12
 * Allow scaling of rasters in transform racs to take account of resampling scheme.
 *
 * Revision 1.14  1993/01/15  15:24:49  olivia
 * Version v1-12 derived from v1-11
 * Allow file protection to be changed on data racs.
 * Change the handling of newly created files so that files are only
 * produced when data is to be written out from cache.
 *
 * Revision 1.13  1992/12/03  14:22:34  davidm
 * Version v1-11 derived from v1-10
 * Development of compression schemes using quad searches for areas
 * which compress well.
 * Use of speeded up default nearest neighbour sampling for non-integer replication
 * and subsampling.
 * Fix free memory read problem in `lsr_delete_rac_by_rac'
 * Set lsr_delete to return GOTH__NORMAL if the data files do not exist.
 *
 * Revision 1.12  1992/11/16  14:25:18  davidm
 * Version v1-10 derived from v1-9
 * Change delete functions so that they no longer return GOTH__ATTACH.
 * Remove a bug where the unknown tile pointer was being stored away and then
 * being realloced elsewhere so that the unknown tile was effectively being
 * overwritten.
 *
 * Revision 1.11  1992/10/19  22:42:34  jon
 * Version v1-9 derived from v1-8
 * Enable the setting of different resampling schemes to override the default
 * scheme of nearest neighbour when the transformation is automatically
 * invoked from rasterlib.
 * Add a function to enable a region to mark tiles as edited as they are
 * extracted through ``lsr_get_reg_ptr''. This will facilitate in situ
 * editing of files for raster editing etc..
 * Set an area of memory blatted with zero so this can be shared by all RAcs
 * with unknown value zero, and so save quite large areas of memory.
 * (e.g. c 50k for RGB byte tiles) .
 *
 * Revision 1.10  1992/09/24  15:06:00  davidr
 * Version v1-8 derived from v1-7
 * Automatatic forward mapping of the source data mbr onto the output dataset
 * for the case where no output data window has been explicitly set.
 * Automatic forward mapping of the source data tiling origin onto the
 * output dataset for the case where no tiling origin has been explicitly set.
 *
 * Revision 1.9  1992/09/21  10:18:57  davidm
 * Version v1-7 derived from v1-6
 * Fix a nasty bug relating to the attachment of rasters to regions.
 * Add a jacket for lsr_r_delete_rac.
 *
 * Revision 1.8  1992/09/15  10:30:20  davidm
 * Version v1-6 derived from v1-5
 * Fix a bug in snapping a tiling origin between a transform raster and its
 * source data when the offsets between the tiling origins are negative.
 * Inclusion of routine lsr_packtype_bytes to return the number of bytes
 * associated with a packing type.
 *
 * Revision 1.7  1992/09/06  19:55:17  jon
 * Version v1-5 derived from v1-4
 * To allow the conversion of short integer type datatypes to byte pack
 * datatypes.
 *
 * Revision 1.6  1992/08/26  20:07:47  jon
 * Version v1-4 derived from v1-3
 * fixed bug in 'lsr_set_space_tree'
 * Fixes to support raster transformations for Translate application.
 *
 * Revision 1.5  1992/08/17  09:58:22  davidm
 * Version v1-3 derived from v1-2
 * Inclusion of routines useful for raster import and export.
 * Various bug fixes and checking of enhancements for SMART release.
 *
 * Revision 1.4  1992/05/28  15:44:48  davidm
 * Version v1-2 derived from v1-1-1
 * Development of a raster using a MRB tree for the index.
 * Bug fixes for layering RACs where the layering function is null.
 *
 * Revision 1.3  1992/05/14  12:00:16  davidr
 * Version v1-1-1 derived from v1-1
 * Merge of old system VTRAK work with development version.
 * Miscellaneous bugfixes for SMART
 *
 * Revision 1.2  1992/04/24  13:04:50  jon
 * Version v1-1 derived from v1-0
 * Alternative extracted to enter access version of library.
 * Raster handling of look up tables with more than 256 entries.
 *								*/
