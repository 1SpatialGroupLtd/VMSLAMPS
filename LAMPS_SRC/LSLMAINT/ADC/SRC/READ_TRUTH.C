#module READ_TRUTH "13AU99"

/************************************************************************/
/*									*/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England    */
/* Author    JM Cadogan, 01-Oct-1993 					*/
/*									*/
/************************************************************************/ 

/************************************************************************/ 
/*									*/
/*			R E A D _ T R U T H				*/
/*									*/
/* - a routine to read a truth file for ADCC				*/
/*									*/
/************************************************************************/ 

#include <stdio.h>		/* standard I/O header		*/
#include <lsldef.h>		/* standard LSL header		*/
#include <stsdef.h>		/* error status definitions	*/
#include <string.h>		/* for char string handling 	*/
#include <lsldesc.h>		/* for s_Desc			*/

#include "lsl$cmnlsl:filename.h"/* LSLLIB file-spec stuff	*/
#include "lsl$cmnlsl:cld.h"	/* LSLLIB command line stuff	*/

#include "lsl$cmnlsd:cjacket.h" /* definitions of C LSLLIB	*/

#include "lsl$cmnlsl:lsllibmsg.h"	/* lsllib messages */
#include "lsl$cmnlsl:cmdcom.h"		/* DCL command line reading header */
#include "lsl$cmnlsl:readstr.h"		/* string reading header */
#include "here:cmdline.h"	/* command line qualifier flags */
#include "here:adcc.h"		/* adcc globals */
#include "here:adccmsg.h"	/* adcc globals */

#define FILE_NAME_LEN 39

char		*cd_spec[MAXFILENAM];	/* dir spec for commons etc*/
char		*tfile[MAXFILENAM];	/* input truth file */
char		*ofile[MAXFILENAM];	/* output source file */
extern	char	*truth_names[MAXVARS][MAXFILENAM];
extern	int	truth_values[MAXVARS];
extern	int	truth_total;
LSL_DESC	fdesc;			/* file's string descriptor */

/************************************************************************/ 
/*									*/
/* read_truth								*/
/* 	Read truth values and create lookup tables			*/
/*									*/
/* returns TRUE if we do so succesfully, FALSE otherwise		*/
/*									*/
/************************************************************************/ 

BOOLEAN read_truth()

{
/* functions */
	void       	SETAUX();		/* set auxiliary buffer */
	LSL_STATUS	FLRLIN();		/* read a line */
	BOOLEAN		RDCH();			/* read a charater */
	BOOLEAN		RDCHS();		/* read a charater */
	BOOLEAN		RDINT();		/* read an integer */
	int	   	READSTR();		/* read a string */
	void		BSCH();			/* backspace a character */

	char		ich;			/* character */
	LSL_STATUS	retval;			/* status return value */
	char		source_line[MAXLINELEN];/* line from source file */
	char		tmpbuf[MAXLINELEN];	/* temp buffer */
	void		LSL_PUTMSG();
	int		nchs;			/* no. of characters */
	INT_4		stringlen;		/* string length */
	LSL_DESC   	stringdesc;		/* string descriptor */
	LSL_STATUS	status,ierr;		/* return codes */
	BOOLEAN		ok;			/* function return status */
	int		truth_count;

/* open truth file */
	fdesc.length = strlen(tfile);
	fdesc.pointer = tfile;
	status = FLROPN( &ADC_LUN_3, &fdesc, &ierr );
	if ( !(status&STS$M_SUCCESS) ) 
	{
	   LSL_PUTMSG(&ADCC__OPN,tfile);
	   LSL_ADDMSG(&status);
	   if ( status==LSL__SYSOPEN ) LSL_ADDMSG( &ierr );
	   return;
	}

/* load names and values */

	status = FLRSEL(&ADC_LUN_3);
	if ( !(status&STS$M_SUCCESS) ) 
	{
	   LSL_PUTMSG(&status);
	   return;
	}

	truth_count = 0;

	do
	{
	   status = FLRLIN(tmpbuf,&nchs,&line_length,&ierr);
	   if (status==LSL__EOF) continue;

	   if (status!=LSL__NORMAL) 
	   {
	      LSL_PUTMSG(&ADC_LUN_3,&truth_count,tfile);
	      LSL_ADDMSG(&status);
	      if (status==LSL__SYSREAD) LSL_ADDMSG(&ierr);

	      if (status!=LSL__RECTOOBIG) return;
	   }

	   if (nchs<=0) continue;

	   SETAUX(tmpbuf,&nchs);		/* set auxiliary buffer */

	   RDCHS(&ich);
	   if (ich==';' || ich=='.') continue;
	   BSCH();

	   stringdesc.length = MAXLINELEN;
	   stringdesc.pointer = source_line;
 	   stringlen = READSTR( &stringdesc,"=",&ON_SPACE,&TRUE,&retval );
	   source_line[stringlen] = 0;

	   truth_count++;

	   strcpy(truth_names[truth_count-1],&source_line);

	   /* skip '=' if we haven't already */
	   if (RDCHS(&ich)) continue;
	   if (ich != '=') BSCH();

 	   ok  = RDINT(&truth_values[truth_count-1]);
	} while (status!=LSL__EOF); 
	
	truth_total = truth_count;

/*  And that's all we want to do - success */

 	return TRUE;
}
