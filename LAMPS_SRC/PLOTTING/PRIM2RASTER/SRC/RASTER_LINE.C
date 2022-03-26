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
