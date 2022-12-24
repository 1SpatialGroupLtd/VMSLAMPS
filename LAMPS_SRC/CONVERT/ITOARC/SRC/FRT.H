/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1988-08-31 09:43:38.000000000 +0100
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
#define FRTMAX 1000			/* max. no. of FCs */

extern struct frtcom_tag {
	int
			frtcnt,		/* count of defined FCs */
			frtind,		/* index of selected FCs */
			frtfc,		/* the selected FC */
			frtgt,		/* ... it's type */
			frtcol;		/* ... colour *

	float
			frtwid,		/* ... width */
			frtsiz;		/* ... size */

	int
			frtsc,		/* ... Secondary Code */
			frtflg;		/* ... flags word */

	int
			frthw,		/* symbol for hardware line */
			frthwl,		/* hardware line style */
			frtast,		/* fill area internal style */
			frtaix;		/* fill area style index */

	unsigned short 	frthws;		/* true if to use hardware symbol */

	short		frtint[FRTMAX][6];	/* integers */

	float		frtflt[FRTMAX][2];	/* floats (reals) */

	unsigned short
			frthks,		/* true if thick lines supressed */
			frtlin,		/* true if linear */
			frtarc,		/* true if symbol */
			frtcur,		/* true if circle arc */
			frtsym,		/* true if curve */
			frttex,		/* true if text */
			frtare;		/* true if fill area */
} frtcom;
