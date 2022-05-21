/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1992-06-23 11:41:20.000000000 +0100
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
#ifndef TREE__LIB
#define TREE__LIB
/*----------------------------------------------------------------------*/
/*			treelib						*/
/*----------------------------------------------------------------------*/

#define NAME_SIZE 40			/*maximum of 40 chars in a name */
#define DEBUG				/*debugging on			*/

/*----------------------------------------------------------------------*/
/*			structures needed				*/
/*----------------------------------------------------------------------*/
typedef struct node_struct *node;
typedef struct node_struct
{
	void *left;
	void *item;
	void *right;
}_node_struct;

typedef struct tree_struct *tree;
typedef struct tree_struct
{
	unsigned int item_size;
	int 	(*compare)();
	void	(*copy)();
	void	(*list)();
	node	tree_top;
}_tree_struct;

typedef enum {ADDED, OUTMEM, EXISTS} add_result;


/*----------------------------------------------------------------------*/
/*		C functions to interface from fortran to C		*/
/*----------------------------------------------------------------------*/
extern int fortran_tree_add_item(tree *t, struct dsc$descriptor *desc);
extern int fortran_tree_search (tree *t, struct dsc$descriptor *desc);
extern void fortran_tree_list (tree *t);


/*----------------------------------------------------------------------*/
/*		functions to manipulate Nodes of trees			*/
/*----------------------------------------------------------------------*/
static add_result node_add_item(tree t, node *n, void *item);
static node node_create(tree t);
static void node_list (tree t, node n);
static void node_destroy( node n);
static int node_search (tree t, node n, void *item);


/*----------------------------------------------------------------------*/
/*		functions to manipulate trees				*/
/*----------------------------------------------------------------------*/
extern add_result tree_add_item( tree t, void *item);
extern tree tree_create( unsigned int item_size, int (*cmp)(), void (*cpy)(), void (*list)() );
extern void tree_destroy(tree *t);
extern void tree_list (tree t);
extern int tree_search (tree t, void *item);

#endif
