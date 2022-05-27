/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1990-06-19 14:21:20.000000000 +0100
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
/* The FORTRAN definitions are :					*/
/* 									*/
/*	PARAMETER	ACD_USER = 50		! default user ACDs	*/
/*C									*/
/*	PARAMETER	ACDOFFSET = 1000	! offset of each table	*/
/*	PARAMETER	ACD_CODE_MAX = 32767	! maximum allowed CODE	*/
/*C									*/
/*	PARAMETER	ACD_FORMAT_MAX = 8	! max format length	*/
/*	PARAMETER	ACD_NAME_MAX = 20	! max name length	*/
/*C									*/
/* ACD data types							*/
/*	INTEGER		ACD_DATATYPE_I					*/
/*	INTEGER		ACD_DATATYPE_R					*/
/*	INTEGER		ACD_DATATYPE_C					*/
/*	INTEGER		ACD_DATATYPE_D					*/
/*	INTEGER		ACD_DATATYPE_T					*/
/*C									*/
/*	PARAMETER	(ACD_DATATYPE_I = 1)	! integer		*/
/*	PARAMETER	(ACD_DATATYPE_R = 2)	! real			*/
/*	PARAMETER	(ACD_DATATYPE_/*= 3)	! 4 characters		*/
/*	PARAMETER	(ACD_DATATYPE_D = 4)	! date			*/
/*	PARAMETER	(ACD_DATATYPE_T = 5)	! time			*/
/*C									*/
/*	INTEGER*4	ACD_DEF_MINI		! default values for 	*/
/*	INTEGER*4	ACD_DEF_MAXI		! min and max values	*/
/*	REAL*4		ACD_DEF_MINR					*/
/*	REAL*4		ACD_DEF_MAXR					*/
/*	INTEGER		ACD_DEF_MINC					*/
/*	INTEGER		ACD_DEF_MAXC					*/
/*	CHARACTER*(*)	ACD_DEF_MIND					*/
/*	CHARACTER*(*)	ACD_DEF_MAXD					*/
/*	CHARACTER*(*)	ACD_DEF_MINT					*/
/*	CHARACTER*(*)	ACD_DEF_MAXT					*/
/*	PARAMETER	(ACD_DEF_MINI = -2147483647)			*/
/*	PARAMETER	(ACD_DEF_MAXI =  2147483647)			*/
/*	PARAMETER	(ACD_DEF_MINR = -1.0E37)			*/
/*	PARAMETER	(ACD_DEF_MAXR =  1.0E37)			*/
/*	PARAMETER	(ACD_DEF_MIN/*= '    ')				*/
/*	PARAMETER	(ACD_DEF_MAX/*= '~~~~')				*/
/*	PARAMETER	(ACD_DEF_MIND = '17-NOV-1858')			*/
/*	PARAMETER	(ACD_DEF_MAXD = '31-DEC-9999')			*/
/*	PARAMETER	(ACD_DEF_MINT = '00:00:00.00')			*/
/*	PARAMETER	(ACD_DEF_MAXT = '23:59:59.99')			*/
/*C									*/
/*/*Attributes of selected AC						*/
/*C									*/
/*	INTEGER*4	ACD_CODE		! code			*/
/*	INTEGER*4	ACD_DATA_TYPE		! data type		*/
/*	CHARACTER*(ACD_FORMAT_MAX) ACD_FORMAT	! format		*/
/*	INTEGER*4	ACD_FORMAT_LEN		! length of format	*/
/*	INTEGER*4	ACD_MIN_MAX_I(2)	! min max (integer) 	*/
/*	REAL*4		ACD_MIN_MAX_R(2)	! min max (real)	*/
/*	CHARACTER*(ACD_NAME_MAX) ACD_NAME	! full name; space filled*/
/*	INTEGER*4	ACD_NAME_LEN		! its length		*/
/*	REAL*4		ACD_INTERVAL		! its granularity	*/
/*C									*/
/*	EQUIVALENCE	(ACD_MIN_MAX_I,ACD_MIN_MAX_R)			*/
/*C									*/
/*	INTEGER*4	ACDCMT			! %LOC(command table)	*/
/*C									*/
/*	COMMON/FRTACD/ACD_CODE,ACD_DATA_TYPE,ACD_FORMAT_LEN,		*/
/*     &	              ACD_MIN_MAX_I,ACD_NAME_LEN,ACD_INTERVAL,ACDCMT*/
/*									*/
/*	COMMON/FRTACDC/ACD_NAME,ACD_FORMAT				*/
/************************************************************************/

#define	ACD_USER 50		! default user ACDs

#define	ACDOFFSET = 1000	! offset of each table
#define	ACD_CODE_MAX = 32767	! maximum allowed CODE
#define	ACD_FORMAT_MAX = 8	! max format length
#define	ACD_NAME_MAX = 20	! max name length

   extern struct
{
   INT_4		ACD_CODE;		/* code*/
   INT_4		ACD_DATA_TYPE;		/* data type*/
   CHARACTER*(ACD_FORMAT_MAX) ACD_FORMAT	! format		
   INT_4		ACD_FORMAT_LEN;		/* length of format*/
	
   union
   {
      INT_4		ACD_MIN_MAX_I[2];	/* min max (INT_4) */
      REAL_4		ACD_MIN_MAX_R[2];	/* min max (real)*/
   } ACD_MIN_MAX;
	
   CHARACTER*(ACD_NAME_MAX) ACD_NAME;		/* full name; space filled*/
   INT_4		ACD_NAME_LEN;		/* its length*/
   REAL_4		ACD_INTERVAL;		/* its granularity*/
   INT_4*4		ACDCMT;			/* %LOC(command table)*/
}

