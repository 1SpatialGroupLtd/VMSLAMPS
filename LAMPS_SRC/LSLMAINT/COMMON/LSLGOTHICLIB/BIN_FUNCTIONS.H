/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 17:41:50.000000000 +0000
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
#ifndef _BIN_FUNCTIONS
#define _BIN_FUNCTIONS
/* $Header: /usr/users/jon/RCS/hdr.bin_functions.h,v 1.5 1995/01/15 21:48:24 jon Exp $								*/


#include "bin_defns.h"

/************************************************************************/
/*									*/
/*		    B I N _ F U N C T I O N S . H			*/
/*									*/
/* External function definitions for BINLIB				*/
/* Requires the prior inclusion of GOTHIC_HDR:BIN_DEFNS.H		*/
/*									*/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England    */
/* Author    TJ Ibbs, 28 February 1989					*/
/*									*/
/* Version 2.0 of include file, 30 November 1989			*/
/************************************************************************/

/*>>> EXTERN functions from BINLIB.C <<<*/


/*----------------------------------------------------------------------*/
/* EXTERN bin_create_tree						*/
/*......................................................................*/
/* Create a new binary tree						*/
/*									*/
/* sizeof_value	- in  - the size of a node `value', as returned by the	*/
/*			sizeof operator (ie, in bytes)			*/
/* tree_id	- out - the tree identifier				*/
/*									*/
/* Note that `value_size' may be zero, if value fields are not		*/
/* required within the tree						*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*			     DEFAULTS					*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* The following defaults are used when a tree is created:		*/
/*									*/
/*	o  address type is BIN__INT  (ie, simple integers)		*/
/*	o  thus address size `sizeof(int)'				*/
/*	o  addition mode is BIN__UNQ (ie, nodes may not be overwritten)	*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*									*/
/* returns - GOTH__NORMAL if the tree is successfully created		*/
/*	     GOTH__MALLOC if there is no memory left for the tree	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_create_tree(BIN_TREE_ID	 *tree_id );
/*----------------------------------------------------------------------*/
/* EXTERN bin_define_address						*/
/*......................................................................*/
/* Tell the library how a node `address' is to be handled		*/
/*									*/
/* tree_id	- in  - identifies the tree being used			*/
/* address_type	- in  - identifies the datatype of a node `address'	*/
/* value_type	- in  - identifies the datatype of a node `value'	*/
/*									*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*			      NOTES					*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*									*/
/*	o  address_type must be a GOTHIC datatype.			*/
/*									*/
/*	o  if the tree already contains data (ie, if any nodes have	*/
/*	   been inserted into it) then this function may not be used	*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*									*/
/* returns - GOTH__NORMAL if all is well				*/
/*	     GOTH__UNKTRE if the tree id is not recognised		*/
/*	     GOTH__TREFUL if the tree already contains data		*/
/*	     GOTH__BADTYP if address_type is not recognised		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_define_address(BIN_TREE_ID	 tree_id,
				      GOTH_DATATYPE	 address_type,
				      GOTH_DATATYPE	 value_type);
/*----------------------------------------------------------------------*/
/* EXTERN bin_override_special						*/
/*......................................................................*/
/* Tell the library how a node `address' of type DT_SPECIAL is to be	*/
/* handled, if the default behaviour is nor required. This can only be	*/
/* used on an empty tree. A special comparison function is also required*/
/* to perform comparisons on the data.					*/
/*									*/
/* tree_id	- in  - identifies the tree being used			*/
/* address_size - in  - size of new datastructure for use with special.	*/
/* value_size   - in  - size of new datastructure for use with special.	*/
/* comp_func	- in  - replacement comparison function			*/
/*									*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*			      NOTES					*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*									*/
/*	o  address_type in node must be DT_SPECIAL.			*/
/*									*/
/*	o  address_size is size of the new datastructure to be held on	*/
/*	   the node.							*/
/*									*/
/*	o  value_size is size of the new datastructure to be held on	*/
/*	   the node.							*/
/*									*/
/*	o  comp_func is required to perform comparison of the new	*/
/*	   datastructure. It is used to order node addresses,		*/
/*	   and must meet the follwoing definition.			*/
/*									*/
/*		GOTH_STATUS comp_func(BIN_ADR_PTR addr1,		*/
/*				      BIN_ADR_PTR addr2);		*/
/*									*/
/*	   If address1 is at addr1 and address2 is at addr2, then it	*/
/*	   returns:							*/
/*		GOTH__GT if address1 >  address2			*/
/*		GOTH__EQ if address1 == address2			*/
/*		GOTH__LT if address1 <  address2			*/
/*									*/
/*	   For user defined types, the goth_user_compare_address	*/
/*	   routine should be used.					*/
/*									*/
/*	o  if the tree already contains data (ie, if any nodes have	*/
/*	   been inserted into it) then this function may not be used	*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*									*/
/* returns - GOTH__NORMAL if all is well				*/
/*	     GOTH__UNKTRE if the tree id is not recognised		*/
/*	     GOTH__TREFUL if the tree already contains data		*/
/*	     GOTH__BADTYP if address_type is not DT_SPECIAL		*/
/*	     GOTH__BADSIZ if address_size if less than one		*/
/*	     GOTH__BADFUN if comparison function is NULL		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_override_special(BIN_TREE_ID	tree_id,
					GOTH_INTEGER	address_size,
					GOTH_INTEGER	value_size,
					GOTH_STATUS	(*comp_func)());
/*----------------------------------------------------------------------*/
/* EXTERN bin_modify_add						*/
/*......................................................................*/
/* Tell the library how a node addition is to be handled		*/
/*									*/
/* tree_id	- in  - identifies the tree being used			*/
/* add_mode	- in  - how node addition works				*/
/* add_func	- in  - special node addition function			*/
/*									*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*			      NOTES					*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*									*/
/*	o  add_mode controls what happens when a node is added to the	*/
/*	   tree. It must be one of the following:			*/
/*									*/
/*		BIN__OVW	if a node already exists with the	*/
/*				specified address, overwrite it		*/
/*		BIN__UNQ	if a node already exists with the	*/
/*				specified address, the addition fails	*/
/*									*/
/*	o  if the tree already contains data (ie, if any nodes have	*/
/*	   been inserted into it) then this function may not be used	*/
/*									*/
/*	o  if the tree is for a user defined or GOTH_DATATYPE use then	*/
/*	   the user specified addition cannot be allowed. Only overwrite*/
/*	   and unique are allowed.					*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*									*/
/* returns - GOTH__NORMAL if all is well				*/
/*	     GOTH__UNKTRE if the tree id is not recognised		*/
/*	     GOTH__TREFUL if the tree already contains data		*/
/*	     GOTH__BADTYP if add_mode is not recognised			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_modify_add(BIN_TREE_ID	 tree_id,
				  int		 add_mode);
/*----------------------------------------------------------------------*/
/* EXTERN bin_add_node							*/
/*......................................................................*/
/* Add a node to a binary tree						*/
/* - see also bin_modify_add, which modifies how this function works	*/
/*									*/
/* tree_id	- in  - the tree identifier				*/
/* address	- in  - pointer to the address of the new node		*/
/* value	- in  - pointer to the value of the new node		*/
/*									*/
/* returns - GOTH__NORMAL if the node is successfully added		*/
/*	     GOTH__UNKTRE if the tree id is not recognised		*/
/*	     GOTH__MALLOC if there is no memory left for the node	*/
/*	     GOTH__EXISTS if the node already exists, and overwriting	*/
/*			  is not allowed				*/
/*	     GOTH__FAIL   if we cannot find where to insert the node,	*/
/*			  or if a user node addition function fails	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_add_node( BIN_TREE_ID	 tree_id,
				BIN_ADR_PTR	 address,
				BIN_VAL_PTR	 value );
/*----------------------------------------------------------------------*/
/* EXTERN bin_count_nodes						*/
/*......................................................................*/
/* Return the number of nodes presently in the tree			*/
/*									*/
/* tree_id	- in  - the tree identifier				*/
/* count	- out - the count of nodes				*/
/*									*/
/* returns - GOTH__NORMAL if the number is returned			*/
/*	     GOTH__UNKTRE if the tree id is not recognised		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_count_nodes(BIN_TREE_ID	 tree_id,
				   int		*count );
/*----------------------------------------------------------------------*/
/* EXTERN bin_get_node							*/
/*......................................................................*/
/* Return the value of the node with the specified address		*/
/*									*/
/* tree_id	- in  - the tree identifier				*/
/* address	- in  - pointer to the address of the node		*/
/* value	- out - pointer to the value of the node		*/
/*									*/
/* returns - GOTH__NORMAL if the value is returned			*/
/*	     GOTH__UNKTRE if the tree id is not recognised		*/
/*	     GOTH__ABSENT if there is no node with that address		*/
/*	     GOTH__FAIL   if the address comparisons failed internally	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_get_node(BIN_TREE_ID	tree_id,
				BIN_ADR_PTR	address,
				BIN_VAL_PTR	*value);
/*----------------------------------------------------------------------*/
/* EXTERN bin_get_node_with_addr					*/
/*......................................................................*/
/* Return the value of the node with the specified address		*/
/*									*/
/* tree_id	- in  - the tree identifier				*/
/* address	- in/out  - pointer to the address of the node		*/
/* value	- out - pointer to the value of the node		*/
/*									*/
/* returns - GOTH__NORMAL if the value is returned			*/
/*	     GOTH__UNKTRE if the tree id is not recognised		*/
/*	     GOTH__ABSENT if there is no node with that address		*/
/*	     GOTH__FAIL   if the address comparisons failed internally	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_get_node_with_addr(BIN_TREE_ID	tree_id,
					  BIN_ADR_PTR	*address,
					  BIN_VAL_PTR	*value);
/*----------------------------------------------------------------------*/
/* EXTERN bin_get_highest_node						*/
/*......................................................................*/
/* Return the value and address of the node that has the highest	*/
/* address in the tree							*/
/*									*/
/* tree_id	- in  - the tree identifier				*/
/* address	- out - pointer to the address of the node		*/
/* value	- out - pointer to the value of the node		*/
/*									*/
/* returns - GOTH__NORMAL if the highest node is returned		*/
/*	     GOTH__UNKTRE if the tree id is not recognised		*/
/*	     GOTH__EMPTY  if the tree is empty				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_get_highest_node(BIN_TREE_ID	  tree_id,
					BIN_ADR_PTR	 *address,
					BIN_VAL_PTR	 *value );
/*----------------------------------------------------------------------*/
/* EXTERN bin_get_lowest_node						*/
/*......................................................................*/
/* Return the value and address of the node that has the lowest		*/
/* address in the tree							*/
/*									*/
/* tree_id	- in  - the tree identifier				*/
/* address	- out - pointer to the address of the node		*/
/* value	- out - pointer to the value of the node		*/
/*									*/
/* returns - GOTH__NORMAL if the lowest node is returned		*/
/*	     GOTH__UNKTRE if the tree id is not recognised		*/
/*	     GOTH__EMPTY  if the tree is empty				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_get_lowest_node( BIN_TREE_ID	  tree_id,
				       BIN_ADR_PTR	 *address,
				       BIN_VAL_PTR	 *value );
/*----------------------------------------------------------------------*/
/* EXTERN bin_delete_tree						*/
/*......................................................................*/
/* Delete the specified tree, freeing all space associated with it	*/
/*									*/
/* tree_id	- in  - the tree identifier				*/
/*									*/
/* returns - GOTH__NORMAL if the tree id makes sense			*/
/*	     GOTH__UNKTRE if the tree id is not recognised		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_delete_tree( BIN_TREE_ID	tree_id );
/*----------------------------------------------------------------------*/
/* EXTERN bin_remove_node						*/
/*......................................................................*/
/* Remove the node with the specified address				*/
/*									*/
/* tree_id	- in  - the tree identifier				*/
/* address	- in  - pointer to the address of the node		*/
/*									*/
/* returns - GOTH__NORMAL if the node is successfully removed		*/
/*	     GOTH__UNKTRE if the tree id is not recognised		*/
/*	     GOTH__ABSENT if there is no node with that address		*/
/*	     GOTH__FAIL   if the address comparisons failed internally	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_remove_node(BIN_TREE_ID	  tree_id,
				   BIN_ADR_PTR	  address );
/*----------------------------------------------------------------------*/
/* EXTERN bin_traverse_tree						*/
/*......................................................................*/
/* Traverse the tree, applying the specified function to each node	*/
/*									*/
/* tree_id	- in  - the tree identifier				*/
/* ascending	- in  - specifies the order to traverse the tree	*/
/* function	- in  - the function to apply to each node		*/
/*									*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*			      NOTES					*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*									*/
/*	o  ascending should be TRUE if nodes are to be processed in	*/
/*	   order of ascending node address, and FALSE for the reverse	*/
/*									*/
/*	o  function must meet the following definition:			*/
/*									*/
/*		GOTH_STATUS function(BIN_ADR_PTR  address,		*/
/*				     BIN_VAL_PTR  value)		*/
/*		returns:						*/
/*			 GOTH__NORMAL if the routine succeeds		*/
/*			 GOTH__FINISH if the traversal should stop	*/
/*			 GOTH__FAIL   if the routine fails		*/
/*									*/
/*	   function will be applied to each node of the tree, in the	*/
/*	   specified order, until all nodes have been processed, or	*/
/*	   function returns GOTH__FINISH.				*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*									*/
/* returns - GOTH__NORMAL if the traversal has been completed, or if	*/
/*			  it has finished at the request of function	*/
/*	     GOTH__UNKTRE if the tree id is not recognised		*/
/*	     GOTH__FAIL   if function failed				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_traverse_tree(BIN_TREE_ID	tree_id,
				     GOTH_BOOLEAN	ascending,
				     GOTH_STATUS      	(*function)() );
/*----------------------------------------------------------------------*/
/* EXTERN bin_monitor_tree						*/
/*......................................................................*/
/* As the tree is manipulated, output messages describing what is	*/
/* being done to it. This routine is provided for debugging purposes	*/
/*									*/
/* tree_id	- in  - the tree identifier				*/
/* monitor	- in  - TRUE  to start monitoring operations,		*/
/*			FALSE to stop					*/
/* print_func	- in  - function to APPEND a node's address and value	*/
/*									*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*			      NOTES					*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*	o  print_func is only required if the address type is BIN__USR,	*/
/*	   although it may be specified for any address type.		*/
/*	   It must be a function with the following specification:	*/
/*									*/
/*		void print_func( BIN_ADR_PTR  address,			*/
/*				 BIN_VAL_PTR  value )			*/
/*									*/
/*	   which calls APPEND to add a representation of the address	*/
/*	   field (and optionally the value field) to the current output	*/
/*	   buffer.							*/
/*									*/
/*	   NOTE that if the address type is BIN__PTR, then print_func	*/
/*	   may be NULL, which will reinstate the default output form.	*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/*									*/
/* returns - GOTH__NORMAL if the routine succeeds			*/
/*	     GOTH__UNKTRE if the tree id is not recognised		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_monitor_tree( BIN_TREE_ID	tree_id,
				    GOTH_BOOLEAN	monitor,
				    void		(*print_func)() );
/*----------------------------------------------------------------------*/
/* EXTERN bin_print_tree						*/
/*......................................................................*/
/* Print out a representation of the specified tree			*/
/* - for each node, output its address and value fields			*/
/*									*/
/* tree_id	- in  - the tree identifier				*/
/* print_func	- in  - function to APPEND a node's address and value	*/
/*			with specification as in bin_monitor_tree	*/
/*									*/
/* returns - GOTH__NORMAL if the routine succeeds			*/
/*	     GOTH__UNKTRE if the tree id is not recognised		*/
/*	     GOTH__BADFUN if print_func is NULL, but the address type	*/
/*			  is BIN__PTR					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_print_tree(BIN_TREE_ID	tree_id,
				  void		(*print_func)() );

/*>>> EXTERN functions from BIN_MARK.C <<<*/


/*----------------------------------------------------------------------*/
/* EXTERN bin_create_tree_mark						*/
/*......................................................................*/
/* In	:	pointer to bin_mark_id					*/
/* Out	:	bin_mark_id.	Mark id to identify mark.		*/
/* Ret	:	GOTH_STATUS						*/
/*		GOTH__NORMAL if all OK.					*/
/*		GOTH__MALLOC if memory error.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_create_tree_mark(BIN_MARK	*binary_mark);
/*----------------------------------------------------------------------*/
/* EXTERN bin_delete_tree_mark						*/
/*......................................................................*/
/* In	:	bin_mark_id.	Mark id to identify mark to delete.	*/
/* Out	:								*/
/* Ret	:	GOTH_STATUS						*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_delete_tree_mark(BIN_MARK	binary_mark);
/*----------------------------------------------------------------------*/
/* EXTERN bin_set_tree_mark						*/
/*......................................................................*/
/* In	:	binary_mark	Identifier for the mark to set.		*/
/*		position	Set mark at FIRST or LAST position in	*/
/*				tree.					*/
/*		BIN_TREE_ID	binary_tree to set the mark on.		*/
/* Out	:								*/
/* Ret	:	GOTH_STATUS						*/
/*		GOTH__NORMAL if all OK.					*/
/*		GOTH_UNKTRE if not a valid tree.			*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_set_tree_mark(BIN_MARK		binary_mark,
				     BIN_POSITION	position,
				     BIN_TREE_ID	binary_tree);
/*----------------------------------------------------------------------*/
/* EXTERN bin_increment_tree_mark					*/
/*......................................................................*/
/* In	:	bmark.	Identifier for the mark.			*/
/* Out	:								*/
/* Ret	:	GOTH_STATUS						*/
/*		GOTH__NORMAL if moved succesfully.			*/
/*		GOTH__FAIL if error.					*/
/*		GOTH__ABSENT if at highest node already.		*/
/*----------------------------------------------------------------------*/
/* This function has four possible choices of actions to take in moving	*/
/* to the next node:							*/
/*									*/
/* Condition 1: The node that is currently marked has left and (maybe)	*/
/*		right children.						*/
/* Action:	Move to the right hand child node and then follow every	*/
/*		lefthand child until the leaf node is reached. Mark this*/
/*		node.							*/
/*									*/
/*		Parent							*/
/*		..							*/
/*	       ..							*/
/*	   Current <---You are here. You will move to LeftChild2	*/
/*	 ..    ..							*/
/*	..	..							*/
/* LeftChild	RightChild						*/
/* ..	..	 ..    ..						*/
/*		..	..						*/
/*		..	..						*/
/*	 LeftChild2	RightChild2					*/
/*									*/
/* ==================================================================== */
/*									*/
/* Condition 2: The node that is currently marked has no righthand	*/
/*		children and is the lefthand child of it's parent.	*/
/* Action:	Move to the parent node and mark that node.		*/
/*									*/
/*    	Parent								*/
/*	..								*/
/*     ..								*/
/* Child								*/
/*									*/
/* ==================================================================== */
/*									*/
/* Condition 3:	The node that is currently marked has no righthand	*/
/*		children and is the righthand child of it's parent.	*/
/* Action:	Move to the parent node on the lefthand side of the	*/
/*		child (ie: the child is a rigthhand child). For all	*/
/*		succesive parent nodes on the left of the child, move to*/
/*		these nodes. When no more parents are on the left of the*/
/*		child, move to the first righthand parent of that	*/
/*		position and mark that node. (Confusing? see diag below)*/
/*									*/
/*			Child8						*/
/*                     .						*/
/*                    .							*/
/*		   Child4						*/
/*              ...      ....						*/
/*           ...             ...					*/
/*	Child2			Child6				        */
/*      .     .                 .    .					*/
/*     .       .              .        .			        */
/* Child1	Child3	Child5		Child7				*/
/*									*/
/* Condition3 arises at Child3 and Child7. Child3 when incremented would*/
/* mark Child4. Child7 when incremented would mark Child8. Note that	*/
/* each move moves to the child's left parent and when no more left	*/
/* parents are available move to the first right parent.		*/
/*									*/
/* Or..									*/
/*			Child9						*/
/*                     .						*/
/*                    .							*/
/*		   Child5						*/
/*              ...      ....						*/
/*           ...             ...					*/
/*	Child2			Child7				        */
/*      .     .                 .    .					*/
/*     .       .              .        .			        */
/* Child1	Child4	Child6		Child8				*/
/*	       ..							*/
/*	     ..								*/
/*	   Child3							*/
/*									*/
/* ==================================================================== */
/*									*/
/* Condition 4:								*/
/* You are at the highest node on the tree. You cannot move anywhere,	*/
/* return GOTH__FAIL.							*/
/*									*/
/*	 Child2								*/
/*	..    ..							*/
/*     ..      ..							*/
/* Child1	Child3 <- You are here. RETURN GOTH__FAIL.		*/
/*									*/
/* Or..									*/
/*									*/
/*	 Child2								*/
/*	..    ..							*/
/*     ..      ..							*/
/* Child1	Child4 <- You are here. RETURN GOTH__FAIL.		*/
/*	       ..							*/
/*	     ..								*/
/*         Child3							*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_increment_tree_mark(BIN_MARK	bmark);
/*----------------------------------------------------------------------*/
/* EXTERN bin_decrement_tree_mark					*/
/*......................................................................*/
/* In	:	bmark.	Identifier for the mark.			*/
/* Out	:								*/
/* Ret	:	GOTH_STATUS						*/
/*		GOTH__NORMAL if moved succesfully.			*/
/*		GOTH__FAIL if error.					*/
/*		GOTH__ABSENT if at highest node already.		*/
/*----------------------------------------------------------------------*/
/* This function has four possible choices of actions to take in moving	*/
/* to the next node:							*/
/*									*/
/* Condition 1: The node that is currently marked has right and (maybe) */
/*              left children.                                          */
/* Action:	Move to the left hand child node and then follow every	*/
/*		righthand child until the leaf node is reached. Mark    */
/*		this node.						*/
/*									*/
/*		Parent							*/
/*		..							*/
/*	       ..							*/
/*	   Current <---You are here. You will move to RightChild2	*/
/*	 ..      ..							*/
/*	..	   ..							*/
/* LeftChild	     RightChild						*/
/* ..	    ..	       ..    ..						*/
/* ..	      ..						        */
/*..	        ..						        */
/*LeftChild2	RightChild2					        */
/*									*/
/* ==================================================================== */
/*									*/
/* Condition 2: The node that is currently marked has no lefthand	*/
/*		children and is the righthand child of it's parent.	*/
/* Action:	Move to the parent node and mark that node.		*/
/*									*/
/*    	Parent								*/
/*	..								*/
/*     ..								*/
/* Child								*/
/*									*/
/* ==================================================================== */
/*									*/
/* Condition 3:	The node that is currently marked has no lefthand	*/
/*		children and is the lefthand child of it's parent.	*/
/* Action:	Move to the parent node on the righthand side of the	*/
/*		child (ie: the child is a lefthand child). For all	*/
/*		succesive parent nodes on the right of the child, move to*/
/*		these nodes. When no more parents are on the right of the*/
/*		child, move to the first lefthand parent of that	*/
/*		position and mark that node. (Confusing? see diag below)*/
/*									*/
/*		Child9						        */
/*                .						        */
/*                  .							*/
/*		   Child13 					        */
/*              ...      ....						*/
/*           ...             ...					*/
/*	Child11			Child15				        */
/*      .     .                 .    .					*/
/*     .       .              .        .			        */
/* Child10	Child12	Child14		Child16				*/
/*									*/
/* Condition3 arises at Child10 and Child14. Child14 when decremented   */
/* would mark Child13. Child10 when decremented would mark Child9.      */
/* Note that each move moves to the child's left parent and when no more*/
/* left	parents are available move to the first right parent.		*/
/*									*/
/* Or..									*/
/*									*/
/*		Child9						        */
/*                .						        */
/*                  .							*/
/*		   Child14 					        */
/*              ...      ....						*/
/*           ...             ...					*/
/*	Child12			Child16				        */
/*      .     .                 .    .					*/
/*     .       .              .        .			        */
/* Child10	Child13	Child15		Child17				*/
/*     .								*/
/*	.								*/
/*      Child11                                                         */
/* ==================================================================== */
/*									*/
/* Condition 4:								*/
/* You are at the lowest node on the tree. You cannot move anywhere,	*/
/* return GOTH__FAIL.							*/
/*									*/
/*	 Child2								*/
/*	..    ..							*/
/*     ..      ..							*/
/* Child1	Child3    You are at Child1. RETURN GOTH__FAIL.		*/
/*									*/
/* Or..									*/
/*									*/
/*	 Child3								*/
/*	..    ..							*/
/*     ..      ..							*/
/* Child1	Child4    You are at Child1. RETURN GOTH__FAIL.		*/
/*	..							        */
/*	  ..								*/
/*         Child2							*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_decrement_tree_mark(BIN_MARK	bmark);
/*----------------------------------------------------------------------*/
/* EXTERN bin_get_mark_node						*/
/*......................................................................*/
/* In	:	bmark.	Binary mark identifier.				*/
/* Out	:	key.	Key (address in node)				*/
/*		value.	Value in node.					*/
/* Ret	:	GOTH_STATUS.						*/
/*		GOTH__NORMAL if all OK.					*/
/*		GOTH__FAIL if tree has changed since markset.		*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_get_mark_node(BIN_MARK		bmark,
				     BIN_ADR_PTR	*key,
				     BIN_VAL_PTR	*value);
/*----------------------------------------------------------------------*/
/* EXTERN bin_same_tree_mark						*/
/*......................................................................*/
/* Determine if two marks are marking the same element			*/
/*									*/
/* In	:	bmark1, bmark2. Two binary marks to compare.		*/
/* Out	:	*result.	Pointer to boolean result TRUE/FALSE.	*/
/* Ret	:	GOTH_STATUS.						*/
/*		GOTH__NORMAL	if all OK				*/
/*		GOTH__DESC	if bad binary marks			*/
/*		GOTH_FAIL	if binary trees have invalid mark_check	*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_same_tree_mark(BIN_MARK		bmark1,
				      BIN_MARK		bmark2,
				      GOTH_BOOLEAN	*result);
/*----------------------------------------------------------------------*/
/* EXTERN bin_set_mark_by_value						*/
/*......................................................................*/
/* In	:	bmark		binary mark to set.			*/
/*		binary_tree	binary tree to set mark on		*/
/*		key		key value we're seraching for in tree	*/
/* Out	:	*value		pointer to value information on node	*/
/*				if value_type is DT_SPECIAL and		*/
/*				value_size is > 0 then *value is	*/
/*				the .special field in node's val_ptr.	*/
/* Ret	:	GOTH_STATUS						*/
/*		GOTH__NORMAL if the value is returned			*/
/*		GOTH__UNKTRE if the tree id is not recognised		*/
/*		GOTH__ABSENT if there is no node with that address	*/
/*		GOTH__FAIL   if the address comparisons failed internal	*/
/*									*/
/* If an error occurs then the mark status is undefined. It should NOT	*/
/* be used until it has been set correctly.				*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_set_mark_by_value(BIN_MARK	bmark,
					 BIN_TREE_ID	binary_tree,
					 BIN_ADR_PTR	key,
					 BIN_VAL_PTR	*value);
/*----------------------------------------------------------------------*/
/* EXTERN bin_copy_tree_mark						*/
/*......................................................................*/
/* In	:		in_bmark.	Source mark to copy.		*/
/* Out	:		out_bmark.	Destination mark to overwrite	*/
/* Ret	:		GOTH_STATUS.					*/
/*			GOTH__NORMAL					*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS bin_copy_tree_mark(BIN_MARK	in_bmark,
				      BIN_MARK	out_bmark);
#endif
