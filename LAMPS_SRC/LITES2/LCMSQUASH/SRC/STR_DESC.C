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
