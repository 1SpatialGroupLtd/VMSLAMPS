/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1990-09-27 13:23:00.000000000 +0100
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
#module READ_PARAMS "27SE90"
/************************************************************************/
/*									*/
/*  Copyright Laser-scan Laboratories Ltd, Cambridge CB4 4FY, England   */
/*  Author    A.Verrill					    18-Jun-1989 */
/*									*/
/* I2GDB Functions for fielding data definitions in PARAMETERS		*/
/*									*/
/************************************************************************/

#include <stdio.h>		
#include <lsldef.h>
#include <string.h>
#include "here:params.h"

#define MAX_TOKENS 10
#define MAX_CHARS_IN_LINE 120

typedef char *TOKEN_T[MAX_TOKENS];
typedef TOKEN_T *TOKEN_P ;
typedef struct
{
   int n_toks;
   int next;
   TOKEN_T tokens;
} DECODE, *DECODEP;

/*----------------------------------------------------------------------*/
int get_line( FILE *fin, char line[], int lim )
/*----------------------------------------------------------------------*/
{
   /* returns a line of characters in line */

   int c; 	/* character in */
   int i = 0;	/* counter */
   
   while (--lim > 0 && ( c= getc(fin)) != EOF && c != '\n' )
   {
      line[i++] = c;
   }

   if ( c == '\n' )
      line[i++] = c;

   line[i] = '\0';
   
   return (i);
}

/*----------------------------------------------------------------------*/
BOOLEAN tokenize( char *ins, DECODEP decodp )
/*----------------------------------------------------------------------*/
{
/* Takes string *ins and returns a pointer to a 'decoding' structure.	*/
/* The individual 'decoded' elements are null terminated strings. 	*/
/* Note that this functions destroys the original input string 		*/


   int i = 0; 			/* loop counter */
   BOOLEAN in_token = 0;	/* decoding status, 1 if *ins not whitespace */
   BOOLEAN end_token = 0;	/* have hit end-of-line etc */
   BOOLEAN had_quote = 0;	/* special case to cope with double quotes   */

   decodp->n_toks = 0;

   while (!end_token && (i++ < MAX_CHARS_IN_LINE ))
   {
      if (in_token)
      {
	 if (had_quote && (*ins=='\"'))
	 {
	    had_quote = 0;
	    in_token = 0;
	    *ins = '\0';
	 }
	 else switch( *ins )
	 {
	 case ' ': 
	    in_token = 0;
	    *ins = '\0';
	    break;

	 case '!':
	 case '\n':
	 case '\0':
	    end_token = 1;
	    *ins = '\0';
	    break;

	 default:;
	 }
      }
      else
      {
	 switch (*ins )
	 {
	 case ' ':
	    in_token = 0;
	    break;
	 
	 case '!':
	 case '\n':
	 case '\0':
	    end_token = 1;
	    break;
	    
	 case '\"': /* note falls through to default */
	    had_quote = 1;
	 default:
	    in_token = 1;
	    decodp->tokens[ decodp->n_toks++] = ins;
	 }
      }
      ins++;
   }

/* Put a NULL in last token, signals end of token list */
   decodp->tokens[decodp->n_toks] = NULL;

/* return TRUE/FALSE depending on whether finished line correctly or not */
   return (end_token);
}

/* Two routines to get tokens back again */

/*----------------------------------------------------------------------*/
char *first_token( DECODEP decodp )
/*----------------------------------------------------------------------*/
{
   decodp->next = 1;
   return ( decodp->tokens[0] );
}

/*----------------------------------------------------------------------*/
char *next_token( DECODEP decodp )
/*----------------------------------------------------------------------*/
{
   return (decodp->tokens[decodp->next++]);
}

/*----------------------------------------------------------------------*/
BOOLEAN decode_line( char *inline )
/*----------------------------------------------------------------------*/
{
   DECODE decoder;	/* structure holding tokens */
   char *tp;		/* token pointer */
   LAYER_T layer;	/* working variables to send to storage */
   SYMBOL_T symbol;
   FC_T fc;
   BOOLEAN had_st;	/* allow only one of ST,SM,LI/LY,FL,FR per line */
   BOOLEAN had_sm;
   BOOLEAN had_lilysn;	/* mutually exclusive */
   BOOLEAN had_fl;
   BOOLEAN had_txfr;	/* mutually exclusive */
   BOOLEAN had_m;	/* text aspect ratio */
   BOOLEAN had_zsp;	/* spline type */
   BOOLEAN had_nam;	/* name for LY, FL */
   char temp_string[20]; /* for reading argument of ZSP, spline type */


   int len, i;

/* convert to upper case */
   len = strlen( inline );
   for ( i = 0; i < len; i++ )
      inline[i] = toupper( inline[i] );

/* break down string into tokens */
   if (!tokenize( inline, &decoder ))
      return FALSE;

   if (!(tp = first_token( &decoder )))
      return TRUE; /* blank line */
   
/* compare with allowable fields */
   if (!strncmp( tp, "LA", 2 ))		/* layer */
   {
      if (!(tp = next_token( &decoder )))
	  return FALSE;
      
      if (sscanf( tp, "%d", &(layer.iff_layer)) != 1)
	 return FALSE;

      if (!(tp = next_token( &decoder )))
	 return FALSE;

      if (sscanf( tp, "%d", &(layer.gdb_layer)) != 1)
	 return FALSE;
       
      if (!add_to_layer_list( layer ))
	 return FALSE;
   }
   else if (!strncmp( tp, "SY", 2 ))	/* symbol */
   {
      symbol.iff_symbol = 0;
      symbol.gdb_symbol = '\0';
      symbol.gdb_symbol_scale = 1.0;
      symbol.as_point = FALSE;

      if (!(tp = next_token( &decoder )))
	  return FALSE;
      
      if (sscanf( tp, "%d", &(symbol.iff_symbol)) != 1)
	 return FALSE;

      if (!(tp = next_token( &decoder )))
	 return FALSE;

      if (!strncmp(tp, "PG", 2 ))
      {
	 symbol.as_point = TRUE;
      }
      else
      {
	 symbol.gdb_symbol = tp;

	 if (!(tp = next_token( &decoder )))
	 {
	    symbol.gdb_symbol_scale = 1.0;
	 }
	 else if (sscanf( tp, "%lf", &(symbol.gdb_symbol_scale)) != 1)
	    return FALSE;
      }

      if (!add_to_symbol_list( symbol ))
	 return FALSE;
   }
   else if (!strncmp( tp, "FC", 2 ) )	/* feature code */
   {
      had_st = FALSE;
      had_sm = FALSE;
      had_lilysn = FALSE;
      had_fl = FALSE;
      had_txfr = FALSE;
      had_m = FALSE;
      had_zsp = FALSE;
      had_nam = FALSE;

      fc = empty_fc;

      if (!(tp = next_token( &decoder )))
	  return FALSE;
      
      if (sscanf( tp, "%d", &(fc.fcode)) != 1)
	 return FALSE;

      while(( tp = next_token( &decoder ) ) != NULL )
      {
	 if (!strncmp( tp, "ST", 2 ))	       /* pen */
	 {
	    if (had_st) return FALSE;

	    if (!(tp = next_token( &decoder ))) return FALSE;
	    
	    if (sscanf( tp, "%d", &(fc.st )) != 1 )
	       return FALSE;

	    had_st = TRUE;
	 }
	 else if ( !strncmp( tp, "SM", 2 ) )	/* colour */
	 {
	    if (had_sm) return FALSE;

	    if (!(tp = next_token( &decoder ))) return FALSE;

	    if (sscanf( tp, "%d", &(fc.sm)) != 1)
	       return FALSE;

	    had_sm = TRUE;
	 }
	 else if ( !strncmp( tp, "LI", 2 ) )	/* LIne */
	 {
	    if (had_lilysn) return FALSE;

	    fc.poly = FALSE;
	    had_lilysn = TRUE;
	 }
	 else if ( !strncmp( tp, "LY", 2 ) )	/* poLYline */
	 {
	    if (had_lilysn) return FALSE;

	    fc.poly = TRUE;
	    had_lilysn = TRUE;
	 }
	 else if ( !strncmp( tp, "SN", 2 ) ) 	/* spline */
	 {
	    if (had_lilysn) return FALSE;

	    fc.spline = TRUE;
	    had_lilysn = TRUE;
	 }
	 else if ( !strncmp( tp, "ZSP", 3 ) )	/* spline type */
	 {
	    if (had_zsp) return FALSE;

	    if (!(tp = next_token( &decoder ))) return FALSE;

	    if (sscanf( tp, "%4c", temp_string ) != 1 )
	       return FALSE;

	    if ( !strncmp( temp_string, "FREI", 4 ))
	       fc.spline_type = FREI;
	    else if (!strncmp( temp_string, "SCHL", 4 ))
	       fc.spline_type = SCHL;
	    else if (!strncmp( temp_string, "STAN", 4 ))
	       fc.spline_type = STAN;
	    else if (!strncmp( temp_string, "STAE", 4 ))
	       fc.spline_type = STAE;
	    else
	       fc.spline_type = FREI;	/* default */
	    
	    had_zsp = TRUE;
	 }
	 else if ( !strncmp( tp, "FL", 2 ) )	/* FiLl area */
	 {
	    if (had_fl) return FALSE;

	    fc.fl_area = TRUE;
	    had_fl = TRUE;
	 }
	 else if ( !strncmp( tp, "FR", 2 ) )	/* cadastral symbol */
	 {
	    if (had_txfr) return FALSE;

	    fc.cadastral = TRUE;
	    had_txfr = TRUE;
	 }
	 else if ( !strncmp( tp, "TX", 2 ) ) 	/* text */
	 {
	    if (had_txfr) return FALSE;

	    fc.cadastral = FALSE;
	    had_txfr = TRUE;
	 }
	 else if ( !strncmp( tp, "M", 1 ) ) 	/* text aspect ratio */
	 {
	    if (had_m) return FALSE;

	    if (!(tp = next_token( &decoder ))) return FALSE;

	    if (sscanf( tp, "%lf", &(fc.text_aspect_ratio)) != 1)
	       return FALSE;
	    
	    had_m = TRUE;
	 }
	 else if (!strncmp( tp, "NAM", 3 )) /* name */
	 {
	    if (had_nam) return FALSE;

	    if (!(tp = next_token( &decoder )))
	       return FALSE;

	    fc.name = tp;
	    had_nam = TRUE;
	 }
	 else
	    return FALSE;
      }
      if (!add_to_fc_list( fc ))
	 return FALSE;
   }
   else
   {
      return FALSE;
   }
   return TRUE;
}

   
/*----------------------------------------------------------------------*/
/*  process_parameter_file						*/
/*......................................................................*/
/*									*/
/*									*/
/*----------------------------------------------------------------------*/

extern BOOLEAN process_parameter_file( FILE *fpar )
{
   char buffer[121];
   char copy_buffer[121];

   while( get_line( fpar, buffer, 120 ) > 0 )
   {
      strcpy( copy_buffer, buffer );
      if (!decode_line( buffer ) )
      {
	 printf( "Error parsing line in parameter file\n %s", copy_buffer );
	 return FALSE;
      }
   }
   return TRUE;
}

