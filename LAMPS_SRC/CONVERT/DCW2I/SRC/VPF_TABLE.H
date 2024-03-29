/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1992-07-13 13:28:46.000000000 +0100
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
/* ================ SCCS_ID[] = "@(#) vpftable.h 2.2 10/29/91"  =================

   Environmental Systems Research Institute (ESRI) Applications Programming

       Project: 		Conversion from ARC/INFO to VPF
       Original Coding:		Barry Michaels	April 1991
       Modifications:		David Flinn	April 1991
                                Barry           June 1991
                                Dave            October 1991
   ======================================================================== */

/* VPFTABLE.H */

#ifndef _VPF_TABLE_H_

#define _VPF_TABLE_H_

#define free vpffree

#include <stdio.h>
#include "machine.h"

#ifndef TRUE
#define TRUE  1
#endif
#ifndef FALSE
#define FALSE 0
#endif

/* Possible byte ordering of the data */
#define LEAST_SIGNIFICANT 0
#define MOST_SIGNIFICANT  1

/* The next definition is machine-specific and may need to be changed */
/* before recompiling on a different machine */
#define MACHINE_BYTE_ORDER LEAST_SIGNIFICANT

#define TWOPI 6.283185307

#include "vpf_io.h"

/* This should be the ISO definition of date */

typedef char date_type[21] ;	/* Include null end of string */

/* NULL value type */

typedef union {
   char 	  *Char ;
   short int	  Short ;
   long int       Int ;
   float	  Float ;
   double	  Double ;
   date_type	  Date ;
   char		  Other ;
} null_field;

/* The basic information carried for each field in the table */
typedef struct {
   char *name;           /* Name of the field */
   char description[81]; /* Field description */
   char keytype;         /* Type of key - (P)rimary, (F)oreign, (N)onkey */
   char vdt[13];         /* Value description table name */
   char *tdx;	 	 /* Thematic index file name */
   char type;            /* Data type - T,I,F,K,D */
   long int  count;      /* Number of items in this column (-1 =>variable)*/
   null_field nullval ;  /* This is used for the converter */
   char *narrative;      /* Name of a narrative table describing the field*/
} header_cell, *header_type;

typedef enum { ram, disk, either, compute } storage_type;
#define RAM 0
#define DISK 1
#define EITHER 2
#define COMPUTE 3

typedef enum { Read, Write } file_mode ;

#define CLOSED 0
#define OPENED 1

/* Each column in a table row has a count and a pointer to the data */
/*      and a null value default */
typedef struct {
   long int count;
   void *ptr;
} column_type;

/* A table row is an array of columns */
typedef column_type *row_type;

/* Index for variable width tables.          */
/* One index cell for each row in the table. */
typedef struct {
   unsigned long int pos;
   unsigned long int length;
} index_cell, *index_type;

/* VPF table structure: */
typedef struct {
   char           name[13];        /* Name of the VPF table */
   char           *path;           /* Directory path to the table */
   long int       nfields;         /* Number of fields */
   char           description[81]; /* Table description */
   char           narrative[13];   /* Table narrative file name */
   header_type    header;          /* Table header structure */
   FILE           *xfp;            /* Index file pointer */
   index_type     index;           /* Index structure */
   storage_type   xstorage;        /* Flag indicating where index stored */
   FILE           *fp;             /* Table file pointer */
   long int       nrows;           /* Number of rows in the table */
   long int       *maxwid;         /* Maximum widths for each field of a row */
   row_type       *row;            /* Array of table rows */
   long int       reclen;          /* Table record length (-1 => variable */
   long int       ddlen;           /* Data definition string length */
   char           *defstr ;        /* rdf, definition string */
   storage_type   storage;         /* Flag indicating table storage method */
   file_mode	  mode ;	   /* Table is either reading or writing */
   unsigned char  status;          /* VPF table status - OPENED or CLOSED */
   long int	  success; 
   unsigned char  byte_order;      /* Byte order of the table's data */
} vpf_table_type;

typedef struct {
   float x,y;
} coordinate_type;

typedef struct {
   double x,y;
} double_coordinate_type;

typedef struct {
   float x,y,z;
} tri_coordinate_type;

typedef struct {
   double x,y, z;
} double_tri_coordinate_type;

/* These macros help determine the type in the key datatype */

#define TYPE0(cell) ((cell>>6)&(3))
#define TYPE1(cell) ((cell>>4)&(3))
#define TYPE2(cell) ((cell>>2)&(3))
#define TYPE3(cell) ((cell)&(3))

/* These macros set the value in the key datatype */

#define SETTYPE0(cell,value) cell = (((cell)&(~(3<<6)))|(((3)&(value))<<6))
#define SETTYPE1(cell,value) cell = (((cell)&(~(3<<4)))|(((3)&(value))<<4))
#define SETTYPE2(cell,value) cell = (((cell)&(~(3<<2)))|(((3)&(value))<<2))
#define SETTYPE3(cell,value) cell = (((cell)&(~(3)))|(((3)&(value))))

/* This macro helps to write out a key */

#define ASSIGN_KEY(tYPE,kEY,loc,val) { \
    if (val < 1) { \
      tYPE(kEY.type,0); \
    } else if (val < (1<<8)) { \
      tYPE(kEY.type,1); \
      kEY.loc = val ; \
    } else if ( val < (1<<16)) { \
      tYPE(kEY.type,2); \
      kEY.loc = val; \
    } else { \
      tYPE(kEY.type,3); \
      kEY.loc = val; }}

/* define NULL values */

#include "values.h"
#include <math.h>
#define		VARIABLE_STRING_NULL_LENGTH	10
#define 	NULLCHAR	' '
#define		NULLTEXT	" "
#define		NULLSHORT	-MAXSHORT
#define         NULLINT         -MAXLONG
#define		NULLDATE	"                    "
#if UNIX
#define		NULLFLOAT	((float) quiet_nan (0))
#define		NULLDOUBLE	((double) quiet_nan (0))
#else
#define		NULLFLOAT	((float) MAXFLOAT)
#define		NULLDOUBLE	((double) MAXFLOAT)
#endif

typedef union {
   unsigned char f1;
   unsigned short int f2;
   unsigned long int f3;
} key_field;

/* id triplet internal storage type */
typedef struct {
   unsigned char type;
   long int id, tile, exid;
} id_triplet_type;

typedef enum { idle_state, name_state, type_state,
	       tuple_state, count_state } ddef_state_type;

/* Functions: */

char *get_string(long int *ind,char *src,char delimit);
char  get_char  (long int *ind,char *src);
long int   get_number(long int *ind,char *src,char delemit);

long int   parse_data_def( vpf_table_type *table );

char      *read_text_defstr( FILE *infile, FILE *outerr );

long int  index_length( long int row_number,
		        vpf_table_type table );

long int  index_pos( long int row_number,
		     vpf_table_type table );

long int row_offset( int field,
		     row_type row,
		     vpf_table_type table);

row_type  read_next_row( vpf_table_type table );

row_type  read_row( long int row_number,
		    vpf_table_type table );

vpf_table_type vpf_open_table( char *tablename,
			       storage_type storage,
			       char *mode,
			       char *defstr );   /* rdf added */

row_type get_row( long int row_number,
		  vpf_table_type table );

void free_row( row_type row, vpf_table_type table );

long int table_pos( char *field_name,
	       vpf_table_type table );

void *get_table_element( long int field_number,
			 row_type row,
			 vpf_table_type table,
			 void *value,
			 long int  *count );

void *named_table_element( char *field_name,
			   long int  row_number,
			   vpf_table_type table,
			   void *value,
			   long int  *count );

void *table_element( long int field_number,
		     long int  row_number,
		     vpf_table_type table,
		     void *value,
		     long int  *count );

void vpf_close_table( vpf_table_type *table );

void vpf_dump_table( char *tablename, char *outname );

long int is_vpf_table( char *fname );

/* Write functions */

long int write_next_row( row_type row, vpf_table_type *table );

row_type create_row( vpf_table_type table );

void nullify_table_element( long int field, row_type row,
			    vpf_table_type table );

long int put_table_element( long int field, row_type row,
			    vpf_table_type table,
			    void *value, long int count );

#if MAIN
  FILE * errorfp = stderr;
#else
  extern FILE * errorfp;
#endif

#endif     /* #ifndef _VPF_TABLE_H_  */


