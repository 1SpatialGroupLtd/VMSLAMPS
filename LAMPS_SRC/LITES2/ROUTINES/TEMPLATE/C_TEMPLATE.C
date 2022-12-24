/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1993-06-07 17:35:06.000000000 +0100
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
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England    */
/* Author    R.W. Russell    May-1993				        */
/************************************************************************/ 

/************************************************************************/ 
/*									*/
/*                    T E M P L A T E  R O U T I N E S			*/
/*									*/
/* LITES2 User Routines							*/
/*									*/
/* These are C template user routines                                   */
/* 									*/
/* They should be compiled, and then linked as a shared image, with 	*/
/* UNIVERSAL entry points for the routines that are required, 		*/
/* for example:								*/
/*									*/
/*	$link/debug/share/debug/exe=usrrts.exe c_template,sys$input:/opt*/
/*	  UNIVERSAL = usrini,usranno,usrdef,usrdo,usrdrw,usrerr,usrgac	*/
/*	  UNIVERSAL = usrgcb,usrgmh,usrgpt,usrgst,usrgtx,usrgzs,usrpac	*/
/*	  UNIVERSAL = usrpcb,usrppt,usrpst,usrptx,usrpzs,usrret,usrsto	*/
/*									*/
/*	  sys$library:vaxcrtl/share					*/
/*									*/
/************************************************************************/ 

/* header files for accessing external libraries			*/
#include <math.h>
#include <stddef.h>
#include <stdio.h>

/* some definitions to ease the interface with the FORTRAN calls	*/

#define BOOLEAN		unsigned int	/* general logical value */
#define NULL		0

/************************************************************************/ 
/* The following defines a string descriptor structure, and a means of	*/
/* declaring such a descriptor. This actually duplicates the structure  */
/* and macro (although by different names) that are defined in the file	*/
/* <DESCRIP.H>								*/
/************************************************************************/ 

struct lsl_descriptor
	{
	unsigned short	length;		/* length of the string      */
	unsigned char	type;		/* the type of descriptor    */
	unsigned char	class;		/* the class ...	     */
	char	       *pointer;	/* the address of the buffer */
	};

typedef	struct lsl_descriptor LSL_DESC;	/* define the 'type' LSL_DESC*/

/************************************************************************/ 
/* And define a macro for declaring a new string descriptor		*/
/* - use it as follows:							*/
/*                                                                      */
/*		char   	expbuf[80];	  -- the string itself	        */
/*		strdesc(expdsc,expbuf);	  -- and declare 'expdsc'       */
/*                                                                      */
/* NOTE that                                                            */
/*		DSC$K_DTYPE_T = 14	(character string descriptor)   */
/*		DSC$K_CLASS_S =  1	(scalar or string descriptor)   */
/*                                                                      */
/************************************************************************/ 

#define	strdesc(name,string)	struct lsl_descriptor name = \
					{ sizeof(string)-1, 14, 1, string }


/*======================================================================*/
/*			Utility Routines                                */
/*									*/
/* these routines are called to decode the values passe in the "rest	*/
/* of line" string							*/
/*======================================================================*/

static	BOOLEAN	get_int_value(
			      int	*strl,
			      LSL_DESC	*str,
			      int	*intgr)
{
   char		tmp_char;
   BOOLEAN	ok = FALSE;

   if (*strl == 0) return FALSE;
   str->pointer[*strl] = NULL;
   ok = (sscanf(str->pointer,"%d%c",intgr,&tmp_char) == 1);

   return ok;
}

static	BOOLEAN	get_float_value(
				int		*strl,
				LSL_DESC	*str,
				float		*flt)
{
   char		tmp_char;
   BOOLEAN	ok = FALSE;

   if (*strl == 0) return FALSE;
   str->pointer[*strl] = NULL;
   ok = (sscanf(str->pointer,"%f%c",flt,&tmp_char) == 1);
   return ok;
}

static	BOOLEAN	get_2_float_value(
				  int		*strl,
				  LSL_DESC	*str,
				  float		*flt1,
				  float		*flt2)
{
   char		tmp_char;
   BOOLEAN	ok = FALSE;

   if (*strl == 0) return FALSE;
   str->pointer[*strl] = NULL;
   ok = (sscanf(str->pointer,"%f%f%c",flt1,flt2,&tmp_char) == 2);
   
   return ok;
}



/*									*/
/* Definition of all graphical types as parameters			*/
/*									*/
#define lintyp = 1		/* line string				*/
#define clotyp = 2		/* clockwise circle arc			*/
#define anttyp = 3		/* anti-clockwise circle arc		*/
#define cirtyp = 4		/* circum-circle arc			*/
#define fultyp = 5		/* full circumcircle			*/
#define curtyp = 6		/* interpolated curve			*/
#define unotyp = 7		/* unoriented symbol			*/
#define orityp = 8		/* oriented symbol			*/
#define scatyp = 9		/* scaled symbol			*/
#define textyp = 10		/* text					*/
#define strtyp = 11		/* symbol string			*/
#define aretyp = 12		/* fill area				*/

/*----------------------------------------------------------------------*/
/* EXTERN usrini							*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/*									*/
/* action	-	action to carry out				*/
/* strl		-	number of characters in STR			*/
/* str		-	string passed to USER command			*/
/* cursor[2]	-	coordinates of cursor				*/
/* cndflg	-	condition flag.					*/
/* state	-	current state			    		*/
/* gotfo	-	TRUE if there is a found object, FALSE 		*/
/*			otherwise, when the next 4 arguments are 	*/
/*			undefined					*/
/* ncoord	-	number of coords		    		*/
/* nacs		-	number of ACS					*/
/* fsn		-	number of feature				*/
/* fc[4]	-	feature status 					*/
/* map		-	map						*/
/* layer	-	layer						*/
/* gt		-	graphical type					*/
/* rotat	-	rotation if text or oriented symbol (in radians)*/
/* thick	-	size of text					*/
/* retcod	-	return code					*/
/*			 = 0 abort, don't call processing routine	*/
/*			 = 1 for get coords and ACs			*/
/*			 = 2 for get coords without ACs			*/
/*			 = 3 for get ACs without coords	     		*/
/*			 = 4 for call processing routine without coords	*/
/*			     or ACs					*/
/*			 = 5 for call completion routine without coords	*/
/*			     or ACs					*/
/*			 > 100 - call the routine to get map header	*/
/*			         information (for map RETCOD - 100))	*/
/*							     		*/
/* All these arguments, apart from RETCOD, should be considered	as read	*/
/* only									*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrini(
		   int		*action,
		   int		*strl,
		   LSL_DESC	*str,
		   float	cursor[2],
		   BOOLEAN	*cndflg,
		   LSL_DESC	*state,
		   BOOLEAN	*gotfo,
		   int		*ncoord,
		   int		*nacs,
		   int		*fsn,
		   int		FC[4],
		   int		*map,
		   int		*layer,
		   int		*gt,
		   float	*rotat,
		   int		*thick,
		   int		*retcod)

{
   /* announce ourselves						*/

   printf("LITES2 User routine %d\n",*action);
   printf(" This version is a dummy that does not do anything\n\n");

   /* in this version, don't do anything				*/

   *retcod = 0;
   return;
}



/*----------------------------------------------------------------------*/
/* EXTERN usranno							*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/* rtstrl	- input: maximum size of RTSTR				*/
/*		  output: size of RTSTR					*/
/*		  if 0 is returned no ANNOTATION command is executed.	*/
/* rtstr	- secondary command (with arguments) for the 		*/
/*		  ANNOTATION command					*/
/*									*/
/* all these arguments are writable.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usranno(
		    int		*rtstrl,
		    LSL_DESC	*rtstr)
{
   /* in this version, don't do anything				*/

   *rtstrl = 0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrdef							*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/* varnam_len	- input: maximum size of VARNAM				*/
/*		- output: size of VARNAM				*/
/* varnam	- variable name to set					*/
/* index	- element if VARNAM is array				*/
/* intval	- integer value to set					*/
/* realval	- real value to set					*/
/* dblval	- double value to set					*/
/* charval_len	- input: maximum size of CHARVAL			*/
/*		- output: size of CHARVAL				*/
/* charval	- character value to set				*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrdef(
		   int		*varnam_len,
		   LSL_DESC	*varnam,
		   int		*index,
		   int		*intval,
		   float	*realval,
		   double	*dblval,
		   int		*charval_len,
		   LSL_DESC	*charval)
{	
   /* in this version, don't do anything				*/

   *varnam_len = 0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrdo								*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/*									*/
/* retcod	- return code						*/
/*		- = 0 abort, dont call completion routine		*/
/*		- = 4 for abort, call completion routine		*/
/*		- = 5 to create a new feature (and keep old one if there*/
/*		      was one)						*/
/*		- = 6 to create a new feature and delete old one	*/
/*									*/
/* This argument should be set on return				*/
/*----------------------------------------------------------------------*/

extern void usrdo(
		  int	*retcod)
{
   /* in this version, don't do anything				*/

   *retcod=0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrdrw							*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/* rtstrl - input: maximum size of RTSTR				*/
/*	  - output: size of RTSTR					*/
/*	  - if 0 is returned no DRAW command is executed.		*/
/* rtstr  - secondary command (with arguments) for the DRAW command	*/
/*									*/
/* all these arguments are writable.					*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrdrw(
		   int		*rtstrl,
		   LSL_DESC	*rtstr)
{
   /* in this version, don't do anything				*/

   *rtstrl = 0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrerr							*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/* fatal   - TRUE if user routine is about to be aborted		*/
/*	   - FALSE if only a warning					*/
/* errcod  - error code							*/
/* 									*/
/* These arguments should be treated as read only			*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrerr(
		   BOOLEAN	*fatal,
		   int		*errcod)
{
   /* in this version, don't do anything				*/

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrgac							*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/* actype	- type of AC						*/
/* acival	- AC value						*/
/*		  note: to read a real AC value, a copy of this will	*/
/*		  have to be equivalenced to a real			*/
/* actxtl	- number of characters in ACTXT				*/
/* actxt	- text (maximum of 255 chars)				*/
/* retcod	- return code						*/
/*	  	   = 0 abort, don't call processing routine		*/
/*		   = 1 for get more ACs if there are any, or start	*/
/*		       getting coords if reqd, or call USRDO if coords	*/
/*		       not reqd						*/
/*		   = 2 stop getting ACs, start getting cooordinates	*/
/*		   = 4 for call processing routine right away		*/
/*									*/
/* All these arguments, apart from RETCOD, should be considered as read	*/
/* only									*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrgac(
		   int		*actype,
		   int		*acival,
		   int		*ACTXTL,
		   LSL_DESC	*actxt,
		   int		*retcod)
{
   /* in this version, don't do anything				*/

   *retcod=0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrgcb							*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/* size		   -  number of coords passed with this call		*/
/* userxy[][2]	   -  coordinates					*/
/* usrflg[SIZE]	   -  flags (visibility only)				*/
/* max_attr	   -  maximum number of attributes			*/
/* usernatt	   -  number of attributes present			*/
/* userattc[]	   -  attribute codes					*/
/* userdatatypes[] -  datatypes of attributes				*/
/* usernamelens[]  -  name lengths					*/
/* usernames[]	   -  names of attributes				*/
/*									*/
/* the following two arrays are equivalenced in the calling routine	*/
/* useriattv[][]   - integer values					*/
/* userrattv[][]   - real values					*/
/* retcod	   - return code					*/
/*			 = 0 abort, don't call processing routine	*/
/*			 = 1 for get more coords or call processing	*/
/*			     routine, if no more			*/
/*			 = 4 for abort, but call processing routine	*/
/*									*/
/* All these arguments, apart from RETCOD, should be considered	as read	*/
/* only									*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrgcb(
		   int		*size,
		   float	*userxy[2],
		   char		usrflg[],
		   int		*max_attr,
		   int		*usernatt,
		   int		userattc[],
		   int		userdatatypes[],
		   int		usernamelens[],
		   LSL_DESC	usernames[],
		   int		*useriattv[],
		   float	*userrattv[],
		   int		*retcod)
{
   /* the following parameter is for testing if an attribute value	*/
   /* is present for a particular point					*/

   int	IABSENT  = 0x80000000;

   /* in this version, don't do anything				*/

   *retcod=0;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrgmh							*/
/*......................................................................*/
/*									*/  
/* Arguments								*/
/* mh_len	-  input  - length of original MH			*/
/*		- output  - length of updated MH			*/
/* mh[mh_len]	- map header - NOTE INTEGER*2				*/
/* write_mh	- input  - TRUE if MH is writeable			*/
/*		- output - TRUE if MH is to be written			*/
/* md_len	- input  - length of original MD			*/
/*		- output - length of updated MD				*/
/* md[md_len]	- map descriptor - NOTE INTEGER*2			*/
/* write_MD	- input  - TRUE if MD is writeable			*/
/*		- output - TRUE if MD is to be written			*/
/* retcod	- return code						*/
/*		 = 0 abort, don't call processing routine		*/
/*		 = 1 for get coords and ACs				*/
/*		 = 2 for get coords without ACs				*/
/*		 = 3 for get ACs without coords				*/
/*		 = 4 for call processing routine without coords or ACs	*/
/*		 = 5 for call completion routine without coords or ACs	*/
/*		 > 100 - call this routine again			*/
/*									*/
/*	All these arguments may be considered writeable but note that	*/
/*	the new lengths of the arrays MUST not be longer than the	*/
/*	original arrays							*/
/*									*/
/*	Trying to write a map header or a map descriptor to a file that	*/
/*	has been opened for READing only will cause an error.		*/
/*							    		*/
/*	Writing a new map header or map descriptor will not affect the	*/
/*	idea that LITES2 has of the origin and scale, and the system,	*/
/*	variables $MHARR, $MHLEN, $MDARR and $MDLEN although the output	*/
/*	file will contain the changes.					*/
/*									*/
/*	Changes to the projection parts of the map descriptor (ie apart	*/
/*	from the origin and scale) require an intimate knowledge of	*/
/*	Laser-Scan's projection software. It is recommended that such	*/
/*	changes are made using the program ITRANS.			*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrgmh(
		   int		*mh_len,
		   short int	mh[],
		   BOOLEAN	*write_mh,
		   int		*md_len,
		   short int	md[],
		   BOOLEAN	*write_md,
		   int		*retcod)
{
   /* do not write anything back					*/

   *write_mh = FALSE;
   *write_md = FALSE;

   *retcod = 0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrgpt							*/
/*......................................................................*/
/*									*/ 
/*C Arguments								*/
/* size		-  number of coords passed with this call		*/
/* userxy[][2]	-  coords						*/
/* usrflg[]	-  flags (visibility only)				*/
/* textl	-  number of characters in TEXT				*/
/* text		-  text string, if text feature				*/
/* retcod	-  return code						*/
/*		   = 0 abort, don't call processing routine		*/
/*		   = 1 for get more coords or call processing routine,	*/
/*		       if no more					*/
/*		   = 4 for abort, but call processing routine		*/
/*									*/
/*	All these arguments, apart from RETCOD, should be considered	*/
/*	as read only							*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrgpt(
		   int		*size,
		   float	*userxy[2],
		   char		usrflg[],
		   int		*textl,
		   LSL_DESC	*text,
		   int		*retcod)
{
   /* in this version do nothing					*/

   *retcod=0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrgst							*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/* size		-  number of coords passed with this call		*/
/* userxy[][2]	-  coords						*/
/* usrflg[]	-  flags (visibility only)				*/
/* retcod	-   return code
/*		   = 0 abort, don't call processing routine		*/
/*		   = 1 for get more coords or call processing routine,	*/
/*		       if no more					*/
/*		   = 4 for abort, but call processing routine		*/
/*									*/
/*	All these arguments, apart from RETCOD, should be considered	*/
/*	as read only							*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrgst(
		   int		*size,
		   float	*userxy[2],
		   char		usrflg[],
		   int		*retcod)
{
   /* in this version, don't do anything				*/

   *retcod=0;

   return;
}



/*----------------------------------------------------------------------*/
/* EXTERN usrgtx							*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/* textl	- number of characters in TEXT				*/
/* text		- text string, if text feature				*/
/* ts[]		- text component status					*/
/* rotat	- rotation of text component				*/
/* height	- height of text (in points or 0.01mm)			*/
/* aux[8]	- data about text (in IFF units)			*/
/*		     aux[0] = angle (in radians)			*/
/*		     aux[1] = cosine of angle				*/
/*		     aux[2] = sine of angle				*/
/*		     aux[3] = height (in IFF units)			*/
/*		     aux[4] = minumum X value (rel to locating point)	*/
/*		     aux[5] = maximum X value				*/
/*		     aux[6] = minimum Y value 				*/
/*		     aux[7] = maximum Y value				*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrgtx(
		   int		*textl,
		   LSL_DESC	*text,
		   int		ts[4],
		   float	*rotat,
		   int		*height,
		   float	aux[8])
{
   /* this is a dummy routine that does nothing				*/

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrgzs							*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/* size		- number of coords passed  with this call		*/
/* userxyz[][3]	- coords						*/
/* usrflg[]	- flags (visibility only)				*/
/* retcod	-   return code
/*		   = 0 abort, don't call processing routine		*/
/*		   = 1 for get more coords or call processing routine,	*/
/*		       if no more					*/
/*		   = 4 for abort, but call processing routine		*/
/*									*/
/*	All these arguments, apart from RETCOD, should be considered	*/
/*	as read only							*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrgzs(
		   int		*size,
		   float	*userxyz[],
		   char		usrflg[],
		   int		*retcod)
{
   /* the following parameter is for testing if a Z coordinate value	*/
   /* is present for a particular point					*/
   /*									*/
   /* NOTE: this must be tested against an integer, which has		*/
   /*       been equivalenced onto the real value to be tested		*/

   int	IABSENT = 0x80000000;

   /* in this version, don't do anything				*/

   *retcod=0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrpac							*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/* actype	- type of AC						*/
/* acival	- AC value						*/
/*		 note: to read a real AC value, a copy of this will	*/
/*		       have to be equivalenced to a real value		*/
/* actxtl	- number of characters in ACTXT				*/
/* actxt	- text (maximum of 255 chars)				*/
/* retcod	- return code						*/
/*		 = 0 abort, do not call completion routine		*/
/*		 = 1 for write another AC if there are any, or else	*/
/*	             start writing coords				*/
/*		 = 2 for start writing coords				*/
/*		 = 4 for abort, call completion routine			*/
/*									*/
/*	All these arguments are writable				*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrpac(
		   int		*actype,
		   int		*acival,
		   int		*actxtl,
		   LSL_DESC	*actxt,
		   int		*retcod)
{
   /* in this version, don't do anything				*/

   *retcod=0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrpcb							*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/* size		- input:  maximum number of coords to pass back		*/
/*		  output: actual number of coords passed back with	*/
/*		          this call					*/
/* userxy[][2]	- coords						*/
/* userflg[]	- flags (visibility only)				*/
/* max_attr	- maximum number of attributes				*/
/* usernatt	- number of attributes present				*/
/* userattc[]	- attribute codes					*/
/*									*/
/* the following two arrays are equivalenced in the calling routine	*/
/* useriattv[][]- integer values					*/
/* userrattv[][]- real values						*/
/* retcod	- return code						*/
/*		 = 0 abort, dont call completion routine		*/
/*		 = 1 for write more coords, if there are any, or else	*/
/*		     call completion routine				*/
/*		 = 4 for abort, call completion routine			*/
/*									*/
/*   	All these arguments are writable.				*/
/*									*/
/* don't send more than maximum number of attributes -- most important	*/
/* ===================================================================	*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrpcb(
		   int		*size,
		   float	*userxy[],
		   char		userflg[],
		   int		*max_attr,
		   int		*usernatt,
		   int		userattc[],
		   int		*useriattv[],
		   float	*userrattv[],
		   int		*retcod)
{
   /* this is a dummy routine that does nothing				*/

   *retcod=0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrppt							*/
/*......................................................................*/
/*									*/
/* size		- input:  maximum number of coords to pass back		*/
/*		  output: actual number of coords passed back with	*/
/*			  this call					*/
/* userxy[][2]	- coords						*/
/* usrflg[]	- flags (visibility only)				*/
/* textl	-  input:  max size of TEXT				*/
/*		   output: actual size of TEXT				*/
/* text		- text string, if text feature				*/
/* retcod	- return code						*/
/*		 = 0 abort, dont call completion routine		*/
/*		 = 1 for write more coords, if there are any, or else	*/
/*		     call completion routine				*/
/*		 = 4 for abort, call completion routine			*/
/*									*/
/*   	All these arguments are writable.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrppt(
		   int		*size,
		   float	*userxy[],
		   char		usrflg[],
		   int		*textl,
		   LSL_DESC	*text,
		   int		*retcod)
{
   /* in this version, don't do anything				*/

   *retcod=0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrpst							*/
/*......................................................................*/
/*									*/
/* size		- input:  maximum number of coords to pass back		*/
/*		  output: actual number of coords passed back with	*/
/*			  this call					*/
/* userxy[][2]	- coords						*/
/* usrflg[]	- flags (visibility only)				*/
/* retcod	- return code						*/
/*		 = 0 abort, dont call completion routine		*/
/*		 = 1 for write more coords, if there are any, or else	*/
/*		     call completion routine				*/
/*		 = 4 for abort, call completion routine			*/
/*									*/
/*   	All these arguments are writable.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrpst(
		   int		*size,
		   float	*userxy[],
		   char		usrflg[],
		   int		*retcod)
{
   /*	This is a dummy routine that does nothing			*/

   *retcod=0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrptx							*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/* text		- text string, if text feature				*/
/* textl	-  input: max size of TEXT				*/
/*		  output: actual size of TEXT				*/
/* ts[4]	- feature status for texts				*/
/* thick	- height of text (in points or 0.01mm)			*/
/* rot		- angle of text						*/
/*									*/
/*	All these arguments are writable.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrptx(
		   LSL_DESC	*text,
		   int		*textl,
		   int		ts[4],
		   int		*thick,
		   float	*rot)
{
   
   /*	This routine does nothing					*/

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrpzs							*/
/*......................................................................*/
/*									*/
/* size		- input:  maximum number of coords to pass back		*/
/*		  output: actual number of coords passed back with	*/
/*			  this call					*/
/* userxyz[][3]	- coords						*/
/* usrflg[]	- flags (visibility only)				*/
/* retcod	- return code						*/
/*		 = 0 abort, dont call completion routine		*/
/*		 = 1 for write more coords, if there are any, or else	*/
/*		     call completion routine				*/
/*		 = 4 for abort, call completion routine			*/
/*									*/
/*   	All these arguments are writable.				*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrpzs(
		   int		*size,
		   float	*userxyz[],
		   char		usrflg[],
		   int		*retcod)
{
   /* This is a dummy routine that does nothing				*/

   retcod=0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrret							*/
/*......................................................................*/
/*									*/     
/* Arguments								*/
/* cndflg	- LITES2 conditional flag				*/
/* rtstrl	-  input: maximum size of RTSTR				*/
/*		  output: size of RTSTR					*/
/* rtstr	- LITES2 command line, to be executed before any other	*/
/*		  command						*/
/* retcod	- return code						*/
/*	  	 = 0 for abort						*/
/*		 = 1 for CNDFLG to be set and command to be executed	*/
/*		 = 2 for call processing routine again			*/
/*		 = 3 for call USRDEF, then call USRRET again		*/
/*		 = 4 for call USRANNO, then call USRRET again		*/
/*		 = 5 for call USRDRW, then call USRRET again		*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrret(
		   BOOLEAN	*cndflg,
		   int		*rtstrl,
		   LSL_DESC	*rtstr,
		   int		*retcod)
{
   /* in this version, don't do anything				*/

   *retcod=0;

   return;
}


/*----------------------------------------------------------------------*/
/* EXTERN usrsto							*/
/*......................................................................*/
/*									*/
/* Arguments								*/
/* fsn		- feature serial number to use (set to -1 for unknown)	*/
/* fc[4]	- feature status to use   (set FC[i] to -1 for unknown)	*/
/* map		- map to put feature in   (set to -1 for unknown)	*/
/* layer	- layer to use		  (set to -1 for unknown)	*/
/* txtf		- TRUE if FC =-1 and want to create a text feature	*/
/* nopts	- number of points in feature				*/
/* nac		- number of ACs in feature				*/
/* rotat	- rotation if text or oriented symbol (in radians)	*/
/* thick	- size of text						*/
/* retcod	- return code						*/
/*		 = 0 abort, dont call completion routine		*/
/*		 = 1 for ask to output data				*/
/*		 = 4 abort, call completion routine			*/
/*									*/
/*----------------------------------------------------------------------*/

extern void usrsto(
		   int		*fsn,
		   int		fc[4],
		   int		*map,
		   int		*layer,
		   BOOLEAN	*txtf,
		   int		*nopts,
		   int		*nac,
		   float	*rotat,
		   int		*thick,
		   int		*retcod)
{
   /* in this version, don't do anything				*/

   *retcod=0;

   return;
}
