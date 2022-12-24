/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1994-04-19 18:35:44.000000000 +0100
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
#ifndef _UES_DEFNS
#define _UES_DEFNS

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Adrian Cuthbert,  6-Apr-1992				*/
/************************************************************************/

/************************************************************************/
/*									*/
/*			   U E S _ D E F N S 				*/
/*									*/
/* Part of GOTHIC module UESLIB						*/
/* Version 0.1, Adrian Cuthbert  6-Apr-1992				*/
/************************************************************************/

#endif
/* $Header: /lslhome/gothic/hdr/ueslib/v1-11/RCS/hdr.ues_defns.h,v 1.12 1994/02/16 19:19:21 jon Exp $								*/
/* 									*/
/* $Log: hdr.ues_defns.h,v $
 * Revision 1.12  1994/02/16  19:19:21  jon
 * Version v1-11 derived from v1-10
 * TOPOPRIMLIB uses UESLIB technology to store its rules. Some of the
 * private UESLIB routines need to be made public.
 * See WICC 137
 * Also included changes described in WICC 151
 *
 * Revision 1.11  1993/09/10  21:06:08  stevewi
 * Version v1-10 derived from v1-9
 * Add ISSUE_LULLS = _ues_prototypes.lull
 * to makefile to allow user customisation of Analysis.
 *
 * See WICC GOTHIC 130
 * Freeze for BNSC IGIS Analysis integration testing.
 *
 * Revision 1.10  1993/07/08  20:12:33  adrian
 * Version v1-9 derived from v1-8
 * Make extensions to the LULL part of ueslib to add three functions:
 * ues_build_name form
 * ues_do_name_blocking
 * ues_destroy_name_form
 * To enable multiple forms to be created with different parents.
 * See WICC GOTHIC 25
 *
 * Revision 1.9  1993/03/26  20:01:49  olivia
 * Version v1-8 derived from v1-7
 * Change to ues_get_name to clear text field if supplied
 * name is not in list. Otherwise get strange hangovers
 * between selections.
 *
 * Revision 1.8  1993/03/15  12:58:24  olivia
 * Version v1-7 derived from v1-6
 * New lull include mechanism
 * Modified the callbacks that cope with value-records to convert any NULL
 * strings returned by PMSXLIB back to zero-length strings.
 *
 * Revision 1.7  1993/03/03  18:14:51  olivia
 * Version v1-6 derived from v1-5
 * Introduce routine `ues_get_name()' for use by frames.
 *
 * Revision 1.6  1993/01/04  15:57:45  olivia
 * Version v1-5 derived from v1-4
 * Fix a bug in the callback to store/load the contents of a VR which causes a
 * failure when the VR's internal index and the user-supplied id's do not match.
 * Fixed some leaks
 *
 * Revision 1.5  1992/09/22  22:16:32  jon
 * Version v1-4 derived from v1-3
 * Extracted to replace calls to `lullx_invoke_lcc()' with calls to
 * `lullx_invoke_lcc2()' and to make the UES routines return any erros
 * passed back to them by the storage and retrieval callbacks, rather than
 * simply returning GOTH__ERROR whenever there is a problem.
 *
 * Revision 1.4  1992/08/26  20:05:13  jon
 * Version v1-3 derived from v1-2
 * Extracted to fix descriptor deletion which could result in a
 * descriptor with a name being recusively deleted as a result of
 * deleting a different descriptor.
 *
 * Revision 1.3  1992/08/10  19:38:18  adrian
 * Version v1-2 derived from v1-1
 * Addition of a routine to allow overwrite of stored description.
 *
 * Revision 1.2  1992/07/13  17:29:08  adrian
 * Version v1-1 derived from v1-0
 * Introduction of `transactions' in UESLIB to enable multi-user usage.
 * Introduction of `changes' in UESLIB allowing the storage and retrieval of
 * changes to existing descriptors as well as building/destroying descriptors.
 * Addition of an `overwrite' mode to storage routines.
 *
 * Revision 1.1  1992/06/08  19:10:27  adrian
 * Version v1-0 derived from root
 * Initial implementation of UESLIB
 *								*/
