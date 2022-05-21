/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1994-01-19 17:47:12.000000000 +0000
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
#module DOTABLES "19JA94"

/******************************************************************************/
/*									      */
/*  Copyright Laser-scan Laboratories Ltd, Cambridge CB4 4FY, England	      */
/*  Author    S Townrow					      05-Mar-1991     */
/*  Only called when /INFO_TABLES specifed, this routine does an initial scan */
/*  of IFF file to build a list of all the ARC and point attributes to go     */
/*  into the .AAT and .PAT IFO tables respectively			      */
/*									      */
/******************************************************************************/

/******************************************************************************/
/*	Modification History:						      */
/*									      */
/*	Mod 1333	19/1/1994	Steve Townrow			      */
/*			Routine now sets the aat_count and pat_count	      */
/*			variables used in I2ARC in the AAT and PAT tables.    */
/*									      */
/*	Mod 1333	19/1/1994	Steve Townrow			      */
/*			Routine outputs attribute names in a fixed field of   */
/*			16 characters.					      */
/******************************************************************************/

#include <stdio.h>			/* standard I/O header */
#include <stsdef.h>			/* error status def'ns */
#include <string.h>			/* for char string handling */
#include <lsldef.h>			/* standard LSL header */
#include <lsldesc.h>			/* for s_Desc */

#include <math.h>
#include "here:cbc.h"			/* GJR's versions of C header files */
#include "here:iffhan.h"
#include "here:iff.h"

/*#include "lsl$cmnfrt:frtcom.h"	/* FRT */
#include "here:frtcom.h"		/* FRT */
#include "lsl$cmnlsl:filename.h"	/* LSLLIB filename stuff */
#include "here:cmdline.h"		/* cmd line qualifier stuff */
#include "here:i2arcmsg.h"		/* message param file */

/******************************************************************************/

extern FILE *faat, *fpat;
extern ACODE ac;
extern FSTATUS fs;
extern int acnum, aclist[256][7];
extern int naat, npat;
extern INT_2 entry_code, entry_length;
extern char ARC_name[];
extern int aat_count,pat_count;

int dotables()
{
   void LSL_PUTMSG();
   FILE *fil;
   char	*attname,*dummy;
   int	fld, dig;
   int	cnt1, cnt2;
   int	aatcnt, patcnt;
   int	aatcnt2, patcnt2;
   int	datatype, width, wid, attwid;
   int	atype = 0, ftype = 0;
   int	dtype = 0, nfeat = 0;
   int	listptr = 0;
   int	j = 0, i = 0;			/* general loop counters */

   nfeat=0;

   /* Initial scan of IFF file to build attribute lists for .AAT and .PAT */

   while (entry_code != -1)	/* retrieve entries sequentially */
	{
	iffnxt (&entry_code,&entry_length);	/* get next entry */
	switch ( entry_code )	/* read entries, (echo if not used) */
	   {
	   case FS:
		eihr (&fs, &entry_length, &one);
		ftype = fs.flag.non_text.type;
		nfeat++;
		break;
	   case EF:
		for (i=0;i<acnum;i++) {

		   /* Determine maximum number of each attribute per feature */

		    if (aclist[i][3]>aclist[i][5])
			aclist[i][5]=aclist[i][3];
		    aclist[i][3]=1;
		    }
		break;
	   case AC:
		for (i=0;i<256;i++) ac.text[i]=NULL;
		eihr (&ac, &entry_length, &one);
		if (ftype>=2) {break;}  /* don't add text attributes to list */

		/* see if it was declared in ACD part of FRT */

		atype = ac.type;
		if (!getattinfo(&atype,&dummy,&datatype)) { break; }
		else
		   { /* see if it already exists in aclist */
		   for (i=0;i<acnum;i++) 	
		      {
			if (( aclist[i][0] == ac.type) &&
			    ( aclist[i][2] == ftype ))
			   {
			   /* got a match if ac type is in list of same feature
			      type (0=linear,1=point) */
			   if (aclist[i][1] < strlen(ac.text) )
			      {
				 /* get maximum length for any string feature */
			         aclist[i][1] = strlen(ac.text);
			      }
			   if (aclist[i][4]==nfeat)
			      {
				 /* if another is in same feature, count it */
			         aclist[i][3]++;
			      }
			   aclist[i][4]=nfeat;
			   goto inlist;
			   }
		      }
		   /* add a new attribute to the list */
		   aclist[acnum][0] = ac.type;		/* AC code */
		   aclist[acnum][1] = strlen(ac.text);	/* field size */
		   aclist[acnum][2] = ftype;		/* point or line */
		   aclist[acnum][3] = 1;		/* counter */
		   aclist[acnum][4] = nfeat;		/* counter */
		   aclist[acnum][6] = datatype;		/* ACD datatype */
		   acnum++;
		   }
		inlist:
		   break;
	   case EJ:		/* end of IFF file */
		goto rewiff;
		break;
	   }
	}  
rewiff:
/* rewind iff file */

   iffrwd();

/* check list for character datatypes with empty string widths and take them */
/* out of the list */

   for (i=0;i<acnum;i++) {
      for (j=0;j<7;j++) { aclist[listptr][j]=aclist[i][j]; }
      if (aclist[i][6]==3 && aclist[i][1]==0)
         { LSL_PUTMSG (&I2ARC__NOTEXT,&aclist[i][0]); }
      else
         { listptr++; }
      }

   acnum = listptr;

/* write additional attributes */

   aatcnt = 7;
   patcnt = 4;
   aatcnt2 = 29;
   patcnt2 = 17;
   for (i=0;i<acnum;i++)
      {
      atype = aclist[i][0];
      getattinfo(&atype,&attname,&datatype);

      /* convert ACD datatype into EXPORT datatype */

      dig = 0;
      switch (aclist[i][6])
	   {
	   case 1:	/* integer */
	        dtype = 5;
		attwid = 4;
		fld = dtype;
		break;
	   case 2:	/* real */
		dig = 3;
	        dtype = 6;
		attwid = 4;
		fld = 12;
		break;
	   case 3:	/* character */
	        dtype = 2;
		attwid = aclist[i][1];
		fld = attwid;
		break;
	   case 4:	/* date */
	        dtype = 1;
		attwid = 8;
		fld = attwid;
		break;
	   case 5:	/* time */
		/*printf("AC datatype TIME ignored. No tranfer to EXPORT file\n");*/
		break;
	   }
      if (aclist[i][2]==0) naat+=aclist[i][5];
      if (aclist[i][2]==1) npat+=aclist[i][5];
      /* if no optional text, use normal text*/
      if (aclist[i][1]==0 && aclist[i][6]==3) aclist[i][1]=4;

      for (j=0;j<aclist[i][5];j++)
	 {
            if (aclist[i][2]==0) {
		aatcnt++;
		fil = faat;
		cnt1=aatcnt;
		cnt2=aatcnt2;
		}
            else if(aclist[i][2]==1) {
		patcnt++;
		fil = fpat;
		cnt1=patcnt;
		cnt2=patcnt2;
		}
	    fprintf (fil,"%-16s",attname);
	    fprintf (fil,"%3d-1",attwid);
	    fprintf (fil,"%4d4-1",cnt2);
	    fprintf (fil,"%4d %1d %1d",fld,dig,dtype);
	    fprintf (fil,"0-1  -1  -1-1%20d\n",cnt1);
            if (aclist[i][2]==0)
	       { aatcnt2+=attwid; }
            else if(aclist[i][2]==1)
	       { patcnt2+=attwid; }
	 }
      }
   aat_count = 2*(aatcnt2/2);
   pat_count = 2*(patcnt2/2);

   return(1);
}
