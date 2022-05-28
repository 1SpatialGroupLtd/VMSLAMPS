/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1987-05-29 11:05:34.000000000 +0100
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
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England    */
/* Author    TJ Ibbs, 28 May 1987					*/
/*									*/
/*			  C J A C K E T . H				*/
/*									*/
/* This header file defines the C jacket routines for LSLLIB		*/
/************************************************************************/ 

extern void lsl_set_desc();	/* set descriptor to point to a string	*/

/*======================================================================*/
/*			   the DCL routines				*/
/*======================================================================*/

extern INT_4 c_DCL_STARTUP();	/* parse the command line	*/
extern INT_4 c_DCL_PARSE();	/* parse a string		*/
extern INT_4 c_DCL_CML();	/* return the parsed line	*/
extern INT_4 c_DCL_QUAL();	/* check for a qualifier	*/
extern INT_4 c_DCL_QUAL_1();	/* abbreviated version of that	*/
extern INT_4 c_DCL_INT();	/* look for an integer argument	*/
extern INT_4 c_DCL_REAL();	/* look for a floating ditto	*/
extern INT_4 c_DCL_DBL();	/* look for a double ditto	*/
extern INT_4 c_DCL_STR();	/* look for a string argument	*/
extern INT_4 c_DCL_FILE();	/* look for a file-spec		*/

/*======================================================================*/
/*			   the IFF routines				*/
/*======================================================================*/

extern INT_4 c_IFFOPEN();	/* open IFF file - for reading	*/
extern INT_4 c_IFFCREATE();	/* open IFF file - create it	*/
extern INT_4 c_IFFMODIFY();	/* open IFF file - for writing	*/

/*======================================================================*/
/*			 the FILENAME routines				*/
/*======================================================================*/

extern INT_4 c_PARFILN();	/* parse a file specification	*/
extern INT_4 c_EXPFLN();	/* expand from 'filename.h'	*/
extern INT_4 c_PUTFLN();	/*  place into 'filename.h'	*/
