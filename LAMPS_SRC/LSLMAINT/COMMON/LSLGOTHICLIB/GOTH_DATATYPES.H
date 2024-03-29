/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 17:57:16.000000000 +0000
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
#ifndef _GOTH_DATATYPES
#define _GOTH_DATATYPES
/* $Header: /usr/users/jon/RCS/hdr.goth_datatypes.h,v 1.9 1995/01/22 20:01:08 jon Exp $								*/
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Tony J Ibbs, 23-Apr-1990					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		      G O T H _ D A T A T Y P E S 			*/
/*									*/
/* Part of GOTHIC module ALL						*/
/* Version 0.1, Tony J Ibbs 23-Apr-1990					*/
/*									*/
/* General datatype related things for the whole GOTHIC package		*/
/*									*/
/* Modified J.M. Billing 10-Oct-1990 					*/
/* 	Now contains definitions of both old and new style object 	*/
/* 	identifiers.							*/
/*									*/
/* 	These are manifested as conditionally compiled alternative	*/
/* 	versions of GOTH_OBJECT_ID.					*/
/* 									*/
/* 	The new object identifier definition is used if the		*/
/* 	GOTH_USE_NEW_OBJECT_ID macro symbol is defined.			*/
/* 									*/
/* 	The GOTH_DUMMY_OBJECT_ID type is included to ensure that	*/
/* 	GOTH_VALUE is always the same size regardless of whether	*/
/* 	it contains the old or the new object id definition.		*/
/*									*/
/* 	The GOTH_DUMMY_OBJECT_ID type is only included in the 		*/
/* 	definition of GOTH_VALUE if the GOTH_USE_DUMMY_OBJECT_ID macro	*/
/* 	symbol is defined.						*/
/* 									*/
/* 	This ensures that libraries which use the new definition	*/
/* 	can be used in the same image as libraries which use		*/
/* 	the new definition, provided they do not expect to pass		*/
/* 	object identifiers to each other.				*/
/* Modified by Dave Radcliffe 10-Mar-92					*/
/*      Old style object ids removed completely				*/
/*									*/
/************************************************************************/



/************************************************************************/
/* If they have not already included CONFIG.H, get it for them		*/
/* (we want it for VOID and VOID_P)					*/
/************************************************************************/

#include "goth_config.h"


/************************************************************************/
/* Define names for the standard GOTHIC `primitive' datatypes		*/
/* In general, these should be used in preference to `standard' C	*/
/* datatypes wherever portability might possibly be helped...		*/
/*									*/
/* NOTE that the following are all pointers:				*/
/* 									*/
/*		GOTH_STRING						*/
/*		GOTH_DESCRIPTOR		(even though DESCRIPTOR wasn't)	*/
/*		GOTH_SPECIAL		(which isn't obvious!)		*/ 
/*		GOTH_MEM_DESCRIPTOR	(ditto)				*/
/*		GOTH_ADDRESS		(which is obvious!)		*/ 
/*		GOTH_INTRINSIC		(if you think about it)		*/
/************************************************************************/

typedef unsigned char			 GOTH_BYTE;
typedef unsigned short int		 GOTH_WORD;
typedef char				 GOTH_CHAR;
#if USE_PLATFORM == PLAT_A3
typedef int       			 GOTH_INTEGER;
typedef int       			 GOTH_STATUS;
typedef int       			 GOTH_ID;
#else
typedef long int			 GOTH_INTEGER;
typedef long int			 GOTH_STATUS;
typedef long int			 GOTH_ID;
#endif
typedef double				 GOTH_REAL;
typedef int				 GOTH_BOOLEAN;
typedef char				*GOTH_STRING;
typedef struct _goth_object_id		 GOTH_OBJECT_ID;
typedef struct _goth_descriptor		*GOTH_DESCRIPTOR;
typedef struct _goth_mem_descriptor	*GOTH_MEM_DESCRIPTOR;
typedef struct _goth_user_address	 GOTH_USER_ADDRESS;
typedef struct _goth_typed_value	 GOTH_TYPED_VALUE;
typedef VOID_P				 GOTH_SPECIAL;
typedef VOID_P				 GOTH_ADDRESS;
typedef union _goth_value		 GOTH_VALUE;
typedef GOTH_STATUS (*GOTH_INTRINSIC)(GOTH_INTEGER	num_params,
				      GOTH_VALUE		*params,
				      GOTH_VALUE		*result);


typedef char				GOTH_SCRATCH[12];

/* typedefs for bit-bashing - chars shorts and ints are fortunately 	*/
/* 8,16 and 32 bits respectively on all our platforms - even ALPHA      */

typedef char			GOTH_1S_INTEGER;
typedef unsigned char			GOTH_1U_INTEGER;
typedef short			GOTH_2S_INTEGER;
typedef unsigned short			GOTH_2U_INTEGER;
typedef int			GOTH_4S_INTEGER;
typedef unsigned int			GOTH_4U_INTEGER;


/* Date and time types							*/
/* 									*/
/* 	date	dd-mmm-yyyy	with lower case letters for month	*/
/* 	time	hh:mm:ss.hh						*/

#define GOTH_DATE_SIZE 12
#define GOTH_TIME_SIZE 12
typedef	char				GOTH_DATE[GOTH_DATE_SIZE];
typedef	char				GOTH_TIME[GOTH_TIME_SIZE];


/*----------------------------------------------------------------------*/
/* TYPE ENUM GOTH_DATATYPE						*/
/* DESCRIPTION								*/
/* 									*/
/* The elements of this enumeration are used for indicating the		*/
/* datatypes of values within the Gothic enivironment. These		*/
/* elements are available in both C and Lull.				*/
/* 									*/
/* ELEMENTS								*/
/* 									*/
/* DT_NULL		- A null, or invalid, datatype.			*/
/* 									*/
/* DT_VOID		- A void type					*/
/* 									*/
/* DT_INTEGER		- An integer type				*/
/* 									*/
/* DT_STATUS		- A status code type				*/
/* 									*/
/* DT_ID		- A numeric identifier type			*/
/* 									*/
/* DT_REAL		- A real (floating point) type			*/
/* 									*/
/* DT_BOOLEAN		- A boolean (TRUE | FALSE) type			*/
/* 									*/
/* DT_OBJECT_ID		- An object identifier type			*/
/* 									*/
/* DT_STRING		- A (text) string type				*/
/* 									*/
/* DT_DESCRIPTOR	- A descriptor type (usually qualified by a	*/
/* 			  separate descriptor datatype.			*/
/* 									*/
/* DT_MEM_DESCRIPTOR	- A memory descriptor type (internal to the	*/
/* 			  Gothic environment).				*/
/* 									*/
/* DT_SPECIAL		- A pointer type				*/
/* 									*/
/* DT_INTRINSIC		- An intrinsic function type			*/
/* 									*/
/* DT_VARIANT		- A variant type, which can be used to match	*/
/* 			  any type.					*/
/* 									*/
/* DT_USER		- A user defined type				*/
/* 									*/
/* DT_SCRATCH		- A general purpose scratch area type		*/
/* 									*/
/* DT_DATE		- A date type (dd-mmm-yyyy format)		*/
/* 									*/
/* DT_TIME		- A time type (hh:mm:ss.hh format)		*/
/*									*/
/* DT_ADDRESS		- A pointer type - just copied as an address   	*/
/* 									*/
/* DT_DELETABLE_DESCRIPTOR						*/
/* 			- A descriptor type (usually qualified by a	*/
/* 			  separate descriptor datatype) that will be	*/
/* 			  freed up by GENLIB				*/
/* 									*/
/* DT_TYPED_VALUE	- A type and pointer to another GOTH_VALUE	*/
/* 									*/
/* DT_COPY_DELETABLE_DESCRIPTOR						*/
/*			- A descriptor type (usually qualified by a	*/
/*			  separate descriptor datatype) that will be	*/
/*			  copied/duplicated by GENLIB, and destroyed/	*/
/*			  freed by GENLIB				*/
/* 									*/
/* DT_COPY_MEM_DESCRIPTOR						*/
/*			- A mem descriptor which will be copied by      */
/*			  goth_value_copy so that all the data		*/
/*			  is also copied instead of a straight		*/
/*		          pointer assignment.				*/
/* 									*/
/* DT_FLAGGED_OBJECT_ID							*/
/* 			- A flagged object id.				*/
/* 									*/
/* DT_CLASS		- A datatype which represents a class.		*/
/* 									*/
/* DT_ENDMARKER		- Used for internal housekeeping		*/
/* 									*/
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum
{
   DT_NULL,
   DT_VOID,
   DT_INTEGER,
   DT_STATUS,
   DT_ID,
   DT_REAL,
   DT_BOOLEAN,
   DT_OBJECT_ID,
   DT_STRING,
   DT_DESCRIPTOR,
   DT_MEM_DESCRIPTOR,
   DT_SPECIAL,
   DT_INTRINSIC,
   DT_VARIANT,
   DT_USER,
   DT_SCRATCH,
   DT_DATE,
   DT_TIME,
   DT_ADDRESS,
   DT_DELETABLE_DESCRIPTOR,
   DT_TYPED_VALUE,
   DT_COPY_DELETABLE_DESCRIPTOR,
   DT_COPY_MEM_DESCRIPTOR,
   DT_FLAGGED_OBJECT_ID,
   DT_CLASS,
   DT_ENDMARKER
} GOTH_DATATYPE;

/* end-def */

#define GOTH_FIRST_DT DT_NULL
#define GOTH_LAST_DT  DT_ENDMARKER
#define GOTH_DT_MAX_CHAR 32

/* NB NO description for DT_ENDMARKER - this is for keeping track
   of the array length */

#define GOTH_DT_DESCRIPTION \
{\
   "null",\
   "void",\
   "integer",\
   "status code",\
   "id",\
   "real",\
   "boolean",\
   "object id",\
   "string",\
   "descriptor",\
   "memory descriptor",\
   "special",\
   "intrinsic function",\
   "variant",\
   "user defined",\
   "scratch area", \
   "date", \
   "time", \
   "address", \
   "deletable descriptor", \
   "typed value", \
   "copy/deletable descriptor", \
   "copy memory descriptor", \
   "flagged object id", \
   "class" \
}

#define GOTH_DT_LULL_CONSTANT \
{\
   "DT_NULL",\
   "DT_VOID",\
   "DT_INTEGER",\
   "DT_STATUS",\
   "DT_ID",\
   "DT_REAL",\
   "DT_BOOLEAN",\
   "DT_OBJECT_ID",\
   "DT_STRING",\
   "DT_DESCRIPTOR",\
   "DT_MEM_DESCRIPTOR",\
   "DT_SPECIAL",\
   "DT_INTRINSIC",\
   "DT_VARIANT",\
   "DT_USER",\
   "DT_SCRATCH",\
   "DT_DATE",\
   "DT_TIME",\
   "DT_ADDRESS",\
   "DT_DELETABLE_DESCRIPTOR",\
   "DT_TYPED_VALUE",\
   "DT_COPY_DELETABLE_DESCRIPTOR",\
   "DT_COPY_MEM_DESCRIPTOR",\
   "DT_FLAGGED_OBJECT_ID",\
   "DT_CLASS",\
   "DT_ENDMARKER"\
}


/************************************************************************/
/* Include descriptor datatype enumeration.				*/
/************************************************************************/

#include "ddt_enum.h"


/************************************************************************/
/* An enumeration of the possible types of memory descriptor.		*/
/************************************************************************/

typedef enum
{
   MDT_INVALID,		/* this indicates a non-valid descriptor block	*/
   MDT_STRING,		/* the memory holds a string			*/
   MDT_ARRAY,		/* the memory holds an array			*/
   MDT_STRING_ARRAY,	/* the memory holds a string array		*/
   MDT_SCRATCH,	        /* the memory holds a scratch byte array	*/
   MDT_ENDMARKER
} GOTH_MEM_DESCRIPTOR_DATATYPE;

#define GOTH_FIRST_MDT MDT_INVALID
#define GOTH_LAST_MDT MDT_SCRATCH
#define GOTH_MDT_MAX_CHAR 40

#define GOTH_MDT_DESCRIPTION \
{ \
   "Invalid", \
   "String", \
   "Array", \
   "String array", \
   "Scratch" \
}

#define GOTH_MDT_LULL_CONSTANT \
{ \
   "MDT_INVALID", \
   "MDT_STRING", \
   "MDT_ARRAY", \
   "MDT_STRING_ARRAY", \
   "MDT_SCRATCH" \
}


/************************************************************************/
/* Define the structures we need for GOTH_OBJECT_ID and our descriptors	*/
/*									*/
/* For object ids, we have three fields:				*/
/* 									*/
/* 	.id1		First identifier field				*/
/* 	.id2		Second identifier field				*/
/* 	.class_id	Class id for object's class			*/
/*									*/
/* For descriptors, we have:						*/
/*									*/
/*	.type	what type of SOD we are pointing to			*/
/*	.sod	points to the actual datastructure			*/
/*		(ie, to the Specialised Object Datastructure)		*/
/*	.refs	provides a reference count for this descriptor		*/
/*	.info	points to additional data				*/
/*									*/
/* For memory descriptors, we have:					*/
/*									*/
/*	.type		what type of memory we are pointing to		*/
/*	.element_count	the number of `elements' in that memory		*/
/*	.memory		points to the allocated memory			*/
/*	.next		the next memory descriptor in this frame	*/
/*									*/
/* For user defined types, we have:					*/
/*									*/
/*	.type		User defined data type type??			*/
/*	.value		The users defined data type value		*/
/* GOTH_DESCRIPTOR_SIZE and GOTH_MEM_DESCRIPTOR_SIZE are provided to	*/
/* allow statements of the form:					*/
/*									*/
/*	GOTH_DESCRIPTOR  desc;						*/
/*	desc = (GOTH_DESCRIPTOR) malloc(GOTH_DESCRIPTOR_SIZE);		*/
/*									*/
/* without needing to worry about the name of the actual structure.	*/
/************************************************************************/

/* Object identifier definitions */

/* Object identifier structure */

struct _goth_object_id
{ 
   GOTH_ID	id1;
   GOTH_ID	id2;
   GOTH_ID	class_id;
};

/* Null object identifier */

static GOTH_OBJECT_ID goth_null_object_id = {0,0,0};

/* Macros used for dealing with the object identifier */

#define GOTH_GET_OBJECT_CLASS_ID(obj) ((obj).class_id)

/* Macro to set cluster key in object. */

#define GOTH_SET_OBJECT_CLASS_ID(obj, class) ((obj).class_id = class)

/* Macro to retrieve cluster key from object. */

#define GOTH_GET_OBJECT_CLUSTER(obj) ((obj).id2)

/* Macro to set cluster key in object. */

#define GOTH_SET_OBJECT_CLUSTER(obj, cluster) ((obj).id2 = cluster)

#define GOTH_SAME_OBJECT_ID(obj1,obj2) \
   ((((obj1).class_id == (obj2).class_id) && \
     ((obj1).id1 == (obj2).id1) && \
     ((obj1).id2 == (obj2).id2)) ? TRUE : FALSE)

#define GOTH_COMPARE_OBJECT_ID(obj1,obj2) \
   (((obj1).class_id < (obj2).class_id) ? GOTH__LT : \
    ((obj1).class_id > (obj2).class_id) ? GOTH__GT : \
    ((obj1).id2      < (obj2).id2     ) ? GOTH__LT : \
    ((obj1).id2      > (obj2).id2     ) ? GOTH__GT : \
    ((obj1).id1      < (obj2).id1     ) ? GOTH__LT : \
    ((obj1).id1      > (obj2).id1     ) ? GOTH__GT : GOTH__EQ)

#define GOTH_COMPARE_CLUST_OBJECT_ID(obj1,obj2) \
   (((obj1).id2      < (obj2).id2     ) ? GOTH__LT : \
    ((obj1).id2      > (obj2).id2     ) ? GOTH__GT : \
    ((obj1).class_id < (obj2).class_id) ? GOTH__LT : \
    ((obj1).class_id > (obj2).class_id) ? GOTH__GT : \
    ((obj1).id1      < (obj2).id1     ) ? GOTH__LT : \
    ((obj1).id1      > (obj2).id1     ) ? GOTH__GT : GOTH__EQ)

#define GOTH_PRINT_OBJECT_ID(stream,obj) \
   goth_printf((stream),"[%d,%d,%d]",(obj).class_id,(obj).id2,(obj).id1)

#define GOTH_SPRINT_OBJECT_ID(string,obj) \
   (sprintf((string),"[%ld,%ld,%ld]",(obj).class_id,(obj).id2,(obj).id1),(string))

#define GOTH_OBJECT_ID_LENGTH 40

struct _goth_descriptor
{
   GOTH_DESCRIPTOR_DATATYPE	type;
   GOTH_SPECIAL			sod;
   unsigned int			refs;
   VOID_P			info;
};

struct _goth_mem_descriptor
{
   GOTH_MEM_DESCRIPTOR_DATATYPE	type;
   GOTH_INTEGER			element_count;
   GOTH_SPECIAL			memory;
   GOTH_MEM_DESCRIPTOR		next;
};

#define  GOTH_DESCRIPTOR_SIZE		sizeof(struct _goth_descriptor)
#define  GOTH_MEM_DESCRIPTOR_SIZE	sizeof(struct _goth_mem_descriptor)
#define	 GOTH_MD_ELEMENT_COUNT(md)	(md)->element_count
#define	 GOTH_MD_DATATYPE(md)		((md)->type == MDT_STRING_ARRAY) ? MDT_ARRAY : (md)->type

struct _goth_user_address
{
   GOTH_DESCRIPTOR	user_addr_id;
   VOID_P		user_data;
};

struct _goth_typed_value
{
   GOTH_DATATYPE	type;
   GOTH_VALUE		*value_ptr;
};


/************************************************************************/
/* And a union of the standard datatypes, for use in passing things	*/
/* around, when we allow any of several datatypes:			*/
/************************************************************************/

union _goth_value
{
   GOTH_INTEGER			integer;
   GOTH_STATUS			status;
   GOTH_ID			id;
   GOTH_REAL			real;
   GOTH_BOOLEAN			boolean;
   GOTH_OBJECT_ID		object_id;
   GOTH_STRING			string;			/* pointer */
   GOTH_DESCRIPTOR		descriptor;		/* pointer */
   GOTH_MEM_DESCRIPTOR		mem_descriptor;		/* pointer */
   GOTH_SPECIAL			special;		/* pointer */
   GOTH_INTRINSIC		intrinsic;		/* pointer */
   GOTH_USER_ADDRESS		user_address;
   GOTH_SCRATCH			scratch;
   GOTH_DATE			date;			/* dd-mmm-yyyy */
   GOTH_TIME			time;			/* hh:mm:ss.hh */
   GOTH_ADDRESS			address;
   GOTH_TYPED_VALUE	       	typed_value;
};


/************************************************************************/
/* The following structures may or may not be of use to general GOTHIC	*/
/* modules. We include them in case they are found to be necessary or	*/
/* even just occasionally useful. If you DO use them, please let	*/
/* Jonathan Billing know...						*/
/*									*/
/* GOTH_TYPEPAIR represents a fully defined datatype definition.	*/
/*									*/
/*	.type		is a datatype chosen from GOTH_DATATYPE.	*/
/*	.subtype	is the `sub' datatype if .type is a descriptor	*/
/*			datatype					*/
/*									*/
/* GOTH_TYPEDVALUE then represents a {datatype,value} pair (ie, a	*/
/* `strongly' typed value), where					*/
/*									*/
/*	 	.type		is the datatype of			*/
/*		.value		the value field				*/
/************************************************************************/

typedef struct
{
   GOTH_DATATYPE		type;
   union
   {
      GOTH_DESCRIPTOR_DATATYPE		ddt;
      GOTH_MEM_DESCRIPTOR_DATATYPE	mdt;
   } subtype;
} GOTH_TYPEPAIR;

typedef struct
{
   GOTH_TYPEPAIR		type;
   GOTH_VALUE			value;
} GOTH_TYPEDVALUE;

#endif /* _GOTH_DATATYPES */


