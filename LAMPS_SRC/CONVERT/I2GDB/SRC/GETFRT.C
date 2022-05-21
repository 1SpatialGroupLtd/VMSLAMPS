/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1990-06-15 16:41:34.000000000 +0100
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

#module GETFRT "15JN90"

/******************************************************************************/
/*									      */
/*  Copyright Laser-scan Laboratories Ltd, Cambridge CB4 4FY, England	      */
/*  Author    J Barber					      15-Sep-1989     */
/*									      */
/******************************************************************************/

#include <lsldef.h>				/* standard LSL header */
#include <stdio.h>				/* standard I/O header */
#include <string.h>				/* for char string handling */

#include "lsl$cmnlsl:filename.h"

#include "iff.h"
#include "functions.h"

/******************************************************************************/
/* Prototypes of functions local to this module */

/* Routine to obtain a char line from a file */

int getline ( FILE *fin,
	      char line[],
	      int  lim );

/* Initialise frt exists entry table */
init_frt_entries();

/******************************************************************************/

#define MAX_FC			32767	/* max number of FCs */

extern FILE *ffrt;
extern short gtype[], frt[];
extern short sc[], colour[]; 			/* FRT info held elsewhere */
extern float width[], size[];

int getfrt()					/* FRT info reading program */
{
   int fc, gt, col, scode;
   double wid, sz;

   int fcl;

   char type[10];
   char buffer[121];				/* working buffer */

	/* Read FRT file line by line to get FC info etc. into the */
	/* 		arrays referenced by fc       		   */

   while ( getline (ffrt, buffer, 120) > 0 )
   {
	if ( sscanf (buffer,"%3s %d %d %d %lf %lf %d",
	   	type,&fc,&gt,&col,&wid,&sz,&scode)==7 &&
		strncmp (type,"FRT",3)==0 )
	{
	   gtype[fc]  = gt;
	   colour[fc] = col;
	   width[fc]  = wid;
	   size[fc]   = sz;
	   sc[fc]     = scode;
	   frt[fc]    = 1;		/* fc exists in FRT file */
	}
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

init_frt_entries()
{
   int fc;	/* counter */

   /* initialise the FRT entry exist arrays */

	for (fc = 0; fc < MAX_FC; frt[fc++] = 0);
}



