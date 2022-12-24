/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 17:57:26.000000000 +0000
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
#ifndef _IOCTL_ANSI
#define _IOCTL_ANSI
/* $Header: /usr/users/jon/RCS/hdr.ioctl_ansi.h,v 1.9 1995/01/22 20:01:47 jon Exp $								*/
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    David Radcliffe, 23-Mar-1990				*/
/************************************************************************/

/************************************************************************/
/*									*/
/*			  I O C T L _ A N S I 				*/
/*									*/
/* Part of GOTHIC module DIOLIB						*/
/* Version 0.1, David Radcliffe 23-Mar-1990				*/
/************************************************************************/


/*----------------------------------------------------------------------*/
/* these macro definitions are ansified versions of the standard 	*/
/* 'ioctl' ones , which do not work with the GNU C compiler		*/
/* 									*/
/*----------------------------------------------------------------------*/

/* get rid of the existing definitions */

#undef _IO
#undef _IOR
#undef _IOW
#undef _IOWR

/*----------------------------------------------------------------------*/
/* ANSI preprocessing does not allow single quoting of formal arguments	*/
/* thus to get a character constant we look at the first character of a	*/
/* string constant							*/
/*----------------------------------------------------------------------*/

#define _char(x)	(#x[0])
#define _IO(x,y)	(int)(IOC_VOID|(_char(x)<<8)|y)
#define _IOR(x,y,t)	(int)(_IOC_OUT|((sizeof(t)&_IOCPARM_MASK)<<16)|(_char(x)<<8)|y)
#define _IOW(x,y,t)	(int)(_IOC_IN|((sizeof(t)&_IOCPARM_MASK)<<16)|(_char(x)<<8)|y)
#define _IOWR(x,y,t)	(int)(IOC_INOUT|((sizeof(t)&_IOCPARM_MASK)<<16)|(_char(x)<<8)|y)
#endif
