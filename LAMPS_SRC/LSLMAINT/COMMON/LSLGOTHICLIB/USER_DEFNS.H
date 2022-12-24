/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:23:10.000000000 +0000
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
#ifndef _USER_DEFNS_H
#define _USER_DEFNS_H
#endif
/* $Header: /lslhome/gothic/hdr/userlib/v1-4/RCS/hdr.user_defns.h,v 1.5 1994/02/16 21:28:28 jon Exp $								*/
/* 									*/
/* $Log: hdr.user_defns.h,v $
 * Revision 1.5  1994/02/16  21:28:28  jon
 * Version v1-4 derived from v1-3
 * change 'userlib.c' to use srand() and rand(), which are the ANSI standard
 * unlike random() and srandom()
 *
 * Revision 1.4  1993/09/15  13:09:52  davida
 * Version v1-3 derived from v1-2
 * Allow use of passwords in batch - see WICC 131.
 *
 * Revision 1.3  1993/09/09  11:04:28  adrian
 * Version v1-2 derived from v1-1
 * WICC 5.
 * Update the user name retreival function so that if no users, the current
 * login ID is returned with <System Login> appended to the name.
 *
 * Revision 1.2  1993/07/20  15:49:05  davem
 * Version v1-1 derived from v1-0
 * Work Instruction 76
 * The function user_read_definitions() has an unitialised variable str, that
 * can become uninitialised if the variable num_strings is zero or less. This can
 * cause serious errors.
 *
 * Revision 1.1  1993/07/15  21:19:28  jon
 * Version v1-0 derived from root
 * Extracted to design module.
 * In the absence of a user password file the initial version defaults to the
 * behaviour of before, namely no password control.
 *								*/
