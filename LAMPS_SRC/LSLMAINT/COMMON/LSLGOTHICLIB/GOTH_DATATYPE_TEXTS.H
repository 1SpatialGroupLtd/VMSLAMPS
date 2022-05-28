/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:57:14.000000000 +0000
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
#ifndef _GOTH_DATATYPE_TEXTS
#define _GOTH_DATATYPE_TEXTS
/* $Header: /usr/users/jon/RCS/hdr.goth_datatype_texts.h,v 1.9 1995/01/22 20:01:05 jon Exp $								*/
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Tony J Ibbs, 27-Apr-1990					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		 G O T H _ D A T A T Y P E _ T E X T S 			*/
/*									*/
/* Part of GOTHIC module ALL						*/
/* Version 0.1, Tony J Ibbs 27-Apr-1990					*/
/*									*/
/* Macros to return a textual representation for datatypes and other	*/
/* enumerations, as defined in GOTH_DATATYPES.H				*/
/************************************************************************/

/* Made obsolete on 2/5/91 - delete when sure nolonger needed */

#define OBSOLETE_goth_DT_to_text(type)\
   (type == DT_NULL		? "null"		:\
    type == DT_VOID		? "void"		:\
    type == DT_INTEGER 		? "integer"		:\
    type == DT_STATUS		? "status code"		:\
    type == DT_ID		? "id"			:\
    type == DT_REAL		? "real"		:\
    type == DT_BOOLEAN		? "boolean"		:\
    type == DT_OBJECT_ID	? "object id"		:\
    type == DT_STRING		? "string"		:\
    type == DT_DESCRIPTOR	? "descriptor"		:\
    type == DT_MEM_DESCRIPTOR	? "memory descriptor"	:\
    type == DT_SPECIAL		? "special"		:\
    type == DT_INTRINSIC	? "intrinsic function"	:\
    type == DT_VARIANT		? "variant"		:\
    type == DT_USER		? "user defined"	:\
    "unknown")

/* Made obsolete on 7/3/91 - delete when sure nolonger needed */

#define OBSOLETE_goth_DDT_to_text(type)\
   (type == DDT_INVALID		? "invalid"		:\
    type == DDT_WINDOW		? "graphics window"	:\
    type == DDT_OVERLAY		? "overlay"		:\
    type == DDT_LIST		? "display list"	:\
    type == DDT_COLOUR		? "colour table"	:\
    type == DDT_GRAPHIC		? "graphic"		:\
    type == DDT_TEMPLATE	? "template"		:\
    type == DDT_HISTORY		? "history window"	:\
    type == DDT_STATUS_LIST	? "status code list"	:\
    type == DDT_OBJECT_ID	? "object id"		:\
    type == DDT_STREAM		? "stream"		:\
    type == DDT_EDITOR		? "editor window"	:\
    type == DDT_HYPER		? "hypercard"		:\
    type == DDT_DEVICE		? "device"		:\
    type == DDT_BUFFER		? "device buffer"	:\
    type == DDT_QUERY_TREE	? "query tree"		:\
    type == DDT_LOOKUP		? "lookup"		:\
    type == DDT_COLLECTION	? "collection"		:\
    type == DDT_BLOCKING	? "blocking context"	:\
    type == DDT_RESULT		? "RDB result"		:\
    type == DDT_SCANBUFFER	? "scan buffer"		:\
    type == DDT_SCANENVIRON	? "scan environment"	:\
    type == DDT_LULL_ENVIRONMENT? "LULL environment"	:\
    type == DDT_PORT		? "port"		:\
    type == DDT_ICODE_SEGMENT	? "icode segment"	:\
    type == DDT_BUTTON		? "button box"		:\
    type == DDT_VAC	       	? "version access context":\
    type == DDT_USER_ADDRESS	? "user defined"	:\
    type == DDT_FOLLOW_CONTEXT	? "follow context"	:\
    type == DDT_MARK		? "collection mark"	:\
    type == DDT_RAC		? "raster access context":\
    type == DDT_GRID		? "raster grid"		:\
    type == DDT_REGION		? "raster region"	:\
    type == DDT_EXTENT		? "raster extent"	:\
    "unknown")

/* Made obsolete on 2/5/91 - delete when sure nolonger needed */

#define OBSOLETE_goth_MDT_to_text(type)\
   (type == MDT_INVALID		? "invalid"	:\
    type == MDT_STRING		? "string"	:\
    type == MDT_ARRAY		? "array"	:\
    "unknown")

#endif /* _GOTH_DATATYPE_TEXTS */
