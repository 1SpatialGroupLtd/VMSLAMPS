/************************************************************************/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England	*/
/* Author    TJ Ibbs, 18 December 1986					*/
/*									*/
/*		       I F F H A N . H					*/
/*									*/
/* this header file is a C version of the IFF 'common block' IFFHAN.CMN	*/
/* which is used by the IFF library to record exceptions and current	*/
/* positions								*/
/************************************************************************/ 

/************************************************************************/ 
/* the FORTRAN definitions (in common block order) are:			*/
/*									*/
/*	INTEGER*4 LPOSE,LPOSR,LPOSW,LPOSH,LPOSM,LPOSF			*/
/*	INTEGER*4 IERCD,IERAD,IERNM					*/
/*	LOGICAL*2 WATEOF						*/
/*	INTEGER*2 IFOREL						*/
/*									*/
/* and they live in COMMON /IFFHAN/					*/
/************************************************************************/ 

extern struct
	{

	INT_4	LPOSE;	/* current EOF word number (next free word)	*/
	INT_4	LPOSR;	/* current reading position			*/
	INT_4	LPOSW;	/* current writing position			*/
	INT_4	LPOSH;	/* posn of entry-in-hand (0 if none)		*/
	INT_4	LPOSM;	/* posn of marked entry  (0 if none)		*/
	INT_4	LPOSF;	/* posn of start of current feature (0 if none)	*/
	INT_4	IERCD;	/* latest error code (0 if no error)		*/
	INT_4	IERAD;	/* locates latest call to IFF error handler	*/
	INT_4	IERNM;	/* VMS numerical error code			*/
	INT_2	WATEOF;	/* is Fortran TRUE if writing at EOF		*/
	INT_2	IFOREL; /* number of virtual blocks in the forepart	*/

	} IFFHAN;

