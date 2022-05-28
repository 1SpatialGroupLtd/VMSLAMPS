/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1994-04-20 11:57:02.000000000 +0100
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
#ifndef _LSRPROCESS_EXTERN_INIT
#define _LSRPROCESS_EXTERN_INIT

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		    L S R P R O C E S S _ E X T E R N _ I N I T		*/
/*									*/
/* Part of GOTHIC module LSRPROCESS					*/
/************************************************************************/

/* Prototype for external intialisation routine */

typedef long int (*LSRPROCESS_INIT_FUNC)(TRN_USER_EXTERNAL_ROUTINE *external_routine,
					 long int             user_integer) ;



#endif
