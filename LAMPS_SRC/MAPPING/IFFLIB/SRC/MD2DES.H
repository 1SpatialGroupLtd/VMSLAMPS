/************************************************************************/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England	*/
/* Author    TJ Ibbs, 29 May 1987					*/
/*									*/
/*		         M D 2 D E S . H				*/
/*									*/
/* this header file is a C version of the IFF 'common block' MD2DES.CMN	*/
/* which is a common block for the version 2 map descriptor		*/
/************************************************************************/ 

/************************************************************************/ 
/* the FORTRAN definition is:						*/
/*									*/
/*	INTEGER*2	MD2ARR(MD2LEN)	! common block as words		*/
/*	INTEGER*2	MATV2		! note I*2, for compatability	*/
/*	INTEGER*2	MD2DUM		! and a dummy for longword	*/
/*					! alignment			*/
/*	REAL*8		MD2LOC(2)	! local origin			*/
/*	REAL*8		MD2SCL		! scale of map			*/
/*	INTEGER*4	MD2PRJ		! projection system		*/
/*	INTEGER*4	MD2UNT		! units that IFF file is in	*/
/*	INTEGER*4	MD2SPH		! spheroid			*/
/*	REAL*8		MD2USP(2)	! description of user defined	*/
/*					! spheroid			*/
/*	REAL*8		MD2PAR(15)	! parameters for projection	*/
/*	LOGICAL*4	MD2FLP		! perhaps flip LAT LONG		*/
/*									*/
/*	EQUIVALENCE	(MATV2 ,MD2ARR(1)),				*/
/*     &		(MD2DUM,MD2ARR(2)),				*/
/*     &		(MD2LOC,MD2ARR(3)),				*/
/*     &		(MD2SCL,MD2ARR(11)),				*/
/*     &		(MD2PRJ,MD2ARR(15)),				*/
/*     &		(MD2UNT,MD2ARR(17)),				*/
/*     &		(MD2SPH,MD2ARR(19)),				*/
/*     &		(MD2USP,MD2ARR(21)),				*/
/*     &		(MD2PAR,MD2ARR(29)),				*/
/*     &		(MD2FLP,MD2ARR(89))				*/
/*									*/
/* and they are in the common block /MD2DES/				*/
/*									*/
/* Note - don't forget that C arrays start indexing at [0]		*/
/************************************************************************/ 
#define  MD2LEN  200		/* the size of the basic array */

/*
 We first declare the shape of the structure that we need, and a typedef
 for using it more conveniently
*/

struct _IFF_map_desc
{
	INT_2	MATV2;			/* MD version/type	 */
	INT_2	MD2DUM;			/* longword alignment	 */
	REAL_8	MD2LOC[2];		/* local origin		 */
	REAL_8	MD2SCL;			/* scale		 */
	INT_4	MD2PRJ;			/* projection		 */
	INT_4	MD2UNT;			/* units of IFF data	 */
	INT_4	MD2SPH;			/* spheroid		 */
	REAL_8	MD2USP[2];		/* user defined spheroid */
	REAL_8	MD2PAR[15];		/* projection parameters */
	INT_4	MD2FLP;			/* perhaps flip LAT LONG */
};

typedef  struct _IFF_map_desc  IFF_MAP_DESC;

/*
 The common block is then a union of the map descriptor structure with
 a large array
*/

extern union
	{
	INT_2	      MD2ARR[MD2LEN];	/* the whole array, or	*/
	IFF_MAP_DESC  str;		/* the actual structure */
	} MD2DES;
