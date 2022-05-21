/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1989-08-04 12:13:08.000000000 +0100
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
 * tricol.c  - draws a  XWindows colour triangle.
 *                 
 ******************************************************/

#define MAXPLANES 8
#define NUM_TRIS 256  /* the number of triangles needed */
                      /* this should be 2^number of planes */
struct tri
{
  float          x1,y1;  /* The x,y position of a vertex */
  float          x2,y2;  /*  "   "     "       "    "    */
  float          x3,y3;  /*  "   "     "       "    "    */
  unsigned int pixval;    /* The pixel value displayed in this triangle      */
                          /* For an eight plane machine this should be < 256 */
};
struct tri   triangles[NUM_TRIS];

int winx=200, winy=200, winw=500, winh=500;
int    depth = 1; /* the depth to which we have descended        */
                  /* ie how many level of breakdown we have had. */
int next_free=0 ; /* holds the location of the next free cell in triangles */
int num_planes;  /* the number of bit planes we have on this display */
float side_len=1;
float red_x,red_y, grn_x,grn_y, blu_x, blu_y;

Display *dpy;
Window   win;
GC       gc;   /* the graphics context used for filling the triangles */
XPoint   points[3]; /* used to hold the three pont fedto 'draw polygon' */
Colormap mycolourmap;
Colormap defaultcolourmap;
Pixmap   pixmap;
XEvent   event;
XSetWindowAttributes xswa;
Screen  *scr;
Visual   visual_struc;

main()
{


  char rubbish[30];

  initialiseX( &scr, &dpy);

  XSynchronize(dpy,1);

  win = XCreateWindow(dpy, XRootWindowOfScreen(scr),
		      winx, winy, winw, winh, 50, 8, InputOutput,
		      &visual_struc,
		      0, &xswa);

  XMapWindow(dpy,win);

  num_planes = XPlanesOfScreen(scr);
  printf("This machine has %d planes\n", num_planes);
  
  pixmap = XCreatePixmap(dpy, win, winw, winh, num_planes);

  defaultcolourmap = XDefaultColormapOfScreen(scr);
  mycolourmap=XCreateColormap(dpy, win, XDefaultVisualOfScreen(scr), AllocAll);
  XSetWindowColormap(dpy, win, mycolourmap);

  xswa.event_mask= StructureNotifyMask |ButtonPressMask| ExposureMask;
  XChangeWindowAttributes(dpy, win, CWEventMask, &xswa);

  drawtriang(scr, dpy, pixmap, num_planes);


  XFlush(dpy);
  HandleEvents();

  XSetWindowColormap(dpy, win, defaultcolourmap);

}

initialiseX( scr_ptr, dpy_ptr)
Screen  **scr_ptr;
Display **dpy_ptr;
{
  *dpy_ptr = XOpenDisplay(0);
  if ( !(*dpy_ptr) )
    {
      printf("XOpenDisplay failed\n");
      exit(1);
    };

  *scr_ptr = XDefaultScreenOfDisplay(*dpy_ptr);

}


drawtriang( dt_scr, dt_dpy, dt_win, planes)
Screen  *dt_scr;
Display *dt_dpy;
Window  dt_win;
int planes;
{
  int          num_triangles = 0;


  XGCValues xgcv;
  int i=0;

  xgcv.foreground = XBlackPixelOfScreen(dt_scr) ;
  xgcv.background = XWhitePixelOfScreen(dt_scr);
  xgcv.function   = GXcopy;
  xgcv.plane_mask = 0xff;


  gc = XCreateGC(dt_dpy, dt_win, GCForeground | GCBackground | GCFunction 
                                                      |GCPlaneMask ,&xgcv);
  

  XSetLineAttributes(dt_dpy, gc, 2, LineSolid,0,0);  
  XSetForeground(dpy, gc, XBlackPixelOfScreen(scr));
  XFillRectangle(dpy, pixmap, gc,0,0, winw, winh);

  num_triangles=1;
  for (i=0; i<planes; i++)
      num_triangles = num_triangles * 2;
  printf("%d triangles\n",num_triangles);

  /*
   *  Set up the first triangle 
   */

  triangles[0].x1 = 0;
  triangles[0].y1 = 0;
  triangles[0].x2 = 1;
  triangles[0].y2 = 0;
  triangles[0].x3 = 0.5;
  triangles[0].y3 = 1;     /* use 0.866 for equilateral tri' in square window*/
  triangles[0].pixval = 0; /* sod this ! we don't need it */
  
  red_x=triangles[0].x1;
  red_y=triangles[0].y1;
  grn_x=triangles[0].x2;
  grn_y=triangles[0].y2;
  blu_x=triangles[0].x3;
  blu_y=triangles[0].y3;



  next_free = 1;

  split_triangle( 0 ); /* split up the first big triangle */
                       /* and this recursively splits up  */
                       /* the smaller ones                */

  /*
   * Now we the array triangles shjould contain a list of all the little
   * triangles. So now it's time to fill them in.
   */
  

  for (i=0; i<num_triangles; i++)
    {
      double temp;
      unsigned int r,g,b;
      XColor   color_def;
      float x_cen,y_cen;

      points[0].x = triangles[i].x1*winw;
      points[0].y = triangles[i].y1*winh;
      points[1].x = triangles[i].x2*winw;
      points[1].y = triangles[i].y2*winh;
      points[2].x = triangles[i].x3*winw;
      points[2].y = triangles[i].y3*winh;


      x_cen= (triangles[i].x1+triangles[i].x2)/2;
      x_cen= (triangles[i].x3+   x_cen       )/2;
      y_cen= (triangles[i].y1+triangles[i].y2)/2;
      y_cen= (triangles[i].y3+   y_cen       )/2;

      temp = 1-(dist(x_cen, grn_x, y_cen, grn_y)/side_len);
      temp = (double)perp_dist(x_cen, y_cen, blu_x, blu_y, red_x, red_y);
      restrict0_1(&temp);
      g=(int)(temp*65535);

      temp = 1-(dist(x_cen, red_x, y_cen, red_y)/side_len);
      temp = (double)perp_dist(x_cen, y_cen, blu_x, blu_y, grn_x, grn_y);
      restrict0_1(&temp);
      r=(int)(temp*65535);

      temp = 1-(dist(x_cen, blu_x, y_cen, blu_y)/side_len);
      temp = (double)perp_dist(x_cen, y_cen, red_x, red_y, grn_x, grn_y);
      restrict0_1(&temp);
      b=(int)(temp*65535);
      
      if (g>=b && g>=r)
	{
	  b=b*65535/g;
	  r=r*65535/g;
	  g=65535;
	}
      else if (b>=r && b>=g)
	{
	  g=g*65535/b;
	  r=r*65535/b;
	  b=65535;
	}
      else if (r>=b && r>=g)
	{
	  b=b*65535/r;
	  g=g*65535/r; 
	  r=65535;
	};

      color_def.pixel=i;
      color_def.red  =r;
      color_def.blue =b;
      color_def.green=g;
      color_def.flags=DoRed|DoGreen|DoBlue;

      XStoreColor(dpy, mycolourmap, &color_def);
      printf("Stored colour %d as (def-rgb)(rgb) %d,%d,%d\n",color_def.pixel,color_def.red,color_def.green,color_def.blue);
      XSetForeground(dpy, gc, i);

      XFillPolygon(dpy, dt_win, gc, points, 3, Convex, CoordModeOrigin);
      XCopyArea(dpy, dt_win, win, gc, 0,0,winw, winh,0,0);

     /* XDrawLine( dt_dpy, dt_win, gc,
		(int)(triangles[i].x1*winw), (int)(triangles[i].y1*winh),
		(int)(triangles[i].x2*winw), (int)(triangles[i].y2*winh));
      XDrawLine( dt_dpy, dt_win, gc,
		(int)(triangles[i].x2*winw), (int)(triangles[i].y2*winh),
		(int)(triangles[i].x3*winw), (int)(triangles[i].y3*winh));
      XDrawLine( dt_dpy, dt_win, gc,
		(int)(triangles[i].x3*winw), (int)(triangles[i].y3*winh),
		(int)(triangles[i].x1*winw), (int)(triangles[i].y1*winh));
      */
      }

}

split_triangle(tri_num)
int tri_num;
{
  int sav_nxt;
  float tmp_x1, tmp_y1, tmp_x2, tmp_y2, tmp_x3, tmp_y3;

/*      XDrawLine( dpy, win, gc,
	 (int)(triangles[tri_num].x1*winw), (int)(triangles[tri_num].y1*winh),
	 (int)(triangles[tri_num].x2*winw), (int)(triangles[tri_num].y2*winh));
      XDrawLine( dpy, win, gc,
	(int)(triangles[tri_num].x2*winw), (int)(triangles[tri_num].y2*winh),
	(int)(triangles[tri_num].x3*winw), (int)(triangles[tri_num].y3*winh));
      XDrawLine( dpy, win, gc,
	(int)(triangles[tri_num].x3*winw), (int)(triangles[tri_num].y3*winh),
	(int)(triangles[tri_num].x1*winw), (int)(triangles[tri_num].y1*winh));
*/  /*
   *  First find the four triangles that this one can be broken up into.
   *  Replace this array cell with the middle small triangle and add the
   *  other three small triangles to the array.
   */
  triangles[next_free].x1 = triangles[tri_num].x1;
  triangles[next_free].y1 = triangles[tri_num].y1;
  triangles[next_free].x2 = (triangles[tri_num].x1+triangles[tri_num].x2)/2 ;
  triangles[next_free].y2 = (triangles[tri_num].y1+triangles[tri_num].y2)/2;
  triangles[next_free].x3 = (triangles[tri_num].x1+triangles[tri_num].x3)/2;
  triangles[next_free].y3 = (triangles[tri_num].y1+triangles[tri_num].y3)/2;

  next_free++;

  triangles[next_free].x1 = triangles[tri_num].x2;
  triangles[next_free].y1 = triangles[tri_num].y2;
  triangles[next_free].x2 = (triangles[tri_num].x1+triangles[tri_num].x2)/2 ;
  triangles[next_free].y2 = (triangles[tri_num].y1+triangles[tri_num].y2)/2;
  triangles[next_free].x3 = (triangles[tri_num].x2+triangles[tri_num].x3)/2;
  triangles[next_free].y3 = (triangles[tri_num].y2+triangles[tri_num].y3)/2;

  next_free++;

  triangles[next_free].x1 = triangles[tri_num].x3;
  triangles[next_free].y1 = triangles[tri_num].y3;
  triangles[next_free].x2 = (triangles[tri_num].x3+triangles[tri_num].x2)/2 ;
  triangles[next_free].y2 = (triangles[tri_num].y3+triangles[tri_num].y2)/2;
  triangles[next_free].x3 = (triangles[tri_num].x1+triangles[tri_num].x3)/2;
  triangles[next_free].y3 = (triangles[tri_num].y1+triangles[tri_num].y3)/2;

  next_free++;

  tmp_x1 = triangles[tri_num].x1;
  tmp_y1 = triangles[tri_num].y1;
  tmp_x2 = triangles[tri_num].x2;
  tmp_y2 = triangles[tri_num].y2;
  tmp_x3 = triangles[tri_num].x3;
  tmp_y3 = triangles[tri_num].y3;

  triangles[tri_num].x1 = (tmp_x1+tmp_x2)/2;
  triangles[tri_num].y1 = (tmp_y1+tmp_y2)/2;
  triangles[tri_num].x2 = (tmp_x1+tmp_x3)/2;
  triangles[tri_num].y2 = (tmp_y1+tmp_y3)/2;
  triangles[tri_num].x3 = (tmp_x2+tmp_x3)/2;
  triangles[tri_num].y3 = (tmp_y2+tmp_y3)/2;



  depth++;
printf("depth - %d,  ",depth);


  if (depth > num_planes/2)
    {
      depth--;
      return;
    };

  sav_nxt=next_free;    
  split_triangle(tri_num);
  split_triangle(sav_nxt-1);
  split_triangle(sav_nxt-2);
  split_triangle(sav_nxt-3);

  depth--;
  return;

}



double dist(x1,x2,y1,y2)
float x1,y1,x2,y2;
{
  double temp;
  temp= (sqrt( (double) ((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1)) ));
  return(temp);
}


restrict0_1(val)
double *val;
{
  if (*val>1)
    *val=1;
  else if (*val<0)
    *val=0;

  return;
}



double perp_dist( xj, yj, xk,yk, xl,yl)
float xj,yj, xk,yk, xl,yl;
{
  float t,retval;
  float dx,dy;

  dx = xl-xk;
  dy = yl-yk;

  t = (-(yk-yj)*(yl-yk)-(xk-xj)*(xl-xk)) / ( dx*dx + dy*dy );

  retval=sqrt( (xk-xj + t*dx)*(xk-xj + t*dx) + (yk-yj + t*dy )*(yk-yj+t*dy));
  return (retval);
}

HandleEvents()
{
  int num_events;
  
  while(1)
    {
      num_events = XEventsQueued(dpy, QueuedAlready);
/*      if (num_events>0)*/
	{
	  XWindowEvent(dpy,win, ExposureMask| StructureNotifyMask 
		       | ButtonPressMask,&event);
	  printf("Got event type - %d.",event.type);

	  if ((event.type == ButtonPress) && (event.xbutton.button==Button2))
	    XUnmapWindow(dpy,win);
	  else if (event.type==ConfigureNotify)
	    {
	      printf("configure notify event\n");
	      winw= event.xconfigure.width;
	      winh= event.xconfigure.height;
	      XFreePixmap(dpy,pixmap);
	      pixmap=XCreatePixmap(dpy,win,winw,winh,num_planes);
	      XSetForeground(dpy, gc, XBlackPixelOfScreen(scr));
	      XFillRectangle(dpy, pixmap,gc, 0,0 ,winw,winh);
       	      drawtriang(scr,dpy,pixmap,num_planes);
	    }
	  else if (event.type==Expose)
	    XCopyArea(dpy, pixmap, win, gc, 0,0,winw, winh,0,0);

	  else 
	    printf("Unrecognised event\n");
        }
    }
}
