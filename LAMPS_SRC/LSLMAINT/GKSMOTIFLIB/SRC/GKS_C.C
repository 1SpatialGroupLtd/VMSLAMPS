/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 2001-10-17 12:03:22.000000000 +0100
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

#module GKS_C "17OC01"

/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Clarke Brunt, 16-Jan-1990					*/
/************************************************************************/

/************************************************************************/
/*									*/
/*				 G K S 					*/
/*									*/
/************************************************************************/

#include <stdio.h>		/* standard i/o header */
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <Mrm/MrmAppl.h>	/* Motif */
#include <Xm/DrawingA.h>
#include <Xm/Atommgr.h>
#include <Xm/Protocols.h>
#include <Xm/BulletinB.h>
#include <Xm/PushB.h>
#include <lsl$library:lsldef.h>	/* standard LSL header  */

extern void _XFlushGCCache();
extern void XSelectAsyncInput();
extern void GUIS_EXPOSE();
extern void GUIS_BUTTON();
extern void GUIS_MOTION();
extern void GUIS_TRACK();
extern void GUIS_EVENT();
extern void GUIS_FOCUS();
extern void GUIS_MENU();
extern void GUIS_SETAST();
static void setup_ast();
static void event_ast();

/* allow Fortran overlay of common onto this structure */
extern struct {
   int ast_on;
   int in_ast;
} GKS_AST;

static Display *display;
static XtAppContext app_context;
static XtTranslations t_table_1=NULL;
static XtTranslations t_table_2=NULL;
static XtTranslations t_table_3=NULL;
static XtTranslations t_table_null=NULL;

typedef	struct _fnt Fnt;
struct _fnt {
   int	size;
   Font	id;
};
static Fnt *fptr=NULL;
static int fcnt=0;
static char *family=NULL;

/*----------------------------------------------------------------------*/
/* EXTERN GOPKS_C							*/
/*......................................................................*/
/*									*/
/* Perform C part of open GKS						*/
/*----------------------------------------------------------------------*/

extern void GOPKS_C(Widget *xtop,
		    Display **xdisplay,
		    Screen **xscreen)
{
   XtActionsRec action[] = {
      {"BUTTON",GUIS_BUTTON},
      {"MOTION",GUIS_MOTION},
      {"TRACK",GUIS_TRACK},
      {"EVENT",GUIS_EVENT},
      {"FOCUS_EVENT",GUIS_FOCUS}
   };
   int argc=1;
   char *argv="Graphics";
   *xtop = XtAppInitialize(&app_context,"LSLGKS",NULL,0,&argc,&argv,
			   NULL,NULL,0);
   display = XtDisplay(*xtop);
   *xdisplay = display;
   *xscreen = XtScreen(*xtop);
   XtAppAddActions(app_context,action,5);
   GKS_AST.ast_on = 0;
   GKS_AST.in_ast = FALSE;
}

/*----------------------------------------------------------------------*/
/* EXTERN GOPKS2_C							*/
/*......................................................................*/
/*									*/
/* Perform another C part of open GKS					*/
/* This function is supposed to be private to X, but XLIB Programming	*/
/* gives it as the way to update the function pointers in an image	*/
/* structure after changing the byte/bit order				*/
/*----------------------------------------------------------------------*/

extern void GOPKS2_C(XImage *ximage)
{
/* routine not available before MOTIF 1.2 */
/*   _XInitImageFuncPtrs(ximage); */
}

/*----------------------------------------------------------------------*/
/* EXTERN GOPWK_C							*/
/*......................................................................*/
/*									*/
/* Perform C part of open workstation					*/
/*----------------------------------------------------------------------*/

extern void GOPWK_C(int *dev,
		    int *px,
		    int *py,
		    int *sx,
		    int *sy,
		    char *title,
		    int *border,
		    int *events,
		    Widget *dcb,
		    Window *swindow,
		    Widget *wcb,
		    Window *window)
{
   int narg;
   Arg arglist[5];
   XtCallbackRec callback[2];
   Atom	proto_atom;

/* Create a application shell widget */
   GKS_AST.ast_on++;
   *dcb = XtAppCreateShell(title,"LSLGKS",
				      applicationShellWidgetClass,display,
				      NULL,0);
   
/* accept TAKE_FOCUS client message in it */
   if (!t_table_3) t_table_3 = XtParseTranslationTable(
"<Message>:FOCUS_EVENT()" );
   narg = 0;
   XtSetArg(arglist[narg],XmNtranslations,t_table_3);narg++;
   XtSetValues(*dcb,arglist,narg);

/* Create a window box widget */
   callback[0].callback = GUIS_EXPOSE;
   callback[0].closure = (void *)*dev;
   callback[1].callback = NULL;
   narg = 0;
   XtSetArg(arglist[narg],XmNwidth,*sx);narg++;
   XtSetArg(arglist[narg],XmNheight,*sy);narg++;
   XtSetArg(arglist[narg],XmNexposeCallback,callback);narg++;
   *wcb = XmCreateDrawingArea(*dcb,"Window name",arglist,narg);

/* add events */
   if (*events)
   {
/* this table is for LITES2 behaviour - track cursor on button 1 down
   and motion while it is down */
      if (!t_table_1) t_table_1 = XtParseTranslationTable(
"<Btn1Down>:MOTION()\n\
<Btn1Motion>:MOTION()\n\
<BtnDown>:BUTTON()\n\
<Message>:EVENT()" );
/* Would like to use the following, but seems to access violate so... */
/*    XtOverrideTranslations(*wcb,t_table_1);			      */
      narg = 0;
      XtSetArg(arglist[narg],XmNtranslations,t_table_1);narg++;
      XtSetValues(*wcb,arglist,narg);
   }

/* Manage the window widget */
   XtManageChild(*wcb);

/* Set position of shell widget */
   narg = 0;
   XtSetArg(arglist[narg],XmNx,*px);narg++;
   XtSetArg(arglist[narg],XmNy,*py);narg++;
   
/* Set available functions and decorations */
/* Just move and minimise functions (always get lower) */
   XtSetArg(arglist[narg],XmNmwmFunctions,12);narg++;
/* Border, title, system menu, and minimise decorations */
   XtSetArg(arglist[narg],XmNmwmDecorations,*border?58:0);narg++;

/* We don't want the input focus */
   XtSetArg(arglist[narg],XmNinput,FALSE);narg++;

   XtSetValues(*dcb,arglist,narg);

/* add obscure atom to the WM_PROTOCOLS property */
/* Allows mwm not to give us the input focus */
   proto_atom = XmInternAtom(display,"WM_TAKE_FOCUS",FALSE);
/*   XmAddWMProtocols(*dcb,&proto_atom,1); where is this function? */
   XmAddProtocols(*dcb,XmInternAtom(display,"WM_PROTOCOLS",FALSE),
                  &proto_atom,1);

/* Realize the top level widget */
   XtRealizeWidget(*dcb);

   *swindow = XtWindow(*dcb);
   *window = XtWindow(*wcb);

/* set event AST on the windows */
   setup_ast(XtWindow(*dcb));
   GKS_AST.ast_on--;
}

/*----------------------------------------------------------------------*/
/* EXTERN SET_TRACK_C
/*									*/
/* Perform C part setting mouse tracking				*/
/*----------------------------------------------------------------------*/

extern void SET_TRACK_C(
		    Widget *wcb,
		    int *on)
{
   int narg;
   Arg arglist[1];

   GKS_AST.ast_on++;
/* this table is for ROVER behaviour - track cursor on button 1 down */
   if (*on) {
      if (!t_table_2) t_table_2 = XtParseTranslationTable(
"<BtnDown>:BUTTON()\n\
<Motion>:TRACK()" );
   } else {
      if (!t_table_null) t_table_null = XtParseTranslationTable("");
   }
   narg = 0;
   XtSetArg(arglist[narg],XmNtranslations,*on?t_table_2:t_table_null);narg++;
   XtSetValues(*wcb,arglist,narg);
   GKS_AST.ast_on--;
}

/*----------------------------------------------------------------------*/
/* EXTERN GCLWK_C							*/
/*......................................................................*/
/*									*/
/* Perform C part of close workstation					*/
/*----------------------------------------------------------------------*/

extern void GCLWK_C(Widget *dcb)
{
   GKS_AST.ast_on++;
   XtDestroyWidget(*dcb);
   GKS_AST.ast_on--;
}

/*----------------------------------------------------------------------*/
/* EXTERN GUIS_EXPOSE_C							*/
/*......................................................................*/
/*									*/
/* Perform C part of expose callback routine				*/
/*----------------------------------------------------------------------*/

extern int GUIS_EXPOSE_C(
			 XmDrawingAreaCallbackStruct *cb,
			 int *count,
			 int *x,
			 int *y,
			 int *width,
			 int *height
			 )
{
   if (cb->reason!=XmCR_EXPOSE) return(FALSE);
   *count = cb->event->xexpose.count;
   *x = cb->event->xexpose.x;
   *y = cb->event->xexpose.y;
   *width = cb->event->xexpose.width;
   *height = cb->event->xexpose.height;
   return(TRUE);
}

/*----------------------------------------------------------------------*/
/* EXTERN GUIS_MAIN_LOOP_C						*/
/*......................................................................*/
/*									*/
/* Perform C part of main loop routine					*/
/*----------------------------------------------------------------------*/

extern void GUIS_MAIN_LOOP_C(
			 int *wait,
			 volatile int *xevent
			 )
{
   XEvent event;

/* deal with events until there aren't any... */
   while (XtAppPending(app_context) || (!*xevent && *wait))
   {
      XtAppNextEvent(app_context,&event);
      XtDispatchEvent(&event);
   }
}

/*----------------------------------------------------------------------*/
/* EXTERN GUIS_REVEAL_VIEWPORT_C					*/
/*......................................................................*/
/*									*/
/* Perform C part of reveal viewport routine				*/
/*----------------------------------------------------------------------*/

extern void GUIS_REVEAL_VIEWPORT_C(
				   Widget *shell
				  )
{
   GKS_AST.ast_on++;
   XtPopup(*shell,0);
   GKS_AST.ast_on--;
}

/*----------------------------------------------------------------------*/
/* EXTERN GUIS_CONCEAL_VIEWPORT_C					*/
/*......................................................................*/
/*									*/
/* Perform C part of reveal viewport routine				*/
/*----------------------------------------------------------------------*/

extern void GUIS_CONCEAL_VIEWPORT_C(
				    Widget *shell
				   )
{
   GKS_AST.ast_on++;
   XtPopdown(*shell);
   GKS_AST.ast_on--;
}

/*----------------------------------------------------------------------*/
/* EXTERN MENU_CREATE_C							*/
/*......................................................................*/
/*									*/
/* Perform C part of menu create routine				*/
/*----------------------------------------------------------------------*/

extern void MENU_CREATE_C(
			  Widget *menu_shell,
			  int *x,
			  int *y,
			  int *xbox,
			  int *ybox,
			  int *w,
			  int *h,
			  int *gap,
			  char *title,
			  LSL_DESC *labels
			 )
{
   int narg;
   Arg arglist[8];
   XtCallbackRec callback[2];
   Widget dialog,button;
   int ix,iy;
   char *lab;
   Atom	proto_atom;

/* Create a application shell widget */
   GKS_AST.ast_on++;
   *menu_shell = XtAppCreateShell(title,"LSLGKS",
				      applicationShellWidgetClass,display,
				      NULL,0);

/* Create a dialog box widget */
   XtSetArg(arglist[0],XmNmarginHeight,0);
   XtSetArg(arglist[1],XmNmarginWidth,0);
   dialog = XmCreateBulletinBoard(*menu_shell,"d",arglist,2);

/* Manage the dialog box widget */
   XtManageChild(dialog);

/* Set the position of the shell */
   narg = 0;
   XtSetArg(arglist[narg],XmNx,*x);narg++;
   XtSetArg(arglist[narg],XmNy,*y);narg++;

/* Set available functions and decorations */
/* Just move and minimise functions (always get lower) */
   XtSetArg(arglist[narg],XmNmwmFunctions,12);narg++;
/* Border, title, system menu, and minimise decorations */
   XtSetArg(arglist[narg],XmNmwmDecorations,58);narg++;

/* We don't want the input focus */
   XtSetArg(arglist[narg],XmNinput,FALSE);narg++;

   XtSetValues(*menu_shell,arglist,narg);

/* add obscure atom to the WM_PROTOCOLS property */
/* Allows mwm not to give us the input focus */
   proto_atom = XmInternAtom(display,"WM_TAKE_FOCUS",FALSE);
/*   XmAddWMProtocols(*dcb,&proto_atom,1); where is this function? */
   XmAddProtocols(*menu_shell,XmInternAtom(display,"WM_PROTOCOLS",FALSE),
                  &proto_atom,1);

/* Create push button widgets */
   callback[0].callback = GUIS_MENU;
   callback[1].callback = NULL;
   narg = 0;
   XtSetArg(arglist[narg],XmNwidth,*w-2*(*gap));narg++;
   XtSetArg(arglist[narg],XmNheight,*h-2*(*gap));narg++;
   XtSetArg(arglist[narg],XmNactivateCallback,callback);narg++;
   XtSetArg(arglist[narg],XmNshadowThickness,0);narg++;
   XtSetArg(arglist[narg],XmNalignment,XmALIGNMENT_BEGINNING);narg++;
   XtSetArg(arglist[narg],XmNmarginHeight,max(0,(*h-2*(*gap)-14)/2));narg++;
   for (iy=0;iy<*ybox;iy++)
   {
      XtSetArg(arglist[narg],XmNy,iy*(*h)+*gap);
      for (ix=0;ix<*xbox;ix++)
      {
         callback[0].closure = (void *)(iy*(*xbox)+ix+1);
         XtSetArg(arglist[narg+1],XmNx,ix*(*w)+*gap);
         lab = (char *) malloc(labels->length+1);
         strncpy(lab,labels->pointer,labels->length);
         lab[labels->length] = 0;
         button = XmCreatePushButton(dialog,lab,arglist,narg+2);
         free(lab);
         labels++;
         XtManageChild(button);
      }
   }
   XtRealizeWidget(*menu_shell);

/* set event AST on the windows */
   setup_ast(XtWindow(*menu_shell));
   GKS_AST.ast_on--;
}

/*----------------------------------------------------------------------*/
/* EXTERN MENU_DELETE_C							*/
/*......................................................................*/
/*									*/
/* Perform C part of menu delete routine				*/
/*----------------------------------------------------------------------*/

extern void MENU_DELETE_C(
			 Widget *menu_shell
			 )
{
   GKS_AST.ast_on++;
   XtDestroyWidget(*menu_shell);
   GKS_AST.ast_on--;
}

/*----------------------------------------------------------------------*/
/* EXTERN GUIS_SETAST							*/
/*......................................................................*/
/*									*/
/* routine to turn on/off event AST routine				*/
/*----------------------------------------------------------------------*/

extern void GUIS_SETAST(
			int *on
			)
{
   *on?GKS_AST.ast_on--:GKS_AST.ast_on++;
}

/*----------------------------------------------------------------------*/
/* EXTERN GUPTX_C							*/
/*......................................................................*/
/*									*/
/* return a font id for a given size					*/
/*----------------------------------------------------------------------*/

extern Font GUPTX_C(
			int *size
			)
{
   char **font_names;
   char fname[100];
   char *f1="-*-";
   char *f2="-Medium-R-Normal--";
   char *f3="-*-*-*-*-*-ISO8859-1";
   int count;
   int psize;
   char *sizloc;
   char *families[]={"Terminal","Courier"};   
   int nfamily=sizeof families/sizeof(char *);
   int i,j,f;
   int err,minerr,best;

/* First get a list of what fonts there are */
   if (!fptr&&!fcnt) {
      for (f=0;f<nfamily;f++) {
         strcpy(fname,f1);
         strcat(fname,families[f]);
         strcat(fname,f2);
         strcat(fname,"*");
         strcat(fname,f3);
         GKS_AST.ast_on++;
         font_names = XListFonts(display,fname,1000,&count);
         GKS_AST.ast_on--;
         if (font_names) break;
      }
      if (!font_names) {
         fptr = (Fnt *)-1;
         return NULL;
      }
      family = families[f];
      for (i=0;i<count;i++) {
         sizloc = strstr(font_names[i],"--");
         if (sizloc) sizloc += 2;
         psize = atoi(sizloc);
         if (psize) {
            for (j=0;j<fcnt;j++) {
               if (psize==fptr[j].size) break;
            }
	    if (j==fcnt) {
	       fptr = (fptr)? realloc(fptr,(fcnt+1)*sizeof(Fnt)) :
                              malloc((fcnt+1)*sizeof(Fnt));
	       fptr[fcnt].size = psize;
	       fptr[fcnt].id = NULL;
               fcnt++;
            }
         }
      }
      GKS_AST.ast_on++;
      XFreeFontNames(font_names);
      GKS_AST.ast_on--;
   }

/* see which size is nearest to that required */
   if (!fcnt) return NULL;
   minerr = -1;
   for (j=0;j<fcnt;j++) {
      err = abs(fptr[j].size - *size);
      if (err<minerr||minerr<0) {
         minerr = err;
         best = j;
      }
   }
   if (!fptr[best].id) {
      strcpy(fname,f1);
      strcat(fname,family);
      strcat(fname,f2);
      sprintf(fname+strlen(fname),"%d",fptr[best].size);
      strcat(fname,f3);
      GKS_AST.ast_on++;
      fptr[best].id = XLoadFont(display,fname);
      GKS_AST.ast_on--;
   }
   return fptr[best].id;
}

/*----------------------------------------------------------------------*/
/* EXTERN GUPTX2_C							*/
/*......................................................................*/
/*									*/
/* flush GC cache
/*----------------------------------------------------------------------*/

extern void GUPTX2_C(
			GC *gc_ptr
			)
{
   GKS_AST.ast_on++;
   _XFlushGCCache(display,*gc_ptr);
   GKS_AST.ast_on--;
}

/*----------------------------------------------------------------------*/
/* event_ast								*/
/*......................................................................*/
/*									*/
/* routine to be called when an X event is queued			*/
/*----------------------------------------------------------------------*/

static void event_ast()
{
   if (GKS_AST.ast_on) return;
   GKS_AST.in_ast = TRUE;
   GUIS_MAIN_LOOP_C(&FALSE,&FALSE);
   GKS_AST.in_ast = FALSE;
}

/*----------------------------------------------------------------------*/
/* setup_ast								*/
/*......................................................................*/
/*									*/
/* set an AST to go off whenever there is an event in a window		*/
/*----------------------------------------------------------------------*/

static void setup_ast(
		      Window w
		      )
{
   Window	root_id_return,parent_id_return;
   Window	*children_return;
   unsigned int	num_children_return;
   int		i;

   XSelectAsyncInput(display,w,(long) -1,event_ast,0);
   if (!XQueryTree(display,w,
			&root_id_return,
			&parent_id_return,
			&children_return,
			&num_children_return)) return;

   for (i=0;i<num_children_return;i++) setup_ast(children_return[i]);
   XFree(children_return);
}

/*----------------------------------------------------------------------*/
/* EXTERN GKS_FREE							*/
/*									*/
/* Free memory, allocated in C, from FORTRAN				*/
/*----------------------------------------------------------------------*/

extern void GKS_FREE(int *inptr)
{
   if (inptr != NULL)
      free(inptr);

   inptr = NULL;
}
/*----------------------------------------------------------------------*/
/* EXTERN gks_c_get_char_bitmap                                      	*/
/*									*/
/* C jacket for textren_get_char_bitmap to be called from FORTRAN 	*/
/* passing proper datatypes						*/
/*----------------------------------------------------------------------*/

extern int gks_c_get_char_bitmap(int	ch,
				 float	rx,
	    			 float	ry,
	                         int	*bitmap,
	                         int	*width,
	                         int	*height,
				 int	*origin_x,
				 int	*origin_y)
{                                     
   /* get the bitmap for the glyph of the character			*/

    return textren_get_char_bitmap((long int)ch,
	                           (double)rx,
	                           (double)ry,
	                           (void *)bitmap,
	                           (long int *)width,
	                           (long int *)height,
	                           (long int *)origin_x,
	                           (long int *)origin_y);
}
/*----------------------------------------------------------------------*/
/* EXTERN gks_c_set_textren_font                                      	*/
/*									*/
/* C jacket for textren_set_font to be called from FORTRAN passing 	*/
/* proper datatypes   							*/
/*----------------------------------------------------------------------*/

extern int gks_c_set_textren_font(char	*fontname,
				 float	size,
	    			 float	angle)
{
   /* call the textrenlib routine with the arguments ast to the 	*/
   /* correct datatypes							*/

    return textren_set_font(fontname,
	                    (double)size,
	                    (double)angle);
}
