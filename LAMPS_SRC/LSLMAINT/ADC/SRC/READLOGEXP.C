/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1993-10-20 15:32:54.000000000 +0100
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
#module READLOGEXP "20OC93"

/******************************************************************************/
/*									      */
/*  Copyright © Laser-scan Ltd, Cambridge CB4 4FY, England		      */
/*  Author    JM Cadogan				      30-Sep-1993     */
/*									      */
/*  Description:							      */
/*  	Decode logical expression for an IF or UNLESS function.		      */
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
#include "lsl$cmnlsl:readstr.h"		/* string reading header */
#include "lsl$cmnlsl:txtc.h"		/* text input */

/*----------------------------------------------------------------------------*/

int	truth_total;			/* no. of logical expr. in truth file */
char	*truth_names[MAXVARS][MAXFILENAM]; /* var names in truth file */
int	truth_values[MAXVARS];		   /* var values in truth file */
char	source_line[MAXLINELEN];	   /* line from source file */
char	tmpbuf[MAXLINELEN];		   /* temp buffer */
int	nchs;				   /* no. of chars in tmpbuf */
extern	LSL_STATUS	retval;		   /* status return value */

BOOLEAN readlogexp(char ch)
{

/* functions */
	BOOLEAN		RDCHS();		/* read a charater */
	int	   	READSTR();		/* read a string */

/* workspace */
extern	BOOLEAN		tmp_flag;		/* temp condition flag */
	BOOLEAN		curr_flag;		/* current state of temp
						   condition flag */
	char		*term_char;		/* termination char */
	char		tc;			/* temp termination char */
	LSL_DESC   	stringdesc;		/* string descriptor */
	INT_4		stringlen;		/* string length */
	int	   	i;			/* counter */

	switch (ch)
	{
	   case '(': /* open bracket */
	   {
	      RDCHS(&ch);
	      readlogexp(ch);
	      break;
	   }
	   case '\\': /* NOT operator */
	   {
	      RDCHS(&ch);
	      readlogexp(ch);
	      tmp_flag = !tmp_flag;
	      break;
	   }
	   case '&': /* AND operator */
	   {
	      RDCHS(&ch);
	      curr_flag = tmp_flag;
	      readlogexp(ch);
	      tmp_flag = curr_flag && tmp_flag;
	      break;
	   }
	   case '|': /* OR operator */
	   {
	      RDCHS(&ch);
	      curr_flag = tmp_flag;
	      readlogexp(ch);
	      tmp_flag = curr_flag || tmp_flag;
	      break;
	   }
	   case ')': return; /* close bracket */

	   default: /* otherwise read and test variable */
	   {
	      BSCH();	/* backspace one char */

	      /* look for termin. char */
	      term_char = strpbrk(&tmpbuf[LSL_TXTC.DCPTR]," !()&|\""); 
	      stringdesc.length = MAXLINELEN;
	      stringdesc.pointer = source_line;
	      if (term_char!=NULL) 
	      {
		 tc = term_char[0];
		 stringlen = READSTR(&stringdesc,&tc,0,&TRUE,&retval);
	      }
	      else
		 stringlen = READSTR(&stringdesc,0,&ON_EOL,&TRUE,&retval);

	      source_line[stringlen] = 0;

	      BSCH();
	      if (stringlen>0)
	      {
		 /* search for variable name */
		 for (i=0;i<truth_total;i++)
		 {
		    if (strcmp(&source_line,truth_names[i])==0) break;
		 }
		 /* test truth value and set condition flag */
		 if (i<truth_total) tmp_flag = truth_values[i]==1;
	      }
	      return;
	   } /* default */
	}

/* exit if end of line reached */
	if ((retval==LSL__STREOL)||(LSL_TXTC.DCPTR>=nchs)||
	    (tc=='!')) return(tmp_flag);
	else
	{
	   RDCHS(&ch);
	   readlogexp(ch);
	}
	
	return;
}
