
#include <stdio.h>
#include <decw$include/Xlib.h>
#include <decw$include/Xutil.h>
#include <decw$include/cursorfont.h>

/* text.c - a toy program to draw some Xlib text */
Display *dpy;
Screen  *screen;
Window  win, win2;
GC      gc;
char rubbish[20];
XGCValues  xgcv;
XSetWindowAttributes xswa;
XEvent event;
XColor exact_col, scr_col;
unsigned long background;

XColor col_str;

main()
{
  unsigned long cols[20];
  int x=80,  y=0;
  int oldx=x, oldy=y;
  int dx=40, dy=40;
  int i=0;

  int winx=200, winy=200;    /* window top left corner  */
  int winh=400, winw=400;    /* window height and width */

  int win2x=600, win2y=400;
  int win2w=400, win2h=400;

  int no_events;
  unsigned int r=1,g=1,b=1;
  int curs_ind=0;
  int  num_cursors=154;

  Cursor rectcursor;
  Cursor all_cursors[155];

  Font font;
  char message[]="Some Text in the Default Font";

  char mybit[]=
    {
      0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
      0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0x00,
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff
    };

  Pixmap pixmap;

   dpy = XOpenDisplay("lslvsb::0.0");
   if (!dpy)
     {
       printf("XOpenDisplay failed\n");
       exit(1);
     };
   screen = XDefaultScreenOfDisplay(dpy);

  XSynchronize(dpy,1);

  /* Allocate some colours in the colour table */
  i=0;
  for( r=0 ; r<=1 ; r++ )
    {
      col_str.flags=DoRed | DoGreen| DoBlue;
      for ( g=0; g<=1 ; g++ )
	{
	  for ( b=0; b<=1 ; b++ )
	    {
	      col_str.red   = r*64000;
	      col_str.green = g*64000;
	      col_str.blue  = b*64000;
	      if (XAllocColor(dpy, XDefaultColormapOfScreen(screen), &col_str))
		cols[i]=col_str.pixel;
	      else
		printf("XAllocColor failed\n");

	      printf("Allocating colour %d as %d to red=%d,gr=%d,bl=%d\n",
		     i,col_str.pixel,r,g,b);
	      i++;
	    }
	}




    }
      
/*  if ( XAllocNamedColor(dpy, XDefaultColormapOfScreen(screen),
			  "firebrick", &scr_col, &exact_col))
     background=scr_col.pixel;
   else
     printf("XAllocNamedColour Failed\n");
*/
   win = XCreateSimpleWindow(dpy, XRootWindowOfScreen(screen),
			     winx, winy, winw, winh,50,
			     XBlackPixelOfScreen(screen),
			     background);
/*			     XWhitePixelOfScreen(screen) );*/

   win2 = XCreateSimpleWindow(dpy, XRootWindowOfScreen(screen),
			     win2x, win2y, win2w, win2h,50,
			     XBlackPixelOfScreen(screen),
			     XWhitePixelOfScreen(screen));

   pixmap = XCreatePixmapFromBitmapData(dpy, win, mybit, 64, 8,
					0,3,XDefaultDepthOfScreen(screen));
   XSetWindowBackgroundPixmap(dpy,win,pixmap);


   rectcursor = XCreateFontCursor(dpy, XC_trek);
   XDefineCursor(dpy, win, rectcursor);

   xswa.event_mask= StructureNotifyMask | ButtonPressMask;


   XChangeWindowAttributes(dpy, win, CWEventMask, &xswa);
   
   XMapWindow(dpy,win);
   XMapWindow(dpy,win2);

  font=XLoadFont(dpy,"*-ITC Avant Garde Gothic-Book-O-Nor*-18-*-*-*-*-*-*-*");

   gc  = XCreateGC(dpy,win,0,&xgcv);
   XSetLineAttributes(dpy, gc, 30, LineDoubleDash,0, 0);

  XSetFont(dpy, gc, font);


   while (i++<5000)
     {
       XDrawString(dpy, win, gc, 40,40, message, strlen(message));

       XSetForeground(dpy, gc, cols[i%8]);
       XSetBackground(dpy, gc, cols[(7-(i%8))]);
       XCopyPlane(dpy, win, win2, gc, 0,0, win2w, win2h, 0,0, 1);

       XFlush(dpy);

       no_events=XEventsQueued(dpy, QueuedAlready);
       if (no_events > 0)
	 {
	   XnextEvent(dpy,&event);

	   if (event.type==ButtonPress)
	     {
	       printf("Got a button press event\n");
	       switch (event.xbutton.button)
		 {
		 case (Button1):
		   curs_ind = (curs_ind+2) % num_cursors;
		   break;
		 case (Button2):
		   i=40000;
		   break;
		 case (Button3):
		   curs_ind-=2;
		   if (curs_ind < 0)
		     curs_ind=num_cursors-2;
		   break;
		 }
	       printf("curs_ind=%d\n", curs_ind);
	       XFreeCursor(dpy,rectcursor);
	       rectcursor = XCreateFontCursor(dpy, curs_ind);
	       XDefineCursor(dpy, win, rectcursor);
	     }
	   else
	     printf("Got an event, of type %d\n",event.type);
	     

	   if (event.type==ConfigureNotify)
	     {
	       winw = event.xconfigure.width;
	       winh = event.xconfigure.height;
	       printf("Resizing window to w=%d, h=%d\n",winw,winh);
	     };
	 };
	   
    };
   XFlush(dpy);

   XCloseDisplay(dpy);

   sys$exit(1);
}


