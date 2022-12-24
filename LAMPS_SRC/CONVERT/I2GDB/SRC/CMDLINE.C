/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1990-06-22 16:00:18.000000000 +0100
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

#module CMDLINE "22JN90"

/************************************************************************/
/*									*/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England    */
/* Author    TJ Ibbs, 30-Sep-1988 					*/
/* Mod	     J Barber 18-Sep-1989					*/
/* Mod	     A Verrill 18-Jun-1990					*/
/*									*/
/************************************************************************/ 

/************************************************************************/ 
/*									*/
/*			   C M D L I N E				*/
/*									*/
/* - a routine to interpret the command line for I2GDB			*/
/*									*/
/************************************************************************/ 

#include <stdio.h>		/* standard I/O header		*/
#include <lsldef.h>		/* standard LSL header		*/
#include <stsdef.h>		/* error status definitions	*/
#include <string.h>		/* for char string handling 	*/

#include "lsl$cmnlsl:filename.h"/* LSLLIB file-spec stuff	*/
#include "lsl$cmnlsl:cld.h"	/* LSLLIB command line stuff	*/

#include "lsl$cmnlsd:cjacket.h" /* definitions of C LSLLIB	*/

#include "here:iff.h"		/* structure definitions	*/
#include "here:functions.h"	/* function definitions */
#include "here:cmdline.h"	/* command line qualifier flags */
#include "here:i2gdbmsg.h"	/* message param file		*/


/************************************************************************/ 
/*									*/
/* read_cmdline								*/
/* interprets the command line using normal VAX procedures (via LSLLIB)	*/
/*									*/
/* 	IFF_file - in  - the file-spec of the IFF file to read		*/
/* 	GDB_file - out - the file-spec of the GDB file to write		*/
/*									*/
/*	/FRT = FRT file-spec (required)					*/
/*	/LOG   for file handling info					*/
/*	/DEBUG for full program run info entry by entry			*/
/*	/PARAMETERS for parameter file					*/
/*									*/
/* returns TRUE if we do so succesfully, FALSE otherwise		*/
/*									*/
/************************************************************************/ 

BOOLEAN read_cmdline( char  IFF_file[C_MAX_SIZ+1],
		      char  GDB_file[C_MAX_SIZ+1],
		      char  FRT_file[C_MAX_SIZ+1],
		      char  PAR_file[C_MAX_SIZ+1] )
{
	void	    LSL_PUTMSG();

	VMS_STATUS  status; 	/* general function return	*/
	BOOLEAN	    absent;	/* not had the filename?	*/
	INT_2	    length;	/* the length of a name		*/

/*  Pretend the CLD spec is a function */

	void	    I2GDB_CLD();

/*  Start up our parsing of the command line */

	status = c_DCL_STARTUP ("I2GDB", FALSE, I2GDB_CLD, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;	/* failed */

/*  Read the input IFF name */

	status = c_DCL_FILE ("INFILE", "LSL$IF:IFF.IFF", &absent, FALSE, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;	/* failed */

	length = LSL_CLD.FIL_LEN[0];
	strncpy (IFF_file, LSL_CLDCHR.FILARY[0], length);
	IFF_file[length] = 0;

/*  Extract the GDB file name */

	status = c_DCL_FILE ("OUTFILE", "GDB.GDB", &absent, FALSE, TRUE );
	if ( !(status & STS$M_SUCCESS) ) return FALSE;	/* failed */

	length = LSL_CLD.FIL_LEN[0];
	strncpy (GDB_file, LSL_CLDCHR.FILARY[0], length);
	GDB_file[length] = 0;

/* ---------------------------------------------------------------------------
 Did we have any qualifiers? - check for /FRT */

	status = c_DCL_QUAL_1 ("FRT", &had_frt, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

	if ( had_frt )
	{
	   status = c_DCL_FILE ("FRT", "LSL$FRT:OS.FRT", &absent, FALSE, TRUE );
	   if ( !(status & STS$M_SUCCESS) ) return FALSE;   /* failed */

	   length = LSL_CLD.FIL_LEN[0];
	   strncpy (FRT_file, LSL_CLDCHR.FILARY[0], length);
	   FRT_file[length] = 0;
	}

/*----------------------------------------------------------------------*/
/* and for /PARAMETERS = */

	status = c_DCL_QUAL_1 ("PARAMETERS", &had_param, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

	if ( had_param )
	{
	   status = c_DCL_FILE ("PARAMETERS", "LSL$FRT:GDB_PARAMS.PAR", 
				&absent, FALSE, TRUE );

	   if ( !(status & STS$M_SUCCESS) ) return FALSE;   /* failed */

	   length = LSL_CLD.FIL_LEN[0];
	   strncpy (PAR_file, LSL_CLDCHR.FILARY[0], length);
	   PAR_file[length] = '\0';
	}
/* ---------------------------------------------------------------------------
 And for /LOG */

	status = c_DCL_QUAL_1 ("LOG", &had_log, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

/* ---------------------------------------------------------------------------
 And for /DEBUG */

	status = c_DCL_QUAL_1 ("DEBUG", &had_debug, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

/*  And that's all we want to do - success */

 	return TRUE;
}


