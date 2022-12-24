/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1991-02-21 10:23:36.000000000 +0000
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
/*			IFF.H						*/
/*									*/
/*	LSL IFF library C interface header file.			*/
/*									*/
/*	GJR, NUTIS			11/8/88				*/
/*	JB				25/5/89				*/
/*									*/
/************************************************************************/

#define PEN_DOWN 1				/* used in ST entries */

struct attvals {
	int	intval;
	float	realval;
	char	text[256];
	struct	attvals *next;
	};

struct attlist {
	int	accode;
	struct	attlist *next;
	struct	attvals *vals;
	};

typedef struct range_tag {			/* range values */
	float
		xmin,	xmax,	ymin,	ymax;
	} RANGE;

typedef struct corner_tag {			/* corner points */
	float
		xnwin,	ynwin,	xnwout,	ynwout,
		xswin,	yswin,	xswout,	yswout,
		xsein,	ysein,	xseout,	yseout,
		xnein,	ynein,	xneout,	yneout;
	} CORNER;

typedef struct section_tag {
	char	text[256];
	} SECTION;

typedef struct over_tag {			/* overlay */
	short
		number,
		status;
	int
		end_pointer;			
	} OVERLAY;

typedef struct feature_tag {
	short
		fsn,
		isn;
	} FEATURE;

typedef struct fs_tag {		/* feature status (used for text status also) */
	short
		fc;		/* feature code OR interpolation type */
	struct stat_tag {			/* status */
		unsigned short
			closed 		: 1,
			line 		: 1,
			reversed 	: 1,
			reorder 	: 1,
			discard 	: 1,
			square		: 1,
			inverse 	: 1,
			unused		: 8,
			paint_out	: 1;
		} status;
	union flag_tag {			/* flags */
		struct text_tag {
			unsigned short
				position	: 4,
				style	 	: 2,
				category	: 6,
				unused		: 2,
				type		: 2;
			} text;
		struct non_text_tag {
			unsigned short
				process_code	: 14,
				type		: 2;
			} non_text;		
		} flag;
	short 
		user;			/* user-specific stuff */
	} FSTATUS;

typedef struct ac_tag {			/* ancilliary code */
	short
		type;
	union value_tag {
		int
			integer;
		float
			real;
		} value;
	char
		text[256];
	} ACODE;

typedef struct v2_tag {			/* coordinate pair */
	float
		x,
		y;
	} VERTEX2;

typedef struct v3_tag {			/* coordinate triplet */
	float
		x,
		y,
		z;
	} VERTEX3;

typedef short int THICK;	/* line thickness or text height */

typedef float ROTATION;		/* text orientation in radians ACW wrt x-axis */


/**********************  Other useful definitions etc..  **********************/


typedef struct vc_tag {	/* var. length text string struct for FORTRAN calls  */
	int len;
	char *text;
	} VARCHAR;

int is_real_ac();	 		/* useful LSL function */

short   zero=0,   one=1,   two=2,   three=3,   four=4; /* useful values for */
int   i_zero=0, i_one=1, i_two=2, i_three=3, i_four=4; /*  calling FORTRAN */

	/* Graphical Types */

#define LINEAR		1	/* Join pts by straight lines */
#define CW_ARC		2	/* CW arc based on end, centre, end */
#define ACW_ARC		3	/* ditto, for ACW */
#define CIRCUM_CIRC_ARC	4	/* arc, based on three pts on arc */
#define CIRCUM_CIRCLE	5	/* ditto */
#define INTERP_CURVE	6	/* as LINEAR, but with interpolated curves */
#define UNORIEN_SYMBOL	7	/* size held in FRT */ 
#define ORIEN_SYMBOL	8	/* ditto, but orientation from IFF file */
#define SCAL_SYMBOL	9	/* use size & orientation from IFF file */
#define TEXT		10	/* ASCII text */
#define SYM_STRING	11	/* use symbol at line vertices */
#define FILL_AREA	12	/* polygon (may be multiple & have holes) */


	/* ... definitions used in LSL FRTLIB */

#define LINTYP		1	/* Join pts by straight lines */
#define CLOTYP		2	/* CW arc based on end, centre, end */
#define ANTTYP		3	/* ditto, for ACW */
#define CIRTYP		4	/* arc, based on three pts on arc */
#define FULTYP		5	/* ditto */
#define CURTYP		6	/* as LINEAR, but with interpolated curves */
#define UNOTYP		7	/* size held in FRT */ 
#define ORITYP		8	/* ditto, but orientation from IFF file */
#define SCATYP		9	/* use size & orientation from IFF file */
#define TEXTYP		10	/* ASCII text */
#define STRTYP		11	/* use symbol at line vertices */
#define ARETYP		12	/* polygon (may be multiple & have holes) */

