/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1988-08-15 16:56:52.000000000 +0100
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
/*									*/
/*			    L S L D E F . H				*/
/*									*/
/*		The Laser-Scan standard C header file.			*/
/*									*/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England    */
/* Author    TJ Ibbs, 25 Sep 1986					*/
/*									*/
/* Modified  TJ Ibbs, 11 Apr 1988 - add tyepdef for LSL_DESC		*/
/* Modified  TJ Ibbs,  9 May 1988 - add #define for VMS_STATUS,UWORD,etc*/
/* Modified  TJ Ibbs, 15 Aug 1988 - add BOOL and LSL_STATUS		*/
/************************************************************************/ 

/************************************************************************/ 
/* VAX C does not define the <MATH.H> functions 'labs' and 'fmod'	*/
/* Therefore we provide a macro approximation to 'labs', since it's	*/
/* likely to be needed. If you want 'fmod', then write the function	*/
/* yourself...								*/
/************************************************************************/ 

#define	labs(x)		( ((long)(x)) > 0 ? ((long)(x)) : (-(long)(x)) )

/************************************************************************/ 
/* The following are not defined in VAX C (and are thus not included in	*/
/* <CTYPE.H> ), so we will define them for ourselves			*/
/* - however - BEWARE OF SIDE EFFECTS, since these are macros		*/
/************************************************************************/ 

#define	isodigit(d)	( (d)>='0' && (d)<='7' )

#define	toint(d)	( (d)>='0' && (d)<='9' ? (int)((d)-'0') : \
			  (d)>='A' && (d)<='F' ? (int)((d)-'A'+10) : \
			  (int)-1 )

/************************************************************************/ 
/* We don't bother to define EOF, as it is defined in <STDIO.H>		*/
/*									*/
/* However, we will define TRUE,FALSE and NULL again, as that shouldn't	*/
/* hurt, and functions might want to use them, but not have <STDIO.H>	*/
/************************************************************************/ 

#define	FALSE	0
#define	TRUE	1
#define	NULL	0

/************************************************************************/ 
/* The following defines a string descriptor structure, and a means of	*/
/* declaring such a descriptor. This actually duplicates the structure  */
/* and macro (although by different names) that are defined in the file	*/
/* <DESCRIP.H> - however, we don't want to have to include that to get	*/
/* the definitions, as its rather large and mostly irrelevant		*/
/************************************************************************/ 

struct lsl_descriptor
	{
	unsigned short	length;		/* length of the string      */
	unsigned char	type;		/* the type of descriptor    */
	unsigned char	class;		/* the class ...	     */
	char	       *pointer;	/* the address of the buffer */
	};

typedef	struct lsl_descriptor LSL_DESC;	/* define the 'type' LSL_DESC*/

/************************************************************************/ 
/* And define a macro for declaring a new string descriptor		*/
/* - use it as follows:							*/
/*                                                                      */
/*		char   	expbuf[80];	  -- the string itself	        */
/*		strdesc(expdsc,expbuf);	  -- and declare 'expdsc'       */
/*                                                                      */
/* NOTE that                                                            */
/*		DSC$K_DTYPE_T = 14	(character string descriptor)   */
/*		DSC$K_CLASS_S =  1	(scalar or string descriptor)   */
/*                                                                      */
/************************************************************************/ 

#define	strdesc(name,string)	struct lsl_descriptor name = \
					{ sizeof(string)-1, 14, 1, string }

/************************************************************************/ 
/* Define some data types for talking to FORTRAN routines		*/
/************************************************************************/ 

#define	INT_2	  short int		/* INTEGER*2		*/
#define	INT_4	  int			/* INTEGER*4 or INTEGER	*/
#define	REAL_4	  float			/* REAL*4    or REAL	*/
#define	REAL_8	  double		/* REAL*8    or DOUBLE	*/
#define LOGICAL	  int			/* LOGICAL		*/
#define LOGICAL_1 char			/* LOGICAL*1 or BYTE	*/

/************************************************************************/ 
/* And some more for system routines					*/
/************************************************************************/ 

#define	WORD		short int	/* VAX word     (16 bits) */
#define	LONGWORD	int		/* VAX longword (32 bits) */
#define	BYTE		char		/*		( 8 bits) */

#define	UWORD		unsigned short int
#define	ULONGWORD	unsigned int
#define	UBYTE		unsigned char

/************************************************************************/ 
/* And some for general help with programming				*/
/************************************************************************/ 

#define BOOLEAN		unsigned int	/* general logical value */
#define BOOL		unsigned char	/* short version thereof */

#define VMS_STATUS	unsigned int	/* VMS system status	    */
#define LSL_STATUS	unsigned int	/* a less VAX specific name */

/************************************************************************/ 
/* Define 'min' and 'max' macros					*/
/************************************************************************/ 

#define	min(x,y)	( ((x) < (y)) ? (x) : (y) )
#define max(x,y)	( ((x) > (y)) ? (x) : (y) )

/************************************************************************/ 
