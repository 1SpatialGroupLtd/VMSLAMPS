# module ADCC "13AU99"

/******************************************************************************/
/*									      */
/*  Copyright © Laser-scan Ltd, Cambridge CB4 4FY, England		      */
/*  Author    JM Cadogan					06-Oct-1993   */
/*									      */
/*	Program to add common blocks to FORTRAN sources, and		      */
/*	otherwise generally prepare them for listing or			      */
/*	compilation.							      */
/*									      */
/******************************************************************************/

#include <stdio.h>			/* standard I/O header */
#include <stsdef.h>			/* error status def'ns */
#include <string.h>			/* for char string handling */
#include <lsldef.h>			/* standard LSL header */
#include <lsldesc.h>			/* for s_Desc */
#include "lsl$cmnlsl:lsllibmsg.h"	/* lsllib messages */
#include "lsl$cmnlsl:cld.h"		/* LSLLIB command line stuff	*/
#include "here:adcc.h"			/* adcc header */
#include "here:adccmsg.h"		/* adcc messages header */
#include "here:cmdline.h"		/* comand line options */

extern	char		*ifile[MAXFILES][MAXFILENAM];	/* input source file */
extern  char		*cd_spec[MAXFILENAM];	/* dir spec for commons etc*/
extern	char		*tfile[MAXFILENAM];	/* input truth file */
extern	char		*ofile[MAXFILENAM];	/* output source file */
extern	char		*idfile[MAXFILENAM];	/* output ident file */
extern	LSL_DESC	fdesc;			/* file's string descriptor */
extern	BOOLEAN		ok;			/* function return status */
extern	int		strseglen;		/* string segment length */
extern	int		linenumber;		/* file line numbers counter */
extern	int		linecount;		/* file line counter */
extern	int		nfiles;			/* number of input files */

/*----------------------------------------------------------------------------*/

main()
{

extern	int	luncount;		/* count of LUNs for output files */
LSL_STATUS	status,ierr;		/* function return status's */
int		i;			/* counter */

/*---------------------------------------------------------------------------*/

/* initialise LSLLIB */
 
 	LSL_INIT (&FALSE);		/* suppress timer output */

/* Initialise line counter and line numbering */
	linecount = 0;
	linenumber = 0;

/* Initialise lun counter */
	luncount = ADC_LUN_3;

/* decode command line */
 	ok = read_cmdline ();
 	if ( !ok ) 
 	{
	   LSL_PUTMSG (&ADCC__CMDLNERR);
	   return;
	}
 
/* Read truth file if required */
	if (had_tr)
	{
 	   ok = read_truth();
 	   if ( !ok ) return;
	}
 
/* open output and ident files */
	fdesc.length = strlen(ofile);
	fdesc.pointer = ofile;
	/* open for appending if required */
	if (had_append) status = FLWEXT( &ADC_LUN_1, &fdesc, &ierr );
	else status = FLWOPN( &ADC_LUN_1, &fdesc, &ierr );
	if ( !(status&STS$M_SUCCESS) ) 
	{
	   LSL_PUTMSG(&ADCC__OPN,ofile);
	   LSL_ADDMSG(&status);
	   if ( status==LSL__SYSOPEN ) LSL_ADDMSG( &ierr );
	   return;
	}

	strcat(idfile,"adc.ide");
	fdesc.length = strlen(idfile);
	fdesc.pointer = idfile;
	if (had_append) status = FLWEXT( &ADC_LUN_2, &fdesc, &ierr );
	else status = FLWOPN( &ADC_LUN_2, &fdesc, &ierr );
	if ( !(status&STS$M_SUCCESS) ) 
	{
	   LSL_PUTMSG(&ADCC__OPN,idfile);
	   LSL_ADDMSG(&status);
	   if ( status==LSL__SYSOPEN ) LSL_ADDMSG( &ierr );
	   return;
	}

/* loop looking for '***' commands and output them to ident and source to source
   output files. */

	for (i=0;i<nfiles;i++) copystream(ifile[i],FALSE);

/* Close input file */
	status = FLWCLO(&ADC_LUN_1);
	if ( !(status&STS$M_SUCCESS) ) 
	{
	   LSL_PUTMSG(&status);
	   if ( status==LSL__SYSOPEN ) LSL_ADDMSG( &ierr );
	   return;
	}
	status = FLWCLO(&ADC_LUN_2);
	if ( !(status&STS$M_SUCCESS) ) 
	{
	   LSL_PUTMSG(&status);
	   if ( status==LSL__SYSOPEN ) LSL_ADDMSG( &ierr );
	   return;
	}

	return;
}
