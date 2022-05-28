/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:57:18.000000000 +0000
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
#ifndef _GOTH_DEFNS
#define _GOTH_DEFNS
/* $Header: /usr/users/jon/RCS/hdr.goth_defns.h,v 1.9 1995/01/22 20:01:11 jon Exp $								*/
/************************************************************************/
/*									*/
/*			    L S L D E F . H				*/
/*									*/
/*		The Laser-Scan standard C header file.			*/
/*									*/
/* 			GOTHIC Project Version				*/
/*									*/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England    */
/* Author   TJ Ibbs, 25 Sep 1986					*/
/*									*/
/* Modified TJ Ibbs, 	11 Apr 1988 	add typedef for LSL_DESC	*/
/*									*/
/* Modified TJ Ibbs,  	9 May 1988 	add #define for VMS_STATUS,	*/
/*					UWORD,etc			*/
/*									*/
/* Modified TJ Ibbs, 	15 Aug 1988 	add BOOL and GOTH_STATUS	*/
/*									*/
/* Modified TJ Ibbs, 	13 Oct 1989  	modify GOTH_STATUS to long int	*/
/*									*/
/* Modified JM Billing, 1 Feb 1990 	test for previous TRUE, FALSE,	*/
/* 					and NULL definitions.		*/
/*									*/
/* Modified JM Billing,	2 Mar 1990	test for previous definitions	*/
/* 					of SEEK_SET, SEEK_END and	*/
/* 					SEEK_CUR, defining them if	*/
/* 					they are undefined.		*/
/*									*/
/* Modified RW Russell, 27 Sept 1990	added 'goth_abs' macro		*/
/* 									*/
/* Modified JM BIlling, 2 May 1991	added 'goth_xor' macro		*/
/*					removed obsolete definitions	*/
/************************************************************************/ 


/*----------------------------------------------------------------------*/
/* We don't bother to define EOF, as it is defined in <STDIO.H>		*/
/*									*/
/* However, we will define TRUE,FALSE and NULL again, as that shouldn't	*/
/* hurt, and functions might want to use them, but not have <STDIO.H>	*/
/*----------------------------------------------------------------------*/

#ifndef FALSE
#define	FALSE	0
#endif

#if (FALSE != 0)
 "FALSE is not defined to be 0"
#endif


#ifndef TRUE
#define	TRUE	1
#endif

#if (TRUE != 1)
 "TRUE is not defined to be 1"
#endif


#ifndef NULL
#define	NULL	0
#endif

/*----------------------------------------------------------------------*/
/* Cannot check for NULL being non-zero here as STDDEF.H on VMS defines */
/* NULL as '(void *)0' which gives a syntax error in a #if.             */
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/* If SEEK_SET, SEEK_CUR and SEEK_END are not already defined, define	*/
/* them to have the values laid done in the ANSI standard.		*/
/*----------------------------------------------------------------------*/

#ifndef SEEK_SET
#define	SEEK_SET	0
#endif

#if (SEEK_SET != 0)
 "SEEK_SET is not defined to be 0"
#endif


#ifndef SEEK_CUR
#define	SEEK_CUR	1
#endif

#if (SEEK_CUR != 1)
 "SEEK_CUR is not defined to be 1"
#endif


#ifndef SEEK_END
#define	SEEK_END	2
#endif

#if (SEEK_END != 2)
 "SEEK_END is not defined to be 1"
#endif


/*----------------------------------------------------------------------*/
/* Define some data types for talking to FORTRAN routines		*/
/*----------------------------------------------------------------------*/

#define	INT_2	  short int		/* INTEGER*2		*/
#define	INT_4	  int			/* INTEGER*4 or INTEGER	*/
#define	REAL_4	  float			/* REAL*4    or REAL	*/
#define	REAL_8	  double		/* REAL*8    or DOUBLE	*/
#define LOGICAL	  int			/* LOGICAL		*/
#define LOGICAL_1 char			/* LOGICAL*1 or BYTE	*/


/*----------------------------------------------------------------------*/
/* And some more for system routines					*/
/*----------------------------------------------------------------------*/

/* This stuff should be obsolete - JMB */
/* Should not be using VAX specific stuff */
/* Should be using GOTH_... types from GOTH_DATATYPES.H */
/* Or machine specific stuff from GOTH_CONFIG.H */

/* Removed by DJA.  Causes conflict with X11R5 header Xmd.h. */

#if (FALSE)

#define	WORD		short int	/* VAX word     (16 bits) */
#define	LONGWORD	int		/* VAX longword (32 bits) */
#define	BYTE	 char	/*		( 8 bits) */

#define	UWORD		unsigned short int
#define	ULONGWORD	unsigned int
#define	UBYTE		unsigned char

#endif


/*----------------------------------------------------------------------*/
/* And some for general help with programming				*/
/*----------------------------------------------------------------------*/

/* This stuff should be obsolete */
/* Should be using GOTH_... types from GOTH_DATATYPES.H */
/* Or machine specific stuff from GOTH_CONFIG.H */

#if (FALSE)

#define BOOL		unsigned char	/* short version thereof */

#endif


/*----------------------------------------------------------------------*/
/* Define some useful macros						*/
/*----------------------------------------------------------------------*/

#define	min(x,y)	( ((x) < (y)) ? (x) : (y) )
#define max(x,y)	( ((x) > (y)) ? (x) : (y) )

#define goth_abs(n) ((n) < 0 ? -(n) : (n)) 

#define goth_xor(a,b) (((a) && !(b)) || ((b) && !(a)))

#define GOTH_NOTE_TIME(s) goth_note_time(s)


/*----------------------------------------------------------------------*/
/* Macro to aid dereferencing a descriptor. Usage:			*/
/*									*/
/* typedef struct _myded_data *MYDED;					*/
/*									*/
/* extern GOTH_STATUS myfunc( GD_MY	desc_id )			*/
/* {									*/
/*     MYDED	myded_ptr;						*/
/* 									*/
/*     myded_ptr = GOTH_GET_DED( desc_id,DDT_MY,MYDED );		*/
/*     if (myded_ptr == NULL) SCH_RETURN(GOTH__DESC);			*/
/* 									*/
/*----------------------------------------------------------------------*/

#define GOTH_GET_DED( desc,ddt,cast )	(((desc) != NULL) && ((desc)->type ==\
					ddt)) ? (cast) (desc)->sod : NULL



/*----------------------------------------------------------------------*/
/*  MACRO GOTH_IS_DED_OF_TYPE						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Macro returns TRUE if descriptor exists and is of the required type,	*/
/* FALSE otherwise.							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* desc	-in- 	Descriptor to check.					*/
/*									*/
/* ddt	-in- 	Required descriptor type.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* TRUE		Descriptor exists and is of the required type.		*/
/* FALSE	Descriptor doesn't exist or is not the required type.	*/
/*									*/
/*----------------------------------------------------------------------*/

#define GOTH_IS_DED_OF_TYPE(desc, ddt)		\
(((desc) != NULL) && ((desc)->type == ddt))	




/*----------------------------------------------------------------------*/
/*  MACRO GOTH_IS_DED_DEFINED						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/* Macro returns TRUE descriptor exists, is the required type, the SOD	*/
/* exists (i.e. not NULL) and the reference count is non-negative,	*/
/* FALSE otherwise. MACRO also returns the SOD field.			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/* desc	-in-	Descriptor to be tested.				*/
/*									*/
/* ddt	-in-	Required descriptor type.				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/* TRUE		The descriptor exists, is the required type, the sod	*/
/*		is defined, and the reference count >= 0.		*/
/* FALSE	Otherwise.						*/
/*									*/
/*----------------------------------------------------------------------*/

#define GOTH_IS_DED_DEFINED(desc, ddt)		\
(GOTH_IS_DED_OF_TYPE(desc, ddt) &&		\
(((desc)->sod) != NULL) && ((desc)->refs >= 0))	



#endif
