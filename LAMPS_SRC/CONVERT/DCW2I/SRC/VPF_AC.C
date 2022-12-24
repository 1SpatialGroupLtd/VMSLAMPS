/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1993-05-13 16:19:12.000000000 +0100
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
/*                             V P F _ A C                      	*/
/*									*/
/* Part of DCW2I which holds the attribute code lookup mechanism	*/
/*									*/
/************************************************************************/

#module	VPF_AC "13MY93"

/*----------------------------------------------------------------------*/
/*	Include definitions						*/
/*----------------------------------------------------------------------*/
#include <stat.h>
#include <stdio.h>
#include <string.h>
#include "mespar.h"
#include "vpf_ac.h"
#include "vpf_table.h"
#include "dcw2imsg.h"

ac_ptr ac_head = NULL;
ac_ptr ac_tail = NULL;


/*----------------------------------------------------------------------*/
/* LONG INT store_ac_info						*/
/*......................................................................*/
/*									*/
/* Store information from FC table about each feature code		*/
/*----------------------------------------------------------------------*/
long int store_ac_info(int *acode,
		       int *fcode,
		       char  *name,
		       int  *type)
{
  ac_ptr ac_entry;

  ac_entry = (ac_ptr)vpfmalloc(sizeof(ac_element));
  ac_entry->ac = (short)*acode;
  ac_entry->fc = (short)*fcode;
  ac_entry->acname = (char *)vpfmalloc(strlen(name)+1);
  strcpy(ac_entry->acname,name);
  ac_entry->actype = (char)*type;
  ac_entry->next = NULL;

  if (ac_tail!=NULL) {
    ac_tail->next = ac_entry;
    ac_tail = ac_entry;
  }
  if (ac_head==NULL) {
    ac_head = ac_entry;
    ac_tail = ac_entry;
  }
}




/*----------------------------------------------------------------------*/
/* LONG INT show_ac_info						*/
/*......................................................................*/
/*									*/
/* Show information from FC table about each feature code		*/
/*----------------------------------------------------------------------*/
long int show_ac_info(void)
{
  ac_ptr tmp;

  tmp = ac_head;

  while (tmp!=NULL) {
    printf("%4d %4d %-12.12s %c\n",tmp->ac,
	                           tmp->fc,
	                           tmp->acname,
	                           tmp->actype);
    tmp = tmp->next;
  }
}



/*----------------------------------------------------------------------*/
/* SHORT get_ac								*/
/*......................................................................*/
/*									*/
/* Find an AC in the attribute table matching the given name.		*/
/* Warnings are given if the Type and FC don't match those in the	*/
/* AC table.								*/
/*----------------------------------------------------------------------*/
extern short get_ac(char *ac,
		    char  type,
		    short fcode)
{
  ac_ptr tmp;

  tmp = ac_head;
  while (tmp!=NULL) {
    if (strcmp(tmp->acname,ac)==0 && tmp->fc==fcode) {
      if (tmp->actype!=type) {
	if (type=='S' && tmp->actype=='I') return tmp->ac;
	lsl_putmsg(&DCW2I__BADTYPE,&ac[0],&type,&(tmp->actype),&type);
      }
      return tmp->ac;
    }
    tmp = tmp->next;
  }
  return -1;   /* this AC wasn't found in lookup so chuck it */
}




/*----------------------------------------------------------------------*/
/* VOID free_ac_table							*/
/*......................................................................*/
/*									*/
/* Free all the entries in the table					*/
/*----------------------------------------------------------------------*/
void free_ac_table(void)
{
  ac_ptr tmp,n;

  tmp=ac_head;

  while (tmp!=NULL) {
    free(tmp->acname);
    n = tmp->next;
    if (tmp->next!=NULL) free(tmp->next);
    free(tmp);
    tmp = n;
  }
}
