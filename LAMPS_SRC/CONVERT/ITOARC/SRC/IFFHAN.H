/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1988-08-09 11:27:26.000000000 +0100
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
extern struct iffhan_tag {
	int
		lpose,	/* current EOF word number (next free word) */
		lposr,	/* current reading position */
		lposw,	/* current writing position */
		lposh,	/* position of entry-in-hand (0 if none) */
		lposm,	/* position of marked entry (0 if none) */
		lposf,	/* position of start of current feature (0 if none) */
		iercd,	/* latest error code (0 if no error) */
		ierad,	/* locates latest call to IFF  error handler */
		iernm;	/* VMS numerical error code (for non-internal errors) */
	short
		iforel;
	unsigned short
		wateof;	/* is TRUE if writing at EOF */
	int
		irvlev,	/* current input revision level */
		orvlev;	/* current output revision level */
	} iffhan;
