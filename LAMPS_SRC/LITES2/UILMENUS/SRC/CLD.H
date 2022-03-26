/************************************************************************/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England	*/
/* Author    TJ Ibbs, 26 May 1987     					*/
/*									*/
/*		           C L D . H  					*/
/* This version has the STR_LEN array reduced by two elements.		*/
/* If this is not done, then the DECC compiler pads the block to a	*/
/* multiple of 8 bytes, and it is then 4 bytes too long to overlay	*/
/* the block in the LSLSHR image. Attempts to access these last two	*/
/* elements will work fine, unless some sort of bounds checking is	*/
/* performed. To use this, define LSL$CMNLSL as a search list to pick	*/
/* this up before the usual place.					*/
/*									*/
/* this header file is a C version of the LSLLIB 'common block' CLD.CMN	*/
/* which is used by the DCL command line parts of the library		*/
/*									*/
/* BEWARE that C array indices start at [0]				*/
/*									*/
/************************************************************************/ 

/************************************************************************/ 
/* the FORTRAN definitions for /LSL_CLD/ (in common block order) are:	*/
/*									*/
/*	REAL*8 		DBLRAY(MAX_REAL)				*/
/*	REAL*4 		RARRAY(MAX_REAL)				*/
/*	INTEGER*4	IARRAY(MAX_LONG)				*/
/*	INTEGER*4	NUMDBL						*/
/*	INTEGER*4	NUMREA						*/
/*	INTEGER*4	NUMINT						*/
/*	INTEGER*4       NUMSTR						*/
/*	INTEGER*4	NUMFIL						*/
/*	INTEGER*2       FIL_LEN(MAX_FIL)				*/
/*	INTEGER*2       STR_LEN(MAX_STR)				*/
/*									*/
/* and those in /LSL_CLDCHR/ are:					*/
/*									*/
/*	CHARACTER*128   CARRAY(MAX_STR)					*/
/*	CHARACTER*128	FILARY(MAX_FIL)					*/
/*									*/
/************************************************************************/ 

#define	MAX_STR	   16
#define MAX_FIL    16
#define MAX_REAL  128
#define MAX_LONG 1024

extern struct
	{
	REAL_8	DBLRAY[MAX_REAL];
	REAL_4	RARRAY[MAX_REAL];
	INT_4	IARRAY[MAX_LONG];
	INT_4	NUMDBL;
	INT_4	NUMREA;
	INT_4	NUMINT;
	INT_4	NUMSTR;
	INT_4	NUMFIL;
	INT_2	FIL_LEN[MAX_FIL];
	INT_2	STR_LEN[MAX_STR-2];
	} LSL_CLD;

extern struct
	{
	char	CARRAY[MAX_STR][128];
	char	FILARY[MAX_FIL][128];
	} LSL_CLDCHR;
