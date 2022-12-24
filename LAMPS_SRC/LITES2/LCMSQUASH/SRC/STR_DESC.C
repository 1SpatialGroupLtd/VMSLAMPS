/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1992-10-05 13:24:18.000000000 +0100
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
#module STR_DESC "05OC92"

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Sunil Gupta, 30-Sep-1992					*/
/************************************************************************/

#include <stdio.h>
#include <descrip.h>
#include <string.h>
#include "str_desc.h"

void desc_to_str (struct dsc$descriptor *desc, char *instr)
{
	int length, i;
	char *cp = instr, *dp = desc->dsc$a_pointer;

	length = desc->dsc$w_length ;			/* find length of str */
	strncpy ( instr, desc->dsc$a_pointer, length);	/* transfer string    */

	for (i = 0;i<length; i++){
	   *cp++ = toupper(*dp++);
	}
	*cp = (char)0;
}

void str_to_desc (char *instr, struct dsc$descriptor *desc)
{
	desc -> dsc$w_length = strlen(instr);
	desc -> dsc$b_class = DSC$K_CLASS_S;
	desc -> dsc$a_pointer = instr;
}
