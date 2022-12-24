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
#ifndef _SABIN_DEFNS
#define _SABIN_DEFNS
/* $Header: /lslhome/gothic/hdr/sabinlib/v1-1/RCS/hdr.sabin_defns.h,v 1.2 1992/04/15 15:37:48 davidr Exp $								*/
/* 									*/
/* $Log: hdr.sabin_defns.h,v $
 * Revision 1.2  1992/04/15  15:37:48  davidr
 * Version v1-1 derived from v1-0
 * Memory debugging disabled - it had been accidentally enabled in V1-0
 *
 * Revision 1.1  1992/03/16  22:46:58  jon
 * Version v1-0 derived from root
 * Version containing `test' alternative from old system
 *								*/

/************************************************************************/
/*									*/
/*		       S A B I N _ D E F N S . H			*/
/*									*/
/* Header file for routines using SABINLIB, the (balanced) binary tree	*/
/* library.								*/
/*									*/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England    */
/* Author    Stephen Kellett. 15 May 1991.				*/
/************************************************************************/

/************************************************************************/
/* STRUCTURE OF THE BINARY TREE

  Each node of the tree is of the form:

            +---------------+---------------+---------------+---------------+
            | long-integer  | character-ptr | left-ptr      | right-ptr     |
            +-------+-------+-------+-------+-------+-------+-------+-------+
		     		    |		    |		    |
		    	 	    v		    v		    v
			        character	  another	 another
				 string		   node	           node

*/
/************************************************************************/
/* The tree id is actually a structure within the library. The user is	*/
/* just handed back a pointer to it, as	its internal structure is not	*/
/* relevant. The 'if defined' business is to allow the library to use	*/
/* this header file, but provide a more complex definition for the id.	*/
/************************************************************************/


#ifndef  SABIN_LIBRARY_COMPILE
     typedef  VOID_P  SABIN_TREE_ID;	/* identify a particular tree	*/
#endif

typedef GOTH_STATUS (*SABIN_CALLBACK)(VOID_P		void_param,
				      GOTH_INTEGER	address,
				      char		*string);
#endif
