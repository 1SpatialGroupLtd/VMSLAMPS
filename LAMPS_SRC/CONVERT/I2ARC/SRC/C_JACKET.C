/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1991-02-08 14:30:26.000000000 +0000
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
#module C_JACKET "24AU88"

/************************************************************************/
/* Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England    */
/* Author    TJ Ibbs, 28 May 1987					*/
/************************************************************************/ 

/************************************************************************/ 
/*									*/
/*			 C J A C K E T  				*/
/*									*/
/* LSDLIB C jacket routines						*/
/* This module is the 'header' module for the CJACKET routine, which	*/
/* provide 'jacket' routines for calling LSLLIB from C			*/
/************************************************************************/ 

/*======================================================================*/
/*		      The header for the module				*/
/*======================================================================*/

#include <stdio.h>			/* standard I/O header		*/
#include <lsldef.h>			/* standard LSL header		*/
/*#include "lsl$cmnlsd:cjacket.h"*/

/*----------------------------------------------------------------------*/
/* lsl_set_desc								*/
/*......................................................................*/
/* routine to set up a descriptor to point to an array			*/
/*----------------------------------------------------------------------*/

void lsl_set_desc(
    char   string[],			/* IN - the string to describe	*/
    struct lsl_descriptor *desc )	/*OUT - the descriptor for it	*/
{
	desc->length  = strlen(string);
	desc->type    = 14;
	desc->class   = 1;
	desc->pointer = string;
	return;
}

/*----------------------------------------------------------------------*/
/* c_FRTINI								*/
/*......................................................................*/
/* open FRT file and fill in FRT and ACD common blocks			*/
/*----------------------------------------------------------------------*/
                                           
VMS_STATUS c_FRTINI(
    char      file_spec[] )	/* the file-spec as a C string		*/
{
	struct lsl_descriptor file_desc;

	extern VMS_STATUS FRTINI();	/* the FORTRAN routine	*/

	lsl_set_desc( file_spec, &file_desc );
	return FRTINI(&file_desc);
}

/*----------------------------------------------------------------------*/
/* c_RDFRT								*/
/*......................................................................*/
/* open FRT file and fill in FRT and ACD common blocks			*/
/*----------------------------------------------------------------------*/
                                           
VMS_STATUS c_RDFRT(
    char      file_spec[] )	/* the file-spec as a C string		*/
{
	struct lsl_descriptor file_desc;

	extern VMS_STATUS RDFRT();	/* the FORTRAN routine	*/

	lsl_set_desc( file_spec, &file_desc );
	return RDFRT(&file_desc);
}

/*----------------------------------------------------------------------*/
/* c_RDPAR								*/
/*......................................................................*/
/* 									*/
/*----------------------------------------------------------------------*/
                                           
VMS_STATUS c_RDPAR(
    char      file_spec[] )	/* the file-spec as a C string		*/
{
	struct lsl_descriptor file_desc;

	extern VMS_STATUS RDPAR();	/* the FORTRAN routine	*/

	lsl_set_desc( file_spec, &file_desc );
	return RDPAR(&file_desc);
}
