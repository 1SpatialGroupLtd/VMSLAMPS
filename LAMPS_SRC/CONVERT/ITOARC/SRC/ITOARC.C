/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1989-05-19 15:22:00.000000000 +0100
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
/* 

 	Laser-Scan IFF to ARC/Info export format conversion program.
	------------------------------------------------------------

	Usage:

		ITOARC <IFF file> <FRT file> <export file>

	The coverage export file generated contains the following information :

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
*/

	    
#include <stdio.h>
#include <math.h>
#include "cbc.h"		/* GJR's versions of C header files */
#include "iffhan.h"
#include "iff.h"

#define MAX_VERTICES 		10000	/* just be safe! */
#define MAX_ARCINFO_VERTICES 	500	/* pretty low huh ? */

#define PI 3.14159265
#define sqr(a) ((a)*(a))
#define min(a,b) ((a)<(b)?(a):(b))

/* working variables etc. */

RANGE	range;
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

int gtype[2000], colour[2000], sc[2000], symbol[2000];	/* FRT info. */
double width[2000], size[2000];

int       id=1;		/* current ID number of feature ( used to relate
			   FSN, FC, layer no. etc. between coords & DB info */
short int fc;		/* current fc */
int       vtot;		/* accum. vertices in ST entries */

FILE *fout, *ffrt, *flab, *ftxt, *ffsn, *fiac, *frac;	/* loadsa work files! */

/******************************************************************************/

main(argc,argv)		/* main routine */
int argc;
char *argv[];
{
	int iff_unit=1;
	short entry_code, entry_length; short length;
	short npts, ends;
	
	VARCHAR iffname, frtname, ghost;

	char out_file[40], frt_name[40];

	int len; int c;

	int exist[2000];	/* 0 : FC not present, else 1 */

	int niac=0, nrac=0, nexist=0;   /* current count of records */

	if ( argc < 4 )	/* check # args */
	{
		printf(
		"??? Usage: ITOARC <IFF file> <FRT file> <coverage>\n");
		exit(1);
	};

	/* set up defaults for input file names */

	iffname.text = argv[1];
	iffname.len  = strlen(iffname.text);

	if ( strcspn(argv[2],":") == strlen(argv[2]) )	/* prepend logical dir */
	{
		strcpy(frt_name,"LSL$FRT:");
		strcat(frt_name,argv[2]);
	};

	if ( strcspn(frt_name,".") == strlen(frt_name) )	/* append file ext. */
		strcat(frt_name,".FRT");

	frtname.text = frt_name;
	frtname.len  = strlen(frtname.text);

	lsl_init(&zero);	/* suppress timer output */

	ifferm(&zero);	/* suppress LSLLIB error messages */
	
	iffopn(&iff_unit,&iffname,&i_zero,&i_zero,&ghost,&i_zero);

	if ( iffhan.iercd != 0 )
	{
		printf("Couldn't open IFF file\n");
		exit(1);
	};

/* ******* don't use LSL FRT handler at present 

	if ( frtini(&frtname) != 0 )
	{
		printf("Couldn't open FRT file\n");
		exit(1);
	};

 ********** */

	if ( !(ffrt = fopen(frt_name,"r")) )	/* open FRT file ... */
	{
		printf("!!! ITOARC : Couldn't open FRT file %s\n",frt_name);
		exit(1);
	}
	else
		getfrt();	/* ... and read in FRT info. */

	/* process coverage name */

	len = strcspn(argv[3],".");    /* check for poss. file ext. */
	argv[3][len] = '\0';        /* ... and remove, if present */
	strcpy(out_file,argv[3]);    /* build output file name */
	strcat(out_file,".e00");
	fout = fopen(out_file,"w");

	/* open temporary work files ... */

	flab = fopen("$$lab.tmp","w");
	ftxt = fopen("$$txt.tmp","w");
	ffsn = fopen("$$fsn.tmp","w");
	fiac = fopen("$$iac.tmp","w");
	frac = fopen("$$rac.tmp","w");

	/* ... & check success */

	if ( !fout || !flab || !ftxt || !ffsn || !fiac || !frac )
	{
	printf("!!! ITOARC : Couldn't create work files\n");
		exit(1);
	};

	/* write header info. to files ... */

	fprintf(fout,"EXP  0\nARC  2\n");
	fprintf(flab,"LAB  2\n");
	fprintf(ftxt,"TXT  2\n");

	/* ... and start converting input file ... */


/******************************  main loop *********************************/


	while(entry_code != -1)		/* retrieve entries sequentially */
	{
		iffnxt(&entry_code,&entry_length);

		switch ( entry_code )	/* do the business, (echo if not used) */
		{	
		/* ---- File level entries ---- */

		case RA:

			eihr(&range,&entry_length,&one);
			break;

		case HI: case SH:

			printf("%2.2s\n",(char *) &entry_code);
			break;

		case EJ:

			goto windup;	/* that's all folks! */
			break;

		/* ---- Map level entries ---- */

		case MH: case MD:

			printf("%2.2s\n",(char *) &entry_code);
			break;

 		case EM:

			break;

		/* ---- Section level entries ---- */

		case NS: case CC:

			printf("%2.2s\n",(char *) &entry_code);
			break;

		case CP:

			eihr(&corner,&entry_length,&one);
			break;

		/* ---- Overlay level entries ---- */

		case NO:

			eihr(&overlay,&entry_length,&one);
			break;

		case EO:

			break;

		/* ---- Feature level entries ---- */

		case NF:

			eihr(&feature,&entry_length,&one);
			vtot = 0;
			break;

		case FS:

			eihr(&fs,&entry_length,&one);
			fc = fs.fc;

			if ( !exist[fc] )
			{
				exist[fc] = 1;
				nexist++;
			};

			break;
	
		case ST:

			eihrs(&npts,&ends);	/* get info on line string */
			length = 2 * npts;

			if ( ends & PEN_DOWN ) /* continuation of prev ST */
			{
				/* try to add to verts list */

				if ( vtot+npts > MAX_VERTICES )
				{
					/* coord buffer will be exceeded ... */

					output(); /* so o/p part feature ... */

					/* ... and start anew */

					/* ... last pt. becomes new 1st pt. */
					vertex[0].x = vertex[vtot-1].x;
					vertex[0].y = vertex[vtot-1].y;
					vtot = 1;
				}
				else
					;	/* OK */
			}
			else	/* multi-string feature, so split */
			{
				output();
				vtot = 0;
			};

			/* ... can now read in coords ! */

			eihrr(vertex+vtot,&length,&one);
			vtot += npts;
			break;

		case ZS: case CB:	/* can't transfer complex stuff yet! */

			printf("%2.2s\n",(char *) &entry_code);
			break;

		case AC:
        		
			eihr(&ac,&entry_length,&one);
			
			if ( is_real_ac(&ac.type) )	/* real */
      			{
				fprintf(frac,"%11d%11d%14.7E%s\n",
					id,ac.type,ac.value.real,ac.text);
                		nrac++;
			}
			else	/* should be integer */
			{
				fprintf(fiac,"%11d%11d%11d%s\n",
					id,ac.type,ac.value.integer,ac.text);
		                niac++;
        		};
			break;

		case TH:

			eihr(&thick,&entry_length,&one);
			break;

		case RO:

			eihr(&rot,&entry_length,&one);
			break;

		case TX:

			eihr((short int *)text,&entry_length,&one);

			/* NB. returned text is NOT null terminated, so ... */

			text[entry_length*2] = '\0'; 
			break;

		case EF:

			output();	/* output coords */
		        fprintf(ffsn,"%11d%11d%11d%11d\n",
				id,feature.fsn,fc,overlay.number);
        		id++;
			break;

		/* ---- ( obsolete entries ) ---- */

	case TC: case CH: case CS: case SS: case SL:

			printf("(%2.2s)\n",(char *) &entry_code);
			break;

		/* ----Other entries ---- */

        case VO: case JB: default:	

			printf("%2.2s\n",(char *) &entry_code);
			break;
		};
	};


/*****************************  End of main loop  *****************************/

windup:

	iffclo(&one);	/* close IFF file */

	/* wind up work and output files */

	fprintf(fout,"%10d%10d%10d%10d%10d%10d%10d\n",
			-1,0,0,0,0,0,0);	/* terminate output data */

	fprintf(flab,"%10d%10d%14.7E%14.7E\n",-1,0,0.0,0.0);
	fprintf(ftxt,"%10d%10d%10d%10d%10d%10d%10d\n",-1,0,0,0,0,0,0);

	/* rewind work files, copy to output, then delete */

	rewind(flab);
	while( (c=getc(flab)) !=EOF )
		putc(c,fout);
	fclose(flab);
	delete("$$lab.tmp;0");

	rewind(ftxt);
	while( (c=getc(ftxt)) !=EOF )
		putc(c,fout);
	fclose(ftxt);
	delete("$$txt.tmp;0");

	rewind(ffsn);
	rewind(fiac);
	rewind(frac);

	/* add INFO data tables */

	fprintf(fout,"IFO  2\n%s.BND%-*s",argv[3],28-strlen(argv[3])," ");
	fprintf(fout,"XX%4d%4d%4d%10d\n",4,4,16,1);
	fprintf(fout,"XMIN%14s4-1   14-1  12 3 60-1  -1  -1-1%20d\n"," ",1);
	fprintf(fout,"YMIN%14s4-1   54-1  12 3 60-1  -1  -1-1%20d\n"," ",2);
	fprintf(fout,"XMAX%14s4-1   94-1  12 3 60-1  -1  -1-1%20d\n"," ",3);
	fprintf(fout,"YMAX%14s4-1  134-1  12 3 60-1  -1  -1-1%20d\n"," ",4);
	fprintf(fout,"%14.7E%14.7E%14.7E%14.7E\n",
				range.xmin,range.ymin,range.xmax,range.ymax);

	fprintf(fout,"%s.TIC%-*s",argv[3],28-strlen(argv[3])," ");
	fprintf(fout,"XX%4d%4d%4d%10d\n",3,3,12,4);
	fprintf(fout,"IDTIC%13s4-1   14-1   5-1 50-1  -1  -1-1%20d\n"," ",1);
	fprintf(fout,"XTIC%14s4-1   54-1  12 3 60-1  -1  -1-1%20d\n"," ",2);
	fprintf(fout,"YTIC%14s4-1   94-1  12 3 60-1  -1  -1-1%20d\n"," ",3);
	fprintf(fout,"%11d%14.7E%14.7E\n",1,corner.xnwout,corner.ynwout);
	fprintf(fout,"%11d%14.7E%14.7E\n",2,corner.xswout,corner.yswout);
	fprintf(fout,"%11d%14.7E%14.7E\n",3,corner.xseout,corner.yseout);
	fprintf(fout,"%11d%14.7E%14.7E\n",4,corner.xneout,corner.yneout);

	fprintf(fout,"%s.FSN%-*s",argv[3],28-strlen(argv[3])," ");
	fprintf(fout,"XX%4d%4d%4d%10d\n",4,4,16,id-1);
	fprintf(fout,"%s-ID%-*s4-1   14-1   5-1 50-1  -1  -1-1%20d\n",
					argv[3],15-strlen(argv[3])," ",1);
	fprintf(fout,"FSN%15s4-1   54-1   5-1 50-1  -1  -1-1%20d\n"," ",2);
	fprintf(fout,"FC%16s4-1   94-1   5-1 50-1  -1  -1-1%20d\n"," ",3);
	fprintf(fout,"LAYER%13s4-1  134-1   5-1 50-1  -1  -1-1%20d\n"," ",4);

	/* add FSN info */

	while( (c=getc(ffsn))!=EOF)
		putc(c,fout);
	fclose(ffsn);
	delete("$$fsn.tmp;");

	fprintf(fout,"%s.IAC%-*s",argv[3],30-strlen(argv[3])," ");
	fprintf(fout,"%4d%4d%4d%10d\n",4,4,52,niac);
	fprintf(fout,"%s-ID%-*s4-1   14-1   5-1 50-1  -1  -1-1%20d\n",
					argv[3],15-strlen(argv[3])," ",1);
	fprintf(fout,"TYPE%14s4-1   54-1   5-1 50-1  -1  -1-1%20d\n"," ",2);
	fprintf(fout,"VALUE%13s4-1   94-1   5-1 50-1  -1  -1-1%20d\n"," ",3);
	fprintf(fout,"TEXT%13s40-1  134-1  40-1 20-1  -1  -1-1%20d\n"," ",4);

	while( (c=getc(fiac))!=EOF)
		putc(c,fout);
	fclose(fiac);
	delete("$$iac.tmp;");

	fprintf(fout,"%s.RAC%-*s",argv[3],30-strlen(argv[3])," ");
	fprintf(fout,"%4d%4d%4d%10d\n",4,4,52,nrac);
	fprintf(fout,"%s-ID%-*s4-1   14-1   5-1 50-1  -1  -1-1%20d\n",
					argv[3],15-strlen(argv[3])," ",1);
	fprintf(fout,"TYPE%14s4-1   54-1   5-1 50-1  -1  -1-1%20d\n"," ",2);
	fprintf(fout,"VALUE%13s4-1   94-1  12 4 60-1  -1  -1-1%20d\n"," ",3);
	fprintf(fout,"TEXT%13s40-1  134-1  40-1 20-1  -1  -1-1%20d\n"," ",4);

	while( (c=getc(frac))!=EOF)
		putc(c,fout);
	fclose(frac);
	delete("$$rac.tmp;");

	fprintf(fout,"%s.LUT%-*s",argv[3],30-strlen(argv[3])," ");
	fprintf(fout,"%4d%4d%4d%10d\n",2,2,8,nexist);
	fprintf(fout,"FC%16s4-1   14-1   5-1 50-1  -1  -1-1%20d\n"," ",1);
	fprintf(fout,"SYMBOL%12s4-1   54-1   5-1 50-1  -1  -1-1%20d\n"," ",2);

	for ( fc=0;fc<2000;fc++)
		if ( exist[fc] )
			fprintf(fout,"%11d%11d\n",fc,symbol[fc]);
    
	fprintf(fout,"EOI\nEOS\n");

	exit(1);
};

int
output()	/* output geometry info. */
{
    double sz, xs, ys, xe, ye, xi, yi; int txlen;
    double a, b, c, d, e, f, g;
	
    if ( vtot > 0 )	/* ... assuming we have some to output ! */
    {
	switch ( gtype[fc] )	/* branch on GT */
	{
	case LINEAR :
	case SYM_STRING :
	case FILL_AREA :	/* treat as closed linear feature */
	case INTERP_CURVE :	/* treat as linear feature ( for now ) */

		st_out();
		break;

	case UNORIEN_SYMBOL :
	case ORIEN_SYMBOL :	/* Sorry folks.... Arc/Info can't cope */
	case SCAL_SYMBOL :	/*   with oriented or scaled symbols ! */

                fprintf(flab,"%10d%10d%14.7E%14.7E\n",
			id,0,vertex[0].x,vertex[0].y);
                fprintf(flab,"%14.7E%14.7E%14.7E%14.7E\n",
			vertex[0].x,vertex[0].y,vertex[0].x,vertex[0].y);
		break;

	case TEXT :	/* can only cope with rotated text, not curved */
 
		txlen = strlen(text);
		xs = vertex[0].x; ys = vertex[0].y;

		if ( size[fc] >= 0.0 )	/* use FRT value by default */
			sz = size[fc];
		else	/* ... else convert point size to mm. */
			sz = thick * 0.2 - 0.025;	/* rule of thumb */

		xe = xs + txlen * sz * cos(rot);
		ye = ys + txlen * sz * sin(rot);

		fprintf(ftxt,"%10d%10d%10d%10d%10d\n",
				(overlay.number+1),2,0,symbol[fc],txlen);
                fprintf(ftxt,"%14.7E%14.7E%14.7E%14.7E%14.7E\n",
						xs,xe,0.0,0.0,ys);
		fprintf(ftxt,"%14.7E%14.7E%14.7E%14.7E%14.7E\n",
						ye,xe,0.0,0.0,ys);
                fprintf(ftxt,"%14.7E%14.7E%14.7E%14.7E%14.7E\n",
						0.0,0.0,0.0,0.0,sz);
		fprintf(ftxt,"%14.7E\n%s\n",
						-100.0,text);
		break;


	case CW_ARC :	/* expand into linear feature */

		arc_to_lin(1);
		st_out();
		break;


	case ACW_ARC :	/* expand into linear feature */

		arc_to_lin(-1);
		st_out();
		break;


	case CIRCUM_CIRCLE :	/* slightly more difficult ! */

		xs = vertex[0].x; ys = vertex[0].y;
		xi = vertex[1].x; yi = vertex[1].y;
		xe = vertex[2].x; ye = vertex[2].y;

		/* compute centre and replace intermediate point ... */

		a = 2.0*(xs-xi); b = 2.0*(ys-yi); c=ys*ys-yi*yi+xs*xs-xi*xi;
		d = 2.0*(xe-xi); e = 2.0*(ye-yi); f=ye*ye-yi*yi+xe*xe-xi*xi;
		g = d*b - a*e;

		vertex[1].x = (b*f - c*e)/g; vertex[1].y = (c*d - a*f)/g;

		/* end at starting point */

		vertex[2].x = xs; vertex[2].y = ys;

		arc_to_lin(1);
		st_out();
		break;


	case CIRCUM_CIRC_ARC : 	/* ... even more difficult ! */

		xs = vertex[0].x; ys = vertex[0].y;
		xi = vertex[1].x; yi = vertex[1].y;
		xe = vertex[2].x; ye = vertex[2].y;

		/* compute centre and replace intermediate point ... */

		a = 2.0*(xs-xi); b = 2.0*(ys-yi); c=ys*ys-yi*yi+xs*xs-xi*xi;
		d = 2.0*(xe-xi); e = 2.0*(ye-yi); f=ye*ye-yi*yi+xe*xe-xi*xi;
		g = d*b - a*e;

		vertex[1].x = (b*f - c*e)/g; vertex[1].y = (c*d - a*f)/g;

		/* determine direction of arc */

		if ( xi*(ys-ye)-yi*(xs-xe)+xs*ye-xe*ys > 0 ) /* simple Pythag! */
			arc_to_lin(1);
		else
			arc_to_lin(-1);

		st_out();
		break;


	default :

		/* what ? */
		break;
	};
    };

    return(1);
};

int
arc_to_lin(dir)		/* convert arc to linear feature */
int dir;	/* direction, +ve = clockwise ( i.e. decreasing theta ) */
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
	if ( thetas < 0.0 )	/* make positive */
		thetas += 2.0 * PI;

	thetae = atan2((ye-yc),(xe-xc));	/* ending angle */

	if ( thetae < 0.0 )	/* make positive */
		thetae += 2.0 * PI;

	dtheta = sqrt(0.08 / r);	/* another rule of thumb! */
/*
printf("r=%f dtheta=%f\n",r,dtheta);
*/
	vertex[0].x = xs; vertex[0].y = ys;	/* keep first point */

	if ( dir > 0 )	/* clockwise case */
	{
		if ( thetae >= thetas ) /* start must be > end angle! */
			thetas += 2.0 * PI;

		for(vtot=1,theta=thetas-dtheta;theta>thetae;theta-=dtheta,vtot++)
		{
			vertex[vtot].x = xc + r * cos(theta);
			vertex[vtot].y = yc + r * sin(theta);
		};
	}
	else
	{
		if ( thetas >= thetae ) /* start must be < end angle! */
			thetae += 2.0 * PI;

		for(vtot=1,theta=thetas+dtheta;theta<thetae;theta+=dtheta,vtot++)
		{
			vertex[vtot].x = xc + r * cos(theta);
			vertex[vtot].y = yc + r * sin(theta);
		};
	};

	/* add last vertex. NOTE: not necessarily same as 3rd ST entry */

	vertex[vtot].x = xc + r * cos(thetae);
	vertex[vtot].y = yc + r * sin(thetae);
	vtot++;

	return(1);
};

int
st_out()	/* output coordinates in MAX_ARCINFO_VERTICES chunks */
{
	int v, vs, ve;

	for(vs=0;vs<vtot;vs+=MAX_ARCINFO_VERTICES-1)
	{
		ve = min(vs+MAX_ARCINFO_VERTICES,vtot) - 1;

		/* o/p header info for this chunk */

		fprintf(fout,"%10d%10d%10d%10d%10d%10d%10d\n",
							1,id,0,0,0,0,ve-vs+1);

		for (v=vs;v<ve;v+=2)	/* o/p coords in pairs ... */
		fprintf(fout,"%14.7E%14.7E%14.7E%14.7E\n",
			vertex[v].x,vertex[v].y,vertex[v+1].x,vertex[v+1].y);

		if ( v == ve  )	/* ... and last coord seperately if odd vtot */
        		fprintf(fout,"%14.7E%14.7E\n",vertex[v].x,vertex[v].y);
	};

	return(1);
}

