/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1989-07-27 18:33:36.000000000 +0100
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
#include <stdio.h>
#include <math.h>
#include <decw$include/Xlib.h>
#include <decw$include/Xutil.h>
#include <decw$include/cursorfont.h>

double dist();
double perp_dist();
/******************************************************
 * colmap.c  - draws a  XWindows collection of rectangles that show
               how the colour map is currently set up..
 *                 
 ******************************************************/



int winx=200, winy=200, winw=500, winh=500;
int num_planes;  /* the number of bit planes we have on this display */


Display *dpy;
Window   win;
GC       gc;   /* the graphics context used for filling the triangles */
XGCValues xgcv;
XPoint   points[4]; /* used to hold the points fed to 'draw polygon' */

Colormap defaultcolourmap;
Pixmap   pixmap;
XEvent   event;
XSetWindowAttributes xswa;
Screen  *scr;

float  hunit;/* horizontal unit */
float  vunit; /* vertical  unit  */

int   gargc;
char display_name[50];

int num_rects=1;


main(argc,argv)
int argc;
char *argv[];
{
   int i;
   
   printf("argc=%d\n",argc);
   for (i=0; i<argc; i++)
      printf("argv[%d]=%s\n",i,argv[i]);
   

   gargc=argc;
   if (argc>1)
      strncpy(display_name,argv[1],50);

   printf("display_name=%s\n",display_name);
   
  initialiseX( &scr, &dpy);

  XSynchronize(dpy,1);

  win = XCreateSimpleWindow(dpy, XRootWindowOfScreen(scr),
			    winx, winy, winw, winh, 50,
			    XBlackPixelOfScreen(scr),
			    XWhitePixelOfScreen(scr));
  printf("XBlackPixelOfScreen=%d\n",XBlackPixelOfScreen(scr));
  printf("XWhitePixelOfScreen=%d\n",XWhitePixelOfScreen(scr));

  XMapWindow(dpy,win);

  num_planes = XPlanesOfScreen(scr);
  printf("This machine has %d planes\n", num_planes);
  num_rects=1;
  for (i=0; i<num_planes; i++)
      num_rects = num_rects * 2;
  printf("%d colours\n",num_rects);

  setunits(&hunit,&vunit);
  
  pixmap = XCreatePixmap(dpy, win, winw, winh, num_planes);

  defaultcolourmap = XDefaultColormapOfScreen(scr);

  xswa.event_mask= StructureNotifyMask |ButtonPressMask| ExposureMask;
  XChangeWindowAttributes(dpy, win, CWEventMask, &xswa);

  xgcv.foreground = XBlackPixelOfScreen(scr) ;
  xgcv.background = XWhitePixelOfScreen(scr);
  xgcv.function   = GXcopy;
  xgcv.plane_mask = 0xff;
/*  xgcv.fill_style = FillSolid;*/
  gc = XCreateGC(dpy, win, GCForeground| GCBackground| 
		 GCFunction |GCPlaneMask ,&xgcv);

  paintrects();

  XFlush(dpy);
  HandleEvents();


}

initialiseX( scr_ptr, dpy_ptr)
Screen  **scr_ptr;
Display **dpy_ptr;
{
   printf("initialise:gargc=%d\n",gargc);
   

  if (gargc>1)
     *dpy_ptr = XOpenDisplay(display_name);
  else
     *dpy_ptr = XOpenDisplay(0);
  
  if ( !(*dpy_ptr) )
    {
      printf("XOpenDisplay failed\n");
      exit(1);
    };

  *scr_ptr = XDefaultScreenOfDisplay(*dpy_ptr);

}

setunits(hunitp,vunitp)
float *hunitp,*vunitp;
{
  *hunitp = winw/28;
  *vunitp = winh/(1.5*num_rects/16+4);
}

paintrects()
{
int i;


  XFillRectangle(dpy, pixmap,gc, 0,0 ,winw,winh);

  for (i=0; i<num_rects; i++)
    {

      XSetForeground(dpy, gc, i);

      points[0].x=hunit*(2.5 + (i%16)*1.5 );
      points[0].y=vunit*(2.5 + (i/16)*1.5 );
      points[1].x=points[0].x+hunit;
      points[1].y=points[0].y  ;
      points[2].x=points[0].x+hunit;
      points[2].y=points[0].y+vunit;
      points[3].x=points[0].x  ;
      points[3].y=points[0].y+vunit;

      XFillRectangle(dpy, win, gc, points[0].x, points[0].y, hunit, vunit);
      XFillRectangle(dpy, pixmap, gc, points[0].x, points[0].y, hunit, vunit);

      XFillPolygon(dpy, pixmap, gc, points, 4, Convex, CoordModeOrigin);
      XFillPolygon(dpy, win, gc, points, 4, Convex, CoordModeOrigin);

      }
XCopyArea(dpy, pixmap, win, gc, 0,0,winw, winh,0,0);

}


HandleEvents()
{
  int num_events;
  
  while(1)
    {
	
      XnextEvent(dpy,&event);
      printf("Got event type - %d.",event.type);

      if ((event.type == ButtonPress) && (event.xbutton.button==Button2))
	break;
      else if (event.type==ConfigureNotify)
	{
	  printf("configure notify event\n");
	  winw= event.xconfigure.width;
	  winh= event.xconfigure.height;
	  setunits(&hunit,&vunit);
	  XFreePixmap(dpy,pixmap);
	  pixmap = XCreatePixmap(dpy, win, winw, winh, num_planes);
	  XSetForeground(dpy, gc, XBlackPixelOfScreen(scr));
	  XFillRectangle(dpy, pixmap,gc, 0,0 ,winw,winh);
	  paintrects();
	}
      else if (event.type==Expose)
	{
	  printf("Expose event\n");
	  XCopyArea(dpy, pixmap, win, gc, 0,0,winw, winh,0,0);
	}
      
      else 
	printf("Unrecognised event\n");
    }
    
}
