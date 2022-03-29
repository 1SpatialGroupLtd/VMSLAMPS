
#module CMDLINE "26JN89"

/************************************************************************/
/*									*/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England    */
/* Author    TJ Ibbs, 30-Sep-1988 					*/
/* Mod	     J Barber 18-May-1989					*/
/*									*/
/************************************************************************/ 

/************************************************************************/ 
/*									*/
/*			   C M D L I N E				*/
/*									*/
/* - a routine to interpret the command line for I2ARC			*/
/*									*/
/************************************************************************/ 

#include <stdio.h>		/* standard I/O header		*/
#include <lsldef.h>		/* standard LSL header		*/
#include <stsdef.h>		/* error status definitions	*/
#include <string.h>		/* for char string handling 	*/

#include "lsl$cmnlsl:filename.h"/* LSLLIB file-spec stuff	*/
#include "lsl$cmnlsl:cld.h"	/* LSLLIB command line stuff	*/

#include "lsl$cmnlsd:cjacket.h" /* definitions of C LSLLIB	*/

#include "here:cmdline.h"	/* command line qualifier flags */
#include "here:i2arcmsg.h"	/* message param file		*/

#define FILE_NAME_LEN 39

/************************************************************************/ 
/*									*/
/* read_cmdline								*/
/* interprets the command line using normal VAX procedures (via LSLLIB)	*/
/*									*/
/* 	IFF_file - in  - the file-spec of the IFF file to read		*/
/* 	ARC_name - out - the file name of the ARCINFO file to write	*/
/*									*/
/*	/FRT = FRT file-spec (required)					*/
/*	/LOG   for file handling info					*/
/*	/DEBUG for full program run info entry by entry			*/
/*									*/
/* returns TRUE if we do so succesfully, FALSE otherwise		*/
/*									*/
/************************************************************************/ 

BOOLEAN read_cmdline( char  IFF_file[C_MAX_SIZ+1],
		      char  ARC_name[FILE_NAME_LEN-3],
		      char  FRT_file[C_MAX_SIZ+1] )
{
	void	    LSL_PUTMSG();

	VMS_STATUS  status; 	/* general function return	*/
	BOOLEAN	    absent;	/* not had the filename?	*/
	INT_2	    length;	/* the length of a name		*/

/*  Pretend the CLD spec is a function */

	void	    I2ARC_CLD();

/*  Start up our parsing of the command line */

	status = c_DCL_STARTUP ("I2ARC", FALSE, I2ARC_CLD, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;	/* failed */

/*  Read the input IFF name */

	status = c_DCL_FILE ("INFILE", "LSL$IF:IFF.IFF", &absent, FALSE, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;	/* failed */

	length = LSL_CLD.FIL_LEN[0];
	strncpy (IFF_file, LSL_CLDCHR.FILARY[0], length);
	IFF_file[length] = 0;

/*  Extract the ARCINFO file name */

	status = c_DCL_FILE ("OUTFILE", "OUTFILE", &absent, FALSE, TRUE );
	if ( !(status & STS$M_SUCCESS) ) return FALSE;	/* failed */

/*  Check that they did not specify anything other than the name */

	if ( LSL_FNAM_LOG.HAD_NOD || LSL_FNAM_LOG.HAD_DEV ||
	     LSL_FNAM_LOG.HAD_DIR || LSL_FNAM_LOG.HAD_EXT ||
	     LSL_FNAM_LOG.HAD_VER ) 
	{
	   LSL_PUTMSG (&I2ARC__ARCNAM);
	   return FALSE;
	}

	length = LSL_CLD.FIL_LEN[0];
	strncpy (ARC_name, LSL_CLDCHR.FILARY[0], length);
	ARC_name[length] = 0;

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

