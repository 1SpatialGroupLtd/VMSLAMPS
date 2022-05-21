/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1990-09-27 14:31:52.000000000 +0100
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
#module PARAMS "27SE90"
/************************************************************************/
/*									*/
/*  Copyright Laser-scan Laboratories Ltd, Cambridge CB4 4FY, England   */
/*  Author    A.Verrill					    18-Jun-1989 */
/*									*/
/* I2GDB functions for handling PARAMETERS table.			*/
/* Stores data, and provides value interfaces to data.			*/
/*									*/
/************************************************************************/

#include <stdio.h>	/* pick up NULL */
#include <lsldef.h>
#include <string.h>
#include "here:params.h"

/* Sizes of look-up tables 						*/
/* MAX_LAYER/SYMBOL_TABLE are sizes of chunks to allocate      		*/

#define MAX_LAYER_TABLE 32
#define MAX_SYMBOL_TABLE 32

#define NSYMBOL_CHARS 8 /* maximum number of characters in a GDB symbol name */
#define NNAME_CHARS 8 /* maximum number of chars in a LY, SN name */

/*----------------------------------------------------------------------*/
/* Look-up table for layers.						*/
/*----------------------------------------------------------------------*/

typedef LAYER_T LAYER_TABLE[ MAX_LAYER_TABLE ];
typedef struct layer_node_t
{
   int count;
   int first;
   int last;
   struct layer_node_t *next;
   LAYER_TABLE layer_table;
} LAYER_NODE_T, *LAYER_NODE_P;

static LAYER_NODE_P first_layer_nodep = (LAYER_NODE_P) NULL;
static LAYER_NODE_P last_layer_nodep  = (LAYER_NODE_P) NULL;

/*----------------------------------------------------------------------*/
/* Look-up table for symbols						*/
/*----------------------------------------------------------------------*/

typedef SYMBOL_T SYMBOL_TABLE[ MAX_SYMBOL_TABLE ];
typedef struct symbol_node_t
{
   int count;
   int first;
   int last;
   struct symbol_node_t *next;
   SYMBOL_TABLE symbol_table;
} SYMBOL_NODE_T, *SYMBOL_NODE_P;

static SYMBOL_NODE_P first_symbol_nodep = (SYMBOL_NODE_P) NULL;
static SYMBOL_NODE_P last_symbol_nodep  = (SYMBOL_NODE_P) NULL;

/*----------------------------------------------------------------------*/
/* Look-up table for feature code data					*/
/*----------------------------------------------------------------------*/

/* Look-up table for feature code data					*/

typedef FCP FC_TABLE[ MAX_FC_TABLE ];

static FC_TABLE fc_table;

/* Useful constant feature code data					*/

FC_T empty_fc = 			
{
   0, -1, -1, 0.81, FREI, FALSE, FALSE, FALSE, FALSE
};

/* Record how many times undefined fc's are used */
/* Picked up as global definition, used at end of program */

short int used_undefined_fc[ MAX_FC_TABLE ];


/*----------------------------------------------------------------------*/
/*  add_to_layer_list							*/
/*......................................................................*/
/*	Insert new layer entry 						*/
/*									*/
/*----------------------------------------------------------------------*/

BOOLEAN add_to_layer_list( LAYER_T layer)
{
   if (last_layer_nodep == (LAYER_NODE_P)NULL )
   {
      /* First entry to list */

      first_layer_nodep = ( LAYER_NODE_P )malloc( sizeof( LAYER_NODE_T ) );
      first_layer_nodep->count = 0;
      first_layer_nodep->first = layer.iff_layer;
      first_layer_nodep->next = ( LAYER_NODE_P) NULL;
      last_layer_nodep = first_layer_nodep;
   }
   else if (last_layer_nodep->count == MAX_LAYER_TABLE )
   {
      /* Filled last list, start new one */

      last_layer_nodep->next = (LAYER_NODE_P)malloc( sizeof( LAYER_NODE_T ) );
      last_layer_nodep  = last_layer_nodep->next;
      last_layer_nodep->next = (LAYER_NODE_P) NULL;
      last_layer_nodep->count = 0;
      last_layer_nodep->first = layer.iff_layer;
      last_layer_nodep->next = (LAYER_NODE_P) NULL;
   }	      

/* insert info */

   last_layer_nodep->layer_table[ last_layer_nodep->count++ ] = layer;
   last_layer_nodep->last = layer.iff_layer;
   
   return ( layer.iff_layer >= last_layer_nodep->last ? TRUE : FALSE );
}
   

/*----------------------------------------------------------------------*/
/*  get_gdb_layer							*/
/*......................................................................*/
/* 	Retrieve gdb layer number for given iff layer_nr		*/
/*									*/
/*----------------------------------------------------------------------*/
int get_gdb_layer( int layer_nr )
{
   LAYER_NODE_P np = first_layer_nodep;
   int i;

   while ( np != (LAYER_NODE_P) NULL )
   {
      if ( layer_nr <= np->last )
      {
	 for ( i = 0; i < np->count; i++ )
	 {
	    if (layer_nr == np->layer_table[i].iff_layer)
	       return np->layer_table[i].gdb_layer;
	 }
	 break;
      }
      np = np->next;
   }
   return ( (layer_nr % 31) + 1); /* gives number in range 1 to 31 */
}


/*----------------------------------------------------------------------*/
/*  add_to_symbol_list							*/
/*......................................................................*/
/*	Insert new symbol definition					*/
/*								    	*/
/*----------------------------------------------------------------------*/
BOOLEAN add_to_symbol_list( SYMBOL_T symbol)
{
   int size_to_malloc;	/* need to alloc space for strings */

   if (last_symbol_nodep == (SYMBOL_NODE_P) NULL )
   {
      /* first entry to list */

      first_symbol_nodep = ( SYMBOL_NODE_P )malloc( sizeof( SYMBOL_NODE_T ) );
      first_symbol_nodep->count = 0;
      first_symbol_nodep->first = symbol.iff_symbol;
      first_symbol_nodep->next = ( SYMBOL_NODE_P) NULL;
      last_symbol_nodep = first_symbol_nodep;
   }
   else if (last_symbol_nodep->count == MAX_SYMBOL_TABLE )
   {
      /* filled last list, star new one */
      last_symbol_nodep->next = (SYMBOL_NODE_P)malloc( sizeof( SYMBOL_NODE_T ) );
      last_symbol_nodep  = last_symbol_nodep->next;
      last_symbol_nodep->next = (SYMBOL_NODE_P) NULL;
      last_symbol_nodep->count = 0;
      last_symbol_nodep->first = symbol.iff_symbol;
      last_symbol_nodep->next = (SYMBOL_NODE_P) NULL;
   }	      

   /* copy in data, note alloc space for string */

   last_symbol_nodep->symbol_table[ last_symbol_nodep->count ].iff_symbol = 
      symbol.iff_symbol;

   if ( symbol.gdb_symbol != '\0' )
   {
      size_to_malloc = sizeof( char ) * 
	 ( 1 + min( strlen( symbol.gdb_symbol ), NSYMBOL_CHARS ));

      last_symbol_nodep->symbol_table[ last_symbol_nodep->count ].gdb_symbol = 
	 malloc( size_to_malloc );

      strncpy(last_symbol_nodep->symbol_table[ last_symbol_nodep->count ].gdb_symbol,
	      symbol.gdb_symbol, NSYMBOL_CHARS );
   }
   else
      symbol.gdb_symbol = '\0';

   last_symbol_nodep->symbol_table[ last_symbol_nodep->count ].gdb_symbol_scale = 
      symbol.gdb_symbol_scale;

   last_symbol_nodep->symbol_table[ last_symbol_nodep->count ].as_point = 
      symbol.as_point;

   /* set list counters, return false if entries not in order */

   ++last_symbol_nodep->count;
   last_symbol_nodep->last = symbol.iff_symbol;

   return (symbol.iff_symbol >= last_symbol_nodep->last ? TRUE : FALSE );
}


/*----------------------------------------------------------------------*/
/*  get_gdb_symbol							*/
/*......................................................................*/
/*	Returns string for SC output given iff symbol number		*/
/*									*/
/*----------------------------------------------------------------------*/
SYMBOL_T get_gdb_symbol( int symbol_nr )
{
   SYMBOL_NODE_P np = first_symbol_nodep;
   int i;

   SYMBOL_T default_symbol; /* returned if no symbol entry */
   static char default_str[20]; /* string for default return */

   /* search through for required symbol number */
   while ( np != (SYMBOL_NODE_P) NULL )
   {
      if ( symbol_nr <= np->last )
      {
	 for ( i = 0; i < np->count; i++ )
	 {
	    if (symbol_nr == np->symbol_table[i].iff_symbol)
	    {
	       return (np->symbol_table[i]);
	    }
	 }
	 break;
      }
      np = np->next;
   }

   /* not found : construct default and return */
   for (i=0; i < 20; i++ )
      default_str[i] = '\0';
   default_str[0] = 'S';
   default_str[1] = 'C';
   sprintf( default_str+2, "%d", symbol_nr );

   default_symbol.iff_symbol = symbol_nr;
   default_symbol.gdb_symbol = default_str;
   default_symbol.gdb_symbol_scale = 1.0;

   return default_symbol;
}


/*----------------------------------------------------------------------*/
/*  add_to_fc_list							*/
/*......................................................................*/
/* 	Insert new fc data						*/
/*									*/
/*----------------------------------------------------------------------*/
BOOLEAN add_to_fc_list( FC_T fc )
{
   int size_to_malloc; /* for name which is a string */

   fc_table[ fc.fcode ] = (FCP) malloc( sizeof( FC_T ) );
   
   *(fc_table[ fc.fcode ]) = fc;

   if (fc.name != '\0')
   {
      size_to_malloc = sizeof(char) * (1 +
				       min( strlen(fc.name), NNAME_CHARS ));
      (fc_table[ fc.fcode ])->name = malloc( size_to_malloc );
      strncpy( (fc_table[ fc.fcode ])->name, fc.name, NNAME_CHARS );
   }
   else
      (fc_table[ fc.fcode ])->name = '\0';
   return TRUE;
}


/*----------------------------------------------------------------------*/
/*  get_fc_data								*/
/*......................................................................*/
/*	Return data on given feature code				*/
/*									*/
/*----------------------------------------------------------------------*/
FC_T get_fc_data( int fcode )
{
   FC_T default_fc;

/* FC defined from parameter file */

   if ( fc_table[ fcode ] != NULL ) return *(fc_table[ fcode ]);

/* else return default */

   default_fc.fcode = fcode;
   default_fc.st = -1;	/* signals no st */
   default_fc.sm = -1;	/* signals no sm */
   default_fc.text_aspect_ratio = 0.81; /* this is common value in SiCAD */
   default_fc.spline_type = FREI;
   default_fc.name = '\0';
   default_fc.poly = FALSE;
   default_fc.fl_area = FALSE;
   default_fc.cadastral = FALSE;
   default_fc.spline = FALSE;

   ++used_undefined_fc[ fcode ];
   return default_fc;
}
