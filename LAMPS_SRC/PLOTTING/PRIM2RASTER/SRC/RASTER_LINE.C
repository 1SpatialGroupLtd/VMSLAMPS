/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1990-02-04 15:10:54.000000000 +0000
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
#module raster_line "04FE90"

/*	Copyright Laser-Scan Laboratories Ltd, Cambridge CB4 4FY, England  */

/*	Module description
	This module contains a routine to draw a horizontal line
*/

void raster_horz_line(x0,x1,y,v,buffer,b_width,b_height)
/* Routine that draws a single pixel line from pixel (x0,y) to pixel (x1,y)
into an array of char. Each pixel on the line is set to value v. Pixel (0,0) 
is the top left hand corner of the array. The array address is given by 
buffer, and is b_width pixels wide and b_height pixels high. */
int	x0,x1,y,b_width,b_height;
char	*buffer,v;
{
   char *ptr;
   int	x;

   if ( y<0 || y>=b_height ) return;

   ptr = buffer+(b_height-1-y)*b_width;

   for (x=x0;x<=x1;x++)
   {
      if ( x>=0 && x<b_width) *(ptr+x) = v;
   }
}
