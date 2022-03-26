#module PROCESSAC "13FE91"

/******************************************************************************/
/*									      */
/*  Copyright Laser-scan Laboratories Ltd, Cambridge CB4 4FY, England	      */
/*  Author    S Townrow					      05-Mar-1991     */
/*  Only called when /INFO_TABLES specifed, this module contains several      */
/*  routines used to build (for each feature) a block of attribute values     */
/*  corresponding to the entries int the .AAT and .PAT tables that was built  */
/*  in DOTABLES() 						              */
/*									      */
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
extern INT_2 entry_code, entry_length;
extern char ARC_name[];
extern struct attlist *alist;
extern struct attlist *plist;

/* add an AC type to the end of an attribute list */
struct attlist *addatt(struct attlist *alist,int cod)
{
	struct attlist *head;
	struct attlist *newatt;
	head = alist;

	if (alist != NULL) {
	   while (head->next != NULL) head = head->next;
	   }

	newatt = (struct attlist *) malloc(sizeof(struct attlist));
	newatt->accode = cod;
	newatt->next = NULL;
	newatt->vals = NULL;

	if (alist==NULL)
	   { alist = newatt; }
	else
	   { head->next = newatt; }

	return (alist);
}

/* add a set of attribute values to the AC type found in the list*/
struct attlist *addattval(struct attlist *alist,
			  int attcode,int iv, float rv, char *tv)
{
	struct attlist *head;
	struct attvals *newval;
	struct attvals *vlist;
	head = alist;

	if (alist==NULL) { return(1); }

	do {
	    /* find attcode in the list */
	   if (head->accode==attcode) {
	      vlist = head->vals;
	      if (vlist != NULL) {
		 /* traverse list of values to get to end */
	         while (vlist->next != NULL) vlist = vlist->next;
	         }
	      /* add new value */
	      newval = (struct attvals *) malloc(sizeof(struct attvals));
	      newval->intval = iv;
	      newval->realval = rv;
	      strcpy(newval->text,tv);
	      newval->next = NULL;
	      if (head->vals==NULL)
	         { head->vals = newval; }
	      else
	         { vlist->next = newval; }
	      }
	   head = head->next;
	   }
	while (head != NULL);
	return (alist);
}

void buildlists()		/* build arc and point lists */
{
   int i;

   alist = NULL;
   plist = NULL;
   for (i=0;i<acnum;i++)
      {
      if (aclist[i][2]==0) 
	 { alist = addatt(alist,aclist[i][0]); }
      else
	 { plist = addatt(plist,aclist[i][0]); }
      }
}

void showlist(struct attlist *alist)	     /* print out list - for testing */
{
	struct attlist *head;
	struct attvals *vhead;

	for (head=alist;head!=NULL;head=head->next)
	   {
	   for (vhead=head->vals;vhead!=NULL;vhead=vhead->next)
	      {
	      printf("%4d -> %5d %14.7E %s\n",head->accode,
					      vhead->intval,
					      vhead->realval,
					      vhead->text);
	      }
	   }
	printf("\n");
}

/* At the end of each feature, the current list of attribute value is freed */
void freelist(struct attlist *alist)		/* free val list */
{
	struct attlist *head;
	struct attvals *vhead,*vsav;

	for (head=alist;head!=NULL;head=head->next) {
	   vsav = head->vals;
	   for (vhead=head->vals;vhead!=NULL;vhead=vsav) {
	      vsav = vhead->next;
	      free(vhead);
	      }
	   head->vals = NULL;
	   }
}

/* this routine writes the block of attribute values to the appropriate file
(ie the AAT or PAT) at the end of each feature. */
void writelist(struct attlist *alist,int ftype)
{
	struct	attlist *head;
	struct	attvals *vhead;
	int	i,j,fldsiz,maxnum,dtype;
	int	dd,mm,yy;
	int	ival;
	float	rval;
	char	*tval;
	char	attstr[256];
	char	attline[80];
	int	slen,lineptr = 0;
	FILE	*fil;

	/* determine which file to write to */
	if (ftype==0)
	   { fil = faat; }
	else if (ftype==1)
	   { fil = fpat; lineptr=50; }

    for (head=alist;head!=NULL;head=head->next)
	   {
	   /* for each attribute in list ... */
	   maxnum = 0;
	   for (i=0;i<acnum;i++)
	      {
	      if (aclist[i][0]==head->accode && aclist[i][2]==ftype )
		 {
		    /* get attribute info */
		    fldsiz = aclist[i][1];
		    maxnum = aclist[i][5];
		    dtype = aclist[i][6];
		    i = acnum;
		 }
	      }
	   if (maxnum>0) {
	      vhead=head->vals;
	      for (i=0;i<maxnum;i++)
	         {
		    /* write appropriate value to file */
		    switch (dtype)
			 {
		    case 1:  if (vhead==NULL)
				{ ival=0; }
			     else
				{ ival=vhead->intval; }
			     slen=sprintf(attstr,"%11d",ival);
			     break;
		    case 2:  if (vhead==NULL)
				{ rval=0; }
			     else
				{ rval=vhead->realval; }
			     slen=sprintf(attstr,"%14.7E",rval);
			     break;
		    case 3:  if (vhead==NULL)
				{ slen=sprintf(attstr,"%-*s",fldsiz," "); }
			     else
				{ tval=vhead->text;
				  slen=sprintf(attstr,"%-*s",fldsiz,tval); }
			     break;
		    case 4:  if (vhead==NULL)
				{ ival=0; }
			     else
				{ ival=vhead->intval; }
				/* convert to date */
		             if (cvt_day_dmy(&ival,&dd,&mm,&yy)) {
			        slen=sprintf(attstr,"%4d%2d%2d",yy,mm,dd);
			     }
		             else {
			        slen=sprintf(attstr,"18581117");
			     }
			     break;
			  }
		    if (vhead!=NULL) vhead=vhead->next;
		    /* deal with attributes running over onto next line */
		    if (lineptr+slen<80) {
		       fprintf(fil,"%-*s",slen,attstr);
		       lineptr+=slen;
		       }
		    else {
			for (j=0;j<slen;j++)
			   {
			   if (lineptr==80) {
			      lineptr=0;
			      fprintf(fil,"\n"); }
			   fprintf(fil,"%c",attstr[j]);
			   lineptr++;
			   }
		       }
	         }
	      }
	   }
	if (alist!=NULL) { fprintf(fil,"\n"); }
}
