/************************************************************************/
/* Copyright Laser-Scan Ltd, Canbridge CB4 4FY, England.		*/
/* Author A.Verrill, 18-Jun-1990					*/
/* 									*/
/* F R T C O M . H							*/
/* 									*/
/* This header file is a C version of the FRT 'common block' FRTCOM.CMN	*/
/* which is used by FRTLIB.						*/
/* 
/************************************************************************/

/************************************************************************/
/* The FORTRAN definitions ( in common block order ) are		*/
/*	PARAMETER FRTMAX=1000		! maximum number of FCs
/*									*/
/*	PARAMETER LINTYP = 1		! line string			*/
/*	PARAMETER CLOTYP = 2		! clockwise circle arc		*/
/*	PARAMETER ANTTYP = 3		! anti-clockwise circle arc	*/
/*	PARAMETER CIRTYP = 4		! circum-circle arc		*/
/*	PARAMETER FULTYP = 5		! full circumcircle		*/
/*	PARAMETER CURTYP = 6		! interpolated curve		*/
/*	PARAMETER UNOTYP = 7		! unoriented symbol		*/
/*	PARAMETER ORITYP = 8		! oriented symbol		*/
/*	PARAMETER SCATYP = 9		! scaled symbol			*/
/*	PARAMETER TEXTYP = 10		! text				*/
/*	PARAMETER STRTYP = 11		! symbol string			*/
/*	PARAMETER ARETYP = 12		! fill area			*/
/*									*/
/*	INTEGER*4	FRTCNT		! count of defined FCs		*/
/*	INTEGER*4	FRTIND		! index of selected FC		*/
/*	INTEGER*4	FRTFC		! the selected FC		*/
/*	INTEGER*4	FRTGT		! its Graphical Type		*/
/*	INTEGER*4	FRTCOL		! its colour			*/
/*	REAL		FRTWID		! its width			*/
/*	REAL		FRTSIZ		! its size			*/
/*	INTEGER*4	FRTSC		! its Secondary Code		*/
/*	INTEGER*4	FRTFLG		! flags word			*/
/*									*/
/*	INTEGER*4	FRTHW		! symbol for hardware line	*/
/*	INTEGER*4	FRTHWL		! hardware line style		*/
/*									*/
/*	INTEGER*4	FRTAST		! fill area internal style	*/
/*	INTEGER*4	FRTAIX		! fill area style index		*/
/*									*/
/*	LOGICAL*4	FRTHWS		! true if to use hardware symbol*/
/*									*/
/*	LOGICAL*4	FRTLIN		! true if linear		*/
/*	LOGICAL*4	FRTSYM		! true if symbol		*/
/*	LOGICAL*4	FRTARC		! true if circle arc		*/
/*	LOGICAL*4	FRTCUR		! true if curve			*/
/*	LOGICAL*4	FRTTEX		! true if text			*/
/*	LOGICAL*4	FRTARE		! true if fill area		*/
/*									*/
/*the main FRT table							*/
/*									*/
/*	INTEGER*2	FRTINT(6,FRTMAX)	! integers		*/
/*	REAL		FRTFLT(2,FRTMAX)	! floats (reals)	*/
/*global control variables
/*									*/
/*	LOGICAL*4	FRTHKS		! true if thick lines supressed	*/
/*	LOGICAL*4	FRTCLP		! true if to clip symbols in	*/
/*					! patterened fill areas		*/
/*	COMMON/FRTCOM/FRTCNT,FRTIND,FRTFC,FRTGT,FRTCOL,			*/
/*     &                FRTWID,FRTSIZ,FRTSC,FRTFLG,FRTHW,FRTHWL,	*/
/*     &		      FRTAST,FRTAIX,FRTHWS,			*/
/*     &                FRTINT,FRTFLT,FRTHKS,				*/
/*     &                FRTLIN,FRTARC,FRTCUR,FRTSYM,FRTTEX,FRTARE,	*/
/*     &	              FRTCLP					*/
/*									*/
/************************************************************************/

#define FRTMAX 1000	/* note C-arrays start at 0 */

#define LINTYP  1		/* line string  */
#define CLOTYP  2		/* clockwise circle */
#define ANTTYP  3		/* anti-clockwise circle arc*/
#define CIRTYP  4		/* circum-circle arc*/
#define FULTYP  5		/* full circumcircle*/
#define CURTYP  6		/* interpolated curve*/
#define UNOTYP  7		/* unoriented symbol*/
#define ORITYP  8		/* oriented symbol*/
#define SCATYP  9		/* scaled symbol*/
#define TEXTYP  10		/* text*/
#define STRTYP  11		/* symbol string*/
#define ARETYP  12		/* fill area*/

   extern struct
{
   INT_4	FRTCNT;		/* count of defined FCs*/
   INT_4	FRTIND;		/* index of selected FC*/
   INT_4	FRTFC;		/* the selected FC*/
   INT_4	FRTGT;		/* its Graphical Type*/
   INT_4	FRTCOL;		/* its colour*/
   REAL_4      	FRTWID;		/* its width*/
   REAL_4	FRTSIZ;		/* its size*/
   INT_4	FRTSC;		/* its Secondary Code*/
   INT_4	FRTFLG;		/* flags word*/
   INT_4	FRTHW;		/* symbol for hardware line*/
   INT_4	FRTHWL;		/* hardware line style*/
   INT_4	FRTAST;		/* fill area internal style*/
   INT_4	FRTAIX;		/* fill area style index*/
   LOGICAL	FRTHWS;		/* true if to use hardware symbol*/
   LOGICAL	FRTLIN;		/* true if linear*/
   LOGICAL	FRTSYM;		/* true if symbol*/
   LOGICAL	FRTARC;		/* true if circle arc*/
   LOGICAL	FRTCUR;		/* true if curve*/
   LOGICAL	FRTTEX;		/* true if text*/
   LOGICAL	FRTARE;		/* true if fill area*/
   INT_2	FRTINT[FRTMAX][6];	/* integers*/
   REAL_4	FRTFLT[FRTMAX][2];	/* floats (REAL_4s)*/
   LOGICAL	FRTHKS;		/* true if thick lines supressed*/
   LOGICAL	FRTCLP;		/* true if to clip symbols in*/
					/* patterened fill areas*/
}  FRTCOM;
