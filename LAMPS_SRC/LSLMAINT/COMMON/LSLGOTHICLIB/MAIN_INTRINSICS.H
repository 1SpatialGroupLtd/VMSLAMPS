/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:03:32.000000000 +0000
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
#ifndef _MAIN_INTRINSICS
#define _MAIN_INTRINSICS
/* $Header: /usr/users/rogera/RCS/hdr.main_intrinsics.h,v 1.11 1994/11/13 20:37:01 rogera Exp $								*/
/* 									*/
/* $Log: hdr.main_intrinsics.h,v $
 * Revision 1.11  1994/11/13  20:37:01  rogera
 * Version v1-10 derived from v1-9
 * see authorisation file.
 * WICC 417.
 *
 * Addition of TELETIFFLIB module allowing export of RACs
 * to TIFF Image files. WICC TELECOMMS 46.
 * some other modules also added
 *
 * Revision 1.10  1994/09/20  18:03:45  adrian
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
 * Revision 1.9  1994/05/19  15:50:37  davida
 * Version v1-8 derived from v1-7
 * Main development version.
 *
 * Add initialisation for xsapilib (See COMMERCIAL WICC 13).
 *
 * Revision 1.8  1994/04/06  20:29:00  davida
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
 * Revision 1.2.1.6  1994/03/08  00:00:21  jon
 * Version v1-5 derived from v1-4
 * compile date and time into 'main_time.o' to avoid recompilation of test_main.c
 * every time
 *
 * Revision 1.2.1.3  1993/09/20  09:47:43  johnh
 * Version v1-4 derived from v1-3
 * Freeze for BNSC IGIS Analysis integration testing.
 *
 * Revision 1.2.1.2  1993/08/24  09:56:41  davida
 * Version v1-3 derived from v1-2
 * development version of main
 *
 * Revision 1.2.1.1  1993/07/16  09:26:50  davidr
 * Version v1-2 derived from v1-1
 * Current development version:
 * Add calls for FINXLIB initialisation routines
 * WICC 14
 * alterations required to implement a more comprehensive -v option
 * WICC 24
 * Removal of two memory leaks when mod_inquire_version() called.
 *
 * Revision 1.2  1993/03/15  18:02:44  davidr
 * Version v1-1 derived from v1-0
 * changes to status code handling and addition of commonly used LULL to 'main's
 * LULL directory
 *
 * Revision 1.1  1993/03/01  11:47:48  olivia
 * Version v1-0 derived from root
 * initial RCS version
 * Frozen for Telecomms System Tests
 *								*/
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    David Radcliffe, 16-Jul-1991				*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		     M A I N _ I N T R I N S I C S 			*/
/*									*/
/* Part of GOTHIC module MAIN						*/
/* Version 0.1, David Radcliffe 16-Jul-1991				*/
/************************************************************************/


/*>>> EXTERN functions from TEST_MAIN.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN main_number_of_ddts						*/
/*......................................................................*/
/* returns the current value of the last DDT enumeration		*/
/* This is needed for functions which maintain arrays with one element	*/
/* for each descriptor datatype.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_INTEGER main_number_of_ddts();
/*----------------------------------------------------------------------*/
/* EXTERN init_library_intrinsics					*/
/*......................................................................*/
/* Routine called by LULL interpreter to tell it about available 	*/
/* library intrinsics.							*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS init_library_intrinsics(GOTH_DESCRIPTOR lull_environ);
/*----------------------------------------------------------------------*/
/* EXTERN init_library_data_types					*/
/*......................................................................*/
/* Routine called by LULL interpreter to tell it about library-specific	*/
/* data-types.								*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS init_library_data_types(GOTH_DESCRIPTOR lull_environ);

/*----------------------------------------------------------------------*/
/* EXTERN main_get_ddt_Lull_desc				        */
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*								        */
/* Return a string containing the Lull constant name for a descriptor   */
/* datatype.  The return value is readonly and should not be modified   */
/* or freed.							        */
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* desc_type	-in- The descriptor type.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STRING 
   main_get_ddt_Lull_desc(GOTH_DESCRIPTOR_DATATYPE	desc_type);
#endif
