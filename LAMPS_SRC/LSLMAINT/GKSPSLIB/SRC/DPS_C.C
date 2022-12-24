/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-28 17:10:12.000000000 +0100
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
#module DPS_C "28MR95"

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Clarke Brunt, 13-Jul-1993					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*				 D P S 					*/
/*									*/
/************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <lsl$library:lsldef.h>	/* standard LSL header  */

/* get round VAXC realloc failure with NULL pointer */
#define REALLOC(p,s) ((p)==NULL)?malloc(s):realloc(p,s)

typedef	struct _finfo Finfo;
typedef	struct _kpair KPair;
typedef	struct _character Character;
typedef	struct _component Component;
struct _finfo {
   int		fnum;
   float	scale;
   int		nchar;
   Character	*charptr;
   int		kerned;
   int		tabsiz;
   long		*namtab;
   int		r_to_l;
   unsigned char *aratab;
};
struct _kpair {
   short	c2;
   float	kpx;
};
struct _character {
   float	width;
   float	box[4];
   int		npair;
   KPair	*pairptr;
   int		ncomp;
   Component	*cptr;
};
struct _component {
   short	c2;
   float	deltax,deltay;
};
static Finfo *fptr=NULL;
static int fcnt=0;

/*----------------------------------------------------------------------*/
/* EXTERN GKS_C_ALLOC_FONT						*/
/*......................................................................*/
/*									*/
/* Allocate a new font definition					*/
/*----------------------------------------------------------------------*/

extern Finfo *GKS_C_ALLOC_FONT(
		int	*fnum,
		float	*scale,
		int	*kerned,
		int	*r_to_l,
		int	*arabic,
		unsigned char *aratab)
{
   int i;
   Finfo *finf=fptr;

/* check if we have had this font before */
   for (i=0;i<fcnt;i++,finf++) if (finf->fnum == *fnum) return NULL;

   fcnt++;
   fptr = REALLOC(fptr,fcnt*sizeof(Finfo));
   finf = fptr + fcnt - 1;
   finf->fnum = *fnum;
   finf->scale = *scale;
   finf->kerned = *kerned;
   finf->nchar = 0;
   finf->charptr = NULL;
   finf->tabsiz = 0;
   finf->namtab = NULL;
   finf->r_to_l = *r_to_l;
   finf->aratab = NULL;
   if (*arabic)
   {
      finf->aratab = malloc(256*4);
      memcpy(finf->aratab,aratab,256*4);
   }

   return finf;
}

/*----------------------------------------------------------------------*/
/* EXTERN GKS_C_FIND_FONT						*/
/*......................................................................*/
/*									*/
/* Find a font definition						*/
/*----------------------------------------------------------------------*/

extern Finfo *GKS_C_FIND_FONT(
		int	*fnum,
		float	*scale,
		int	*kerned,
		int	*got_width,
		long	*namtab,
		int	*r_to_l,
		int	*arabic)
{
   int i;
   Finfo *finf=fptr;

/* check if we have had this font before */
   for (i=0;i<fcnt;i++,finf++)
   {
      if (finf->fnum == *fnum)
      {
         *scale = finf->scale;
         *got_width = (finf->charptr)?1:0;
         *kerned = (*got_width && finf->kerned);
         *namtab = finf->namtab;
         *r_to_l = (*got_width && finf->r_to_l);
         *arabic = (finf->aratab)?1:0;
         break;
      }
   }
   if (i==fcnt) return NULL;
   return finf;
}

/*----------------------------------------------------------------------*/
/* EXTERN GKS_C_SET_TAB_SIZE						*/
/*......................................................................*/
/*									*/
/* Sets the size, and character name table of a font			*/
/*----------------------------------------------------------------------*/

extern void GKS_C_SET_TAB_SIZE(
		Finfo	*finf,
		int	*nchar,
		long	*namtab)
{
   finf->nchar = *nchar;
   /* worst case assumption that all characters are un-encoded */
   finf->charptr = calloc(256 + *nchar, sizeof(Character));
   finf->tabsiz = *nchar;
   finf->namtab = namtab;
}

/*----------------------------------------------------------------------*/
/* EXTERN GKS_C_TRIM_TAB						*/
/*......................................................................*/
/*									*/
/* Trim character array to true size (after all chars entered)		*/
/*----------------------------------------------------------------------*/

extern void GKS_C_TRIM_TAB(
		Finfo	*finf,
		int	*nchar)
{
   finf->nchar = *nchar;
   finf->charptr = REALLOC(finf->charptr,*nchar * sizeof(Character));
}

/*----------------------------------------------------------------------*/
/* EXTERN GKS_C_SET_CHAR_METRICS					*/
/*......................................................................*/
/*									*/
/* Sets a character's metrics in a font					*/
/*----------------------------------------------------------------------*/

extern void GKS_C_SET_CHAR_METRICS(
		Finfo	*finf,
		int	*charno,
		float	*width,
		float	box[4])
{
   int i;
   Character *c = finf->charptr + *charno;
   float *cbox = c->box;
   c->width = *width/1000.0;
   for (i=0;i<4;i++) cbox[i] = box[i]/1000.0;
}

/*----------------------------------------------------------------------*/
/* EXTERN GKS_C_GET_CHAR_WIDTH						*/
/*......................................................................*/
/*									*/
/* Gets a character's width from a font					*/
/*----------------------------------------------------------------------*/

extern float GKS_C_GET_CHAR_WIDTH(
		Finfo	*finf,
		int	*charno)
{
   return finf->charptr[*charno].width;
}

/*----------------------------------------------------------------------*/
/* EXTERN GKS_C_GET_CHAR_METRICS					*/
/*......................................................................*/
/*									*/
/* Gets a character's metrics from a font				*/
/*----------------------------------------------------------------------*/

extern float GKS_C_GET_CHAR_METRICS(
		Finfo	*finf,
		int	*charno,
		float	box[4])
{
   int i;
   Character *c = finf->charptr + *charno;
   float *cbox = c->box;
   for (i=0;i<4;i++) box[i] = cbox[i];
   return c->width;
}

/*----------------------------------------------------------------------*/
/* EXTERN GKS_C_SET_KERN_PAIR						*/
/*......................................................................*/
/*									*/
/* Sets a kern pair in a font						*/
/*----------------------------------------------------------------------*/

extern void GKS_C_SET_KERN_PAIR(
		Finfo	*finf,
		int	*c1,
		int	*c2,
		float	*kpx)
{
   Character *c;
   KPair *pair;
   c = finf->charptr + *c1;
   c->npair++;
   c->pairptr = REALLOC(c->pairptr,c->npair*sizeof(KPair));
   pair = c->pairptr + c->npair - 1;
   pair->c2 = *c2;
   pair->kpx = *kpx/1000.0;
}

/*----------------------------------------------------------------------*/
/* EXTERN GKS_C_GET_KERN_PAIR						*/
/*......................................................................*/
/*									*/
/* Gets a kern pair from a font						*/
/*----------------------------------------------------------------------*/

extern float GKS_C_GET_KERN_PAIR(
		Finfo	*finf,
		int	*c1,
		int	*c2)
{
   Character *c = finf->charptr + *c1;
   KPair *pptr = c->pairptr;
   int i;
   float k=0.0;
   for (i=0;i<c->npair;i++,pptr++)
   {
      if (pptr->c2 == *c2)
      {
         k = pptr->kpx; break;
      }
   }
   return k;
}

/*----------------------------------------------------------------------*/
/* EXTERN GKS_C_SET_COMPONENT						*/
/*......................................................................*/
/*									*/
/* Sets a component of a composite character				*/
/*----------------------------------------------------------------------*/

extern void GKS_C_SET_COMPONENT(
		Finfo	*finf,
		int	*c1,
		int	*c2,
		float	*deltax,
		float	*deltay)
{
   Character *c;
   Component *cc;
   c = finf->charptr + *c1;
   c->ncomp++;
   c->cptr = REALLOC(c->cptr,c->ncomp*sizeof(Component));
   cc = c->cptr + c->ncomp - 1;
   cc->c2 = *c2;
   cc->deltax = *deltax/1000.0;
   cc->deltay = *deltay/1000.0;
}

/*----------------------------------------------------------------------*/
/* EXTERN GKS_C_GET_COMPONENT						*/
/*......................................................................*/
/*									*/
/* Gets a component of a composite character				*/
/*----------------------------------------------------------------------*/

extern int GKS_C_GET_COMPONENT(
		Finfo	*finf,
		int	*c1,
		int	*n,
		float	*deltax,
		float	*deltay)
{
   Character *c;
   Component *cc;
   c = finf->charptr + *c1;
   if (*n<0 || *n>=c->ncomp) return -1;
   cc = c->cptr + *n;
   *deltax = cc->deltax;
   *deltay = cc->deltay;
   return cc->c2;
}

/*----------------------------------------------------------------------*/
/* EXTERN GKS_C_GET_ARABIC						*/
/*......................................................................*/
/*									*/
/* Gets the form of Arabic character at position p in string		*/
/*----------------------------------------------------------------------*/

extern int GKS_C_GET_ARABIC(
		Finfo	*finf,
		unsigned char *string,
		int	*len,
		int	*p,
		int	*comp)
{
   unsigned char *aratab=finf->aratab;
   Character *ctab=finf->charptr;
   int a1,a3;
   int ptr;
   int a,c,c2;

   c2 = string[*p];
   if (aratab[c2*4]==0) return -1;	/* this char not Arabic */

   /* find if previous non-zero width character is Arabic */
   /* check for something in the 'Isolate' column of the table.
      If the 'Isolate' is the same as the 'Initial' then the
      character does not join its successor */
   a1 = FALSE;
   ptr = *p;
   while (ptr-- > 0) {
      c = string[ptr];
      if (*comp && c=='}') break;
      a = aratab[c*4];
      if (a==0) break;
      if (ctab[a].width!=0.0) {
         if (aratab[c*4]!=aratab[c*4+3]) a1 = TRUE;
         break;
      }
   }

   /* find if next non-zero width character is Arabic */
   /* check for something in the 'Isolate' column of the table.
      If the 'Isolate' is the same as the 'Final' then the
      character does not join its predecessor */
   a3 = FALSE;
   ptr = *p;
   while (++ptr < *len) {
      c = string[ptr];
      if (*comp && c=='{') break;
      a = aratab[c*4];
      if (a==0) break;
      if (ctab[a].width!=0.0) {
         if (aratab[c*4]!=aratab[c*4+1]) a3 = TRUE;
         break;
      }
   }
   /* Utilise values 0 and 1 for Booleans here */
   if (a3) a1 = !a1;
   a = aratab[4*c2 + 2*a3 + a1];
   if (a==0) a = aratab[4*c2];
   return a;
}

/*----------------------------------------------------------------------*/
/* EXTERN GKS_C_FREE_FONTS						*/
/*......................................................................*/
/*									*/
/* Free all font definitions						*/
/*----------------------------------------------------------------------*/

extern void GKS_C_FREE_FONTS()
{
   int i,j;
   Finfo *finf = fptr;
   Character *c;

   for (i=0;i<fcnt;i++,finf++)
   {
      if (finf->namtab) GKS_FREE_NAME_TABLE(&finf->tabsiz,finf->namtab);
      c = finf->charptr;
      for (j=0;j<finf->nchar;j++,c++)
      {
         free(c->pairptr);
         free(c->cptr);
      }
      free(finf->charptr);
      free(finf->aratab);
   }
   free(fptr); fptr = NULL; fcnt = 0;
}
