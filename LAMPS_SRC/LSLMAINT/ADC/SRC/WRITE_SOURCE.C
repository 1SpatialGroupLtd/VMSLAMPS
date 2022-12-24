/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1993-10-21 16:45:12.000000000 +0100
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
#module WRITE_SOURCE "21OC93"

/******************************************************************************/
/*									      */
/*  Copyright © Laser-scan Ltd, Cambridge CB4 4FY, England		      */
/*  Author    JM Cadogan				      15-Oct-1993     */
/*									      */
/*  Description:							      */
/*  	Write lines of FORTRAN source code saved in buffer to a source file.  */
/*									      */
/******************************************************************************/

#include <stdio.h>			/* standard I/O header */
#include <stsdef.h>			/* error status def'ns */
#include <string.h>			/* for char string handling */
#include <lsldef.h>			/* standard LSL header */
#include <lsldesc.h>			/* for s_Desc */
#include "lsl$cmnlsl:lsllibmsg.h"	/* lsllib messages */
#include "here:adcc.h"			/* adcc header */
#include "here:adccmsg.h"		/* adcc message header */
#include "here:cmdline.h"		/* adcc command flags */

/*----------------------------------------------------------------------------*/

char		*ofile[MAXFILENAM];	/* output source file */
int		linenumber;		/* file line numbers counter */
int		linecount;		/* file line counter */
char		source_line[MAXLINELEN];/* line from source file */
char		tmpbuf[MAXLINELEN];	/* temp buffer */
char		*numbuf[MAXLINELEN];	/* IDENT string */
int		nchs;			/* no. of characters */

void write_source(BOOLEAN inner_level)
{
/* workspace */
	LSL_STATUS	status,ierr;		/* return codes */

	switch(tmpbuf[0])
	{
	/* Treat D as a comment if debug flag off.
	   If had debug flag ignore 'D' by substituting ' ' */
	   case 'D':
	   case 'd': if (had_debug) tmpbuf[0] = ' ';
	   case 'C':
	   case 'c':
	   /* don't output comment if comment flag off or if we're
	      in an inner level and outer_level_only flag is on */
	   {
	      if (!had_comments) break;
	      if (inner_level && outer_level_only) break;
	   }

	   default:
	   {
	      /* write source line to output source file */
	      status = FLWSEL(&ADC_LUN_1);
	      if ( !(status&STS$M_SUCCESS) )
	      {
		 LSL_PUTMSG(&status);
		 return;
	      }

	      if (had_ln)
	      {
	         linenumber = linenumber + 1;
		 sprintf(numbuf,"%d",linenumber);
		 strcat(numbuf," ");
		 nchs = nchs + strlen(numbuf);
		 strcat(numbuf,&tmpbuf);
		 strcpy(&tmpbuf,numbuf);
	      }

	      status = FLWLIN(tmpbuf,&nchs,&ierr);

	      if (status!=LSL__NORMAL) 
	      {
		 LSL_PUTMSG(&ADCC__WRTSOU,&linecount,ofile);
		 LSL_ADDMSG(&status);
		 if (status==LSL__SYSWRITE) LSL_ADDMSG(&ierr);
		 return;
	      }
	   }
	} /* switch */
}
