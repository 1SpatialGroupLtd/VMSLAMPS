/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1989-01-16 15:49:44.000000000 +0000
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
/*
   CB (co-ordinate block) header file
*/

#define IFF_MAXCBCOL 20
#define IFF_MAXCBROW 200
#define IFF_MAXCBDATA (IFF_MAXCBCOL*IFF_MAXCBROW)
#define IFF_MAXCBATT 20
#define IFF_ABSENT 0x80000000

/*
   Parameters defining column headers for x,y,z for convenience. These must
   agree with those in the default ACDs
*/

#define IFFC_X 91
#define IFFC_Y 92
#define IFFC_Z 93

/*
   Attribute structure.
*/

typedef struct iff_cbatt {
	int	attc;		/* code */
	union {
		int	i;          /* integer */
		float	r;          /* real */
		char	c[4];       /* string */
	} attv;			/* value */
} IFF_CBATT;

/*
   Define the record structure to hold CB header ( the fixed part )
*/

typedef struct iff_cbh {
	int	flags,			/* flags ( cf. iends */
		gtype,			/* graphical type */
		nrow,			/* no. of rows */
		ncol,			/* no. of cols */
		colh[IFF_MAXCBCOL],	/* column headers */
		natt;			/* no. of attributes */
	IFF_CBATT att[IFF_MAXCBATT];
} IFF_CBH;

/*
   ... and a record structure to hold CB data ( treats the whole thing as
   a one-dimensional array.
*/

typedef union iff_cbd {
	int	i[IFF_MAXCBDATA];	/* integer */
	float	r[IFF_MAXCBDATA];	/* real */
	char	c[4][IFF_MAXCBDATA];	/* string ... CHECK ORDER ! */
} IFF_CBD;

/*
   ... and a structure for use in declaring CB row arrays,
   e.g IFF_CBITEM row[IFF_MAXCBATT] 

*/

typedef union iff_cbitem {
	int	i;			/* integer */
	float	r;			/* real */
	char	c[4];			/* string */
} IFF_CBITEM;
