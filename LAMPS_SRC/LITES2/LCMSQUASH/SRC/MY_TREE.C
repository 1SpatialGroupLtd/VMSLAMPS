/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1992-10-01 11:47:00.000000000 +0100
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
#module MY_TREE "01OC92"

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Sunil Gupta, 30-Sep-1992					*/
/************************************************************************/

#include <stdio.h>
#include <descrip.h>
#include <string.h>
#include "tree.h"

static tree init_tree(void);
static void kill_tree(tree *t);
static int my_cmp_fn(char *s1, char *s2);
static void my_cpy_fn(char *s1, char *s2);
static void my_list_fn(void *item);

extern void F77_LIST_ITEM(struct dsc$descriptor *);

/*----------------------------------------------------------------------*/
/*									*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/
tree init_tree()
{
   return( tree_create(256*sizeof(char),&my_cmp_fn,&my_cpy_fn,&my_list_fn) );
}

/*----------------------------------------------------------------------*/
/*									*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/
void kill_tree(tree *t)
{
	tree_destroy(t);
}

/*----------------------------------------------------------------------*/
/* returns:								*/
/*	-1	if s1 < s2						*/
/*	0	if s1 == s2						*/
/*	1	if s1 > s2						*/
/*----------------------------------------------------------------------*/
int my_cmp_fn(char *s1, char *s2)
{
	int retval;

	retval = strcmp(s1,s2) ;
	return ((retval<0)?-1:((retval>0)?1:0));
}

/*----------------------------------------------------------------------*/
/*									*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/
void my_cpy_fn(char *s1, char *s2)
{
	strcpy(s1,s2);
}

/*----------------------------------------------------------------------*/
/*Print the item to screen and also to the listing file			*/
/*NOTE. THe files were opened in FORTRAN so a string must be passed back*/
/*to a fortran function for printing.					*/
/*----------------------------------------------------------------------*/
void my_list_fn(void *item)
{
	struct dsc$descriptor_s outdesc;		/*output descriptor*/

	printf("\t\t\t%s\n",(char *)item);		/*print to screen*/
							
	str_to_desc((char *)item, &outdesc);		/*convert */
	F77_LIST_ITEM(&outdesc);
}
