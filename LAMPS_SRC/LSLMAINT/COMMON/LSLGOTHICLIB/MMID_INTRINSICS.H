/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 19:03:38.000000000 +0000
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
#ifndef _MMID_INTRINSICS
#define _MMID_INTRINSICS

#include <mmid_defns.h>

/*----------------------------------------------------------------------*/
/* EXTERN mmid_build_colour						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful completion.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS mmid_build_colour(GD_MMID_INTERFACE	*i_ptr,
				     GOTH_STRING	title,
				     GOTH_DESCRIPTOR	parent,
				     GOTH_BOOLEAN	has_shell,
				     Widget		parent_w);
/*----------------------------------------------------------------------*/
/* EXTERN mmid_delete_colour						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful completion.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS mmid_delete_colour(GD_MMID_INTERFACE	i_ptr);
/*----------------------------------------------------------------------*/
/* EXTERN mmid_free_interface						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful completion.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS mmid_free_interface( GD_MMID_INTERFACE i_ptr );

/*----------------------------------------------------------------------*/
/* EXTERN mmid_make_visible_interface					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*..RETURN-CODES........................................................*/
/* GOTH__NORMAL		Successful completion.				*/
/*			Errors from MMILIB.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS mmid_make_visible_interface(GD_BLOCKING	 parent_bc_ptr,
					       GD_MMID_INTERFACE i_ptr,
					   GOTH_INTEGER		*ret_code);
#endif
/* $Header: /usr/users/rogera/RCS/hdr.mmid_intrinsics.h,v 1.11 1994/11/13 20:37:11 rogera Exp $								*/
/* 									*/
/* $Log: hdr.mmid_intrinsics.h,v $
 * Revision 1.11  1994/11/13  20:37:11  rogera
 * Version v1-10 derived from v1-9
 * see authorisation file.
 * WICC 417.
 *
 * Addition of TELETIFFLIB module allowing export of RACs
 * to TIFF Image files. WICC TELECOMMS 46.
 * some other modules also added
 *
 * Revision 1.10  1994/09/20  18:04:06  adrian
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
 * Revision 1.9  1994/05/19  15:51:27  davida
 * Version v1-8 derived from v1-7
 * Main development version.
 *
 * Add initialisation for xsapilib (See COMMERCIAL WICC 13).
 *
 * Revision 1.8  1994/04/06  20:29:10  davida
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
 * Revision 1.2.1.6  1994/03/08  00:00:29  jon
 * Version v1-5 derived from v1-4
 * compile date and time into 'main_time.o' to avoid recompilation of test_main.c
 * every time
 *
 * Revision 1.2  1994/03/08  00:00:28  jon
 * checked in as parent of branch
 *								*/
