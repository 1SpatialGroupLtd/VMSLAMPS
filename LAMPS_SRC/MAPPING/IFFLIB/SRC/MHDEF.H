/************************************************************************/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England	*/
/* Author    TJ Ibbs, 29 May 1987					*/
/*									*/
/*		         M H D E F . H					*/
/*									*/
/* this header file is a C version of the IFF 'common block' MHDEF.CMN	*/
/************************************************************************/ 

/************************************************************************/ 
/* the FORTRAN definition is:						*/
/*									*/
/*	INTEGER*2 MHARR(MHLEN)						*/
/*	LOGICAL*1 MHDESC(10)						*/
/*	EQUIVALENCE (MHARR,MHDESC)					*/
/*									*/
/* and they live in COMMON /MAPHDR/					*/
/*									*/
/* Note - don't forget that C arrays start indexing at [0]		*/
/************************************************************************/ 
#define  MHLEN  350		/* the size of the basic array */

extern union
	{
	INT_2      MHARR[MHLEN];	/* either the whole array, or	*/
	LOGICAL_1  MHDESC[10];		/* just the descriptor		*/
	} MAPHDR;
