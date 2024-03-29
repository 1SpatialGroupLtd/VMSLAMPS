/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:13:02.000000000 +0000
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
#ifndef _SABIN_INTRINSICS
#define _SABIN_INTRINSICS
/* $Header: /lslhome/gothic/hdr/sabinlib/v1-1/RCS/hdr.sabin_intrinsics.h,v 1.2 1992/04/15 15:37:49 davidr Exp $								*/
/* 									*/
/* $Log: hdr.sabin_intrinsics.h,v $
 * Revision 1.2  1992/04/15  15:37:49  davidr
 * Version v1-1 derived from v1-0
 * Memory debugging disabled - it had been accidentally enabled in V1-0
 *
 * Revision 1.1  1992/03/16  22:47:01  jon
 * Version v1-0 derived from root
 * Version containing `test' alternative from old system
 *								*/

/*>>> EXTERN functions from SABIN.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN sabin_create_tree						*/
/*......................................................................*/
/* Create a new binary tree						*/
/*									*/
/* In	:	NOTHING							*/
/* Out	:	*tree_id	The SABIN tree ID.			*/
/* Ret	:	GOTH__NORMAL						*/
/* 		GOTH__MALLOC						*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS sabin_create_tree(SABIN_TREE_ID	*tree_id);
/*----------------------------------------------------------------------*/
/* EXTERN sabin_add_node						*/
/*......................................................................*/
/* Add a node to a binary tree. The address must be unique. If the	*/
/* string == NULL then no string is stored. The SABINLIB stores a copy	*/
/* of the string passed. So you must free up string (if needed) after	*/
/* this function call.							*/
/*									*/
/* In	:	tree_id	the tree identifier				*/
/* 		address	long-integer value to store in binary tree.	*/
/* 		*string	the character string to store.			*/
/* Out	:	NOTHING							*/
/* Ret	:	GOTH__NORMAL						*/
/*		GOTH__EXISTS	Address already in tree.		*/
/*		GOTH__MALLOC	No memory left.				*/
/*		GOTH__UNKTRE	Unknown sabin tree.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS sabin_add_node(SABIN_TREE_ID	tree_id,
				  GOTH_INTEGER	address,
				  char		*string);
/*----------------------------------------------------------------------*/
/* EXTERN sabin_count_nodes						*/
/*......................................................................*/
/* Return the number of nodes presently in the tree			*/
/*									*/
/* In	:	tree_id	tree identifier					*/
/* Out	:	*count	number of nodes					*/
/* Ret	:	GOTH__NORMAL						*/
/*		GOTH__UNKTRE						*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS sabin_count_nodes(SABIN_TREE_ID	tree_id,
				     GOTH_INTEGER	*count);
/*----------------------------------------------------------------------*/
/* EXTERN sabin_get_node						*/
/*......................................................................*/
/* Return the value of the node with the specified address		*/
/*									*/
/* In	:	tree_id		tree identifier				*/
/* 		address		value of long integer of the node	*/
/* Out	:	**string	pointer to copy of string in node. You	*/
/*				are responsible for freeing this copy!!	*/
/* Ret	:	GOTH__NORMAL if the value is returned			*/
/*	     	GOTH__UNKTRE if the tree id is not recognised		*/
/*	     	GOTH__ABSENT if there is no node with that address	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS sabin_get_node(SABIN_TREE_ID	tree_id,
				  GOTH_INTEGER	address,
				  char		**string);
/*----------------------------------------------------------------------*/
/* EXTERN sabin_delete_tree						*/
/*......................................................................*/
/* Delete the specified tree, freeing all space associated with it	*/
/*									*/
/* In	:	tree_id	Tree to delete.					*/
/* Out	:	NOTHING							*/
/* Ret	:	GOTH__NORMAL if the tree id makes sense			*/
/*		GOTH__UNKTRE if the tree id is not recognised		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS sabin_delete_tree(SABIN_TREE_ID	tree_id);
/*----------------------------------------------------------------------*/
/* EXTERN sabin_remove_node						*/
/*......................................................................*/
/* Remove the node with the specified address				*/
/*									*/
/* In	:	tree_id	The tree identifier				*/
/* 		address	The address to remove (it's string is also	*/
/*			removed).					*/
/* Out	:	NOTHING							*/
/* Ret	:	GOTH__NORMAL if the node is successfully removed	*/
/*		GOTH__UNKTRE if the tree id is not recognised		*/
/*	     	GOTH__ABSENT if there is no node with that address	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS sabin_remove_node(SABIN_TREE_ID	tree_id,
				     GOTH_INTEGER	address);
/*----------------------------------------------------------------------*/
/* EXTERN sabin_traverse_tree						*/
/*......................................................................*/
/* Traverse the tree, applying the specified function to each node	*/
/*									*/
/* In	:	tree_id		The tree identifier			*/
/* 		ascending	Specifies the order to traverse the tree*/
/* 		callback	The callback to apply to each node	*/
/*		void_param	VOID parameter passed back to function	*/
/* Out	:	NOTHING. 	The function `function' is called for	*/
/*				each node. The parameter void_param and	*/
/*				the integer and string are passed too.	*/
/* Ret	:	GOTH__NORMAL	if the traversal has been completed, or */
/*				if it has finished at the request of	*/
/*				function				*/
/*		GOTH__UNKTRE	if the tree id is not recognised	*/
/*		GOTH__FAIL	if function failed			*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*									*/
/* 1) ascending should be TRUE if nodes are to be processed in order of	*/
/*    ascending node address, and FALSE for the reverse			*/
/*									*/
/* 2) function must meet the following definition:			*/
/*									*/
/*    typedef GOTH_STATUS (*SABIN_CALLBACK)(VOID_P	 void_param,	*/
/*				            GOTH_INTEGER address,	*/
/*				            char	 *string);	*/
/*									*/
/*    Note that the string the callback	receives is a COPY and must	*/
/*    be freed by the callback.						*/
/*									*/
/*    This is typedef defined in sabin_defns.h				*/
/*									*/
/*    returns:								*/
/*		GOTH__NORMAL if the callback succeeds			*/
/*		GOTH__FINISH if the traversal should stop		*/
/*		GOTH__FAIL   if the callback fails			*/
/*									*/
/*    function will be applied to each node of the tree, in the		*/
/*    specified order, until all nodes have been processed, or		*/
/*    function returns GOTH__FINISH.					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS sabin_traverse_tree(SABIN_TREE_ID	tree_id,
				       GOTH_BOOLEAN	ascending,
				       VOID_P		void_param,
				       SABIN_CALLBACK	callback);
/*----------------------------------------------------------------------*/
/* EXTERN sabin_print_tree						*/
/*......................................................................*/
/* Print out a representation of the specified tree			*/
/* - for each node, output its address and string fields		*/
/*									*/
/* In	:	tree_id	Tree to print.					*/
/* Out	:	NOTHING							*/
/* Ret	:	GOTH__NORMAL						*/
/* 		GOTH_UNKTRE	If tree is not recognised.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS sabin_print_tree(SABIN_TREE_ID	tree_id);

#endif
