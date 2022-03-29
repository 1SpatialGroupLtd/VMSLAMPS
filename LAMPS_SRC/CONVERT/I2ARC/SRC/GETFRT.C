
#module GETFRT "13JL89"

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
#include "iff.h"

extern FILE *ffrt;
extern short gtype[], colour[], sc[], symbol[]; /* FRT info held elsewhere */
extern float width[], size[];

int getfrt()					/* FRT info reading program */
{
   int fc, gt, col, scode;
   double wid, sz;
   char type[10], group[20];

   int ntext = 0, nlin = 0, nsym = 0;		/* symbol nos for text, lines */
						/*  and points */
   int fcl;

   char buffer[121];				/* working buffer */

	/* Read FRT file line by line to get fc info etc. into the */
			/* arrays referenced by FC */

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

