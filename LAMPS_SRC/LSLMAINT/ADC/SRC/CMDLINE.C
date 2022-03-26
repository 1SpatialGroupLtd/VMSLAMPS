#module CMDLINE "20OC93"

/************************************************************************/
/*									*/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England    */
/* Author    JM Cadogan, 01-Oct-1993 					*/
/*									*/
/************************************************************************/ 

/************************************************************************/ 
/*									*/
/*			   C M D L I N E				*/
/*									*/
/* - a routine to interpret the command line for ADCC			*/
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
#include "here:adcc.h"		/* adcc globals */
#include "here:adccmsg.h"	/* adcc messages */

#define FILE_NAME_LEN 39

char		*cd_spec[MAXFILENAM];	/* dir spec for commons etc*/
char		*tfile[MAXFILENAM];	/* input truth file */
char		*ifile[MAXFILES][MAXFILENAM];	/* input source file */
char		*ofile[MAXFILENAM];	/* output source file */
int		nfiles;			/* number of input files */

/************************************************************************/ 
/*									*/
/* read_cmdline								*/
/* interprets the command line using normal VAX procedures (via LSLLIB)	*/
/*									*/
/* 	 ifile - in  - the file-spec of the input source file to read   */
/* 	 ofile - out - the file name of the output source file to write	*/
/*									*/
/* returns TRUE if we do so succesfully, FALSE otherwise		*/
/*									*/
/************************************************************************/ 

BOOLEAN read_cmdline()

{
	void	    LSL_PUTMSG();

	VMS_STATUS  status; 	/* general function return	*/
	BOOLEAN	    absent;	/* not had the filename?	*/
	INT_2	    length;	/* the length of a name		*/
	int	    i;		/* counter			*/

/*  Pretend the CLD spec is a function */

	void	    ADCC_CLD();

/*  Start up our parsing of the command line */

	status = c_DCL_STARTUP ("ADCC", FALSE, ADCC_CLD, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;	/* failed */

/*  Read the list of input filenames and save in ifile */

	status = c_DCL_FILE ("INFILE", ".SRC", &absent, TRUE, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;	/* failed */

	nfiles = LSL_CLD.NUMFIL;
	for (i=0;i<nfiles;i++) 
	{
	   length = LSL_CLD.FIL_LEN[i];
	   strncpy (ifile[i], LSL_CLDCHR.FILARY[i], length);
	   ifile[i][length] = 0;
	}
/*  Extract the source file name */

	status = c_DCL_FILE ("OUTFILE", ".FOR", &absent, FALSE, TRUE );
	if ( !(status & STS$M_SUCCESS) ) return FALSE;	/* failed */

	length = LSL_CLD.FIL_LEN[0];
	strncpy (ofile, LSL_CLDCHR.FILARY[0], length);
	ofile[length] = 0;

/* ---------------------------------------------------------------------------
 Did we have any qualifiers? - check for /PRINT */

	status = c_DCL_QUAL_1 ("PRINT", &had_print, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

/* ---------------------------------------------------------------------------
  - check for /APPEND */

	status = c_DCL_QUAL_1 ("APPEND", &had_append, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

/* ---------------------------------------------------------------------------
 And for /LOG */

	status = c_DCL_QUAL_1 ("LOG", &had_log, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

/* ---------------------------------------------------------------------------
 And for /THREAD */

	status = c_DCL_QUAL_1 ("THREAD", &had_thread, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

/* ---------------------------------------------------------------------------
 And for /DEBUG */

	status = c_DCL_QUAL_1 ("DEBUG", &had_debug, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

/* ---------------------------------------------------------------------------
 And for /LN (line numbering) */

	status = c_DCL_QUAL_1 ("LN", &had_ln, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

/* ---------------------------------------------------------------------------
 And for /COMMENTS */

	status = c_DCL_QUAL_1 ("COMMENTS", &had_comments, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

	if (had_comments)
	{
	   status = c_DCL_QUAL_1 ("COMMENTS.OUTER",&outer_level_only,TRUE);
	   if ( !(status & STS$M_SUCCESS) ) return FALSE;
	}

/* ---------------------------------------------------------------------------
 And for /CD */

	status = c_DCL_QUAL_1 ("CD", &had_cd, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

	if (had_cd)
	{
	   status = c_DCL_FILE ("CD", "", &absent, FALSE, TRUE );
	   if ( !(status & STS$M_SUCCESS) ) return FALSE;	/* failed */

/*  Check that they did not specify a file name */

	   if ( LSL_FNAM_LOG.HAD_NAM || LSL_FNAM_LOG.HAD_EXT ||
	        LSL_FNAM_LOG.HAD_VER ) 
	   {
	      LSL_PUTMSG (&ADCC__BADDIR);
	      return FALSE;
	   }

	   length = LSL_CLD.FIL_LEN[0];
	   strncpy (cd_spec, LSL_CLDCHR.FILARY[0], length);
	   cd_spec[length] = 0;
	}

/* ---------------------------------------------------------------------------
 And for /LL (set line length) */

	status = c_DCL_QUAL_1 ("LL", &had_ll, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

	if (had_ll)
	{
 	   status=c_DCL_INT("LL", TRUE) ;
	   if ( !(status & STS$M_SUCCESS) ) return FALSE;
 	   line_length = LSL_CLD.IARRAY[0];
	}
	else line_length = LINE_LEN_DFLT;

/* ---------------------------------------------------------------------------
 And for /IN (reinitialise truth file) */

	status = c_DCL_QUAL_1 ("IN", &had_in, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

/* ---------------------------------------------------------------------------
 And for /TR (truth file) */

	status = c_DCL_QUAL_1 ("TR", &had_tr, TRUE);
	if ( !(status & STS$M_SUCCESS) ) return FALSE;

	if (had_tr)
	{
	   status = c_DCL_FILE ("TR", ".SRC", &absent, FALSE, TRUE);
	   if ( !(status & STS$M_SUCCESS) ) return FALSE;	/* failed */

	   length = LSL_CLD.FIL_LEN[0];
	   strncpy (tfile, LSL_CLDCHR.FILARY[0], length);
	   tfile[length] = 0;
	}

/*  And that's all we want to do - success */

 	return TRUE;
}
