/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1993-10-13 13:35:20.000000000 +0100
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
/* Copyright © Laser-Scan Ltd, Cambridge CB4 4FY, England		*/
/* Author    JM Cadogan   4-Oct-1993					*/
/*									*/
/*		     C M D L I N E . H					*/
/*									*/
/* Header file for command line qualifiers for ADC			*/
/*									*/
/************************************************************************/ 

extern BOOLEAN  had_log;	/* TRUE if we log file open/close, etc	      */
extern BOOLEAN	had_debug;	/* TRUE if we should output debug source code */
extern BOOLEAN	had_print;	/* TRUE if we should print output source      */
extern BOOLEAN	had_append;	/* TRUE if we should append to existing file  */
extern BOOLEAN	had_thread;	/* TRUE if we should process directive lines  */
extern BOOLEAN	had_ln;		/* TRUE if we should number output lines      */
extern BOOLEAN	had_cd;		/* TRUE if dir for commons/parameters given   */
extern BOOLEAN	had_comments;	/* TRUE if we should output comments	      */
extern BOOLEAN	had_ll;		/* TRUE if line length set		      */
extern BOOLEAN	had_in;		/* TRUE if we should reinit. truth file rec   */
extern BOOLEAN	had_tr;		/* TRUE if given truth file spec	      */
extern BOOLEAN	outer_level_only; /* TRUE if comments in outer level only     */
extern int	line_length;	/* value of line length given 		      */
