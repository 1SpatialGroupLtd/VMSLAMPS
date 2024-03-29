/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1989-12-20 16:00:42.000000000 +0000
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
#ifdef VMS
#include <decw$include:X.h>
#include <decw$include:Xlib.h>
#include <decw$include:Xutil.h>
#else
#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#endif

#include <stdio.h>

main()
{
   Display      *display;
   XVisualInfo  *vinfo_ret, vinfo_template;
   Visual       *def_vinfo;

   long         vinfo_mask;
   int          nitems_ret;
   int          i;
   char         *vis_type;

   display = XOpenDisplay(0);
   if ( display == NULL)
   {
      printf("XOpenDisplay Failed\n");
      exit(1);
   }
   def_vinfo = XDefaultVisualOfScreen(XDefaultScreenOfDisplay(display));
   
   vinfo_mask = VisualNoMask;
   
   vinfo_ret=XGetVisualInfo(display, vinfo_mask, &vinfo_template, &nitems_ret);

   printf("No. visuals = %d\n\n", nitems_ret);

   for (i=0; i<nitems_ret; i++)
   {
     
     if ( vinfo_ret->visualid == def_vinfo->visualid)
       printf("This is the default visual of default screen !!\n");
     printf("bits per rgb:         %d\n", vinfo_ret->bits_per_rgb);
     printf("colour map size:      %d\n", vinfo_ret->colormap_size);
     printf("blue mask:          0x%x\n", vinfo_ret->blue_mask);
     printf("green mask:         0x%x\n", vinfo_ret->green_mask);
     printf("red mask:           0x%x\n", vinfo_ret->red_mask);
     switch( vinfo_ret->class )
       {
       case (StaticGray):vis_type = "StaticGrey";break;
       case (StaticColor):vis_type = "StaticColour";break;
       case (TrueColor):vis_type = "TrueColour";break;
       case (GrayScale):vis_type = "GreyScale";break;
       case (PseudoColor):vis_type = "PseudoColour";break;
       case (DirectColor):vis_type = "DirectColour";break;
       default: vis_type = "unknown";
       }
     printf("class:                %s\n", vis_type);
     printf("depth:                %u\n", vinfo_ret->depth);
     printf("screen:               %d\n\n", vinfo_ret->screen);
     
     vinfo_ret++;
   }
   
}
