/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1988-09-08 12:47:52.000000000 +0100
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
/*									*/
/*			 L S L D E S C . H				*/
/*									*/
/* A simple way of producing a string descriptor for use with routines	*/
/* such as WRITEF, EXPAND, etc						*/
/*									*/
/* Requires the inclusion of LSLDEF.H beforehand			*/
/*									*/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England    */
/* Author    TJ Ibbs, 8 Sep 1988					*/
/************************************************************************/ 

/************************************************************************/ 
/* Define a format descriptor for use with EXPAND/WRITEF, and a macro	*/
/* that will use that as a temporary descriptor for a string...		*/
/************************************************************************/ 

static	LSL_DESC    format = {0,14,1,NULL};
#define	s_Desc(s)   (format.pointer=(s),format.length=strlen((s)),&format)

