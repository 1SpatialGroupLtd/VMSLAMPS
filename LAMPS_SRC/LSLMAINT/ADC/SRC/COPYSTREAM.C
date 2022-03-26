#module COPYSTREAM "17AU99"

/******************************************************************************/
/*									      */
/*  Copyright © Laser-scan Ltd, Cambridge CB4 4FY, England		      */
/*  Author    JM Cadogan				      30-Sep-1993     */
/*									      */
/*  Description:							      */
/*  	Copy lines of FORTRAN source code from input source file to output    */
/*	source file, while decoding and special function commands in the      */
/*	code.								      */
/*									      */
/******************************************************************************/

#include <stdio.h>			/* standard I/O header */
#include <stsdef.h>			/* error status def'ns */
#include <string.h>			/* for char string handling */
#include <lsldef.h>			/* standard LSL header */
#include <lsldesc.h>			/* for s_Desc */
#include "lsl$cmnlsl:lsllibmsg.h"	/* lsllib messages */
#include "lsl$cmnlsl:cmdcom.h"		/* command decoding */
#include "lsl$cmnlsl:readstr.h"		/* string reading header */
#include "here:adcc.h"			/* adcc header */
#include "here:adccmsg.h"		/* adcc message header */
#include "here:cmdline.h"		/* adcc command flags */

/*----------------------------------------------------------------------------*/

char		*ofile[MAXFILENAM];	/* output source file */
char		*idfile[MAXFILENAM];	/* output ident file */
LSL_DESC	fdesc;			/* file's string descriptor */
int		luncount;		/* count of LUNs for output files */
int		linenumber;		/* file line numbers counter */
int		linecount;		/* file line counter */
int		truth_total;		/* no. of logical expr. in truth file */
char		*truth_names[MAXVARS][MAXFILENAM]; /* var names in truth file */
int		truth_values[MAXVARS];	/* var values in truth file */

extern void copystream(char *source_file[],BOOLEAN inner_level)
{

/* functions */
	void       	SETAUX();		/* set auxiliary buffer */
	void		ADCC_CMD_TABLE();	/* lookup table */
	LSL_STATUS	FLRLIN();		/* read a line */
	BOOLEAN		RDCH();			/* read a charater */
	BOOLEAN		RDCHS();		/* read a charater */
	int	   	READSTR();		/* read a string */
	INT_4      	RDCOMM();		/* read a command */
	void		BSCH();			/* backspace a character */

/* workspace */
	LSL_STATUS	status,ierr;		/* return codes */
	char		asterisk = '*';		/* keyword prefix */
	LSL_STATUS	retval;			/* status return value */
	INT_4		stringlen,cmd;		/* string length; command no. */
	LSL_DESC   	stringdesc;		/* string descriptor */
extern	char		source_line[MAXLINELEN];/* line from source file */
extern	char		tmpbuf[MAXLINELEN];	/* temp buffer */
extern	char		*numbuf[MAXLINELEN];	/* IDENT string */
	char		idbuf[MAXIDLEN];	/* IDENT string */
	char		modbuf[MAXMODLEN];	/* MODULE string */
	int		sourcelun;		/* source file LUN */
	int		i;			/* counter */
extern	int		nchs;			/* no. of characters */
	char		ich;			/* character */
	BOOLEAN		got_id,got_mod;		/* flags for IDENT,<END,MODULE> */
	BOOLEAN		cond_flag;		/* flag for conditional 
						   directive */
	BOOLEAN		exp_val;		/* value of conditional 
						   expression */

/* Initialise flags */
	got_id = FALSE;
	got_mod = FALSE;
	cond_flag = TRUE;
	exp_val = TRUE;

/* Open source file for read only */

	fdesc.length = strlen(source_file);   /* prepare filename descriptor */
	fdesc.pointer = source_file;
	luncount = luncount + 1;	      /* increment LUN counter */
	sourcelun = luncount;
	status = FLROPN( &sourcelun, &fdesc, &ierr );
	if ( !(status&STS$M_SUCCESS) ) 
	{
	   LSL_PUTMSG(&ADCC__OPN,source_file);
	   LSL_ADDMSG(&status);
	   if ( status==LSL__SYSOPEN ) LSL_ADDMSG( &ierr );
	   return;
	}

/* DO block repeated once per line */

	do
	{ 

	   linecount = linecount + 1;

/* Get line from source file and look for asterisks */	
	   status = FLRSEL(&sourcelun);
	   if ( !(status&STS$M_SUCCESS) ) 
	   {
	      LSL_PUTMSG(&status);
	      return;
	   }
	   status = FLRLIN(tmpbuf,&nchs,&MAXLINELEN,&ierr);
	   if (status==LSL__EOF) continue;

	   if (status!=LSL__NORMAL) 
	   {
	      LSL_PUTMSG(&sourcelun,&linecount,source_file);
	      LSL_ADDMSG(&status);
	      if (status==LSL__SYSREAD) LSL_ADDMSG(&ierr);

	      if (status!=LSL__RECTOOBIG) return;

	   }

/* Line too long warning */
	   if (nchs>line_length) 
	      LSL_PUTMSG(&ADCC__LINETOOLONG,&linecount,source_file);

	   if (nchs>0)
	   {
	      SETAUX(tmpbuf,&nchs);		/* set auxiliary buffer */
	      RDCH(&ich);
	   }

/* If we have *** then look for a command, otherwise write line to output source
   file. */

	   if (nchs>0 && ich==asterisk)
	   {
	      /* skip any more asterisks */
	      do
	      {
	         if (RDCH(&ich)) break;
	      } while (ich==asterisk);
	      BSCH();
	      cmd = RDCOMM(ADCC_CMD_TABLE);
	      if (cmd<=0)
	      {
	         LSL_ADDMSG(&ADCC__ATLINE,&linecount,&source_file);
	         LSL_ADDBUF();
	         return;
	      }

	      switch (cmd)
	      {
		/* error case */

		/* ** DATA, DEFPAR, or SETVAR */

		/* ** INCLUDE, PARAMETER, or COMMON */

		   case F_INC:
		   case F_PAR:
		   case F_COM:
		   {
		      RDCH(&ich);   /* move on 1 char to start of filename */
	              stringdesc.length = MAXLINELEN;
	              stringdesc.pointer = source_line;
		      stringlen = READSTR( &stringdesc,"/",&ON_SPACE,&TRUE,
					   &retval );
		      source_line[stringlen] = 0;

		      switch (cmd) /* append the relevant file extension */
		      {
			 case F_INC: strcat(&source_line,".src");break;
			 case F_PAR: strcat(&source_line,".par");break;
			 case F_COM: strcat(&source_line,".cmn");break;
		      }
		      /* copy in this file recusively */
		      copystream(&source_line,TRUE);
		      break;
		   }
		/* ** UNLESS or IF */
		   case F_UNL:
		   case F_IF:
		   {
		      if (had_thread)
		      {
		      /* read first variable */
		         RDCHS(&ich);   /* move on 1 char */
		         exp_val = readlogexp(ich);
			 cond_flag = (cmd==F_IF)?exp_val:!exp_val;
		         break;
		      }
		   }
		/* ** IFF, or IFT */
		   case F_IFT: 
		   case F_IFF:
		   {
		      if (had_thread) /* reset cond. flag */
		      {
			 cond_flag = (cmd==F_IFT)?exp_val:!exp_val;
			 break;
		      } 
		   } 
		/* ** IFTF, ENDC */
		   case F_FTF:
		   case F_END:
		   {
		      if (had_thread) /* reset cond. flag */
		      {
			 cond_flag = TRUE;
			 break;
		      }
		   }
		/* IDENT */
		   case F_ID:
		   {
		      stringdesc.length = MAXIDLEN;
		      stringdesc.pointer = idbuf;
		      stringlen = READSTR( &stringdesc,"!",&ON_SPACE,&TRUE,
				           &retval );
		      idbuf[stringlen]=0;
		      got_id = TRUE;
		      if (!got_mod) break;
		   }
		/* MODULE */
		   case F_MOD:
		   {
		   /* out put MODULE/IDENT command records to ident file all
		      together */
		      if (!got_mod)
		      {
		         RDCH(&ich);   /* move on 1 char to start of filename */
		         stringdesc.length = MAXMODLEN;
		         stringdesc.pointer = modbuf;
		         stringlen = READSTR( &stringdesc,"!",&ON_SPACE,&TRUE,
					      &retval );
		         /* pad with spaces */
		         for (i=(stringlen);i<MAXMODLEN;i++) modbuf[i]=' ';
		         modbuf[MAXMODLEN-1]=0;

		         got_mod = TRUE;
		      }
		      if (got_id && got_mod)
		      {		      /* write commands to ident file. */
		      /* select id file */
		         status = FLWSEL(&ADC_LUN_2);
		         if ( !(status&STS$M_SUCCESS) ) 
		         {
		            LSL_PUTMSG(&status);
		            return;
		         }

		         if (got_mod)
			 {
			    strcpy(&tmpbuf,&modbuf);
			    strcat(&tmpbuf,&idbuf);
			 }

			 i = strlen(&tmpbuf);
			 status = FLWLIN(tmpbuf,&i,&ierr);
			 if (status!=LSL__NORMAL) 
		         {
		            LSL_PUTMSG(&ADCC__WRTIDE,&linecount,idfile);
		            LSL_ADDMSG(&status);
		            if (status==LSL__SYSWRITE) LSL_ADDMSG(&ierr);
		            return;
		         }

			 got_id = FALSE;
			 got_mod = FALSE;
			 break;
		      }
		   } /* CASE F_MOD */
	      } /* switch(cmd) */

	   } /* if (!strcmp... */
	   else
	   { /* write to output source */
	      if (cond_flag) write_source(inner_level);
	   }/* closing else clause */
	} while (status!=LSL__EOF); /* once for each remaining line of the file */

/* Close current input files */
	status = FLRCLO(&sourcelun);
	if ( !(status&STS$M_SUCCESS) ) 
	{
	   LSL_PUTMSG(&status);
	   if ( status==LSL__SYSOPEN ) LSL_ADDMSG( &ierr );
	   return;
	}

	return;
}
