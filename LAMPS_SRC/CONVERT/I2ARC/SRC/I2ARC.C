#module I2ARC "12AP95"

/******************************************************************************/
/*									      */
/*  Copyright Laser-scan Laboratories Ltd, Cambridge CB4 4FY, England	      */
/*  Author    J Barber					      15-May-1989     */
/*  Based on ITOARC written by G.J.Robinson, NUTIS	      13-Aug-1988     */
/*									      */
/******************************************************************************/


/******************************************************************************/
/*
 	Laser-Scan IFF to ARC/Info export format conversion program.
	------------------------------------------------------------

	ARC/INFO export format defined by:

	Environmental Systems Research Institute (ESRI)
	380 New York St.
	Redlands
	California

	Usage:

	I2ARC <IFF file> <export file>/frt = <FRT file>/any other quals

	The coverage export file generated contains the following information:

	    ARC - lines and circles + arcs converted to linear features.
	    LAB - points
	    TXT - text
	    IFO - Info tables, comprising:
		<coverage>.BND - Coordinate RAnges
		<coverage>.TIC - Corner Points 
		  plus 'non-standard' stuff to relate LSL info to INFO info.
		<coverage>.FSN - FSN to FC and layer relations
		<coverage>.IAC - Integer ACs ( types 1-2,4-11 )
		<coverage>.RAC - Real ACs ( type 3  )
		<coverage>.LUT - LUT for FCs occuring in this data set.

	Version 1.0	13/08/1988	Gary Robinson, NUTIS
	Version 1.1	07/09/1988		"

	Version 2.0	15/05/1989	Jon Barber
			LSL standardised (with LSL_PUTMSG etc.)
			Command line driven
			TS entries produce separate text features
			ZS entries handled (to give x,y only)
			CB entries turned into ST/ZS for x,y -
					(set input revision level 0)

	Version 3.0	06/03/1991	Steve Townrow
	                New qualifiers /INFO_TABLES and /PARAMETER added
			to arc attribute tables .AAT and .PAT using the
			parameter file to describe the type of the attributes

        Mod 1224	21/04/1993	Steve Townrow
			Function st_out now writes attribute id numbers (narcs)
			which are equal to the features to which they belong.

	Mod 1333	19/1/1994	Steve Townrow
			New global variables introduced which keep a count of
			the number of bytes used in the AAT and PAT tables.
			They are called aat_count and pat_count and are set
			in routine DOTABLES.

	Mod 1379	2/3/1995	Steve Townrow
			The program now outputs sequential Internal and User
			IDs when /NOINFO_TABLES is used. SPR 2719.

	Mod 1474	2/3/1995	Steve Townrow
			A feature with > 500 points which is broken up into
			separate features will have each new part given a 
			unique (sequential) Internal ID and User-ID and
			the same attributes as on the original feature.

	Mod 1485	12/4/1995	Steve Townrow
			The program now outputs sequential Internal and User
			IDs always.
*/
/******************************************************************************/

#include <stdio.h>			/* standard I/O header */
#include <stsdef.h>			/* error status def'ns */
#include <string.h>			/* for char string handling */
#include <lsldef.h>			/* standard LSL header */
#include <lsldesc.h>			/* for s_Desc */

#include <math.h>
#include "here:cbc.h"			/* GJR's versions of C header files */
#include "here:iffhan.h"
#include "here:iff.h"

#include "here:frtcom.h"		/* FRT */
#include "lsl$cmnlsl:filename.h"	/* LSLLIB filename stuff */
#include "here:cmdline.h"		/* cmd line qualifier stuff */
#include "here:i2arcmsg.h"		/* message param file */

#define FILE_NAME_LEN		39	/* length for file name */
#define MAX_VERTICES 		10000	/* just be safe! */
#define MAX_ARCINFO_VERTICES 	500	/* coordinate string size in ARCINFO */
#define MAX_FC			32767	/* max number of FCs */

#define PI 3.14159265
#define sqr(a) ((a)*(a))

RANGE	range;				/* working variables etc. */
CORNER	corner;
SECTION section;
OVERLAY overlay;
FEATURE feature;
FSTATUS fs;
ACODE	ac;
THICK 	thick;
ROTATION rot;
VERTEX2 vertex[MAX_VERTICES];
char 	text[256];
char	attline[80];
char	expstr[320];
int	lineptr;

short gtype[MAX_FC], colour[MAX_FC];		/* FRT info. */
short sc[MAX_FC]   , symbol[MAX_FC];

float width[MAX_FC], size[MAX_FC];

int	acnum = 0; aclist[256][7];

int	blocknum = 0;	/* number of times a feature was split into blocks */
			/* of size MAX_ARCINFO_VERTICES */
int	narcs = 0;	/* number of arcs (line) features */
int	nsymb = 0;	/* number of symbol features */
int	naat = 0;	/* number of arc attributes */
int	npat = 0;	/* number of point attributes */
int	j = 0, i = 0;	/* general loop counters */
int     id = 1;		/* current ID number of feature ( used to relate
			   FSN, FC, layer no. etc. between coords & DB info */
INT_2	fc;		/* current fc */
int     vtot = 0;	/* accum. vertices in ST,ZS entries */
int	aat_count;	/* number of bytes for all attributes in AAT table */
int	pat_count;	/* number of bytes for all attributes in PAT table */

FILE *fout, *ffrt, *fpar, *flab, *ftxt;		/* work files */
FILE *faat, *fpat, *ffsn, *fiac, *frac;

struct attlist *alist;
struct attlist *plist;

/******************************************************************************/

main()
{
	void LSL_INIT();
	void LSL_EXIT();
	void LSL_PUTMSG();
	struct attlist *addatt(struct attlist *, int);
	struct attlist *addattval(struct attlist *, int, int, float, char *);
	void buildlists(void);
	void showlist(struct attlist *);
	void writelist(struct attlist *, int);
	void freelist(struct attlist *);

   /* C_MAX_SIZ = 217 in filename.h */

	char IFF_file[C_MAX_SIZ+1];		/* input IFF file */
	char FRT_file[C_MAX_SIZ+1];		/* input FRT file */
	char PAR_file[C_MAX_SIZ+1];		/* parameter file */
	char ARC_name[FILE_NAME_LEN-3];		/* output ARCINFO name */
	char ARCINFO_file[FILE_NAME_LEN+1];	/* output ARCINFO file */

	strdesc (IFF_desc, IFF_file); 

	BOOLEAN	   IFF_is_open = FALSE;
	BOOLEAN	   ARC_is_open = FALSE;
	BOOLEAN	   LAB_is_open = FALSE;
	BOOLEAN	   TXT_is_open = FALSE;
	BOOLEAN	   FSN_is_open = FALSE;
	BOOLEAN	   IAC_is_open = FALSE;
	BOOLEAN	   RAC_is_open = FALSE;
	BOOLEAN	   AAT_is_open = FALSE;
	BOOLEAN	   PAT_is_open = FALSE;

	BOOLEAN	   had_ts      = FALSE;		/* had a TS entry */
	BOOLEAN	   ok 	       = FALSE;		/* function return */
	VMS_STATUS status;			/* function return */

	INT_2 IFF_unit = 1;
	INT_2 entry_code, entry_length, length, npts, ends, start;
	INT_4 rev_level = 0;			/* IFF input revision level */

	char *attname;
	int atype, dtype, ftype, nfeat;
	int len, c, cnt;		/* workspace variables */
	int nexist = 0;   		/* current count of FCs */
	int niac = 0;			/* no. of integer ACs */
	int nrac = 0;			/* no. of real ACs */
	short exist[MAX_FC];		/* 0 for FC not present, else 1 */

   /* initialise the FC exist and symbol arrays */

	for ( fc = 0; fc < MAX_FC; fc++ )
	{
		symbol[fc] = 0;
		exist[fc]  = 0;
	}

   /* initialise LSLLIB */

	LSL_INIT (FALSE);		/* suppress timer output */
	ifferm (FALSE);			/* suppress LSLLIB error messages */

   /* read and decode the command line */

	had_frt = FALSE;
	had_par = FALSE;
	had_tab = FALSE;
	had_log = FALSE;
	had_debug = FALSE;

	ok = read_cmdline ( IFF_file, ARC_name, FRT_file, PAR_file );
	if ( !ok ) 
	{
		LSL_PUTMSG (&I2ARC__CMDLNERR);
		goto end_program;
	}

	if (had_debug) had_log = TRUE;		/* output all info for debug */

   /* and open the input IFF file with input revision level 0 so that CBs 
	appear as ZS's or ST's */

	IFF_desc.length = strlen (IFF_file);

	status = iffopen (&IFF_unit, &IFF_desc, 0, FALSE, &rev_level);

	if ( !( status & STS$M_SUCCESS) )	/* check error opening IFF */
	{
		LSL_PUTMSG (&I2ARC__IFFOPNERR);
		goto end_program;
	}

	if (had_log) printf ("\n Opening IFF file       %s \n", IFF_file);
	IFF_is_open = TRUE;

   /* open FRT file */

	if ( !c_RDFRT(&FRT_file) )
	{
		LSL_PUTMSG (&I2ARC__FRTOPNERR);
		goto end_program;
	}
	getfrt();

	if (had_log) printf ("\n Read FRT file       %s\n", FRT_file);

   /* open parameter file */

	if (had_log) printf ("\n Opening parameter file %s\n", PAR_file);
	if (had_par)
	{ 
	   if ( !c_rdpar(&PAR_file) )
	   {
		LSL_PUTMSG (&I2ARC__PAROPNERR);
		goto end_program;
	   }
	}

   /* process output coverage file name */

	strcpy (ARCINFO_file, ARC_name);	/* build output file name */
	strcat (ARCINFO_file,".e00");  
	fout = fopen (ARCINFO_file,"w"); 

	if ( !fout )
	{
		LSL_PUTMSG (&I2ARC__ARCOPNERR);
		goto end_program;
	}

	ARC_is_open = TRUE;
	if (had_log) printf ("\n Opening ARC/INFO file %s\n\n", ARCINFO_file);

   /* open temporary work files ... */

	flab = fopen("$$lab.tmp","w");
	ftxt = fopen("$$txt.tmp","w");
	ffsn = fopen("$$fsn.tmp","w");

	if (had_tab)
	   {
		faat = fopen("$$aat.tmp","w");
		fpat = fopen("$$pat.tmp","w");
		if ( !flab || !ftxt || !ffsn || !faat || !fpat ) {
			LSL_PUTMSG (&I2ARC__TMPFILERR);
			goto end_program;
		}
		AAT_is_open = TRUE;
		PAT_is_open = TRUE;
	   }
	else
	   {
		fiac = fopen("$$iac.tmp","w");
		frac = fopen("$$rac.tmp","w");
		if ( !flab || !ftxt || !ffsn || !fiac || !frac ) {
			LSL_PUTMSG (&I2ARC__TMPFILERR);
			goto end_program;
		}
		IAC_is_open = TRUE;
		RAC_is_open = TRUE;
	   }

	LAB_is_open = TRUE;
	TXT_is_open = TRUE;
	FSN_is_open = TRUE;

	if (had_log)
	{
		printf (" Opening work files    $$lab.tmp\n");
		printf ("                       $$txt.tmp\n");
		printf ("                       $$fsn.tmp\n");
		if (had_tab) {
			printf ("                       $$aat.tmp\n");
			printf ("                       $$pat.tmp\n");
		   }
		else
		   {
			printf ("                       $$iac.tmp\n");
			printf ("                       $$rac.tmp\n");
		   }

		printf ("\n Now processing the IFF file to ARC/INFO\n\n");
	}

   /* write header info. to files ... */

	fprintf (fout,"EXP  0\nARC  2\n");
	fprintf (flab,"LAB  2\n");
	fprintf (ftxt,"TXT  2\n");

   /* first pass of IFF file builds a list of all the AC codes */

	if (had_tab) {
	   dotables();
	   buildlists();
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

			printf ("%2.2s\n",(char *) &entry_code);
			break;

		case EJ:		/* end of IFF file */

			if (had_debug) printf ("%2.2s\n",(char *) &entry_code);

			goto windup;
			break;

   /* ---- Map level entries ---- */
		
		case MH: case MD:

			printf ("%2.2s\n",(char *) &entry_code);
			break;

 		case EM:

			if (had_debug) printf ("%2.2s\n",(char *) &entry_code);

			break;

   /* ---- Section level entries ---- */

		case NS: case CC:

			printf ("%2.2s\n",(char *) &entry_code);
			break;

		case CP:

			if (had_debug) printf ("%2.2s\n",(char *) &entry_code);

			eihr (&corner,&entry_length,&one);
			break;

   /* ---- Overlay level entries ---- */

		case NO:

			if (had_debug) printf ("%2.2s\n",(char *) &entry_code);

			eihr (&overlay,&entry_length,&one);
			break;

		case EO:

			if (had_debug) printf ("%2.2s\n",(char *) &entry_code);

			break;

   /* ---- Feature level entries ---- */

		case NF:

			eihr (&feature, &entry_length, &one);
			vtot = 0;		/* initialise vertex count */
			had_ts     = FALSE;

			blocknum = 0;

			if (had_debug) printf ("%2.2s %d %d\n", 
				(char *) &entry_code, feature.fsn, feature.isn);

			break;

		case FS:

			if (had_debug) printf ("%2.2s\n",(char *) &entry_code);

			eihr (&fs, &entry_length, &one);

			blocknum = 0;

			fc = fs.fc;			/* store FC */

			ftype = fs.flag.non_text.type;	/* store feature type */

/* defer this until we process the EF */
/*			if (had_tab) {
			   if (ftype==0)
			      { narcs++;
			        if (naat>0) {
			           fprintf(faat,"%11d%11d%11d%11d%14.7E%11d%11d\n",
				       0,0,0,0,0.0,narcs,narcs); }
			      }
			   else if (ftype==1)
			      { nsymb++;
			        if (npat>0) {
			           fprintf(fpat,"%14.7E%14.7E%11d%11d",
				        0.0,0.0,nsymb,nsymb); }
			      }
			 }
			else
			  {
			    if (ftype==0) narcs++;
			    if (ftype==1) nsymb++;
			  }
			nfeat++;
*/
			if ( symbol[fc] == 0 )		/* no FRT entry */
			{
				LSL_PUTMSG (&I2ARC__NOFRTENTRY, &fc);
				goto end_program;
			}

			if ( !exist[fc] )
			{
				exist[fc] = 1;  /* signal the FCs existance */
				nexist++;	/* and count them */
			}
			break;
	
		case ST:

			eihrs (&npts,&ends);	/* get info on line string */

			if (had_debug)
			{
				if (iffhan.orvlev == 0) 
				      printf ("ST %d %d\n", npts, ends);
				if (iffhan.orvlev == 1) 
				      printf ("CB %d %d as ST\n", npts, ends);
			}

			if ( ends & PEN_DOWN ) 	/* continuation of prev ST */
			{			/* try to add to vertex list */

   /* if there are too many coordinates to fit the buffer, output the old: */

				if ( vtot+npts > MAX_VERTICES )
				{
					output();

   /* and start another, last point of old coord block becoming 1st point of */
   /* new, both blocks on output, st_out(), have the same internal id number */

					vertex[0].x = vertex[vtot-1].x;
					vertex[0].y = vertex[vtot-1].y;
					vtot = 1;
				}
				else
					;	/* OK */
			}
			else		/* pen up - new coord string:	 */
					/* new feature - diff id 	 */
					/* or invis line break - same id */

   /* output the old coordinate buffer, and initialise a new one */

			{
				output();
				vtot = 0;
			}

   /* can now read in coordinates into vertex buffer */

			length = 2 * npts;	/* no. of reals to read */
			eihrr (vertex+vtot, &length, &one);
			vtot += npts;
			break;

   /* for ZS entries, use the x,y as in ST entries, and ignore the z */

		case ZS:

			eihrs (&npts,&ends);	/* get info on line string */

			if (had_debug) 
			{
				if (iffhan.orvlev == 0) 
				      printf ("ZS %d %d\n", npts, ends);
				if (iffhan.orvlev == 1) 
				      printf ("CB %d %d as ZS\n", npts, ends);
			}

			if ( ends & PEN_DOWN ) 	/* continuation of prev ZS */
			{			/* try to add to vertex list */

   /* if there are too many coordinates to fit the buffer, output the old: */

				if ( vtot+npts > MAX_VERTICES )
				{
					output();

   /* and start another, last point of old coord block becoming 1st point of */
   /* new, both blocks on output, st_out(), have the same internal id number */

					vertex[0].x = vertex[vtot-1].x;
					vertex[0].y = vertex[vtot-1].y;
					vtot = 1;
				}
				else
					;	/* OK */
			}

			else		/* pen up - new coord string:	 */
					/* new feature - diff id 	 */
					/* or invis line break - same id */
			{

   /* output the old coordinate buffer, and initialise a new one */

				output();
				vtot = 0;
			}

   /* can now read in coordinates into vertex buffer */

			for ( cnt = 0; cnt < npts; cnt++ )
			{
				start = 6*cnt + 1;	/* skip z coords */
				eihrr (vertex+cnt+vtot, &two, &start);
			}

			vtot += npts;
			break;

		case CB: 	/* converted into ST/ZS entry */

			if (had_debug) printf ("%2.2s\n",(char *) &entry_code);

			break;

		case AC:
        		
			if (had_debug) printf ("%2.2s\n",(char *) &entry_code);

			for (i=0;i<256;i++) ac.text[i]=NULL;

			eihr (&ac, &entry_length, &one);

			if (had_tab) {
			   atype = ac.type;
			   if (ftype==0 && naat>0)
			      { alist = addattval(alist,atype,ac.value.integer,
					       ac.value.real,ac.text); }
			   else if (ftype==1 && npat>0)
			      { plist = addattval(plist,atype,ac.value.integer,
					       ac.value.real,ac.text); }
			   }
			else {
			   if ( is_real_ac(&ac.type) )	/* real */
			      {
				fprintf (frac,"%11d%11d%14.7E%s\n",
					id,ac.type,ac.value.real,ac.text);
                		nrac++;
				ac.text[0] = NULL;	/* empty for next AC  */
							/* - text is optional */
			      }
			   else				/* should be integer */
			      {
				fprintf (fiac,"%11d%11d%11d%s\n",
					id,ac.type,ac.value.integer,ac.text);
		                niac++;
				ac.text[0] = NULL;	/* empty for next AC  */
							/* - text is optional */
        		      }
			   }
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
   /* are output as a string of separate text features. (The ARC/INFO TXT */
   /* section does not contain any internal ID number to have been able   */
   /* to indicate which feature the text components belonged to anyway).  */


			if (!had_ts)		/* reflect first TS only */
			{
				if (!had_debug) printf 
					("%2.2s\n",(char *) &entry_code);
			}
			else
			{
				output();		/* output coords */
				vtot = 0;		/*   as for EF   */

			        fprintf (ffsn, "%11d%11d%11d%11d\n",
					id,feature.fsn,fc,overlay.number);
        			id++;

			}
			had_ts = TRUE;
			break;

		case EF:

			if (had_debug) printf ("%2.2s\n",(char *) &entry_code);

			output();			/* output coords */
			vtot = 0;
			had_ts = FALSE;
			for (i=0;i<blocknum;i++) {
			  fprintf (ffsn,"%11d%11d%11d%11d\n",
				   id, feature.fsn, fc, overlay.number);
			  id++;

			  if (ftype==0) narcs++;
			  if (ftype==1) nsymb++;

			  if (had_tab) {
			    if (ftype==0 && naat>0)
			      {
				fprintf(faat,
					"%11d%11d%11d%11d%14.7E%11d%11d\n",
					0,0,0,0,0.0,narcs,narcs);
				writelist(alist,ftype);
			      }
			    else if (ftype==1 && npat>0 )
			      {
				fprintf(fpat,"%14.7E%14.7E%11d%11d",
				        0.0,0.0,nsymb,nsymb);
				writelist(plist,ftype);
			      }
			  }
			  nfeat++;
			}
			if (had_tab) {
			  if (ftype==0 && naat>0)
			      { freelist(alist); }
			  else if (ftype==1 && npat>0 )
			      { freelist(plist); }
			}
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

   /* close the IFF file, and output all the data */

windup:
	if (IFF_is_open) 
	{
		iffclo (&IFF_unit);			/* close IFF file */
		if (had_log) 
			printf ("\n Closing IFF file      %s\n", IFF_file);
		IFF_is_open = FALSE;
	}

   /* wind up work and output files */

	fprintf(fout,"%10d%10d%10d%10d%10d%10d%10d\n",
			-1,0,0,0,0,0,0);	/* terminate output data */

	fprintf(flab,"%10d%10d%14.7E%14.7E\n",-1,0,0.0,0.0);
	fprintf(ftxt,"%10d%10d%10d%10d%10d%10d%10d\n",-1,0,0,0,0,0,0);

   /* rewind work files, copy to output, then delete */

	rewind (flab);
	while ( (c=getc(flab)) !=EOF )
		putc (c,fout);
	fclose (flab);
	LAB_is_open = FALSE;
	remove ("$$lab.tmp;0");

	if (had_log) printf ("\n Removing work file    $$lab.tmp \n");

	rewind (ftxt);
	while ( (c=getc(ftxt)) !=EOF )
		putc (c,fout);
	fclose (ftxt);
	TXT_is_open = FALSE;
	remove ("$$txt.tmp;0");

	if (had_log) printf ("\n Removing work file    $$txt.tmp \n");


   /* add INFO data tables: first the RAnge */

	fprintf (fout,"IFO  2\n%s.BND%-*s",ARC_name,
						28-strlen(ARC_name)," ");
	fprintf (fout,"XX%4d%4d%4d%10d\n",4,4,16,1);
	fprintf (fout,"XMIN%14s4-1   14-1  12 3 60-1  -1  -1-1%20d\n"," ",1);
	fprintf (fout,"YMIN%14s4-1   54-1  12 3 60-1  -1  -1-1%20d\n"," ",2);
	fprintf (fout,"XMAX%14s4-1   94-1  12 3 60-1  -1  -1-1%20d\n"," ",3);
	fprintf (fout,"YMAX%14s4-1  134-1  12 3 60-1  -1  -1-1%20d\n"," ",4);
	fprintf (fout,"%14.7E%14.7E%14.7E%14.7E\n",
				range.xmin,range.ymin,range.xmax,range.ymax);

   /* then the corner point CP entries */

	fprintf (fout,"%s.TIC%-*s",ARC_name, 28-strlen(ARC_name)," ");
	fprintf (fout,"XX%4d%4d%4d%10d\n",3,3,12,4);
	fprintf (fout,"IDTIC%13s4-1   14-1   5 0 50-1  -1  -1-1%20d\n"," ",1);
	fprintf (fout,"XTIC%14s4-1   54-1  12 3 60-1  -1  -1-1%20d\n"," ",2);
	fprintf (fout,"YTIC%14s4-1   94-1  12 3 60-1  -1  -1-1%20d\n"," ",3);
	fprintf (fout,"%11d%14.7E%14.7E\n",1,corner.xnwout,corner.ynwout);
	fprintf (fout,"%11d%14.7E%14.7E\n",2,corner.xswout,corner.yswout);
	fprintf (fout,"%11d%14.7E%14.7E\n",3,corner.xseout,corner.yseout);
	fprintf (fout,"%11d%14.7E%14.7E\n",4,corner.xneout,corner.yneout);

   /* the ID / FSN / FC / Layer cross reference table */

	fprintf (fout,"%s.FSN%-*s",ARC_name, 28-strlen(ARC_name)," ");
	fprintf (fout,"XX%4d%4d%4d%10d\n",4,4,16,id-1);
	fprintf (fout,"%s-ID%-*s4-1   14-1   5-1 50-1  -1  -1-1%20d\n",
			ARC_name,15-strlen(ARC_name)," ",1);
	fprintf (fout,"FSN%15s4-1   54-1   5-1 50-1  -1  -1-1%20d\n"," ",2);
	fprintf (fout,"FC%16s4-1   94-1   5-1 50-1  -1  -1-1%20d\n"," ",3);
	fprintf (fout,"LAYER%13s4-1  134-1   5-1 50-1  -1  -1-1%20d\n"," ",4);

	rewind (ffsn);
	while ( (c = getc (ffsn)) != EOF)   /* add FSN info from $$FSN.TMP */
		putc (c,fout);
	fclose (ffsn);
	FSN_is_open = FALSE;
	remove ("$$fsn.tmp;");

	if (had_log) printf ("\n Removing work file    $$fsn.tmp \n");

   /* the FC to unique SYMBOL reference table */

	fprintf (fout,"%s.LUT%-*s",ARC_name,30-strlen(ARC_name)," ");
	fprintf (fout,"%4d%4d%4d%10d\n",2,2,8,nexist);
	fprintf (fout,"FC%16s4-1   14-1   5-1 50-1  -1  -1-1%20d\n"," ",1);
	fprintf (fout,"SYMBOL%12s4-1   54-1   5-1 50-1  -1  -1-1%20d\n"," ",2);

	for ( fc = 0; fc<MAX_FC; fc++)
		if ( exist[fc] )
			fprintf (fout,"%11d%11d\n",fc,symbol[fc]);

   /* write .IAC and .RAC or the .AAT and .PAT */

	if (!had_tab) {

   /* the integer AC values from $$IAC.TMP */

	fprintf (fout,"%s.IAC%-*s",ARC_name, 30-strlen(ARC_name)," ");
	fprintf (fout,"%4d%4d%4d%10d\n",4,4,52,niac);
	fprintf (fout,"%s-ID%-*s4-1   14-1   5-1 50-1  -1  -1-1%20d\n",
					ARC_name,15-strlen(ARC_name)," ",1);
	fprintf (fout,"TYPE%14s4-1   54-1   5-1 50-1  -1  -1-1%20d\n"," ",2);
	fprintf (fout,"VALUE%13s4-1   94-1   5-1 50-1  -1  -1-1%20d\n"," ",3);
	fprintf (fout,"TEXT%13s40-1  134-1  40-1 20-1  -1  -1-1%20d\n"," ",4);

	rewind (fiac);
	while ( (c = getc (fiac)) != EOF)
		putc (c,fout);
	fclose (fiac);
	IAC_is_open = FALSE;
	remove ("$$iac.tmp;");

	if (had_log) printf ("\n Removing work file    $$iac.tmp \n");

   /* the real AC values from $$RAC.TMP */

	fprintf (fout,"%s.RAC%-*s",ARC_name, 30-strlen(ARC_name)," ");
	fprintf (fout,"%4d%4d%4d%10d\n",4,4,52,nrac);
	fprintf (fout,"%s-ID%-*s4-1   14-1   5-1 50-1  -1  -1-1%20d\n",
			ARC_name,15-strlen(ARC_name)," ",1);
	fprintf (fout,"TYPE%14s4-1   54-1   5-1 50-1  -1  -1-1%20d\n"," ",2);
	fprintf (fout,"VALUE%13s4-1   94-1  12 4 60-1  -1  -1-1%20d\n"," ",3);
	fprintf (fout,"TEXT%13s40-1  134-1  40-1 20-1  -1  -1-1%20d\n"," ",4);

	rewind (frac);
	while ( (c = getc (frac)) != EOF)
		putc (c,fout);
	fclose (frac);
	RAC_is_open = FALSE;
	remove ("$$rac.tmp;");

	if (had_log) printf ("\n Removing work file    $$rac.tmp \n");

	}
	else		/* write .AAT and .PAT tables */
	{

   /* write 7 standard AAT attributes */

	 if (naat>0) {
	    fprintf (fout,"%s.AAT%-*s",ARC_name, 28-strlen(ARC_name)," ");
	    fprintf (fout,"XX%4d%4d%4d%10d\n",7+naat,7+naat,aat_count,narcs);
	    fprintf (fout,"FNODE#%12s4-1   14-1   5 0 50-1  -1  -1-1%20d\n"," ",1);
	    fprintf (fout,"TNODE#%12s4-1   54-1   5 0 50-1  -1  -1-1%20d\n"," ",2);
	    fprintf (fout,"LPOLY#%12s4-1   94-1   5 0 50-1  -1  -1-1%20d\n"," ",3);
	    fprintf (fout,"RPOLY#%12s4-1  134-1   5 0 50-1  -1  -1-1%20d\n"," ",4);
	    fprintf (fout,"LENGTH%12s4-1  174-1  12 3 60-1  -1  -1-1%20d\n"," ",5);
	    fprintf (fout,"%s#%-*s4-1  214-1   5 0 50-1  -1  -1-1%20d\n",
					    ARC_name,17-strlen(ARC_name)," ",6);
	    fprintf (fout,"%s-ID%-*s4-1  254-1   5 0 50-1  -1  -1-1%20d\n",
					    ARC_name,15-strlen(ARC_name)," ",7);

   /* write additional arc attributes */

	    rewind (faat);
	    while ( (c = getc (faat)) != EOF)
		   putc (c,fout);
	  }
   /* write 4 standard PAT attributes */
	 if (npat>0) {
	    fprintf (fout,"%s.PAT%-*s",ARC_name, 28-strlen(ARC_name)," ");
	    fprintf (fout,"XX%4d%4d%4d%10d\n",4+npat,4+npat,pat_count,nsymb);
	    fprintf (fout,"AREA%14s4-1   14-1  12 3 60-1  -1  -1-1%20d\n"," ",1);
	    fprintf (fout,"PERIMETER%9s4-1   54-1  12 3 60-1  -1  -1-1%20d\n"," ",2);
	    fprintf (fout,"%s#%-*s4-1   94-1   5 0 50-1  -1  -1-1%20d\n",
					  ARC_name,17-strlen(ARC_name)," ",3);
	    fprintf (fout,"%s-ID%-*s4-1  134-1   5 0 50-1  -1  -1-1%20d\n",
					  ARC_name,15-strlen(ARC_name)," ",4);

   /* write additional point attributes */

	    rewind (fpat);
	    while ( (c = getc (fpat)) != EOF)
	            putc (c,fout);
	  }

	  fclose (faat);
	  AAT_is_open = FALSE;
	  remove ("$$aat.tmp;");

	  if (had_log) printf ("\n Removing work file    $$aat.tmp \n");

	  fclose (fpat);
	  PAT_is_open = FALSE;
	  remove ("$$pat.tmp;");

	  if (had_log) printf ("\n Removing work file    $$pat.tmp \n");
	}

	fprintf (fout,"EOI\nEOS\n");

	fclose (fout);
	ARC_is_open = FALSE;
	if (had_log) printf ("\n Closing ARC/INFO file %s\n\n", ARCINFO_file);

	LSL_PUTMSG (&I2ARC__NORMAL);
	goto exit;

end_program:				/* abnormal exit */

	if (ARC_is_open)
	{
		fclose (fout);
		if (had_log) printf 
			("\n Closing ARC/INFO file %s\n", ARCINFO_file);
	}

	if (IFF_is_open)
	{
		iffclo (&IFF_unit);
		if (had_log) printf ("\n Closing IFF file      %s\n\n", IFF_file);
	}

	if (LAB_is_open) fclose (flab);
	if (TXT_is_open) fclose (ftxt);
	if (FSN_is_open) fclose (ffsn);
	if (IAC_is_open) fclose (fiac);
	if (RAC_is_open) fclose (frac);
	if (AAT_is_open) fclose (faat);
	if (PAT_is_open) fclose (fpat);

	if ( !had_debug )		/* leave files for debugging */
	{
		remove ("$$lab.tmp;");
		remove ("$$txt.tmp;");
		remove ("$$fsn.tmp;");
		if (had_tab) {
		   remove ("$$aat.tmp;");
		   remove ("$$pat.tmp;");
		   }
		else {
		   remove ("$$iac.tmp;");
		   remove ("$$rac.tmp;");
		   }

		if (had_log)
		{
			printf (" Removing work files   $$lab.tmp\n");
			printf ("                       $$txt.tmp\n");
			printf ("                       $$fsn.tmp\n");
			if (had_tab) {
			   printf ("                       $$aat.tmp\n");
			   printf ("                       $$pat.tmp\n\n");
			   }
			else {
			   printf ("                       $$iac.tmp\n");
			   printf ("                       $$rac.tmp\n\n");
			   }
		}
	}
	else
	{
		printf (" Closing work files    $$lab.tmp\n");
		printf ("                       $$txt.tmp\n");
	        printf ("                       $$fsn.tmp\n");
		if (had_tab) {
		   printf ("                       $$aat.tmp\n");
		   printf ("                       $$pat.tmp\n\n");
		   }
		else {
		   printf ("                       $$iac.tmp\n");
		   printf ("                       $$rac.tmp\n\n");
		   }
	}

exit:

	LSL_EXIT();
}

/************************************************************************/
/*									*/
/*			output()					*/
/*									*/
/* 	Routine to output the coordinate information			*/
/*									*/
/************************************************************************/

int output()
{
    double sz, xs, ys, xe, ye, xi, yi; 
    int txlen;
    double a, b, c, d, e, f, g;

    if ( vtot > 0 )		/* if we have some to output */
    {
	switch ( gtype[fc] )	/* branch on GT */
	{
	case LINEAR :		/* GT 1  */
	case SYM_STRING :	/* GT 11 */
	case FILL_AREA :	/* GT 12 - treat as closed linear feature    */
	case INTERP_CURVE :	/* GT 6  - treat as linear feature (for now) */

		st_out();
		break;

	case UNORIEN_SYMBOL :	/* GT 7 - Arc/Info can't cope with oriented   */
	case ORIEN_SYMBOL :	/* GT 8 - or scaled symbols: ignore any RO    */
	case SCAL_SYMBOL :	/* GT 9 - or 2nd point defining size & orient */

                fprintf (flab,"%10d%10d%14.7E%14.7E\n",
						nsymb+1,nsymb+1,vertex[0].x,
			                        vertex[0].y);
		blocknum = 1;
                fprintf (flab,"%14.7E%14.7E%14.7E%14.7E\n",
			     vertex[0].x,vertex[0].y,vertex[0].x,vertex[0].y);
		break;

	case TEXT :		/* GT 10 - can cope with rotated text, and */
				/*   curved as TS text component strings   */
 
		txlen = strlen(text);
		xs = vertex[0].x; ys = vertex[0].y;

 		if ( size[fc] >= 0.0 )		/* use FRT value by default */
 			sz = size[fc];
 		else				/* convert point size to mm. */
 			sz = thick * 0.2 - 0.025;	/* rule of thumb */

		/* for CJ to have the program output heights */
		/* as they are in the IFF file use: */
		/* sz = thick; */

		xe = xs + txlen * sz * cos(rot);
		ye = ys + txlen * sz * sin(rot);

		fprintf (ftxt,"%10d%10d%10d%10d%10d\n",
				(overlay.number+1),2,0,symbol[fc],txlen);
                fprintf (ftxt,"%14.7E%14.7E%14.7E%14.7E%14.7E\n",
						xs,xe,0.0,0.0,ys);
		fprintf (ftxt,"%14.7E%14.7E%14.7E%14.7E%14.7E\n",
						ye,xe,0.0,0.0,ys);
                fprintf (ftxt,"%14.7E%14.7E%14.7E%14.7E%14.7E\n",
						0.0,0.0,0.0,0.0,sz);
		fprintf (ftxt,"%14.7E\n%s\n", -100.0,text);
		break;


	case CW_ARC :			/* GT 2 - expand into linear feature */

		arc_to_lin(1);
		st_out();
		break;


	case ACW_ARC :			/* GT 3 - expand into linear feature */

		arc_to_lin(-1);
		st_out();
		break;


	case CIRCUM_CIRCLE :		/* GT 5 - expand into linear feature */

		xs = vertex[0].x; ys = vertex[0].y;
		xi = vertex[1].x; yi = vertex[1].y;
		xe = vertex[2].x; ye = vertex[2].y;

   /* compute centre and replace intermediate point */

		a = 2.0*(xs-xi); b = 2.0*(ys-yi); c=ys*ys-yi*yi+xs*xs-xi*xi;
		d = 2.0*(xe-xi); e = 2.0*(ye-yi); f=ye*ye-yi*yi+xe*xe-xi*xi;
		g = d*b - a*e;

		vertex[1].x = (b*f - c*e)/g; vertex[1].y = (c*d - a*f)/g;

		vertex[2].x = xs; vertex[2].y = ys;  /* end at starting point */

		arc_to_lin(1);
		st_out();
		break;


	case CIRCUM_CIRC_ARC :		/* GT 4 - expand into linear feature */

		xs = vertex[0].x; ys = vertex[0].y;
		xi = vertex[1].x; yi = vertex[1].y;
		xe = vertex[2].x; ye = vertex[2].y;

   /* compute centre and replace intermediate point ... */

		a = 2.0*(xs-xi); b = 2.0*(ys-yi); c=ys*ys-yi*yi+xs*xs-xi*xi;
		d = 2.0*(xe-xi); e = 2.0*(ye-yi); f=ye*ye-yi*yi+xe*xe-xi*xi;
		g = d*b - a*e;

		vertex[1].x = (b*f - c*e)/g; vertex[1].y = (c*d - a*f)/g;

			/* determine direction of arc */

		if ( xi*(ys-ye)-yi*(xs-xe)+xs*ye-xe*ys > 0 ) /* simple Pythag */
			arc_to_lin(1);
		else
			arc_to_lin(-1);

		st_out();
		break;


	default :

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

	xs = vertex[0].x; ys = vertex[0].y;
	xc = vertex[1].x; yc = vertex[1].y;
	xe = vertex[2].x; ye = vertex[2].y;

   /* radius assumed to be distance from 1st to 2nd ST entry */ 

	r = sqrt( sqr(xs - xc) + sqr(ys - yc) );

	thetas = atan2((ys-yc),(xs-xc));	/* starting angle */
	if ( thetas < 0.0 )			/* make positive */
		thetas += 2.0 * PI;

	thetae = atan2((ye-yc),(xe-xc));	/* ending angle */

	if ( thetae < 0.0 )			/* make positive */
		thetae += 2.0 * PI;

	dtheta = sqrt(0.08 / r);		/* another rule of thumb! */
/*
printf("r=%f dtheta=%f\n",r,dtheta);
*/
	vertex[0].x = xs; vertex[0].y = ys;	/* keep first point */

	if ( dir > 0 )				/* clockwise case */
	{
		if ( thetae >= thetas ) 	/* start must be > end angle! */
			thetas += 2.0 * PI;

		for(vtot=1,theta=thetas-dtheta;theta>thetae;theta-=dtheta,vtot++)
		{
			vertex[vtot].x = xc + r * cos(theta);
			vertex[vtot].y = yc + r * sin(theta);
		}
	}
	else
	{
		if ( thetas >= thetae ) 	/* start must be < end angle! */
			thetae += 2.0 * PI;

		for(vtot=1,theta=thetas+dtheta;theta<thetae;theta+=dtheta,vtot++)
		{
			vertex[vtot].x = xc + r * cos(theta);
			vertex[vtot].y = yc + r * sin(theta);
		}
	}

   /* add last vertex. NOTE: not necessarily same as 3rd ST entry */

	vertex[vtot].x = xc + r * cos(thetae);
	vertex[vtot].y = yc + r * sin(thetae);
	vtot++;

	return(1);

}


/************************************************************************/
/*									*/
/*			st_out()					*/
/*									*/
/* 	Routine to output the linear coordinate information		*/
/*	in MAX_ARCINFO_VERTICES sections 				*/
/*									*/
/************************************************************************/

int st_out()
{
	int v, vs, ve, num;

/*	num = narcs;
	num = num + blocknum;
*/
	for(vs=0;vs<vtot;vs+=MAX_ARCINFO_VERTICES-1)
	{
		ve = min(vs+MAX_ARCINFO_VERTICES,vtot) - 1;

		blocknum++;
		num = narcs + blocknum;

   /* output header info for this chunk */

		fprintf (fout,"%10d%10d%10d%10d%10d%10d%10d\n",
						num,num,0,0,0,0,ve-vs+1);

		for (v=vs;v<ve;v+=2)		/* o/p coords in pairs ... */
		fprintf (fout,"%14.7E%14.7E%14.7E%14.7E\n",
			vertex[v].x,vertex[v].y,vertex[v+1].x,vertex[v+1].y);

		if ( v == ve  )	/* ... and last coord seperately if odd vtot */
        		fprintf(fout,"%14.7E%14.7E\n",vertex[v].x,vertex[v].y);
	}

	return(1);
}
