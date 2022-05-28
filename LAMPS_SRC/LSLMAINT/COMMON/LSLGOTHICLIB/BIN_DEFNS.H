/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:41:48.000000000 +0000
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
#ifndef _BIN_DEFNS
#define _BIN_DEFNS
/* $Header: /usr/users/jon/RCS/hdr.bin_defns.h,v 1.5 1995/01/15 21:48:22 jon Exp $								*/


/************************************************************************/
/*									*/
/*			 B I N _ D E F N S . H				*/
/*									*/
/* Header file for routines using BINLIB, the (balanced) binary tree	*/
/* library.								*/
/*									*/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England    */
/* Author    TJ Ibbs, 16 February 1989					*/
/*									*/
/* Version 1.0 of include file, 14 March 1989				*/
/************************************************************************/

/************************************************************************/
/* STRUCTURE OF THE BINARY TREE

  Each node of the tree is of the form:

            +---------------+---------------+---------------+---------------+
            | address-ptr   | value-ptr     | left-ptr      | right-ptr     |
            +-------+-------+-------+-------+-------+-------+-------+-------+
		    |		    |		    |		    |
		    v		    v		    v		    v
	         address	  value	         another	 another
	        structure	structure	   node	           node

*/
/************************************************************************/
/* The tree id is actually a structure within the library. The user is	*/
/* just handed back a pointer to it, as	its internal structure is not	*/
/* relevant. The 'if defined' business is to allow the library to use	*/
/* this header file, but provide a more complex definition for the id.	*/
/* Same rationale for BIN_MARK.						*/
/************************************************************************/


#ifndef  BIN_LIBRARY_COMPILE
     typedef  VOID_P  BIN_TREE_ID;	/* identify a particular tree	*/
     typedef  VOID_P  BIN_MARK;		/* identify a particular mark	*/
#endif

typedef  VOID_P  BIN_ADR_PTR;		/* pointer to an address field	*/
typedef  VOID_P  BIN_VAL_PTR;		/* pointer to a value field	*/

/************************************************************************/
/* define FIRST AND LAST positions in a binary tree. These are the	*/
/* lowest and highest values on the tree, hence their names.		*/
/************************************************************************/

typedef enum
{
   BPT_LOWEST,			/* first position in tree		*/
   BPT_HIGHEST			/* last position in tree		*/
} BIN_POSITION;

/************************************************************************/
/* Define the different ways that adding a node can work		*/
/* - these are required in calling the routine `bin_modify_add'		*/
/* - when a tree is created, the default is BIN__UNQ			*/
/************************************************************************/

#define  BIN__OVW  21	/* overwrite existing nodes with same address	*/
#define  BIN__UNQ  22	/* fail if a node has the specified address	*/

#endif
