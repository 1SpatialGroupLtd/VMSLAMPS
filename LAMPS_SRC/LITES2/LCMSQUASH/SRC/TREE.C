#module TREE "05OC92"

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Sunil Gupta, 30-Sep-1992					*/
/************************************************************************/

#include <stdio.h>
#include <descrip.h>
#include <string.h>
#include "tree.h"
#include "str_desc.h"


/*----------------------------------------------------------------------*/
/*	These routines are my own binary tree specific routines		*/
/*	these only allow insertion and doesnt worry about balancing	*/
/*	These provide a quick method of inserting something in a tree	*/
/*	and later on seeing if that element is still there. It is ideal	*/
/*	for applications that do lots of inserts and no deletions from	*/
/*									*/
/*	You can use binlib instead, but these are recursive routines	*/
/*	and are simpler to understand.					*/
/*									*/
/*	Thanks for the support in writing fortran<->C interfaces from 	*/
/*	Barron Greig							*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/*	dereference variables passed from fortran, call relevant C	*/
/*----------------------------------------------------------------------*/
int fortran_tree_search(tree *t, struct dsc$descriptor *desc)
{
	char item[100];

	desc_to_str( desc, item);
	return(  tree_search(*t, item)  );
}

int fortran_tree_add_item( tree *t, struct dsc$descriptor *desc)
{
	char item[100];

	desc_to_str( desc, item);
	return (   (tree_add_item(*t,item) == ADDED)?1:0   );
}

void fortran_tree_list( tree *t)
{
	tree_list (*t);
}

/*----------------------------------------------------------------------*/
/* add_result node_add_item						*/
/* 	add_to_tree to left						*/
/* 	OR add_to_tree to right						*/
/* 	OR add_to_node							*/
/*----------------------------------------------------------------------*/
add_result node_add_item(tree t, node *n, void *item)
{
	add_result retval;
	int	cmp_result;

	if (*n == NULL)
	{
		*n = node_create(t);
		(t->copy)( (*n)->item, item);
		retval = ADDED;
	}else{
	   	cmp_result =  (t->compare) ((*n)->item, item);
	   	switch (cmp_result)
	   	{
			case 0:	/*equal to */
				retval = EXISTS;
				break;
			case 1: /*1st arg is greater than */
				retval = node_add_item(t, &((*n)->left), item);
				break;
			case -1: /*1st arg is less than */
				retval = node_add_item(t, &((*n)->right), item);
				break;
		}
	}
	return (retval);
}


/*----------------------------------------------------------------------*/
/* node_create								*/
/* 	allocate memory for node					*/
/* 	initialise all fields to NULL					*/
/*----------------------------------------------------------------------*/
node node_create(tree t)
{
	node n;

	n = (node) malloc( sizeof(_node_struct) );
	n->left = n->item = n->right =NULL;

	n->item = malloc(t->item_size);

	return(n);
}



/*----------------------------------------------------------------------*/
/* node_destroy								*/
/* 	destroy_node left						*/
/* 	free memory associate with node item				*/
/* 	destroy_node right						*/
/*----------------------------------------------------------------------*/
void node_destroy( node n)
{
	if ( n != NULL)
	{
	   node_destroy ( n->left  );
	   node_destroy ( n->right );

	   free ( n->item);
	   free ( n );
	}
}


/*----------------------------------------------------------------------*/
/* node_list 								*/
/* 	show the left node						*/
/* 	show the item							*/
/* 	show the right node						*/
/*----------------------------------------------------------------------*/
void node_list ( tree t, node n)
{
	if ( n != NULL)
	{
	   node_list (t, n->left  );
	   (t->list) (n->item);
	   node_list (t, n->right );
	}
}



/*----------------------------------------------------------------------*/
/*node_search								*/
/*	look for an item in a node					*/
/*----------------------------------------------------------------------*/
int node_search (tree t, node n, void *item)
{
	int	cmp_result;
	int	retval;

	if (n == NULL)
	{
		retval = 0;
	}else{
	   	cmp_result =  (t->compare) (n->item, item);
	   	switch (cmp_result)
	   	{
			case 0:	/*equal to */
				retval = 1;
				break;
			case 1: /*1st arg is greater than */
				retval = node_search(t, n->left, item);
				break;
			case -1: /*1st arg is less than */
				retval = node_search(t, n->right, item);
				break;
		}
	}
	return (retval);
}



/*----------------------------------------------------------------------*/
/* tree_add_item							*/
/*	get the top node from tree structure				*/
/*	add_to_node top_node						*/
/*----------------------------------------------------------------------*/
add_result tree_add_item( tree t, void *item)
{
	return ( node_add_item (t, &(t->tree_top), item) );
}



/*----------------------------------------------------------------------*/
/* 	allocate space for tree structure				*/
/* 	copy arguments into structure					*/
/* 	create an empty node						*/
/*----------------------------------------------------------------------*/
tree tree_create( unsigned int item_size, int (*cmp)(), void (*cpy)(), void (*list)() )
{
	tree t;
	
	t = (tree) malloc( sizeof(_tree_struct) );
	t->item_size = item_size;
	t->compare = cmp;
	t->copy = cpy;
	t->list = list;
	t->tree_top = NULL;

	return(t);
}


/*----------------------------------------------------------------------*/
/* tree_destroy								*/
/* 	destroy the node structure					*/
/* 	free memory associated with tree structure			*/
/*----------------------------------------------------------------------*/
void tree_destroy(tree *t)
{
	node_destroy( (*t)->tree_top );
	free(*t);
	*t = NULL;
}

/*----------------------------------------------------------------------*/
/* tree_list								*/
/* 	list the elements of the tree					*/
/*----------------------------------------------------------------------*/
void tree_list(tree t)
{
	node_list( t, t->tree_top );
}

/*----------------------------------------------------------------------*/
/* tree_search								*/
/* 	look for an item in a tree					*/
/*----------------------------------------------------------------------*/
int tree_search (tree t, void *item)
{
	return (node_search(t,t->tree_top,item));
}




