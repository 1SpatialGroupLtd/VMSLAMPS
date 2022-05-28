/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 19:06:24.000000000 +0000
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

#ifndef _PLATE_INTRINSICS
#define _PLATE_INTRINSICS

 
/*>>> EXTERN functions from PLATE.C <<<*/

/*----------------------------------------------------------------------*/
/* EXTERN plate_build_plate						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*  Platelib function to build the plate				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*  plate_id -out- the plate to build					*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS plate_build_plate(GD_PLATE *plate_id);

/*----------------------------------------------------------------------*/
/* EXTERN plate_build_colour						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*  Platelib function to build a colour descriptor for the plate	*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*  plate_colour_id -out- the plate colour id				*/
/*  colour_name     -in-  the colour name				*/
/*  red		    -in-  the amount of red in RGB			*/
/*  green	    -in-  the amount of green in RGB			*/
/*  blue	    -in-  the amount of blue in RGB			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS plate_build_colour(GD_PLATE_COLOUR *plate_colour_id,
				      GOTH_STRING     colour_name,
				      GOTH_REAL	      red,
				      GOTH_REAL       green,
				      GOTH_REAL	      blue);

/*----------------------------------------------------------------------*/
/* EXTERN plate_build_base  						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*  Platelib function to build a base for the plate			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*  plate_base_id    -out- the base id					*/
/*  base_name	     -in-  the base name				*/
/*  colour_name	     -in-  the base colour name	      			*/
/*  stipple_factor   -in-  the base stipple factor	      		*/
/*  priority	     -in-  the base priority				*/
/*  combination_type -in-  the base combination type			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS plate_build_base(GD_PLATE_BASE    *plate_base_id,
				      GOTH_STRING     base_name,
				      GOTH_STRING     colour_name,
				      GOTH_REAL	      stipple_factor,
				      GOTH_INTEGER    priority,
				      PLATE_COMB_TYPE combination_type);

/*----------------------------------------------------------------------*/
/* EXTERN plate_build_combination					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*  									*/
/*  Platelib function to create a combination				*/
/*  									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*  plate_comb_id     -out- the plate combination to build		*/
/*  combination_name  -in-  the combination name			*/
/*  base_set_id	      -in-  the combination of bases 	 		*/
/*  palette_code      -in-  the combination palette code		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS plate_build_combination(GD_PLATE_COMBINATION *plate_comb_id,
                                           GOTH_STRING	      combination_name,
					   GD_COLLECTION      base_set_id,
					   GOTH_INTEGER	      palette_code);

/*----------------------------------------------------------------------*/
/* EXTERN plate_define_colour						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*  Associates a colour id to a colour name in a plate dictionary with  */
/*  its R,G,B values							*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*  plate_id 	-in- the plate						*/
/*  colour_name -in- the colour name					*/
/*  red		-in- the red colour in RGB				*/
/*  green	-in- the green colour in RGB				*/
/*  blue        -in- the blue colour in RGB				*/
/*									*/
/*..RETURN-CODES........................................................*/
/*  									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS plate_define_colour(GD_PLATE    plate_id,
				       GOTH_STRING colour_name,
				       GOTH_REAL   red,
				       GOTH_REAL   green,
				       GOTH_REAL   blue);

/*----------------------------------------------------------------------*/
/* EXTERN plate_define_background_colour				*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*  Defines a background colour 					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*  plate_id    -in- the plate						*/
/*  colour_name -in- the colour name for the background			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*  									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS plate_define_background_colour(GD_PLATE    plate_id,
						  GOTH_STRING colour_name);

/*----------------------------------------------------------------------*/
/* EXTERN plate_define_base						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*  Platelib function to define a base					*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*  plate_id 	      -in- the plate id					*/
/*  base_name         -in- the base name				*/
/*  colour_name       -in- the base colour				*/
/*  stipple_factor    -in- the base stipple factor			*/
/*  priority 	      -in- the base priority				*/
/*  combination_type  -in- the base combination type			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS plate_define_base  (GD_PLATE        plate_id,
				       GOTH_STRING     base_name,
				       GOTH_STRING     colour_name,
				       GOTH_REAL       stipple_factor,
				       GOTH_INTEGER    priority,
				       PLATE_COMB_TYPE combination_type);

/*----------------------------------------------------------------------*/
/* EXTERN plate_define_combination					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*  Platelib function to define a combination				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/*									*/
/*  plate_id         -in- the plate id					*/
/*  combination_name -in- the combination name				*/
/*  base_set_id      -in- the combination set id			*/
/*  palette_code     -in- the combination palette code			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS plate_define_combination(GD_PLATE 	  plate_id,
				            GOTH_STRING   combination_name,
				            GD_COLLECTION base_set_id,
					    GOTH_INTEGER  palette_code);

/*----------------------------------------------------------------------*/
/* EXTERN plate_get_table						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*  Returns the palette table for all possible combinations of the  	*/
/*  bases in a plate session						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/*  plate_id    -in-  the plate holding the table			*/
/*  table_size 	-out- the table size					*/
/*  table    	-out- the table						*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*  GOTH__ERROR  Invalid combination collection				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  plate_get_table(GD_PLATE 	  plate_id,
				    GOTH_INTEGER  *table_size,
				    GOTH_INTEGER  **table);

/*----------------------------------------------------------------------*/
/* EXTERN plate_generate_table						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*  Generate the colour table for all possible combinations of the  	*/
/*  bases in a plate session						*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/*  plate_id    -in- the plate holding the table			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*  GOTH__ERROR  Invalid combination collection				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  plate_generate_table(GD_PLATE 	plate_id);

/*----------------------------------------------------------------------*/
/* EXTERN plate_print_table						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*  Print the colour table for a plate session				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/*  plate_id    -in- the plate holding the table			*/
/*  print_style -in- the style in which to print the table		*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  plate_print_table(GD_PLATE 	        plate_id,
				      PLATE_PRINT_STYLE print_style);

/*----------------------------------------------------------------------*/
/* EXTERN plate_show_base						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*  Show the base table for a plate session				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/*  plate_id    -in- the plate holding the table			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*  GOTH__ERROR  Invalid combination collection				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  plate_show_base(GD_PLATE plate_id);

/*----------------------------------------------------------------------*/
/* EXTERN plate_show_background						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*  Show the background colour for a plate session			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/*  plate_id    -in- the plate holding the table			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*  GOTH__ERROR  Invalid combination collection				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  plate_show_background(GD_PLATE plate_id);

/*----------------------------------------------------------------------*/
/* EXTERN plate_show_colour						*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*  Show the colour table for a plate session				*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/*  plate_id    -in- the plate holding the table			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*  GOTH__ERROR  Invalid combination collection				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  plate_show_colour(GD_PLATE plate_id);

/*----------------------------------------------------------------------*/
/* EXTERN plate_show_combination					*/
/*......................................................................*/
/*..DESCRIPTION.........................................................*/
/*									*/
/*  Show the combination table for a plate session			*/
/*									*/
/*..ARGUMENTS...........................................................*/
/* 									*/
/*  plate_id    -in- the plate holding the table			*/
/*									*/
/*..RETURN-CODES........................................................*/
/*									*/
/*  GOTH__NORMAL Normal,successful completion.				*/
/*  GOTH__DESC   A descriptor is corrupt or of the wrong type.		*/
/*  GOTH__MALLOC No more virtual memory to allocate.                    */
/*  GOTH__ERROR  Invalid combination collection				*/
/*									*/
/*----------------------------------------------------------------------*/

extern GOTH_STATUS  plate_show_combination(GD_PLATE plate_id);



#endif

/* $Header: /gothic/hdr/platelib/v1-0/RCS/hdr.plate_intrinsics.h,v 1.1 1994/05/03 15:11:40 davidm Exp $								*/
/* 									*/
/* $Log: hdr.plate_intrinsics.h,v $
 * Revision 1.1  1994/05/03  15:11:40  davidm
 * Version v1-0 derived from root
 * Initial development.
 * WICC 284.
 *								*/
