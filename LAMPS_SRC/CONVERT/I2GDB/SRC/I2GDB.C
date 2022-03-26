
#module I2GDB "11AP91"

/******************************************************************************/
/*									      */
/*  Copyright Laser-scan Laboratories Ltd, Cambridge CB4 4FY, England	      */
/*  Author    J Barber					      15-Sep-1989     */
/*  Modified A Verrill					      18-Jun-1990     */
/*									      */
/******************************************************************************/


/******************************************************************************/
/*
  Laser-Scan IFF to SICAD/GDB format conversion program.
  ------------------------------------------------------
  
  SICAD/GDB (Geographical Data Base) format defined by:
  
  Siemens Ltd.
  Data Systems
  Feltham
  Middlesex
  
  Usage:
  
  I2GDB <IFF file> <output file>/frt = <FRT file>/any other qualifiers
  
  Version 1	15/09/1989	Jon Barber (from i2arc)
  Mod 		10/02/90	to pass blocks of <= 49 points to 
  ETYP=LY features
  */
/******************************************************************************/

#include <stdio.h>			/* standard I/O header */
#include <stsdef.h>			/* error status def'ns */
#include <string.h>			/* for char string handling */
#include <math.h>
#include <ctype.h>			/* toupper(), etc */

#include <lsldef.h>			/* standard LSL header */
#include <lsldesc.h>			/* for s_Desc */
#include "lsl$cmnlsl:filename.h"	/* LSLLIB filename stuff */
#include "lsl$cmniff:MD2DES.h"		/* map descriptor common block */

#include "functions.h"			/* function definitions */
#include "cbc.h"
#include "iffhan.h"
#include "iff.h"
#include "cmdline.h"			/* cmd line qualifier stuff */
#include "here:i2gdbmsg.h"		/* message parameter file */
#include "here:params.h"		/* reading parameter file */

/******************************************************************************/

/* Function prototypes for routines local to this module */

/* Function to output IFF data to the GDB file */

int output();

/* Function to convert arc/circular coordinate strings to linear */

int arc_to_lin (
		int dir);

void fprintf_point_descriptors( FILE *fout, int index );
void fprintf_feature_descriptors( FILE *fout );
BOOLEAN had_feature_descriptor( int code );
BOOLEAN had_point_descriptor( int code, int index );
INT_4 point_descriptor_val( int code, int index );

/******************************************************************************/

#define MAX_FC			32767	/* max number of FCs */
#define I2GDB_SPECIAL_TEXT_VALUE "USTX"	/* special value signifies use Text */

#define PI 3.14159265
#define sqr(a) ((a)*(a))
#define POINT_EQUAL( a, b )\
   ( ((a).x == (b).x ) && ( (a).y == (b).y ) )
#define ABSOLUTE_X( xin ) ( (coord_scale_factor * (xin)) + loc_origin_x)
#define ABSOLUTE_Y( yin ) ( (coord_scale_factor * (yin)) + loc_origin_y)

/*---------------------------------------------------------------------------*/
/* Working variables to catch values from iff file			     */
/*---------------------------------------------------------------------------*/
RANGE	range;
CORNER	corner;
SECTION section;
OVERLAY overlay;
FEATURE feature;
FSTATUS fs;
ACODE	ac;
THICK 	thick;
ROTATION rot;
char 	text[256];

/*----------------------------------------------------------------------*/
/* Structure holding data read from CB coordinate block			*/
/*----------------------------------------------------------------------*/
typedef struct v_info_t 
{
   INT_2 npts;			/* number of points in block 	*/
   INT_4 flags;			/* only PEN UP/DOWN USED	*/
   INT_2 curr_pt_nr;		/* counter through block     	*/
   INT_2 last_vertex_enumber; 	/* enumber of last vertex	*/
   INT_2 last_vertex_pnumber;	/* pnumber of last vertex	*/
   INT_2 start_enumber; 	/* enumber of first point	*/
   INT_2 start_pnumber;		/* pnumber of first point 	*/
   INT_2 last_block_enumber;	/* for use ONLY in split LY and SN  elements */
   LOGICAL zset;		/* 3d coordinates		*/
   LOGICAL descriptorset;	/* have  descriptors		*/
   VERTEX3 start_vertex;	/* position of first point   	*/
   VERTEX3 vertex[200];		/* block of vertex data		*/
} V_INFO;

V_INFO 	v_info;

/*----------------------------------------------------------------------*/
/* Set of variables recording attribute data attached to features	*/
/*----------------------------------------------------------------------*/
typedef struct 
{
   int code;
   char name[20+1];
   int type;
   union
   {
      INT_4 int_val;
      REAL_4 real_val;
      char char_val[4];
   }value;
   char text[256];
}feature_descriptor_t; 

#define MAX_NR_FEATURE_DESCRIPTORS 20
feature_descriptor_t feature_descriptor[MAX_NR_FEATURE_DESCRIPTORS];
int n_feature_descriptors;

/*----------------------------------------------------------------------*/
/* Set of variables recording attributes attached to individual points 	*/
/*----------------------------------------------------------------------*/
union 
{
   INT_4 int_val;
   REAL_4 real_val;
   char char_val[4];
} point_descriptor_values[20][200];
int point_descriptor_types[20];
int point_descriptor_codes[20];
char point_descriptor_names[20][20];
int n_point_descriptors;


/*----------------------------------------------------------------------*/
/* List structure to maintain a list of per point attributes	 	*/
/*----------------------------------------------------------------------*/
struct pdlist_type
{
  INT_4  shared_val;
  int    enum_of_pt;
  struct pdlist_type *next;
} pdlist_t;

typedef struct pdlist_type *PDLIST;
PDLIST pdlist = NULL;

PDLIST add_pair(PDLIST list,INT_4 val,int enum_to_add);
PDLIST free_list(PDLIST list);
/*void show_list(PDLIST list);      for testing */
int get_existing_enum(PDLIST list,INT_4 val);

/*----------------------------------------------------------------------*/
/* Make a note of the codes for particular attributes which are used	*/
/* to pass required parameters from iff to SiCAD GDB			*/
/*----------------------------------------------------------------------*/
/* only put out as descriptors those attributes which are in the 	*/
/* special ACD table							*/

int descriptor_code_table;	/* (1000 * ACD table) */
int pkz_code, wan_code, wen_code, pnr_code, w_code, shared_code;

/*----------------------------------------------------------------------*/
/* Other variables							*/
/*----------------------------------------------------------------------*/
double coord_scale_factor = 1.0;/* to be applied to coord values */
double frt_scale_factor = 1.0;	/* to be applied to symbol sizes and text 
				 * heights */   
double loc_origin_x = 0.0;	/* local origin from map descriptor MD 	*/
double loc_origin_y = 0.0;	/* GDB works in absolute coordinates	*/

struct	/* values retrieved from FRT */
{
   INT_4 gtype;
   INT_4 colour;
   INT_4 sc;
   REAL_4 width;
   REAL_4 size;
} frt_entry;

SYMBOL_T symbol_entry; /* values retrieved from parameters file */

int	existing_enum;	/* enum of point common to two areas */
INT_4	shared_value;
BOOLEAN	line_exists;
BOOLEAN	first_point;

INT_2	fc;		/* current fc */
INT_2   level;		/* current level number */
int     vtot = 0;	/* accum. vertices in ST,ZS entries */
int	enumber = 1;	/* internal GDB feature number, starts at 1 */
int	pnumber = 1;	/* internal point number */
int	max_vertices;	/* restricts the number of points in SiCAD elements */
BOOLEAN CB_split_into_sections; /* flag for output() */

FILE *fout; 		/* work files */
FILE *fpar;		/* parameter file */

/*----------------------------------------------------------------------*/
main()
/*----------------------------------------------------------------------*/
{
   /* declare functions used */
   void LSL_INIT();
   void LSL_EXIT();
   void LSL_PUTMSG();
   LOGICAL FRTINI();
   LOGICAL FRT_RETRIEVE();
   LOGICAL ACD_RETRIEVE();
   LOGICAL FIND_CODES();
   LOGICAL GETCB();
   
   /* C_MAX_SIZ = 217 in filename.h */
   
   /* filenames */
   char IFF_file[C_MAX_SIZ+1];		/* input IFF file */
   char FRT_file[C_MAX_SIZ+1];		/* input FRT file */
   char GDB_file[C_MAX_SIZ+1];		/* output GDB file */
   char PAR_file[C_MAX_SIZ+1];		/* input parameter file */
   
   /* used to retrieve name of an Ancilliary Code */
   char AC_name[20];
   
   /* buffers for data from coordinate  blocks */
   REAL_4 xbuf[200], ybuf[200], zbuf[200];
   
   /* set up string descriptors for calls to Fortran */
   strdesc (IFF_desc, IFF_file); 
   strdesc (FRT_desc, FRT_file);
   strdesc (AC_desc, AC_name );
   
   BOOLEAN	   IFF_is_open = FALSE;
   BOOLEAN	   GDB_is_open = FALSE;
   
   BOOLEAN	   had_ts      = FALSE;		/* had a TS entry */
   BOOLEAN	   ok 	       = FALSE;		/* function return */
   VMS_STATUS status;			/* function return */
   
   INT_2 IFF_unit = 1;
   INT_2 entry_code, entry_length;
   INT_2 length, pos, ends, start;
   INT_4 rev_level = 1;			/* IFF input revision level */
   
   
   /* workspace variables */
   int len, i, j, c, cnt;		/* workspace variables */
   int name_len;
   
   int fc_counter; /* used as loop counter at end_of_program */
   
   
   /* initialise LSLLIB */
   
   LSL_INIT (FALSE);		/* suppress timer output */
   ifferm (FALSE);			/* suppress LSLLIB error messages */
   
   /* read and decode the command line */
   
   had_frt = FALSE;
   had_log = FALSE;
   had_debug = FALSE;
   
   ok = read_cmdline ( IFF_file, GDB_file, FRT_file, PAR_file );
   if (!ok) 
   {
      LSL_PUTMSG (&I2GDB__CMDLNERR);
      goto end_program;
   }
   
   if (had_debug) had_log = TRUE;		/* output all info for debug */
   
   /* and open the input IFF file with input revision level 1 so that STs
      and ZSs appear as CBs */
   
   IFF_desc.length = strlen (IFF_file);
   
   status = iffopen (&IFF_unit, &IFF_desc, 0, FALSE, &rev_level);
   
   if ( !( status & STS$M_SUCCESS) )	/* check error opening IFF */
   {
      LSL_PUTMSG (&I2GDB__IFFOPNERR);
      goto end_program;
   }
   
   if (had_log) printf ("\n Opening IFF file      %s \n", IFF_file);
   IFF_is_open = TRUE;
   
   /* initialise the FRT table */
   if (had_log) printf ("\n Opening FRT file      %s\n", FRT_file);
   
   FRT_desc.length = strlen (FRT_file);
   if (FRTINI( &FRT_desc )) /* note TRUE => error */
   {
      LSL_PUTMSG( &I2GDB__INVALFRT );
      goto end_program;
   }
   if (had_log) printf ("\n Closing FRT file      %s\n", FRT_file);
   
   /* set up attribute codes */
   
   FIND_CODES(
	      &descriptor_code_table,
	      &pkz_code,
	      &wan_code,
	      &wen_code,
	      &pnr_code,
	      &shared_code);
   
   /* process output file name */
   
   fout = fopen (GDB_file,"w"); 
   
   if ( !fout )
   {
      LSL_PUTMSG (&I2GDB__GDBOPNERR);
      goto end_program;
   }
   
   GDB_is_open = TRUE;
   if (had_log) printf ("\n Opening GDB file %s\n\n", GDB_file);
   
   printf ("\n Now processing the IFF file %s to %s\n\n", IFF_file, 
	   GDB_file);

   
   /*----------------------------------------------------------------------*/
   /* if had parameter file then process it				*/
   /*----------------------------------------------------------------------*/
   if (had_param)
   {
      if (had_log) printf( "n Opening PARAMETER file	%s\n", PAR_file );
      if ( !(fpar = fopen( PAR_file, "r" )))
      {
	 LSL_PUTMSG( &I2GDB__PAROPNERR );
	 goto end_program;
      }
      if ( !process_parameter_file( fpar ) )
      {
	 LSL_PUTMSG( &I2GDB__PARSTXERR );
	 fclose( fpar );
	 goto end_program;
      }
      
      fclose( fpar );
      if (had_log) printf( "\n Closing PARAMETER file	%s\n", PAR_file );
   }
   
   
   /* ... and start converting input IFF file ... */
   
   /******************************  main loop *********************************/
   
   /* get each entry in turn, echoing to the user if not to be used */
   
   while (entry_code != -1)	/* retrieve entries sequentially */
   {
      iffnxt (&entry_code,&entry_length);	/* get next entry */
      
      switch ( entry_code )	/* read entries, (echo if not used) */
      {
	 
	 /* ---- File level entries ---- */
	 
      case RA:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 
	 eihr (&range, &entry_length,&one);
	 
	 
	 break;
	 
      case HI:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 break;
	 
      case EJ:		/* end of IFF file */
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 
	 goto windup;
	 break;
	 
	 /* ---- Map level entries ---- */
	 
      case MH:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 break;
	 
      case MD:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 eihr (&MD2DES, &entry_length, &one);
	 
	 /* set up local origin */
	 loc_origin_x = MD2DES.str.MD2LOC[0];
	 loc_origin_y = MD2DES.str.MD2LOC[1];
	 
	 /* set up map scale */
	 switch (MD2DES.str.MD2UNT)
	 {
	 case 0: /* unset, note falls through to case 2 */
	    printf( "Map units unset, assuming iff coordinates in ground metres\n");
	 case 2: /* ground metres */
	    if (MD2DES.str.MD2SCL > 0)
	    {
	       coord_scale_factor = 1.0;
	       frt_scale_factor = MD2DES.str.MD2SCL / 1000.0;
	    }
	    else
	    {
	       printf( "No scale in descriptor, using sizes and heights straight from FRT file\n");
	       coord_scale_factor = 1.0;
	       frt_scale_factor = 1.0;
	    }
	    break;
	    
	 case 101: /* sheet mms */
	 case 102:
	    if (MD2DES.str.MD2SCL > 0)
	    {
	       coord_scale_factor = MD2DES.str.MD2SCL / 1000.0;
	       frt_scale_factor = MD2DES.str.MD2SCL / 1000.0;
	    }
	    else
	    {
	       printf( "No scale in descriptor, using sizes and heights straight from FRT file\n");
	       coord_scale_factor = 1.0;
	       frt_scale_factor = 1.0;
	    }
	    break;
	    
	 default:
	    printf( "Warning : unexpected map units, using sizes and heights straight from FRT file\n");
	 }

	 /* Put out range info here, since when case RA did not have scale
	  * and origin info.
	  */
	 fprintf (fout, "***\n"); 
	 fprintf (fout, 
		  "*** XLU=%f    YLU=%f   XRO=%f   YRO=%f   ***\n",
		  ABSOLUTE_X(range.xmin),
		  ABSOLUTE_Y(range.ymin),
		  ABSOLUTE_X(range.xmax), 
		  ABSOLUTE_Y(range.ymax));
	 fprintf (fout, "***\n"); 

	 break;
	 
      case EM:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 break;
	 
	 /* ---- Section level entries ---- */
	 
      case NS: case CC: case CP:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 break;
	 /*
	   case CP:
	   
	   if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	   
	   eihr (&corner,&entry_length,&one);
	   break;
	   */
	 /* ---- Overlay level entries ---- */
	 
      case NO:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 
	 eihr (&overlay, &entry_length, &one);
	 
	 level = get_gdb_layer( overlay.number );
	 
	 if (level > 31)
	 {
	    LSL_PUTMSG (&I2GDB__GDBLEVELERR, &level);
	    goto end_program;
	 }
	 
/*****************************************************************************/
	 pdlist = free_list(pdlist);
/*****************************************************************************/

	 break;
	 
      case EO:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 
	 break;
	 
	 /* ---- Feature level entries ---- */
	 
      case NF:
	 n_feature_descriptors = 0;
	 CB_split_into_sections = FALSE;
	 
	 eihr (&feature, &entry_length, &one);
	 vtot   = 0;		/* initialise vertex count */
	 rot    = 0;
	 thick  = 0;
	 had_ts = FALSE;
	 
	 if (had_debug) printf ("%2.2s %d %d\n", 
				(char *) &entry_code, feature.fsn, feature.isn);
	 
	 fprintf( fout, "***** IFF : NF %d ******************************\n", feature.fsn);
	 break;
	 
      case FS:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 
	 eihr (&fs, &entry_length, &one);
	 fc = fs.fc;			/* store FC */
	 
	 if (FRT_RETRIEVE(&(fc),	/* note TRUE => error */
			  &(frt_entry.gtype),
			  &(frt_entry.colour),
			  &(frt_entry.size),
			  &(frt_entry.width),
			  &(frt_entry.sc))) /* no FRT entry */
	 {
	    LSL_PUTMSG (&I2GDB__NOFRTENTRY, &fc);
	    goto end_program;
	 }
	 fprintf( fout, "***** IFF : FS %d ******************************\n", fc);
	 if ((frt_entry.gtype == LINEAR) ||
	     (frt_entry.gtype == INTERP_CURVE) ||
	     (frt_entry.gtype == FILL_AREA) )
	    max_vertices = 49;	/* vertex block size */
	 else
	    max_vertices = 200; 	/* vertex block size */
	 
	 break;
	 
      case CB:
	 if (GETCB(xbuf, ybuf, zbuf,
		   point_descriptor_values,
		   point_descriptor_codes,
		   &(v_info.zset), 
		   &(v_info.descriptorset),
		   &(v_info.flags), 
		   &(v_info.npts),
		   &(n_point_descriptors)))
	 {
	    LSL_PUTMSG(&I2GDB__CBREADERR);
	    goto end_program;
	 }

	 /* get all available info on descriptors */
	 
	 for (i=0; i< n_point_descriptors; i++)
	 {
	    int loop;
	    
	    ACD_RETRIEVE(&(point_descriptor_codes[i]),
			 &(point_descriptor_types[i]),
			 &(name_len),
			 &(AC_desc));
	    
	    for ( loop = 0; loop < name_len; loop++ )
	       point_descriptor_names[i][loop] =
		  AC_name[loop];
	    point_descriptor_names[i][name_len] = '\0';

	 }
	 
	 if (had_debug)
	 {
	    printf("CB %d %d\n", v_info.npts, v_info.flags);
	 }
	 
	 if (!(v_info.flags & PEN_DOWN))
	 {
	    /* output the old coordinate buffer,
	     * initialise a new one
	     */
	    v_info.curr_pt_nr = 1;
	    output();
	    vtot = 0;
	    
	    /* set start vertex */
	    v_info.start_vertex.x = xbuf[0];
	    v_info.start_vertex.y = ybuf[0];
	  }

	  for (i = 0; i < v_info.npts; i++ )
	  {
	     v_info.vertex[vtot].x = xbuf[i];
	     v_info.vertex[vtot].y = ybuf[i];
	     if (v_info.zset)   v_info.vertex[vtot].z = zbuf[i];
	     vtot++;

	     if ((v_info.npts % (max_vertices-2))==2)
		{
		if (vtot==max_vertices-2)
	           {
		   /* too many coords,
		    * output buffer
		    */
		    output();
		    CB_split_into_sections = TRUE;

		    if ( i < (v_info.npts-1) )
		      {
			/* start another buffer if more points to come
			 * last point of old becomes first point of new
			 */
			v_info.vertex[0] = v_info.vertex[vtot - 1];
			vtot = 1;
		      }
		    else {vtot=0;}
		  }
		}
	       else {
		 if (vtot==max_vertices-1)
		   {
		     /* too many coords,
		      * output buffer
		      */
		     output();
		     CB_split_into_sections = TRUE;

		     if ( i < (v_info.npts-1) )
		       {
			 /* start another buffer if more points to come
			  * last point of old becomes first point of new
			  */
			 v_info.vertex[0] = v_info.vertex[vtot - 1];
			 vtot = 1;
		       }
		     else {vtot=0;}
		   }
	       }
	    }
	 
	 break;
	 
      case AC:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);

	 for ( i = 0; i < 256; i++)
	    ac.text[i] = '\0';
	 eihr (&ac, &entry_length, &one);
	 
	 n_feature_descriptors++;
	 
	 if ( (ac.type == 2) || (ac.type == 3) )
	 {
	    strcpy( feature_descriptor[n_feature_descriptors-1].name, "HGEL");
	    if (ac.type == 2 ) 
	       feature_descriptor[n_feature_descriptors-1].type = 1; /*integer*/
	    else 
	       feature_descriptor[n_feature_descriptors-1].type = 2; /*real*/
	 }
	 else
	 {
	    ACD_RETRIEVE(&(ac.type),
			 &(feature_descriptor[n_feature_descriptors-1].type),
			 &(name_len),
			 &AC_desc);
	    for ( i = 0; i < name_len; i++ )
	       feature_descriptor[n_feature_descriptors-1].name[i] = 
		  AC_name[i];
	    feature_descriptor[n_feature_descriptors-1].name[name_len] = '\0';	
	 }			
	 
	 for ( i = 0; ac.text[i] != '\0'; i++)
	    feature_descriptor[n_feature_descriptors-1].text[i] =
	       ac.text[i];
	 feature_descriptor[n_feature_descriptors-1].text[i] = '\0';

	 feature_descriptor[n_feature_descriptors-1].code = ac.type;
	 feature_descriptor[n_feature_descriptors-1].value.int_val = ac.value.integer;
	 
	 break;
	 
      case TH:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 
	 eihr (&thick, &entry_length, &one);
	 break;
	 
      case RO:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 
	 eihr (&rot, &entry_length, &one);
	 break;
	 
      case TX:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 
	 eihr ((short int *)text, &entry_length, &one);
	 
	 /* NB. returned text is NOT null terminated, so ... */
	 
	 text[entry_length*2] = '\0'; 
	 break;
	 
      case TS:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 
	 /* the second or subsequent TS entry signifies further text components */
	 /* belonging to a composite text feature, so treat it as an EF entry   */
	 /* (to output the previous TX entry as a single text feature), and an  */
	 /* NF entry (as the start a new text feature) so that the text compts  */
	 /* are output as a string of separate text features. 		  */
	 
	 
	 if (!had_ts)		/* reflect first TS only */
	 {
	    if (!had_debug) printf 
	       ("%2.2s\n",(char *) &entry_code);
	 }
	 else
	 {
	    output();		/* output coords */
	    vtot = 0;		/*   as for EF   */
	 }
	 had_ts = TRUE;
	 break;
	 
      case EF:
	 
	 if (had_debug) printf ("%2.2s\n",(char *) &entry_code);
	 
	 output();		/* output feature data */
	 vtot = 0;		/* and re-initialise for next */
	 had_ts     = FALSE;
	 
	 break;
	 
	 /* ---- ( obsolete entries ) ---- */		
	 
      case TC: case CH: case CS: case SS: case SL: 
	 
	 printf ("(%2.2s)\n",(char *) &entry_code);
	 break;
	 
	 /* ---- Other ignored entries ---- */
	 
      case VO: case JB: case JP: case SH: default:	
	 
	 printf ("%2.2s\n",(char *) &entry_code);
	 break;
      }
   }
   
   
   /*****************************  End of main loop  *****************************/
   
   /* close the IFF file */
   
 windup:
   iffclo (&IFF_unit);			/* close IFF file */
   if (had_log) 
      printf ("\n Closing IFF file      %s\n", IFF_file);
   IFF_is_open = FALSE;
   
   fprintf (fout, "************************************************\n");
   fclose (fout);
   if (had_log) printf ("\n Closing GDB file %s\n\n", GDB_file);
   GDB_is_open = FALSE;
   
   LSL_PUTMSG (&I2GDB__NORMAL);
   
   /*  output the number of default fc definitions used */
   
   for ( fc_counter = 1; fc_counter < MAX_FC_TABLE; fc_counter++ )
      if (used_undefined_fc[fc_counter] != 0 )
	 printf( "%d feature(s) with FC %d have been output using default translations\n", used_undefined_fc[fc_counter], fc_counter );
   
   
   goto exit;
      
   end_program:
   
   if (IFF_is_open) 
   {
      iffclo (&IFF_unit);			/* close IFF file */
      if (had_log) 
	 printf ("\n Closing IFF file      %s\n", IFF_file);
      IFF_is_open = FALSE;
   }
   
   fclose (fout);
   GDB_is_open = FALSE;
   if (had_log) printf ("\n Closing GDB file %s\n\n", GDB_file);
   
 exit:
   
   LSL_EXIT();
}




/************************************************************************/
/*									*/
/*			output()					*/
/*									*/
/* 	Routine to output the feature information			*/
/*
  Linear features (GT1) with <= 3 vertices are output as line (LI)
  elements, each with its associated point (PG) pair. Those with
  more than 3 vertices are output as poly-line (LY) element, with
  the end points defined by a point (PG) pair. Both cases have no 
  symbols defined at the vertices.
  
  Interpolated curves (GT6) are output as interpolated line or 
  spline (SN) element, with the end points defined by a point (PG) 
  pair with no symbol defined at the vertces.
  
  Symbol strings (GT11) are output as a series of line segments (LI)
  each with its associated point (PG) pair defining a symbol at all
  vertices.
  
  Area features (GT12) are output as an area (FL) element, and then 
  decomposed into their constituent line (LI) segments, each in turn 
  defined by two point (PG) elements with no symbol defined.
  
  All arc features (GT2,3,4) are output as curve (BO) elements
  
  Full circle arc features (GT5) are output as circle (KR) elements.
  
  All symbol (GT7,8,9) features are output as SY elements.
  
  Text features (GT10) are output to text (TX) elements.
  
  
  
  Each feature element has a line containing:
  
  ETYP elem type (required)
  
  ENUM elem number (required and must be unique: any subsequent 
  occurrence will be assumed to be an element identical to the first.
  
  STU  hierarchy level
  
  EB   level number
  
  SM   line style
  
  ST   line thickness/colour --- use for FC
  
  followed by:
  
  X,Y, etc  parameter/descriptor names
  
  *    comment lines
  
  
  
  All IFF linear features (LI) assumed to not have symbols at
  vertices except for symbol string (GT 11)
  
  For the underlying PG entries:
  
  PKZ Z 		un-symbolled vertex
  PKZ G		symbol at vertex
  PKZ U		circle at vertex
  
  PG elements required for BO (arc), LI (line), LY (poly-line) and
  SN (interpolated line) feature elements.
  
  /*									*/
   /************************************************************************/
   
int output()
{
   int i,j;			/* loops */
   int txlen;			/* no. of chars in text */
   int spacing;			/* hatching spacing */
   char position;		/* text position */
   INT_2 graph_type;		/* graphical type to switch on */
   FC_T fc_data;		/* feature code data from parameter file */
   double radius, angle;	/* arc parameters */
   VERTEX3 seed;		/* seed point for FL areas */
   double wan_angle;
   double wen_angle;
   
   double sz, xs, ys, xe, ye, xi, yi; 
   double a, b, c, d, e, f, g;
   
   int cadastral_text_nr[2];
   
   
#define IFF_ABSENT 0x80000000
   
   
/* define a few macros to save typing, also easy to re-define actions */

#define FPRINTF_STARS( f )\
fprintf( (f), "************************************************\n" )
      
#define FPRINTF_ST_SM(f, x)\
if ( x.st >= 0 ) fprintf( (f), " ST=%d", x.st );\
if ( x.sm >= 0 ) fprintf( (f), " SM=%d", x.sm );\
fprintf( (f), "\n" )
	       
#define FPRINTF_HGEL( fout, j )\
if (v_info.zset && ( ( (INT_4) v_info.vertex[(j)].z ) != IFF_ABSENT))\
fprintf( (fout), "HGEL %14.4f\n", v_info.vertex[(j)].z )
		     
   if (vtot > 0)		/* if we have some to output */
   {
      /* set up feature code data */
      fc_data = get_fc_data( fc );
      
      /* determine graphical type to output */
      if (frt_entry.gtype == FILL_AREA) 
	 graph_type = ( fc_data.fl_area ? FILL_AREA : LINEAR );
      else 
	 graph_type = frt_entry.gtype;
      
      if ((graph_type == FILL_AREA) &&
	  (CB_split_into_sections))
	 graph_type = LINEAR;

      switch (graph_type)	/* branch on GT */
      {
	 /*----------------------------------------------------------------------*/
      case FILL_AREA :	/* GT 12 - treat as closed linear feature */
	 /* Note that this falls through into case LINEAR to output the edges */
	 /* get hatching angle and spacing */
	 
	 if (frt_entry.size > 0.0)
	    spacing = frt_scale_factor * frt_entry.size;
	 else 
	    spacing = frt_scale_factor * 5;			/* default */
	 
	 if (frt_entry.sc == 1 || frt_entry.sc == 101)
	    rot = 0;
	 else if (frt_entry.sc == 2 || frt_entry.sc == 102)
	    rot = 90;
	 else if (frt_entry.sc == 3 || frt_entry.sc == 103)
	    rot = 45;
	 else if (frt_entry.sc == 4 || frt_entry.sc == 104)
	    rot = -45;
	 else if (frt_entry.sc == -1)		/* solid */
	 {
	    spacing = 0;
	    rot     = 0;
	 }
	 else
	    rot = 0;

	 /* if IFF feature has invisible perimeter, set sm (pen) to 0 */
	 if ((frt_entry.sc == 101) ||
	     (frt_entry.sc == 102) ||
	     (frt_entry.sc == 103) ||
	     (frt_entry.sc == 104) ||
	     (frt_entry.sc == 105) ||
	     (frt_entry.sc == 106))
	    fc_data.sm = 0;

	 /* calculate seed point */
	 if ( !seed_point( &seed, v_info.vertex, vtot ))
	 {
	    seed.x = 0.0;
	    seed.y = 0.0;
	 }
	 
	 FPRINTF_STARS( fout );
	 fprintf (fout, "ETYP=FL STU=1 ENUM=%d/00000000 EB=%d",
		  enumber++, level);
	 FPRINTF_ST_SM( fout, fc_data );
	 if ( fc_data.name != '\0' )
	    fprintf (fout, "NAM %s\n", fc_data.name );
	 else
	    fprintf (fout, "NAM\n");
	 fprintf (fout, "X %14.4f\n", ABSOLUTE_X(seed.x) );
	 fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(seed.y) );
	 if (!had_feature_descriptor( w_code ))
	    fprintf (fout, "W %f\n", rot);	/* hatching angle */
	 fprintf (fout, "SA %d\n", spacing); 	/* hatching spacing */
	 fprintf (fout, "FLA \n"); /* unused */
	 fprintf_feature_descriptors( fout );

	 first_point = TRUE;

	 if (!(fc_data.poly && (vtot>2)))	     /* single line elements */
	 {

	    for (i = 1; i < vtot; i++)
	    {
	      /* see if line has shared-code attributes associated with it */
	      /* and maintain a linked list of line ENUMs so that line are */
	      /* not duplicated */

	      line_exists = FALSE;

	      shared_value = point_descriptor_val(shared_code,i-1);
	      if ((shared_value!=IFF_ABSENT) && (shared_value!=0))
		{
		  existing_enum = get_existing_enum(pdlist,shared_value);
		  if (existing_enum!=0)
		    {
		      /* printf("EXISTING ENUM COMMON TO TWO AREAS = %4d\n",existing_enum); */
		      line_exists = TRUE;
		      v_info.curr_pt_nr = 1;
		    }
		}


	       FPRINTF_STARS( fout );
	       if (line_exists) {
		 fprintf (fout,"ETYP=LI STU=%d ENUM=%d/00000000 EB=%d\n",
			 (fc_data.fl_area ? 2 : 1), /* STU */
			  existing_enum, level ); 
	         }
	       else {
	         fprintf (fout,"ETYP=LI STU=%d ENUM=%d/00000000 EB=%d",
			(fc_data.fl_area ? 2 : 1), /* STU */
			enumber++, level ); 
	         }

	      if ((shared_value!=IFF_ABSENT) &&
		  (shared_value!=0) &&
		  (!line_exists))
		 {
		   pdlist = add_pair(pdlist,shared_value,enumber-1);
		   /*show_list(pdlist);  for testing */
		 }

	       if (!line_exists) {

	       if (graph_type == LINEAR)
	       {
    		  FPRINTF_ST_SM( fout, fc_data );
		  fprintf_feature_descriptors(fout);
	       }
	       else
		  fprintf( fout, "\n" );

	       FPRINTF_STARS( fout );
	       
	       if (v_info.curr_pt_nr == 1)
	       {
		  /* first point of IFF feature, never seen before */

		  fprintf (fout, "ETYP=PG STU=%d ENUM=%d/00000000 EB=%d\n", 
			   (fc_data.fl_area ? 3 : 2), /* STU */
			   enumber++, level);
		  fprintf (fout, "X %14.4f\n",
			   ABSOLUTE_X(v_info.vertex[i-1].x));
		  fprintf (fout, "Y %14.4f\n",
			   ABSOLUTE_Y(v_info.vertex[i-1].y));
		  fprintf_point_descriptors( fout, i-1 );
		  if (!(had_point_descriptor(pkz_code,i-1)))
		     fprintf(fout, "PKZ Z\n" );
		  FPRINTF_HGEL( fout, i-1 );
		  if (!(had_point_descriptor(pnr_code,i-1)))
		     fprintf(fout, "PNR 0\n");
		  
		  if (first_point)
		    {
		      v_info.start_enumber = enumber - 1;
		      v_info.start_pnumber = pnumber - 1;
		    }
	       }
	       else
	       {
		  /* seen as last point, so reference last enumber, pnumber */
		  
		  fprintf (fout, "ETYP=PG STU=%d ENUM=%d/00000000 EB=%d\n", 
			   (fc_data.fl_area ? 3 : 2), /* STU */
			   v_info.last_vertex_enumber, level);
		  
		  /* just put out reference to element, not its details */
		  /*		  fprintf (fout, "X %14.4f\n",
		   *			   ABSOLUTE_X(v_info.vertex[i-1].x));
		   *		  fprintf (fout, "Y %14.4f\n",
		   *			   ABSOLUTE_Y(v_info.vertex[i-1].y));
		   *		  fprintf_point_descriptors( fout, i-1 );
		   *		  FPRINTF_HGEL( fout, i-1 );
		   *		  fprintf (fout, "PNR %d\n", v_info.last_vertex_pnumber);  
		   */
		  
	       }	
	       
	       if (( i == (vtot - 1) ) && POINT_EQUAL( v_info.vertex[i], v_info.start_vertex ))
	       {
		  /* last point is equal to first point */
		  
		  FPRINTF_STARS( fout );
		  fprintf (fout, "ETYP=PG STU=%d ENUM=%d/00000000 EB=%d\n", 
			   (fc_data.fl_area ? 3 : 2), /* STU */
			   v_info.start_enumber, level);
		  
		  /* just put out reference to element, not its details*/
		  /*		  fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[i].x));
		   *		  fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[i].y));
		   *		  fprintf_point_descriptors( fout, i );
		   *		  FPRINTF_HGEL( fout, i );
		   *		  fprintf (fout, "PNR %d\n", v_info.start_pnumber);  
		   */
	       }
	       else 
	       {
		  /* usual case */
		  
		  FPRINTF_STARS( fout );
		  fprintf (fout, "ETYP=PG STU=%d ENUM=%d/00000000 EB=%d\n", 
			   (fc_data.fl_area ? 3 : 2), /* STU */
			   enumber++, level);
		  fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[i].x));
		  fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[i].y));
		  fprintf_point_descriptors( fout, i );
		  if (!(had_point_descriptor(pkz_code,i)))
		     fprintf(fout, "PKZ Z\n" );
		  FPRINTF_HGEL( fout, i );
		  if (!(had_point_descriptor(pnr_code,i)))
		     fprintf(fout, "PNR 0\n");
	       }
	       
	       v_info.last_vertex_enumber = enumber - 1 ;
	       v_info.last_vertex_pnumber = pnumber - 1;
	       ++v_info.curr_pt_nr;
	     }
	     first_point = FALSE;
	    } /* close for */
	    break;
	 } /* close if */
	 
	 /* Note NO break when dealing polygon areas ! */
 /*----------------------------------------------------------------------*/
      case LINEAR :		/* GT 1  */
	 
	 if (fc_data.poly && (vtot>2) )	/* create polylinea */
	 {
	    FPRINTF_STARS( fout );
	    fprintf (fout, "ETYP=LY STU=%d ENUM=%d/00000000 EB=%d",
		     (fc_data.fl_area ? 2 : 1), /* STU */
		     enumber++, level );

	    if (graph_type == LINEAR)
	    {
	       FPRINTF_ST_SM( fout, fc_data );
	    }
	    else
	       fprintf( fout, "\n" );
	    
	    if ((fc_data.name != '\0') &&
		(frt_entry.gtype == LINEAR))
	       fprintf (fout, "NAM %s\n", fc_data.name );
	    else
	       fprintf (fout, "NAM\n" );
	    /*	    fprintf (fout, "N %d\n", vtot-2);	no of coordinates */
	    
	    if (graph_type == LINEAR) fprintf_feature_descriptors(fout);
	    
	    if (POINT_EQUAL( v_info.vertex[0], v_info.vertex[vtot-1] ))
	    {
	       fprintf(fout, "FLD %14.4f\n", ABSOLUTE_X(v_info.vertex[0].x));
	       fprintf(fout, "    %14.4f\n", ABSOLUTE_Y(v_info.vertex[0].y));
	       for (i=1; i <= vtot-1; i++)
	       {
		  fprintf(fout, "    %14.4f\n", ABSOLUTE_X(v_info.vertex[i].x));
		  fprintf(fout, "    %14.4f\n", ABSOLUTE_Y(v_info.vertex[i].y));
	       }
	    }
	    else
	    {
	       fprintf (fout, "FLD %14.4f\n", ABSOLUTE_X(v_info.vertex[1].x));
	       fprintf (fout, "    %14.4f\n", ABSOLUTE_Y(v_info.vertex[1].y));
	       
	       for (i = 2; i <= vtot-2; i++)
	       {
		  fprintf (fout, "    %14.4f\n", ABSOLUTE_X(v_info.vertex[i].x));
		  fprintf (fout, "    %14.4f\n", ABSOLUTE_Y(v_info.vertex[i].y));
	       }

	       if (CB_split_into_sections)
	       {
		  FPRINTF_STARS( fout );
		  fprintf(fout, "ETYP=PG STU=%d ENUM=%d/00000000 EB=%d\n",
			  (fc_data.fl_area ? 3 : 2), /* STU */
			  v_info.last_block_enumber, level );
	       }
	       else
	       {
		  FPRINTF_STARS( fout );
		  fprintf (fout, "ETYP=PG STU=%d ENUM=%d/00000000 EB=%d\n", 
			   (fc_data.fl_area ? 3 : 2), /* STU */
			   enumber++, level);
		  fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[0].x));
		  fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[0].y));
		  fprintf_point_descriptors( fout, 0 );
		  if (!(had_point_descriptor(pkz_code,0)))
		     fprintf(fout, "PKZ Z\n" );
		  FPRINTF_HGEL( fout, 0 );
		  if (!(had_point_descriptor(pnr_code,0)))
		     fprintf(fout, "PNR 0\n");
	       }	       
	       FPRINTF_STARS( fout );
	       fprintf (fout, "ETYP=PG STU=%d ENUM=%d/00000000 EB=%d\n", 
			(fc_data.fl_area ? 3 : 2), /* STU */
			enumber++, level);
	       fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[vtot-1].x));
	       fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[vtot-1].y));
	       fprintf_point_descriptors( fout, vtot-1 );
	       if (!(had_point_descriptor(pkz_code,vtot-1)))
		  fprintf(fout, "PKZ Z\n" );
	       FPRINTF_HGEL( fout, vtot-1 );
	       if (!(had_point_descriptor(pnr_code,vtot-1)))
		  fprintf(fout, "PNR 0\n");

	       v_info.last_block_enumber = enumber - 1;
	    }
	 }
	 else	/* single line elements */
	 {
	    for (i = 1; i < vtot; i++)
	    {
	       FPRINTF_STARS( fout );
	       fprintf (fout,"ETYP=LI STU=%d ENUM=%d/00000000 EB=%d",
			(fc_data.fl_area ? 2 : 1), /* STU */
			enumber++, level ); 

	       if (graph_type == LINEAR)
	       {
		  FPRINTF_ST_SM( fout, fc_data );
		  fprintf_feature_descriptors(fout);
	       }
	       else
		  fprintf( fout, "\n" );

	       FPRINTF_STARS( fout );
	       
	       if (v_info.curr_pt_nr == 1)
	       {
		  /* first point of IFF feature, never seen before */

		  fprintf (fout, "ETYP=PG STU=%d ENUM=%d/00000000 EB=%d\n", 
			   (fc_data.fl_area ? 3 : 2), /* STU */
			   enumber++, level);
		  fprintf (fout, "X %14.4f\n",
			   ABSOLUTE_X(v_info.vertex[i-1].x));
		  fprintf (fout, "Y %14.4f\n",
			   ABSOLUTE_Y(v_info.vertex[i-1].y));
		  fprintf_point_descriptors( fout, i-1 );
		  if (!(had_point_descriptor(pkz_code,i-1)))
		     fprintf(fout, "PKZ Z\n" );
		  FPRINTF_HGEL( fout, i-1 );
		  if (!(had_point_descriptor(pnr_code,i-1)))
		     fprintf(fout, "PNR 0\n");
		  
		  v_info.start_enumber = enumber - 1;
		  v_info.start_pnumber = pnumber - 1;
	       }
	       else
	       {
		  /* seen as last point, so reference last enumber, pnumber */
		  
		  fprintf (fout, "ETYP=PG STU=%d ENUM=%d/00000000 EB=%d\n", 
			   (fc_data.fl_area ? 3 : 2), /* STU */
			   v_info.last_vertex_enumber, level);
		  
		  /* just put out reference to element, not its details */
		  /*		  fprintf (fout, "X %14.4f\n",
		   *			   ABSOLUTE_X(v_info.vertex[i-1].x));
		   *		  fprintf (fout, "Y %14.4f\n",
		   *			   ABSOLUTE_Y(v_info.vertex[i-1].y));
		   *		  fprintf_point_descriptors( fout, i-1 );
		   *		  FPRINTF_HGEL( fout, i-1 );
		   *		  fprintf (fout, "PNR %d\n", v_info.last_vertex_pnumber);  
		   */
		  
	       }	
	       
	       if (( i == (vtot - 1) ) && POINT_EQUAL( v_info.vertex[i], v_info.start_vertex ))
	       {
		  /* last point is equal to first point */
		  
		  FPRINTF_STARS( fout );
		  fprintf (fout, "ETYP=PG STU=%d ENUM=%d/00000000 EB=%d\n", 
			   (fc_data.fl_area ? 3 : 2), /* STU */
			   v_info.start_enumber, level);
		  
		  /* just put out reference to element, not its details*/
		  /*		  fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[i].x));
		   *		  fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[i].y));
		   *		  fprintf_point_descriptors( fout, i );
		   *		  FPRINTF_HGEL( fout, i );
		   *		  fprintf (fout, "PNR %d\n", v_info.start_pnumber);  
		   */
	       }
	       else 
	       {
		  /* usual case */
		  
		  FPRINTF_STARS( fout );
		  fprintf (fout, "ETYP=PG STU=%d ENUM=%d/00000000 EB=%d\n", 
			   (fc_data.fl_area ? 3 : 2), /* STU */
			   enumber++, level);
		  fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[i].x));
		  fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[i].y));
		  fprintf_point_descriptors( fout, i );
		  if (!(had_point_descriptor(pkz_code,i)))
		     fprintf(fout, "PKZ Z\n" );
		  FPRINTF_HGEL( fout, i );
		  if (!(had_point_descriptor(pnr_code,i)))
		     fprintf(fout, "PNR 0\n");
	       }
	       
	       v_info.last_vertex_enumber = enumber - 1 ;
	       v_info.last_vertex_pnumber = pnumber - 1;
	       ++v_info.curr_pt_nr;
	    }
	 }	
	 
	 break;
	 
 /*----------------------------------------------------------------------*/
      case INTERP_CURVE :	/* GT 6  - interpolated curve */
	 /* assume at least 3 points in buffer */
	 
	 /* find min and max x, y values */
	 
	 xs = v_info.vertex[0].x;			/* x min */
	 xe = v_info.vertex[0].x;			/* x max */
	 ys = v_info.vertex[0].y;			/* y min */
	 ye = v_info.vertex[0].y;			/* y max */
	 
	 for (i = 1; i < vtot; i++)
	 {
	    if (v_info.vertex[i].x  > xe)
	       xe = v_info.vertex[i].x;
	    else if (v_info.vertex[i].x  < xs)
	       xs = v_info.vertex[i].x;
	    
	    if (v_info.vertex[i].y  > ye)
	       ye = v_info.vertex[i].y;
	    else if (v_info.vertex[i].y  < ys)
	       ys = v_info.vertex[i].y;
	 }	
	 
	 switch(fc_data.spline_type)
	 {
	 case FREI:
	    break;
	 case SCHL:
	    if ( !POINT_EQUAL(v_info.vertex[0],v_info.vertex[vtot-1]) )
	       fc_data.spline_type = FREI;
	    break;
	 case STAN:
	    if ( !had_feature_descriptor( wan_code ) )
	       fc_data.spline_type = FREI;
	    break;
	 case STAE:
	    if ((!had_feature_descriptor(wan_code)) ||
		(!had_feature_descriptor(wen_code)))
	       fc_data.spline_type = FREI;
	    break;
	 }
	 
	 FPRINTF_STARS( fout );
	 fprintf (fout, "ETYP=SN STU=1 ENUM=%d/00000000 EB=%d",
		  enumber++, level);
	 FPRINTF_ST_SM( fout, fc_data );
	 switch(fc_data.spline_type)
	 {
	 case FREI:
	    fprintf(fout, "ZSP FREI\n");
	    break;
	 case SCHL:
	    fprintf(fout, "ZSP SCHL\n");
	    break;
	 case STAN:
	    fprintf(fout, "ZSP STAN\n");
	    break;
	 case STAE:
	    fprintf(fout, "ZSP STAE\n");
	    break;
	 }
	 fprintf (fout, "XMI %14.4f\n", ABSOLUTE_X(xs));
	 fprintf (fout, "YMI %14.4f\n", ABSOLUTE_Y(ys));
	 fprintf (fout, "XMA %14.4f\n", ABSOLUTE_X(xe));
	 fprintf (fout, "YMA %14.4f\n", ABSOLUTE_Y(ye));

	 /* NB : dummy values as specified by Vaupel, 19-9-90 */
	 fprintf (fout, "LEN %14.4f\n", 999.0); /* dummy value */
	 fprintf (fout, "FRE %d\n", 999); /* dummy value */

	 switch(fc_data.spline_type)
	 {
	 case FREI:
	    /* calculate WAN,WEN,
	     * if user has already attached values then use these instead
	     */
	    if (!had_feature_descriptor(wan_code))
	    {
	       wan_angle = (180 / PI ) *
		  atan2((v_info.vertex[1].y - v_info.vertex[0].y),
			(v_info.vertex[1].x - v_info.vertex[0].x));
	       fprintf (fout, "WAN %lf\n", wan_angle );
	    }
	    if (!had_feature_descriptor(wen_code))
	    {
	       wen_angle = 180 - (180 / PI ) *
		  atan2((v_info.vertex[vtot-2].y - v_info.vertex[vtot-1].y),
			(v_info.vertex[vtot-2].x - v_info.vertex[vtot-1].x));
	       fprintf (fout, "WEN %lf\n", wen_angle );
	    }
	    break;
	 case SCHL:
	 case STAN:
	 case STAE:
	    break;
	 }
	 
	 fprintf_feature_descriptors(fout);
	 
	 if (POINT_EQUAL(v_info.vertex[0], v_info.vertex[vtot-1]))
	 {
	    fprintf(fout, "FLD %14.4f\n", ABSOLUTE_X(v_info.vertex[0].x ));
	    fprintf(fout, "    %14.4f\n", ABSOLUTE_Y(v_info.vertex[0].y ));
	    for (i=1; i < vtot; i++)
	    {
	       fprintf(fout, "    %14.4f\n", ABSOLUTE_X(v_info.vertex[i].x ));
	       fprintf(fout, "    %14.4f\n", ABSOLUTE_Y(v_info.vertex[i].y ));
	    }
	 }
	 else
	 {
	    fprintf (fout, "FLD %14.4f\n", ABSOLUTE_X(v_info.vertex[1].x));
	    fprintf (fout, "    %14.4f\n", ABSOLUTE_Y(v_info.vertex[1].y));
	    
	    for (i = 2; i <= vtot-2; i++)
	    {
	       fprintf (fout, "    %14.4f\n", ABSOLUTE_X(v_info.vertex[i].x));
	       fprintf (fout, "    %14.4f\n", ABSOLUTE_Y(v_info.vertex[i].y));
	    }
	    
	    if (CB_split_into_sections)
	    {
	       /* seen as last point in previous time through */
	       FPRINTF_STARS(fout);
	       fprintf(fout, "ETYP=PG STU=2 ENUM=%d/00000000 EB=%d\n",
		       v_info.last_block_enumber, level);
	    }
	    else
	    {
	       FPRINTF_STARS( fout );
	       fprintf (fout, "ETYP=PG STU=2 ENUM=%d/00000000 EB=%d\n", 
			enumber++, level);
	       fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[0].x));
	       fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[0].y));
	       fprintf_point_descriptors( fout, 0 );
	       if (!(had_point_descriptor(pkz_code,0)))
		  fprintf(fout, "PKZ Z\n" );
	       FPRINTF_HGEL( fout, i );
	       if (!(had_point_descriptor(pnr_code,0)))
		  fprintf(fout, "PNR 0\n");
	    }	    

	    FPRINTF_STARS( fout );
	    fprintf (fout, "ETYP=PG STU=2 ENUM=%d/00000000 EB=%d\n", 
		     enumber++, level);
	    fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[vtot-1].x));
	    fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[vtot-1].y));
	    fprintf_point_descriptors( fout, vtot-1 );
	    if (!(had_point_descriptor(pkz_code,vtot-1)))
	       fprintf(fout, "PKZ Z\n" );
	    FPRINTF_HGEL( fout, vtot-1 );
	    if (!(had_point_descriptor(pnr_code,vtot-1)))
	       fprintf(fout, "PNR 0\n");

	    v_info.last_block_enumber = enumber - 1;
	 }	 
	 break;
	 
 /*----------------------------------------------------------------------*/
      case SYM_STRING :	/* GT 11 symbol string */
	 
/* Simply put out a symbol at each of the points in the coordinate block*/
/* This is the behaviour agreed to by Kircher(Tirre) and Vaupel(Borger) */
/* on 3/AUG/90.								*/
/* All symbols at level 1						*/
	 
	 /* size of symbol is determined from frt entry and scale factor */
	 sz = frt_entry.size * frt_scale_factor;
	 
	 /* symbol to use comes from frt secondary code */
	 symbol_entry = get_gdb_symbol( frt_entry.sc );
	 
	 /* symbols are unoriented and unscaled so extent of bounding box is
	  * trivial */
	 xs = -sz;
	 xe = sz;
	 ys = -sz;
	 ye = sz;
	 
	 for (i = 0; i < vtot; i++)
	 {
	    FPRINTF_STARS( fout );
	    fprintf(fout,
		    "ETYP=SY STU=1 ENUM=%d/00000000 EB=%d",
		    enumber++,
		    level);
	    FPRINTF_ST_SM(fout, fc_data);
	    fprintf (fout, "NAM %s \n", symbol_entry.gdb_symbol );
	    fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[i].x));
	    fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[i].y));
	    fprintf (fout, "W 0.000000\n");
	    if (symbol_entry.gdb_symbol_scale != 0.0 )
	       fprintf (fout, "F %14.4f\n",
			(sz / symbol_entry.gdb_symbol_scale));
	    else
	       fprintf (fout, "F 1\n");
	    fprintf (fout, "S 0\n");
	    fprintf (fout, "X1 %14.4f\n", xs);
	    fprintf (fout, "Y1 %14.4f\n", ys);
	    fprintf (fout, "X2 %14.4f\n", xe);
	    fprintf (fout, "Y2 %14.4f\n", ye);
	    fprintf_feature_descriptors(fout);
	 }
	 
	 break;
	 
/*----------------------------------------------------------------------*/
      case UNORIEN_SYMBOL :	/* GT 7 - */
      case ORIEN_SYMBOL :	/* GT 8 - */
      case SCAL_SYMBOL :	/* GT 9 - */
	 
	 if (graph_type == ORIEN_SYMBOL)
	 {
	    sz = frt_entry.size * frt_scale_factor;
	    
	    if (vtot == 2)
	       angle = (180/PI) * atan2( (v_info.vertex[1].y - v_info.vertex[0].y), 
					(v_info.vertex[1].x - v_info.vertex[0].x) );
	    else
	       angle = rot*180/PI;
	 }
	 else if (graph_type == SCAL_SYMBOL)
	 {
	    angle = (180/PI) * atan2( (v_info.vertex[1].y - v_info.vertex[0].y), 
				     (v_info.vertex[1].x - v_info.vertex[0].x) );
	    if (vtot == 2)
	       sz = frt_scale_factor *
		  sqrt(sqr(v_info.vertex[1].y - v_info.vertex[0].y) +
		       sqr(v_info.vertex[1].x - v_info.vertex[0].x));
	    else
	       sz = frt_scale_factor * frt_entry.size;
	 }
	 else 	/* UNORIEN_SYBOL */
	 {
	    angle = 0;
	    sz = frt_scale_factor * frt_entry.size;
	 }
	 
	 rot = angle * PI/180;		/* convert back to radians */
	 
      {
	 /* local variables for finding out bounding box around symbol */
	 
	 VERTEX2 p[4]; /* transformed corners of IFF default box */
	 double cs = cos(rot); 
	 double sn = sin(rot);
	 
	 /* work out transformed corners of square (-1,-1) to (1,1 ) */
	 /* note calculation is relative to origin */
	 p[0].x = sz * ( cs + sn );
	 p[0].y = sz * ( -sn + cs ); 	/* (1,1) */
	 p[1].x = sz * ( cs - sn );
	 p[1].y = sz * ( -sn - cs ); 	/* (1,-1) */
	 p[2].x = sz * ( -cs - sn );
	 p[2].y = sz * ( sn + cs ); 	/* (-1,1) */
	 p[3].x = sz * ( -cs - sn );
	 p[3].y = sz * ( sn - cs ); 	/* (-1,-1) */
	 
	 /* work out max/min x and y */
	 xs = p[0].x;
	 xe = p[0].x;
	 ys = p[0].y;
	 ye = p[0].y;
	 for (j=1; j < 4; j++)
	 {
	    if (p[j].x < xs ) xs = p[j].x;
	    if (p[j].x > xe ) xe = p[j].x;
	    if (p[j].y < ys ) ys = p[j].y;
	    if (p[j].y > ye ) ye = p[j].y;
	 }
      }
	 
	 symbol_entry = get_gdb_symbol( frt_entry.sc );
	 
	 if (!(symbol_entry.as_point))
	 {
	    /* Normal output of symbols */

	    FPRINTF_STARS( fout );
	    fprintf (fout, "ETYP=SY STU=1 ENUM=%d/00000000 EB=%d", 
		     enumber++, level);
	    FPRINTF_ST_SM( fout, fc_data );
	    
	    fprintf (fout, "NAM %s \n", symbol_entry.gdb_symbol );
	    fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[0].x));
	    fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[0].y));
	    fprintf (fout, "W %lf\n", angle);
	    if (symbol_entry.gdb_symbol_scale != 0.0 )
	       fprintf (fout, "F %14.4f\n",
			(sz / symbol_entry.gdb_symbol_scale));
	    else
	       fprintf (fout, "F 1\n");
	    fprintf (fout, "S 0\n");
	    fprintf (fout, "X1 %14.4f\n", xs);
	    fprintf (fout, "Y1 %14.4f\n", ys);
	    fprintf (fout, "X2 %14.4f\n", xe);
	    fprintf (fout, "Y2 %14.4f\n", ye);
	    fprintf_feature_descriptors(fout);
	 }
	 else
	 {
	    /* very special case where the symbol in iff should be output
	     * as a point. This caters for such things as geodetic fix points,
	     * elevation points etc. Result of
	     * 	       	SYMBOL n PG
	     * in parameters file.
	     */
	    FPRINTF_STARS(fout);
	    fprintf (fout, "ETYP=PG STU=1 ENUM=%d/00000000 EB=%d\n", 
		     enumber++, level);
	    fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[0].x));
	    fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[0].y));
	    fprintf_feature_descriptors(fout);
	    if (!had_feature_descriptor(pkz_code))
	       fprintf(fout, "PKZ Z\n");
	 }
	 
	 break;
	 
/*----------------------------------------------------------------------*/
      case TEXT :		/* GT 10 - can cope with rotated text, and */
	 /*   curved as TS text component strings   */
	 
	 txlen = strlen(text);		/* no. of characters */
	 angle = rot*180/PI;			/* convert to degrees */
	 
	 if (frt_entry.size > 0.0)			/* use FRT value by default */
	    sz = frt_entry.size * frt_scale_factor;
	 else if (thick > 0.0)		/* convert TH size to mm. */
	    sz = thick * 100 * frt_scale_factor;
	 
	 /* extract the text position flag from fs.flag.text.position */
	 
	 if (fs.flag.text.position == 0)
	    position = 'L';			/* left */
	 else if (fs.flag.text.position == 3)
	    position = 'M'; 			/* middle */
	 else if (fs.flag.text.position == 6)
	    position = 'R'; 			/* right */
	 else /* fs.flag.text.position == 4 or anything else */
	    position = 'Z';			/* centre */
	 
	 /*
	   xs = v_info.vertex[0].x; ys = v_info.vertex[0].y;
	   xe = xs + txlen * sz * cos(rot);
	   ye = ys + txlen * sz * sin(rot);
	   */
	 
	 if (!(fc_data.cadastral ))
	 {
	    /* normal text output */
	    
	    FPRINTF_STARS( fout );
	    fprintf (fout, "ETYP=TX STU=1 ENUM=%d/00000000 EB=%d", 
		     enumber++, level);
	    FPRINTF_ST_SM( fout, fc_data );
	    fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[0].x));
	    fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[0].y));
	    fprintf (fout, "N %d\n", txlen);
	    fprintf (fout, "H %lf\n", sz);
	    fprintf (fout, "W %lf\n", angle);
	    fprintf (fout, "A %c\n", position);
	    fprintf (fout, "M %lf\n", fc_data.text_aspect_ratio);
	    fprintf (fout, "TXT %s\n", text);
	 }
	 else
	 {
	    /* cadastral symbol handled as text */
	    
	    if ( sscanf(text, "%d/%d", 
			&cadastral_text_nr[0], &cadastral_text_nr[1]) != 2)
	    {
	       if (sscanf(text, "%d", &cadastral_text_nr[0]) == 1)
	       {
		  cadastral_text_nr[1] = 0;
	       }
	       else if (sscanf(text, "/%d", &cadastral_text_nr[1]) == 1)
	       {
		  cadastral_text_nr[0] = 0;
	       }
	       else
	       {
		  /* sscanf failed, set to 0/0 */
		  cadastral_text_nr[0] = cadastral_text_nr[1] = 0;
	       }
	    }	       
	    FPRINTF_STARS( fout );
	    fprintf (fout, "ETYP=FR STU=1 ENUM= %d/00000000 EB=%d",
		     enumber++, level ); /* corrected from EYTP */
	    FPRINTF_ST_SM (fout, fc_data);
	    fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[0].x ));
	    fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[0].y ));
	    fprintf (fout, "NR1 %d\n", cadastral_text_nr[0]);
	    fprintf (fout, "NR2 %d\n", cadastral_text_nr[1]);
	    fprintf (fout, "H %lf\n", sz);
	    fprintf (fout, "RNR %d\n", 0);
	    fprintf (fout, "SFK\n");
	    fprintf (fout, "FRI\n");
	    if (angle != 0.0)
	       fprintf (fout, "W %lf\n", angle);
	    fprintf (fout, "M %lf\n", fc_data.text_aspect_ratio);
	 }
	 
	 fprintf_feature_descriptors(fout);
	 
	 break;
	 
/*----------------------------------------------------------------------*/
      case CW_ARC :			/* GT 2 - */
	 /* edge, centre, edge */
	 /*	    arc_to_lin(1); */
	 
	 /* note carefully the differences between CW and ACW_ARC */
	 
	 radius = sqrt(sqr(v_info.vertex[0].x - v_info.vertex[1].x) + 
		       sqr(v_info.vertex[0].y - v_info.vertex[1].y) ); 
	 
	 angle = (180/PI) * 
	    (atan2((v_info.vertex[0].y - v_info.vertex[1].y), 
		   (v_info.vertex[0].x - v_info.vertex[1].x) ) -
	     atan2((v_info.vertex[2].y - v_info.vertex[1].y), 
		   (v_info.vertex[2].x - v_info.vertex[1].x) ) );
	 
	 if (angle < 0)
	    angle = angle + 360;
	 else if (angle > 360)
	    angle = angle - 360;
	 
	 FPRINTF_STARS( fout );
	 fprintf (fout, "ETYP=BO STU=1 ENUM=%d/00000000 EB=%d", 
		  enumber++, level);
	 FPRINTF_ST_SM( fout, fc_data );
	 fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[1].x));
	 fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[1].y));
	 fprintf (fout, "R %lf\n", radius);
	 fprintf (fout, "W %lf\n", angle);
	 fprintf_feature_descriptors(fout);
	 
	 FPRINTF_STARS( fout );
	 fprintf (fout, "ETYP=PG STU=2 ENUM=%d/00000000 EB=%d\n", 
		  enumber++, level);
	 fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[2].x));
	 fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[2].y));
	 fprintf_point_descriptors( fout, 2 );
	 if (!(had_point_descriptor(pkz_code,2)))
	    fprintf(fout, "PKZ Z\n" );
	 FPRINTF_HGEL( fout, 2 );
	 if (!(had_point_descriptor(pnr_code,2)))
	    fprintf(fout, "PNR 0\n");
	 
	 
	 FPRINTF_STARS( fout );
	 fprintf (fout, "ETYP=PG STU=2 ENUM=%d/00000000 EB=%d\n", 
		  enumber++, level);
	 fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[0].x));
	 fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[0].y));
	 fprintf_point_descriptors( fout, 0 );
	 if (!(had_point_descriptor(pkz_code,0)))
	    fprintf(fout, "PKZ Z\n" );
	 FPRINTF_HGEL( fout, 0 );
	 if (!(had_point_descriptor(pnr_code,0)))
	    fprintf(fout, "PNR 0\n");
	 
	 break;
	 
      case ACW_ARC :			/* GT 3 - */
	 /* edge, centre, edge */
	 
	 /*	    arc_to_lin(-1); */
	 
	 radius = sqrt(sqr(v_info.vertex[0].x - v_info.vertex[1].x) + 
		       sqr(v_info.vertex[0].y - v_info.vertex[1].y) ); 
	 
	 angle = (180/PI) * 
	    (atan2((v_info.vertex[2].y - v_info.vertex[1].y), 
		   (v_info.vertex[2].x - v_info.vertex[1].x) ) -
	     atan2((v_info.vertex[0].y - v_info.vertex[1].y), 
		   (v_info.vertex[0].x - v_info.vertex[1].x) ) );
	 
	 if (angle < 0)
	    angle = angle + 360;
	 else if (angle > 360)
	    angle = angle - 360;
	 
	 FPRINTF_STARS( fout );
	 fprintf (fout, "ETYP=BO STU=1 ENUM=%d/00000000 EB=%d", 
		  enumber++, level);
	 FPRINTF_ST_SM( fout, fc_data );
	 fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[1].x));
	 fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[1].y));
	 fprintf (fout, "R %lf\n", radius);
	 fprintf (fout, "W %lf\n", angle);
	 fprintf_feature_descriptors(fout);
	 
	 FPRINTF_STARS( fout );
	 fprintf (fout, "ETYP=PG STU=2 ENUM=%d/00000000 EB=%d\n", 
		  enumber++, level);
	 fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[0].x));
	 fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[0].y));
	 fprintf_point_descriptors( fout, 0 );
	 if (!(had_point_descriptor(pkz_code,0)))
	    fprintf(fout, "PKZ Z\n" );
	 FPRINTF_HGEL( fout, 0 );
	 if (!(had_point_descriptor(pnr_code,0)))
	    fprintf(fout, "PNR 0\n");
	 
	 
	 FPRINTF_STARS( fout );
	 fprintf (fout, "ETYP=PG STU=2 ENUM=%d/00000000 EB=%d\n", 
		  enumber++, level);
	 fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[2].x));
	 fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[2].y));
	 fprintf_point_descriptors( fout, 2 );
	 if (!(had_point_descriptor(pkz_code,2)))
	    fprintf(fout, "PKZ Z\n" );
	 FPRINTF_HGEL( fout, 2 );
	 if (!(had_point_descriptor(pnr_code,2)))
	    fprintf(fout, "PNR 0\n");
	 
	 break;
	 
	 
/*----------------------------------------------------------------------*/
      case CIRCUM_CIRCLE :		/* GT 5 - */
	 /* 3 points on edge */
	 
	 xs = v_info.vertex[0].x; ys = v_info.vertex[0].y;
	 xi = v_info.vertex[1].x; yi = v_info.vertex[1].y;
	 xe = v_info.vertex[2].x; ye = v_info.vertex[2].y;
	 
	 /* compute centre and replace intermediate point */
	 
	 a = 2.0*(xs-xi); b = 2.0*(ys-yi); c=ys*ys-yi*yi+xs*xs-xi*xi;
	 d = 2.0*(xe-xi); e = 2.0*(ye-yi); f=ye*ye-yi*yi+xe*xe-xi*xi;
	 g = d*b - a*e;
	 
	 /* replace middle coordinate with position of centre of circle */
	 
	 v_info.vertex[1].x = (b*f - c*e)/g; v_info.vertex[1].y = (c*d - a*f)/g;
	 
	 /*	    v_info.vertex[2].x = xs; v_info.vertex[2].y = ys;  /* end at starting point */
	 /*	    arc_to_lin(1); */
	 
	 radius = sqrt(sqr(v_info.vertex[0].x - v_info.vertex[1].x) + 
		       sqr(v_info.vertex[0].y - v_info.vertex[1].y) ); 
	 
	 
	 FPRINTF_STARS( fout );
	 fprintf (fout, "ETYP=KR STU=1 ENUM=%d/00000000 EB=%d", 
		  enumber++, level);
	 FPRINTF_ST_SM( fout, fc_data );
	 fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[1].x));
	 fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[1].y));
	 fprintf (fout, "R %lf\n", radius);
	 fprintf_feature_descriptors(fout);

	 break;
	 
/*----------------------------------------------------------------------*/
      case CIRCUM_CIRC_ARC :		/* GT 4 - */
	 /* 3 points on edge */
	 
	 xs = v_info.vertex[0].x; ys = v_info.vertex[0].y;
	 xi = v_info.vertex[1].x; yi = v_info.vertex[1].y;
	 xe = v_info.vertex[2].x; ye = v_info.vertex[2].y;
	 
	 /* compute centre and replace intermediate point ... */
	 
	 a = 2.0*(xs-xi); b = 2.0*(ys-yi); c=ys*ys-yi*yi+xs*xs-xi*xi;
	 d = 2.0*(xe-xi); e = 2.0*(ye-yi); f=ye*ye-yi*yi+xe*xe-xi*xi;
	 g = d*b - a*e;
	 
	 v_info.vertex[1].x = (b*f - c*e)/g;
	 v_info.vertex[1].y = (c*d - a*f)/g;
	 
	 /*	    if ( xi*(ys-ye)-yi*(xs-xe)+xs*ye-xe*ys > 0 ) 
		    arc_to_lin(1);
		    else
		    arc_to_lin(-1); */

	 radius = sqrt(sqr(v_info.vertex[0].x - v_info.vertex[1].x) + 
		       sqr(v_info.vertex[0].y - v_info.vertex[1].y) ); 

	 /* test cross-product to see if clockwise or anticlockwise arc */
	 /* NB version 6-aug-90 had typo here, check carefully */

	 if ((((xi - xs)*(ye - yi)) -
	      ((xe - xi)*(yi - ys))) < 0 )
	 {	 
	    /* clockwise */

	    angle = (180/PI) * 
	       (atan2((v_info.vertex[0].y - v_info.vertex[1].y), 
		      (v_info.vertex[0].x - v_info.vertex[1].x) ) -
		atan2((v_info.vertex[2].y - v_info.vertex[1].y), 
		      (v_info.vertex[2].x - v_info.vertex[1].x) ) );
	    
	    if (angle < 0)
	       angle = angle + 360;
	    else if (angle > 360)
	       angle = angle - 360;
	    
	    FPRINTF_STARS( fout );
	    fprintf (fout, "ETYP=BO STU=1 ENUM=%d/00000000 EB=%d", 
		     enumber++, level);
	    FPRINTF_ST_SM( fout, fc_data );
	    fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[1].x));
	    fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[1].y));
	    fprintf (fout, "R %lf\n", radius);
	    fprintf (fout, "W %lf\n", angle);
	    fprintf_feature_descriptors(fout);
	    
	    FPRINTF_STARS( fout );
	    fprintf (fout, "ETYP=PG STU=2 ENUM=%d/00000000 EB=%d\n", 
		     enumber++, level);
	    fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[2].x));
	    fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[2].y));
	    fprintf_point_descriptors( fout, 2 );
	    if (!(had_point_descriptor(pkz_code,2)))
	       fprintf(fout, "PKZ Z\n" );
	    FPRINTF_HGEL( fout, 2 );
	    if (!(had_point_descriptor(pnr_code,2)))
	    fprintf(fout, "PNR 0\n");
	 
	    FPRINTF_STARS( fout );
	    fprintf (fout, "ETYP=PG STU=2 ENUM=%d/00000000 EB=%d\n", 
		     enumber++, level);
	    fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[0].x));
	    fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[0].y));
	    fprintf_point_descriptors( fout, 0 );
	    if (!(had_point_descriptor(pkz_code,0)))
	    fprintf(fout, "PKZ Z\n" );
	    FPRINTF_HGEL( fout, 0 );
	    if (!(had_point_descriptor(pnr_code,0)))
	       fprintf(fout, "PNR 0\n");
	 }
	 else
	 {
	    /* anti-clockwise */

	    angle = (180/PI) * 
	       (atan2((v_info.vertex[2].y - v_info.vertex[1].y), 
		      (v_info.vertex[2].x - v_info.vertex[1].x) ) -
		atan2((v_info.vertex[0].y - v_info.vertex[1].y), 
		      (v_info.vertex[0].x - v_info.vertex[1].x) ) );
	 
	    if (angle < 0)
	       angle = angle + 360;
	    else if (angle > 360)
	       angle = angle - 360;
	 
	    FPRINTF_STARS( fout );
	    fprintf (fout, "ETYP=BO STU=1 ENUM=%d/00000000 EB=%d", 
		     enumber++, level);
	    FPRINTF_ST_SM( fout, fc_data );
	    fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[1].x));
	    fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[1].y));
	    fprintf (fout, "R %lf\n", radius);
	    fprintf (fout, "W %lf\n", angle);
	    fprintf_feature_descriptors(fout);
	 
	    FPRINTF_STARS( fout );
	    fprintf (fout, "ETYP=PG STU=2 ENUM=%d/00000000 EB=%d\n", 
		     enumber++, level);
	    fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[0].x));
	    fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[0].y));
	    fprintf_point_descriptors( fout, 0 );
	    if (!(had_point_descriptor(pkz_code,0)))
	       fprintf(fout, "PKZ Z\n" );
	    FPRINTF_HGEL( fout, 0 );
	    if (!(had_point_descriptor(pnr_code,0)))
	       fprintf(fout, "PNR 0\n");
	 
	    FPRINTF_STARS( fout );
	    fprintf (fout, "ETYP=PG STU=2 ENUM=%d/00000000 EB=%d\n", 
		     enumber++, level);
	    fprintf (fout, "X %14.4f\n", ABSOLUTE_X(v_info.vertex[2].x));
	    fprintf (fout, "Y %14.4f\n", ABSOLUTE_Y(v_info.vertex[2].y));
	    fprintf_point_descriptors( fout, 2 );
	    if (!(had_point_descriptor(pkz_code,2)))
	       fprintf(fout, "PKZ Z\n" );
	    FPRINTF_HGEL( fout, 2 );
	    if (!(had_point_descriptor(pnr_code,2)))
	       fprintf(fout, "PNR 0\n");
	 }
	 break;
	 
      default:
	    
	 break;
      }
   }
   return(1);
}


/************************************************************************/
/*									*/
/*			arc_to_lin()					*/
/*									*/
/* 	Routine to convert arc features to linear			*/
/*									*/
/************************************************************************/

int arc_to_lin ( int dir )

   /* direction, +ve = clockwise (i.e. decreasing theta) */

{
   double r,re, xs, ys, xc, yc, xe, ye, theta, thetas, thetae, dtheta;

/*
printf("in arc2lin with vtot=%d dir=%d\n",vtot,dir);
printf("verts = %f %f \n      %f %f\n      %f %f\n",
vertex[0].x,vertex[0].y,
vertex[1].x,vertex[1].y,
vertex[2].x,vertex[2].y);
*/

	xs = v_info.vertex[0].x; ys = v_info.vertex[0].y;
	xc = v_info.vertex[1].x; yc = v_info.vertex[1].y;
	xe = v_info.vertex[2].x; ye = v_info.vertex[2].y;

   /* radius assumed to be distance from 1st to 2nd ST entry */ 

	r = sqrt( sqr(xs - xc) + sqr(ys - yc) );

	thetas = atan2( (ys-yc),(xs-xc) );	/* starting angle */
	if ( thetas < 0.0 )			/* make positive */
		thetas += 2.0 * PI;

	thetae = atan2( (ye-yc),(xe-xc) );	/* ending angle */

	if ( thetae < 0.0 )			/* make positive */
		thetae += 2.0 * PI;

	dtheta = sqrt(0.08 / r);		/* another rule of thumb! */
/*
printf("r=%f dtheta=%f\n",r,dtheta);
*/
	v_info.vertex[0].x = xs; v_info.vertex[0].y = ys;	/* keep first point */

	if ( dir > 0 )				/* clockwise case */
	{
		if ( thetae >= thetas ) 	/* start must be > end angle! */
			thetas += 2.0 * PI;

		for(vtot=1,theta=thetas-dtheta;theta>thetae;theta-=dtheta,vtot++)
		{
			v_info.vertex[vtot].x = xc + r * cos(theta);
			v_info.vertex[vtot].y = yc + r * sin(theta);
		}
	}
	else
	{
		if ( thetas >= thetae ) 	/* start must be < end angle! */
			thetae += 2.0 * PI;

		for(vtot=1,theta=thetas+dtheta;theta<thetae;theta+=dtheta,vtot++)
		{
			v_info.vertex[vtot].x = xc + r * cos(theta);
			v_info.vertex[vtot].y = yc + r * sin(theta);
		}
	}

   /* add last vertex. NOTE: not necessarily same as 3rd ST entry */

	v_info.vertex[vtot].x = xc + r * cos(thetae);
	v_info.vertex[vtot].y = yc + r * sin(thetae);
	vtot++;

	return(1);

}

/*----------------------------------------------------------------------*/
/* fprintf_point_descriptors						*/
/* 									*/
/* put out any special attribute info which has been attached to a 	*/
/* single point								*/
/*----------------------------------------------------------------------*/
void fprintf_point_descriptors( FILE *fout, int index )
{
    int loop;
    for (loop = 0; loop < n_point_descriptors; loop++)
       if ((point_descriptor_codes[loop] / 1000) == descriptor_code_table)
	  if (point_descriptor_codes[loop]!=shared_code)
	    { /*comm*/
	    switch(point_descriptor_types[loop])
	      {
	      case 1:
	        if (point_descriptor_values[loop][index].int_val != IFF_ABSENT)
	          {
	  	  fprintf((fout),
			  "%s ", 
			  point_descriptor_names[loop]);
		  fprintf((fout), 
			  "%d\n",
			  point_descriptor_values[loop][index].int_val);
	          }
	          break;
	      case 2:
	        if (point_descriptor_values[loop][index].int_val != IFF_ABSENT)
	          {
		  fprintf((fout),
			  "%s ", 
			  point_descriptor_names[loop]);
		  fprintf((fout),
			  "%14.4f\n",
			  point_descriptor_values[loop][index].real_val);
	          }
	        break;
	      case 3:
	        if ((point_descriptor_values[loop][index].int_val != IFF_ABSENT) &&
		    (point_descriptor_values[loop][index].int_val != 0))
	          {
		  fprintf((fout),
			  "%s ", 
			  point_descriptor_names[loop]);
		  fprintf((fout),
			  "%c%c%c%c\n",
			  point_descriptor_values[loop][index].char_val[0],
			  point_descriptor_values[loop][index].char_val[1],
			  point_descriptor_values[loop][index].char_val[2],
			  point_descriptor_values[loop][index].char_val[3]
			  );
		  }
	        break;
	      }
	    }
 }



/*----------------------------------------------------------------------*/
/* had_point_descriptor( int code, int index )    			*/
/*----------------------------------------------------------------------*/
BOOLEAN had_point_descriptor( int code, int index )
{
   int loop;

   for (loop = 0; loop < n_point_descriptors; loop++ )
      if (point_descriptor_codes[loop] == code )
      {
	 switch(point_descriptor_types[loop])
	 {
	 case 1:
	 case 2:
	    if (point_descriptor_values[loop][index].int_val != IFF_ABSENT)
	       return TRUE;
	    else
	       return FALSE;
	    break;
	 case 3:
	    if ((point_descriptor_values[loop][index].int_val != IFF_ABSENT) &&
		(point_descriptor_values[loop][index].int_val != 0))
	       return TRUE;
	    else
	       return FALSE;
	    break;
	 }
      }
   return FALSE;
}   


/*----------------------------------------------------------------------*/
/* point_descriptor_val( int code, int index )    			*/
/*----------------------------------------------------------------------*/
INT_4 point_descriptor_val( int code, int index )
{
   int	 loop;
   INT_4 pdval;

   for (loop = 0; loop < n_point_descriptors; loop++ )
      if (point_descriptor_codes[loop] == code )
      {
	 switch(point_descriptor_types[loop])
	 {
	 case 1:
	 case 2:
	    pdval = point_descriptor_values[loop][index].int_val;
	    if (pdval != IFF_ABSENT)
	       return pdval;
	    else
	       return IFF_ABSENT;
	    break;
	 case 3:
	    pdval = point_descriptor_values[loop][index].int_val;
	    if ((pdval != IFF_ABSENT) && (pdval != 0))
	       return pdval;
	    else
	       return IFF_ABSENT;
	    break;
	 }
      }
   return IFF_ABSENT;
}   

/*----------------------------------------------------------------------*/
/*	fprintf_feature_descriptors( FILE *fout )			*/
/*----------------------------------------------------------------------*/

void fprintf_feature_descriptors( FILE *fout )
{
#define HAS_VALUE(c) ( ((c) != '\0') ? (c) : ' ')

   int loop;
   char char_val_as_string[4+1];
   
   for (loop = 0; loop < n_feature_descriptors; loop++)
      if (((feature_descriptor[loop].code / 1000) == descriptor_code_table) ||
	  (feature_descriptor[loop].code == 2) ||
	  (feature_descriptor[loop].code == 3))
      {
	 fprintf((fout),
		 "%s ", 
		 feature_descriptor[loop].name);
	 
	 switch(feature_descriptor[loop].type)
	 {
	 case 1:
	    fprintf((fout),
		    "%d",
		    feature_descriptor[loop].value.int_val);
	    break;
	    
	 case 2:
	    fprintf((fout),
		    "%14.4f",
		    feature_descriptor[loop].value.real_val);
	    break;	
	    
	 case 3:
	    char_val_as_string[0] =
	       toupper(feature_descriptor[loop].value.char_val[0]);
	    char_val_as_string[1] =
	       toupper(feature_descriptor[loop].value.char_val[1]);
	    char_val_as_string[2] =
	       toupper(feature_descriptor[loop].value.char_val[2]);
	    char_val_as_string[3] =
	       toupper(feature_descriptor[loop].value.char_val[3]);
	    char_val_as_string[4] = '\0';
	    
	    if (!strncmp(char_val_as_string,
			 I2GDB_SPECIAL_TEXT_VALUE,
			 4))
	       fprintf((fout), 
		       "%s",
		       feature_descriptor[loop].text);
	    else
	       fprintf((fout),
		       "%c%c%c%c",
		       HAS_VALUE(feature_descriptor[loop].value.char_val[0]),
		       HAS_VALUE(feature_descriptor[loop].value.char_val[1]),
		       HAS_VALUE(feature_descriptor[loop].value.char_val[2]),
		       HAS_VALUE(feature_descriptor[loop].value.char_val[3]));
	    break;
	 }
	 fprintf(fout,
		 "\n");
      }
}
#undef HAS_VALUE

/*----------------------------------------------------------------------*/
/* had_feature_descriptor( int code )					*/
/*----------------------------------------------------------------------*/
BOOLEAN had_feature_descriptor( int code )
{
   int loop;

   for (loop = 0; loop < n_feature_descriptors; loop++ )
      if (feature_descriptor[loop].code == code )
	 return TRUE;
   return FALSE;
}

/*----------------------------------------------------------------------*/
/* add_pair(PDLIST list,INT_4 val,int enum_to_add)			*/
/*----------------------------------------------------------------------*/
PDLIST add_pair(PDLIST list,INT_4 val,int enum_to_add)
{
	PDLIST head;
	PDLIST newpair;
	head = list;

	if (list != NULL) {
	   while (head->next != NULL) head = head->next;
	   }

	newpair = (PDLIST) malloc(sizeof(pdlist_t));
	newpair->shared_val = val;
	newpair->enum_of_pt = enum_to_add;
	newpair->next = NULL;

	if (list==NULL)
	   { list = newpair; }
	else
	   { head->next = newpair; }

	return (list);
}

/*----------------------------------------------------------------------*/
/* show_list(PDLIST list)						*/
/*----------------------------------------------------------------------*/
/*void show_list(PDLIST list)	     /* print out list - for testing */
/*{
	PDLIST head;

	for (head=list;head!=NULL;head=head->next)
	   {
	    printf("val=%4d,enum=%4d\n",head->shared_val,
		                        head->enum_of_pt);
	   }
}*/

/*----------------------------------------------------------------------*/
/* free_list(PDLIST list)						*/
/*----------------------------------------------------------------------*/
PDLIST free_list(PDLIST list)
{
	PDLIST   head,vsav;

	if (list != NULL) {
	   for (head=list->next;head!=NULL;head=vsav) {
	      vsav = head->next;
	      free(head);
	      }
	   list = NULL;
	   }
	return list;
}

/*----------------------------------------------------------------------*/
/* get_existing_enum(PDLIST list,INT_4 val)				*/
/*----------------------------------------------------------------------*/
int get_existing_enum(PDLIST list,INT_4 val)
{
	PDLIST head;

	for (head=list;head!=NULL;head=head->next)
	   if (head->shared_val == val) return head->enum_of_pt;

	return 0;
}

