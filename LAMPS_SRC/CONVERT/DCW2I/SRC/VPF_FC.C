/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1992-09-04 17:28:58.000000000 +0100
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
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    S.Townrow, 26-May-1992					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*                             V P F _ F C                      	*/
/*									*/
/* Part of DCW2I which holds the feature code lookup mechanism		*/
/*									*/
/************************************************************************/

#module	VPF_FC "26MY92"

/*----------------------------------------------------------------------*/
/*	Include definitions						*/
/*----------------------------------------------------------------------*/
#include <stat.h>
#include <stdio.h>
#include <string.h>
#include "mespar.h"
#include "vpf_fc.h"
#include "vpf_table.h"
#include "dcw2imsg.h"

extern int verbose;
fc_ptr fc_head = NULL;
fc_ptr fc_tail = NULL;


/*----------------------------------------------------------------------*/
/* LONG INT store_fc_info						*/
/*......................................................................*/
/*									*/
/* Store information from FC table about each feature code		*/
/*----------------------------------------------------------------------*/
long int store_fc_info(int  *fcode,
		       char *vpf,
		       char *pn,
		       int  *pv,
		       char *sn,
		       int  *sv)
{
  fc_ptr fc_entry;

  fc_entry = (fc_ptr)vpfmalloc(sizeof(fc_element));
  fc_entry->fc = (short)*fcode;
  fc_entry->vpftable = (char *)vpfmalloc(strlen(vpf)+1);
  strcpy(fc_entry->vpftable,vpf);
  fc_entry->pname = (char *)vpfmalloc(strlen(pn)+1);
  strcpy(fc_entry->pname,pn);
  fc_entry->pval = *pv;
  fc_entry->sname = (char *)vpfmalloc(strlen(sn)+1);
  strcpy(fc_entry->sname,sn);
  fc_entry->sval = *sv;

  fc_entry->next = NULL;

  if (fc_tail!=NULL) {
    fc_tail->next = fc_entry;
    fc_tail = fc_entry;
  }
  if (fc_head==NULL) {
    fc_head = fc_entry;
    fc_tail = fc_entry;
  }

}




/*----------------------------------------------------------------------*/
/* LONG INT show_fc_info						*/
/*......................................................................*/
/*									*/
/* Show information from FC table about each feature code		*/
/*----------------------------------------------------------------------*/
long int show_fc_info(void)
{
  fc_ptr tmp;

  tmp = fc_head;

  while (tmp!=NULL) {
    printf("%4d %-12.12s %-12.12s %3d %-12.12s %3d\n",tmp->fc,
	                                              tmp->vpftable,
	                                              tmp->pname,
	                                              tmp->pval,
	                                              tmp->sname,
	                                              tmp->sval);
    tmp = tmp->next;
  }
}




/*----------------------------------------------------------------------*/
/* INT find_att_name							*/
/*......................................................................*/
/*									*/
/* Find if the given name is a primary or secondary attribute name 	*/
/*----------------------------------------------------------------------*/
extern int find_att_name(char *table,
			 char *name)
{
  fc_ptr tmp;

  tmp = fc_head;
  while (tmp!=NULL) {
    if (strcmp(tmp->vpftable,table)==0) {
      if (strcmp(tmp->pname,name)==0) return 1;
      if (strcmp(tmp->sname,name)==0) return 2;
    }
    tmp = tmp->next;
  }
  return -1;
}




/*----------------------------------------------------------------------*/
/* SHORT get_fc								*/
/*......................................................................*/
/*									*/
/* Find a FC matching the primary and secondary attribute (and values)	*/
/*----------------------------------------------------------------------*/
extern short get_fc(char *table,
		    char *prim_name,
		    int   prim_val,
		    char *sec_name,
		    int   sec_val)
{
  fc_ptr tmp;

  tmp = fc_head;
  
  while (tmp!=NULL) {
    if (strcmp(tmp->vpftable,table)==0) {
      if (strlen(tmp->pname)==0 && strlen(tmp->sname)==0) {
	return tmp->fc;
      }
      else {
	if (strlen(tmp->sname)==0) {
	  if (strcmp(tmp->pname,prim_name)==0) {
	    if (tmp->pval==prim_val) return tmp->fc;
/*	    if (prim_val==L_UNDEFINED) {
	      if (verbose) lsl_putmsg(&DCW2I__NULLCODED,&0);
	      return 0;
	    }*/
	  }
	} 
	else {
	  if (strcmp(tmp->pname,prim_name)==0 &&
	      strcmp(tmp->sname,sec_name)==0) {
	    if (tmp->pval==prim_val && tmp->sval==sec_val) return tmp->fc;
/*	    if (prim_val==L_UNDEFINED) {
	      if (verbose) lsl_putmsg(&DCW2I__NULLCODED,&0);
	      return 0;
	    }*/
	  }
	}
      }
    }
    tmp = tmp->next;
  }
  return -1;   /* this feature wasn't found in lookup so chuck it */
}




/*----------------------------------------------------------------------*/
/* VOID free_fc_table							*/
/*......................................................................*/
/*									*/
/* Free all the entries in the table					*/
/*----------------------------------------------------------------------*/
void free_fc_table(void)
{
  fc_ptr tmp,n;

  tmp=fc_head;

  while (tmp!=NULL) {
    free(tmp->vpftable);
    free(tmp->pname);
    free(tmp->sname);
    n = tmp->next;
    if (tmp->next!=NULL) free(tmp->next);
    free(tmp);
    tmp = n;
  }
}
