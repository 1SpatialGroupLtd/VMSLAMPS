/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1989-05-19 15:23:58.000000000 +0100
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


#include <lsldef.h>
#include <stdio.h>
#include "iff.h"

extern FILE *ffrt;
extern int gtype[], colour[], sc[], symbol[];   /* FRT info held elsewhere */
extern double width[], size[];

int getfrt()					/* FRT info reading program */

{
   int fc, gt, col;
   double wid, sz;
   int scode;
   char type[10], group[20];

   int ntext = 0, nlin = 0, nsym = 0;		/* symbol nos for text, lines */
						/*  and points */
   int fcl;

   char buffer[121];				/* working buffer */

	/* Read FRT file line by line to get fc info etc. into the */
	/*       arrays referenced by FC */

   while ( getline (ffrt,buffer,120) > 0 )
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
	}

	else if ( sscanf (buffer,"%5s",type,group) == 2 &&
		strncmp (type,"GROUP",5) == 0 )
	{
	   fprintf (stderr,"GROUP = %s\n",group);	   
	};
   };

   return(1);
}

/******************************************************************************/

/* Routine to obtain a char line from a file */

int getline (fin,line,lim)

FILE *fin;
char line[];
int lim;
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


