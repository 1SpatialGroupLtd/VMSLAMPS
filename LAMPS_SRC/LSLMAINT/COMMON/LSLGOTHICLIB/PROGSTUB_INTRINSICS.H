/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1994-04-25 18:13:52.000000000 +0100
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
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Ian Fisher, 31-Mar-1994					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*		 P R O G S T U B _ I N T R I N S I C S 			*/
/*									*/
/* Part of GOTHIC module PROGSTUBLIB					*/
/* Version 0.1, Ian Fisher 31-Mar-1994					*/
/************************************************************************/
#ifndef _PROGSTUB_INTRINSICS
#define  _PROGSTUB_INTRINSICS

/*----------------------------------------------------------------------*/
/* EXTERN progstub_init							*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* To initialise the gothic status code. 				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* None.								*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* GOTH__NORMAL		Normal, successful completion.			*/
/* GOTH__ERROR		Invalid vac_id specified.			*/
/*									*/
/*----------------------------------------------------------------------*/
extern GOTH_STATUS progstub_init() ;

#endif
