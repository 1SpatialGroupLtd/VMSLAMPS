/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1990-09-26 18:26:52.000000000 +0100
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
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England.	*/
/* Author 	A.Verrill 	18-June-1990				*/
/* 									*/
/* 	P A R A M S . H							*/
/*									*/
/* Header file for parameter file definitions				*/
/************************************************************************/

/* should include lsldef.h before this file */

#define MAX_FC_TABLE 32768

typedef struct
{
   int iff_layer;		/* input iff layer number */
   int gdb_layer;		/* output gdb level number */
} LAYER_T, *LAYERP;

typedef struct
{
   int iff_symbol;		/* input iff feature code */
   char *gdb_symbol;		/* output gdb symbol name */
   double gdb_symbol_scale;    	/* scale factor between iff and gdb */
   BOOLEAN as_point;		/* in special case, output a point instead */
} SYMBOL_T, *SYMBOLP;

typedef enum { FREI = 1001, SCHL, STAN, STAE } spline_enum;

typedef struct
{
   int fcode;			/* input iff feature code */
   int st;			/* output gdb ST = */
   int sm;			/* output gdb SM = */
   double text_aspect_ratio;	/* output gdb text aspect ratio */
   spline_enum spline_type;	/* output gdb spline type */
   char *name;			/* output gdb NAM ... */
   BOOLEAN poly;		/* true if must output gdb LY */
   BOOLEAN fl_area;		/* true id must output gdb FL */
   BOOLEAN cadastral;		/* true if must output gdb FR */
   BOOLEAN spline;		/* true if must output gdb SN */
} FC_T, *FCP;

extern FC_T empty_fc;
extern BOOLEAN add_to_layer_list( LAYER_T layer);
extern int get_gdb_layer( int layer_nr );
extern BOOLEAN add_to_symbol_list( SYMBOL_T symbol);
extern SYMBOL_T get_gdb_symbol( int symbol_nr );extern BOOLEAN add_to_fc_list( FC_T fc );
extern FC_T get_fc_data( int fcode );

extern short int used_undefined_fc[ MAX_FC_TABLE ];

