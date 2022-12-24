/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:03:34.000000000 +0000
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
#ifndef _MAIN_VTYPE_DEFNS
#define _MAIN_VTYPE_DEFNS


/*----------------------------------------------------------------------*/
/* Definition of macro to determine if version type is a checkpoint.    */
/*----------------------------------------------------------------------*/

#define DICT_VTYPE_IS_CHECKPOINT(type) ((type) < 0)
#define DICT_CHECKPOINT_VTYPE(type) (-(type))
#define DICT_UNCHECKPOINT_VTYPE(type) (-(type))


/*----------------------------------------------------------------------*/
/* TYPE ENUM DICT_VERSION_TYPE                                          */
/* DESCRIPTION                                                          */
/* The version type enumeration contains elements corresponding to      */
/* each of the types of version which can be present in the             */
/* database. The version types usually correspond to the use to which   */
/* the version is put, either by applications or by the Gothic          */
/* environment                                                          */
/*                                                                      */
/* ELEMENTS                                                             */
/*                                                                      */
/* VTYPE_INVALID -              Invalid version type.                   */
/*                                                                      */
/* VTYPE_GENERAL -              A general version type.                 */
/*                                                                      */
/* VTYPE_BASE -                 The root version in the version tree.   */
/*                                                                      */
/* VTYPE_VTRAK_FPARAM -         A version containing following          */
/*                              parameters for VTRAK.                   */
/*                                                                      */
/* VTYPE_SPACE -                A space and transformations dataset.    */
/*                                                                      */
/* VTYPE_VECTOR -               A vector dataset.                       */
/*                                                                      */
/* VTYPE_RASTER -               A raster dataset.                       */
/*                                                                      */
/* VTYPE_PRE_RASTER -           A pre-structured raster dataset.        */
/*                                                                      */
/* VTYPE_STRUCT_RASTER -        A raster dataset being `structured'.    */
/*                                                                      */
/* VTYPE_OBSOLETE_1 -           OBSOLETE ELEMENT                        */
/*                                                                      */
/* VTYPE_IGIS_RASTER -          A raster dataset for IGIS.              */
/*                                                                      */
/* VTYPE_ISIS -                 An ISIS (help) dataset                  */
/*									*/
/* VTYPE_LVC -			Version resulting from linear		*/
/* 				version compression and replacement	*/
/* 				operation.				*/
/* 									*/
/* VTYPE_MAPLIB -		Version containing special map library	*/
/* 				information in a schema setup by dinlib	*/
/*                                                                      */
/* VTYPE_RASTDB	-		Version containing exclusively raster	*/
/* 				data					*/
/* 									*/
/* VTYPE_SCRATCH -		Version containg scratch-pad data	*/
/* 									*/
/* VTYPE_XLATE - 		Version containing format 		*/
/* 				specifications for translate		*/
/* 									*/
/* VTYPE_CP -			Version containing Control Point	*/
/* 				information for registration of		*/
/* 				datasets				*/
/* 									*/
/* VTYPE_BATCH -		Version created for translate		*/
/* 				batch jobs from XLATE versions 		*/
/*									*/
/* VTYPE_DTM - 			Version containing dtm data - version	*/
/*				created using rastdblib - reason for	*/
/*				having a different type is so that	*/
/*			        version frame can be used to list	*/
/*				dtms only				*/
/*									*/
/* VTYPE_TREC - 		Version containing text recognition	*/
/* 				learnt symbol templates			*/
/* 									*/
/* VTYPE_UES -			Version containing User Environment	*/
/*				Store for UESLIB			*/
/*									*/
/* VTYPE_GAZETTEER -            Version containing gazetteer data.      */
/*									*/
/* VTYPE_METHOD -		Version containing globally stored	*/
/* 				Method behaviours for the methodframe	*/
/*									*/
/* VTYPE_ENDMARKER -            This endmarker element is used for      */
/*                              internal housekeeping.                  */
/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/* Definition of the version type enumeration. New version types        */
/* should be added as required.                                         */
/*                                                                      */
/* When a new element is added to the enumeration, the following steps  */
/* should be followed:                                                  */
/*                                                                      */
/*      1) Add the enumeration element just before VTYPE_ENDMARKER      */
/*                                                                      */
/*      2) Add a textual description of the new element to the          */
/*         end of the list DICT_VTYPE_DESCRIPTION.                      */
/*                                                                      */
/*      3) Add the name of the corresponding Lull constant to the       */
/*         end of the DICT_VTYPE_LULL_CONSTANT list.                    */
/*                                                                      */
/*      4) The Lull constant names and description strings should not   */
/*         exceed DICT_VTYPE_MAX_CHAR-1 characters in length.           */
/*                                                                      */
/*      5) Add a description of the enumeration element to the comment  */
/*         above, to ensure that it is documented.                      */
/*									*/
/* 	6) Change DICT_LAST_VTYPE to indicate the new last element	*/
/* 	   in the enumeration.						*/
/*                                                                      */
/*----------------------------------------------------------------------*/

/* begin-def */

typedef enum
{
   VTYPE_INVALID,
   VTYPE_GENERAL,
   VTYPE_BASE,
   VTYPE_VTRAK_FPARAM,
   VTYPE_SPACE,
   VTYPE_VECTOR,
   VTYPE_RASTER,
   VTYPE_PRE_RASTER,
   VTYPE_STRUCT_RASTER,
   VTYPE_OBSOLETE_1,
   VTYPE_IGIS_RASTER,
   VTYPE_ISIS,
   VTYPE_LVC,
   VTYPE_MAPLIB,
   VTYPE_RASTDB,
   VTYPE_SCRATCH,
   VTYPE_XLATE,
   VTYPE_CP,
   VTYPE_BATCH,
   VTYPE_DTM,
   VTYPE_TREC,
   VTYPE_UES,
   VTYPE_GAZETTEER,
   VTYPE_METHOD,
   VTYPE_ENDMARKER,

   /* Entries added to ensure that negative enumeration values, as used by DICTLIB */
   /* are also legal. */
   /* All elements added to the enumeration should have a corresponding entry added */
   /* here. */
   /* There is no need to add the elements after this comment to either of the array  */
   /* initialisers below. */
   /* These elements are needed to force the enumeration to be a signed integer rather */
   /* than an unsigned integer, which is the default for some compilers. DICTLIB */
   /* uses the negative elements internally to indicate that a version has been  */
   /* checkpointed. */

   VTYPE_CKPT_GENERAL = -VTYPE_GENERAL,
   VTYPE_CKPT_BASE = -VTYPE_BASE,
   VTYPE_CKPT_VTRAK_FPARAM = -VTYPE_VTRAK_FPARAM,
   VTYPE_CKPT_SPACE = -VTYPE_SPACE,
   VTYPE_CKPT_VECTOR = -VTYPE_VECTOR,
   VTYPE_CKPT_RASTER = -VTYPE_RASTER,
   VTYPE_CKPT_PRE_RASTER = -VTYPE_PRE_RASTER,
   VTYPE_CKPT_STRUCT_RASTER = -VTYPE_STRUCT_RASTER,
   VTYPE_CKPT_OBSOLETE_1 = -VTYPE_OBSOLETE_1,
   VTYPE_CKPT_IGIS_RASTER = -VTYPE_IGIS_RASTER,
   VTYPE_CKPT_ISIS = -VTYPE_ISIS,
   VTYPE_CKPT_LVC = -VTYPE_LVC,
   VTYPE_CKPT_MAPLIB = -VTYPE_MAPLIB,
   VTYPE_CKPT_RASTDB = -VTYPE_RASTDB,
   VTYPE_CKPT_SCRATCH = -VTYPE_SCRATCH,
   VTYPE_CKPT_XLATE = -VTYPE_XLATE,
   VTYPE_CKPT_CP = -VTYPE_CP,
   VTYPE_CKPT_BATCH = -VTYPE_BATCH,
   VTYPE_CKPT_DTM = -VTYPE_DTM,
   VTYPE_CKPT_TREC = -VTYPE_TREC,
   VTYPE_CKPT_UES = -VTYPE_UES,
   VTYPE_CKPT_GAZETTEER = -VTYPE_GAZETTEER,
   VTYPE_CKPT_METHOD = -VTYPE_METHOD,
   VTYPE_CKPT_ENDMARKER = -VTYPE_ENDMARKER
} DICT_VERSION_TYPE;

/* end-def */

#define DICT_FIRST_VTYPE VTYPE_INVALID
#define DICT_LAST_VTYPE VTYPE_METHOD

#define DICT_VTYPE_MAX_CHAR 51

#define DICT_VTYPE_DESCRIPTION \
{ \
   "Invalid", \
   "General", \
   "Base", \
   "VTRAK fol-params", \
   "Space", \
   "Geographic", \
   "VTRAK raster", \
   "VTRAK pre-raster", \
   "Obsolete1", \
   "Obsolete2", \
   "IGIS raster", \
   "Help", \
   "LVC", \
   "Map library", \
   "Raster", \
   "Scratch", \
   "Translate", \
   "Control point", \
   "Translate batch", \
   "DTM", \
   "VTRAK txt-params", \
   "User", \
   "Gazetteer", \
   "Methods" \
}
/*   VTYPE_ENDMARKER only here for searching purposes */

#define DICT_VTYPE_CHECKPOINT " (Checkpoint)"

#define DICT_VTYPE_LULL_CONSTANT \
{ \
   "VTYPE_INVALID", \
   "VTYPE_GENERAL", \
   "VTYPE_BASE", \
   "VTYPE_VTRAK_FPARAM", \
   "VTYPE_SPACE", \
   "VTYPE_VECTOR", \
   "VTYPE_RASTER", \
   "VTYPE_PRE_RASTER", \
   "VTYPE_STRUCT_RASTER", \
   "VTYPE_OBSOLETE_1", \
   "VTYPE_IGIS_RASTER", \
   "VTYPE_ISIS", \
   "VTYPE_LVC", \
   "VTYPE_MAPLIB", \
   "VTYPE_RASTDB", \
   "VTYPE_SCRATCH", \
   "VTYPE_XLATE", \
   "VTYPE_CP", \
   "VTYPE_BATCH", \
   "VTYPE_DTM", \
   "VTYPE_TREC", \
   "VTYPE_UES", \
   "VTYPE_GAZETTEER", \
   "VTYPE_METHOD" \
}

/*   VTYPE_ENDMARKER only here for searching purposes */

extern GOTH_INTEGER main_vtype_count();
extern GOTH_STRING main_vtype_description(GOTH_INTEGER vtype);
extern GOTH_STRING main_vtype_lull_constant(GOTH_INTEGER vtype);

/* $Header: /usr/users/rogera/RCS/hdr.main_vtype_defns.h,v 1.11 1994/11/13 20:37:06 rogera Exp $								*/
/* 									*/
/* $Log: hdr.main_vtype_defns.h,v $
 * Revision 1.11  1994/11/13  20:37:06  rogera
 * Version v1-10 derived from v1-9
 * see authorisation file.
 * WICC 417.
 *
 * Addition of TELETIFFLIB module allowing export of RACs
 * to TIFF Image files. WICC TELECOMMS 46.
 * some other modules also added
 *
 * Revision 1.10  1994/09/20  18:03:53  adrian
 * Version v1-9 derived from v1-8
 * Gothic WICC 323
 *
 * Include initialisation of new modules.
 *
 * Include new error codes.
 *
 * Added topological model and spatial index VAC/DED roles.
 *
 * Add DED and VDED for metalib (ADE v2 schema) plus a load of new
 * metalib error codes.
 *
 * Move definition of Lull recover directory from the local sos init file
 * to the main file sos_unix_init.lull.
 *
 * Revision 1.9  1994/05/19  15:50:55  davida
 * Version v1-8 derived from v1-7
 * Main development version.
 *
 * Add initialisation for xsapilib (See COMMERCIAL WICC 13).
 *
 * Revision 1.8  1994/04/06  20:29:04  davida
 * Version v1-7 derived from v1-5
 * See Gothic WICC 263.
 *
 * Extracted to allow ongoing additions like status codes.
 *
 * NETXLIB declarations added.
 *
 * Added SOSes for UNIX domain sockets (`port:') and for method Lull source code
 * (`methods:').
 *
 * Revision 1.2.1.6  1994/03/08  00:00:23  jon
 * Version v1-5 derived from v1-4
 * compile date and time into 'main_time.o' to avoid recompilation of test_main.c
 * every time
 *
 * Revision 1.2.1.3  1993/09/20  09:47:49  johnh
 * Version v1-4 derived from v1-3
 * Freeze for BNSC IGIS Analysis integration testing.
 *
 * Revision 1.2.1.2  1993/08/24  09:56:54  davida
 * Version v1-3 derived from v1-2
 * development version of main
 *
 * Revision 1.2.1.1  1993/07/16  09:26:55  davidr
 * Version v1-2 derived from v1-1
 * Current development version:
 * Add calls for FINXLIB initialisation routines
 * WICC 14
 * alterations required to implement a more comprehensive -v option
 * WICC 24
 * Removal of two memory leaks when mod_inquire_version() called.
 *
 * Revision 1.2  1993/03/15  18:02:52  davidr
 * Version v1-1 derived from v1-0
 * changes to status code handling and addition of commonly used LULL to 'main's
 * LULL directory
 *
 * Revision 1.1  1993/03/01  11:47:53  olivia
 * Version v1-0 derived from root
 * initial RCS version
 * Frozen for Telecomms System Tests
 *								*/
#endif
