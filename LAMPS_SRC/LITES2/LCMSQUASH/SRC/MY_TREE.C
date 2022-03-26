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
