/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1991-03-06 12:12:02.000000000 +0000
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

#module GETFRT "04FE91"

/******************************************************************************/
/*									      */
/*  Copyright Laser-scan Laboratories Ltd, Cambridge CB4 4FY, England	      */
/*  Author    J Barber					      15-May-1989     */
/*  Based on ITOARC written by G.J.Robinson, NUTIS	      13-Aug-1988     */
/*									      */
/******************************************************************************/

#include <lsldef.h>				/* standard LSL header */
#include <stdio.h>				/* standard I/O header */
#include <string.h>				/* for char string handling */

/*#include "lsl$cmnfrt:frtcom.h"*/
#include "here:frtcom.h"
#include "here:iff.h"

extern short gtype[], colour[], sc[], symbol[]; /* FRT info held elsewhere */
extern float width[], size[];

int getfrt()					/* FRT info reading program */
{
   BOOLEAN FRTFND();

   int fc, gt, col, scode;
   double wid, sz;
   char type[10], group[20];

   int ntext = 0, nlin = 0, nsym = 0;		/* symbol nos for text, lines */
						/*  and points */
   int i,fcl;

   for (i=0;i<FRTCOM.FRTCNT;i++)
   {
	if (! FRTFND(&(FRTCOM.FRTINT[i][0])) )
	   {
	   fc = FRTCOM.FRTFC;
	   gt = FRTCOM.FRTGT;
	   col = FRTCOM.FRTCOL;
	   wid = FRTCOM.FRTWID;
	   sz = FRTCOM.FRTSIZ;
	   scode = FRTCOM.FRTSC;

	   gtype[fc]  = gt;
	   colour[fc] = col;
	   width[fc]  = wid;
	   size[fc]   = sz;
	   sc[fc]     = scode;

   /* Look for previous similar occurence */

	   for ( fcl=0;fcl<fc;fcl++)
	   {
		if ( gtype[fc] == gtype[fcl]
		   && colour[fc] == colour[fcl]
		   && width[fc] == width[fcl]
		   && size[fc] == size[fcl] 
		   && sc[fc] == sc[fcl] )  
		{
		   symbol[fc] = symbol[fcl];
		   goto found;
		};
	   };

   /* New symbol so set appropriate value */

	   switch(gt)
	   {
		case UNORIEN_SYMBOL :
		case ORIEN_SYMBOL :
		case SCAL_SYMBOL :
		   symbol[fc] = ++nsym;
		   break;
		case TEXT:
		   symbol[fc] = ++ntext;
		   break;
		default :			/* lines etc. */
		   symbol[fc] = ++nlin;
		   break;
	   };

	found:

	   continue;
	};
   };
   return(1);
}

/******************************************************************************/
/* Routine to obtain a char line from a file */

int getline ( FILE *fin,
	      char line[],
	      int  lim )
{
   int c, i = 0;

   while (--lim > 0 && (c = getc(fin)) != EOF && c != '\n' )
   {
	line[i++] = c;
   };

   if ( c == '\n' )
	line[i++] = c;

   line[i] = '\0';

   return(i);
}

