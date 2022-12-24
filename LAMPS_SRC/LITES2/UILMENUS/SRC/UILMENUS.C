/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1992-07-08 13:36:50.000000000 +0100
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

#module UILMENUS "08JL92"

/************************************************************************/
/*									*/
/*  Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England		*/
/*  Author    Clarke Brunt			18-Nov-1989		*/
/*									*/
/************************************************************************/


/************************************************************************/
/*									*/
/* 	Laser-Scan DECwindows menu system				*/
/*	---------------------------------				*/
/*									*/
/************************************************************************/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <unixio.h>
#include <iodef.h>
#include <ssdef.h>
#include <lsl$library:lsldef.h>
#include <lsl$library:lsldesc.h>
#include <lsl$cmnlsl:cld.h>
#include <lsl$cmnlsl:cmdcom.h>
#include <lsl$cmnlsl:lsllibmsg.h>
#include <lsl$cmnlsl:readstr.h>
#include <decw$include:MrmAppl.h>
#include <decw$include:DXmColor.h>   
#include <decw$include:FileSB.h>   
#include <decw$include:List.h>
#include <decw$include:SelectioB.h>
#include <decw$include:ToggleB.h>
#include <decw$include:stringdefs.h>
#include <decw$include:cursorfont.h>
/* for XmAddWmProtocols */
#include <decw$include:protocols.h>

extern void UIL_CMD_TABLE();
extern void CHOICE_CMD_TABLE();
extern void CREATE_CMD_TABLE();
extern void UILMEN_CLD();
extern void lsl_init();
extern int readstr();
extern int rdcomm();
extern int rdchs();
extern void setaux();
extern void dcpsav();
extern void lsl_putmsg();
extern int dcl_startup();
extern int dcl_file();
extern int dcl_qual();
extern int dcl_str();
extern void set_ctrlc_ast();

typedef	struct _wotsit Wotsit;	/* new datatype to describe a menu */
typedef	struct _toggle Toggle;	/* new datatype to describe a toggle */
typedef	struct _item Item;	/* new datatype to describe a widget */

struct _wotsit {
   char		*name;
   Widget	widget;
   char		*control;
   Wotsit	*sibling;
   Wotsit	*child;
};

enum _toggle_type {GROUP=1,RADIO,OPTION};

struct _toggle {
   Widget	widget;
   Widget	parent_widget;
   int		group;
   enum _toggle_type type;
   int		on;
   Toggle	*next;
};

enum _item_type {
   BUTTON=1,TOGGLE,LIST,OPTION_MENU,SCALE,TEXT,LABEL,
   SEPARATOR,RADIO_BOX,BAR,MENU,COMMAND,CASCADE
};

struct _item {
   char		*name;
   enum _item_type type;
   Widget	widget;
   Item		*lss;
   Item		*gtr;
};

/* callback routines */
static void do_proc();	   /* activate etc. callbacks */

static void choice_proc(); /* create callback for toggles */
static void zap_help_proc(); /* create callback for select box */
static void create_proc(); /* general create callback */
static void list_create(); /* create callback for list box */
static void toggle_proc(); /* internal value changed callback */

static void command_proc();/* command window command entered */
static void file_proc();   /* file select activated */
static void list_proc();   /* list box single callback */
static void scale_proc();  /* scale value changed */
static void select_proc(); /* selection activated */
static void text_proc();   /* simple text value changed */
static void color_proc();  /* colormix select activated */

/* internal routines */
static void input_proc();  /* input available callback */
static void do_display();
static void do_add();
static Wotsit *do_fetch();
static void do_remove();
static void do_position();
static void do_scale();
static void do_prompt();
static void do_list();
static void do_text();
static void do_file();
static void do_label();
static void do_color();
static void do_subs(
   Widget w,char *string,XmAnyCallbackStruct *reason,char *value);
static void do_command(
   Widget w,int command,XmAnyCallbackStruct *reason);
static int widget_is_on(Widget w,XmAnyCallbackStruct *reason);
static void get_dcl();
static void init(int argc,char **argv);
static void fetch_widget(Wotsit *wptr);
static void write_output();
static void write_abort();
static Wotsit *add_wotsit(char *name,char *parent,char *control);
static Wotsit *lookup_name(char *name,Wotsit *ptr,int create);
static Item *lookup_item(char *name,int create);
static int is_visible(char *name,Wotsit *ptr);
static void set_all_toggles(Widget w,char *name,int on);
static void reset_all_toggles(Widget w,char *name);
static void set_toggle(Widget w,int on);
static char *get_string(XmString string);
static void start_input();
static void ctrlcast();

static Wotsit toplevel_wotsit = {"none",0,0,0,0};
static Toggle *toggle_ptr = NULL;
static Item *item_ptr = NULL;
static Widget toplevel;                 /* top level shell widget */
static Widget topwidget;		/* top level dialog box */
static MrmHierarchy s_DRMHierarchy;     /* DRM database hierarchy ID */
static MrmType *dummy_class;            /* and class variable. */

static char combuf[512];
static strdesc(comdsc,combuf);
static XtAppContext app_context;
static Cursor watch_cursor;
static Display *xdisplay;
static Screen *xscreen;
static int do_commands;
static int uid_numfil;
static char **uid_file_vec;
static char *output_file;
static char *input_file = NULL;
static char *symbol_name;
static char *logical_name;
static char *class_name;
static char *abort_file = NULL;
static strdesc(lnm_table,"LNM$JOB");
static char *command_string = NULL;
static FILE *output_stream, *abort_stream;
static short iosb[4];
#define IEFN 1
static char ibuf[256];
static short ichan;
static int ierr;

/* The names and addresses of things that DRM has to bind */
static MrmRegisterArg reglist[] = {
    {"choice_proc", (caddr_t) choice_proc}, 
    {"zap_help_proc", (caddr_t) zap_help_proc}, 
    {"create_proc" , (caddr_t) create_proc}, 
    {"do_proc", (caddr_t) do_proc}, 
    {"command_proc", (caddr_t) command_proc},
    {"file_proc", (caddr_t) file_proc},
    {"list_proc", (caddr_t) list_proc},
    {"scale_proc", (caddr_t) scale_proc},
    {"select_proc", (caddr_t) select_proc},
    {"text_proc", (caddr_t) text_proc},
    {"color_proc", (caddr_t) color_proc},
};

static int reglist_num = (sizeof reglist / sizeof reglist [0]);
static float xfac,yfac;

/******************************************************************************/

main(int argc, char **argv)

{

/* Initialise LSLLIB */
   lsl_init(&FALSE);

/* Set up the CTRL/C handler */
   if (isatty(fileno(stdin))==1) ctrlcast();

/* Get DCL command */
   get_dcl();

/* Initialize everything */
   init(argc,argv);

/* Obey initial command string */
   if (command_string) {
      do_subs(NULL, command_string, NULL, "");
      free(command_string);
   }

/* and wait for ever for X events */
   XtAppMainLoop(app_context);
}

/************************************************************************/
/************************************************************************/
/************************************************************************/
/************************************************************************/
/************************************************************************/
/*									*/
/*	init - initialize everything					*/
/*									*/
/************************************************************************/

static void init(int argc, char **argv)

{
   char *name;
   int *items;
   MrmCode type;
#define LSL_MENU_INDEX 8
   char lslmenuname[LSL_MENU_INDEX+4] = "LSL_MENU";
#define LSL_COLOUR_INDEX 9
   char lslcolourname[LSL_COLOUR_INDEX+4] = "LSL_COLOR";
#define COLOUR_INDEX 6
   char colourname[COLOUR_INDEX+21] = "color_";
#define LSL_FONT_INDEX 8
   char lslfontname[LSL_FONT_INDEX+4] = "LSL_FONT";
#define FONT_INDEX 5
   char fontname[FONT_INDEX+21] = "font_";
   Wotsit *wptr;
   int menu_number;
   int colour_number;
   int font_number;
   Arg arglist[4];
   int narg;
   Pixel pixel;
   XmFontList fontlist;
   float red,green,blue;
   MrmRegisterArg regarg[1];
   Position x,y;
   int i;
   char colour_resource[14];
   XtResource resource;

/* Initialize DRM before initializing the X Toolkit. */
   MrmInitialize();               

/* Initialize DXm widgets */    
    DXmInitialize();

/* Initialize the X Toolkit. We get back a top level shell widget. */
   toplevel = XtAppInitialize(&app_context,class_name,
                 NULL,0,&argc,argv,NULL,NULL,0);
   xdisplay = XtDisplay(toplevel);
   xscreen = XtScreen(toplevel);

/* Set the font units to be 100 pixels on a 1024x864 pixel screen */
   xfac = (float) WidthOfScreen(xscreen)/1024;
   yfac = (float) HeightOfScreen(xscreen)/864;
   XmSetFontUnits(xdisplay, (int) (xfac*100), (int) (yfac*100) );

/* Open the UID files (the output of the UIL compiler) in the hierarchy*/
   if (MrmOpenHierarchy(uid_numfil,uid_file_vec,NULL,&s_DRMHierarchy
		) !=MrmSUCCESS) {
      printf("cannot open UID file %s\n",*uid_file_vec);
      exit(0);
   }
   for (i=0;i<uid_numfil;i++) free(uid_file_vec[i]);
   free(uid_file_vec);

/* Open the output */
   output_stream = fopen(output_file,"a");
   if (!output_stream) {
      printf("cannot open file %s\n",output_file);
      exit(0);
   }

/* Open the input */
   if (input_file) {
      ierr = sys$assign(s_Desc(input_file),&ichan,0,0);
      if (!(ierr&1)) {
         printf("cannot assign file %s\n",input_file);
         lsl_putmsg(&ierr);
         exit(0);
      }
      start_input();
      XtAppAddInput(app_context,IEFN,&iosb,input_proc,NULL);
   }

/* Open the abort stream */
   if (abort_file) {
      abort_stream = fopen(abort_file,"a");
      if (!abort_stream) {
         printf("cannot open file %s\n",abort_file);
         exit(0);
      }
   }

/* Get the watch cursor */
   watch_cursor = XCreateFontCursor(xdisplay,XC_watch);

/* Register the items DRM needs to bind for us. */
   MrmRegisterNames(reglist, reglist_num);

/* retrieve names of colours, fonts, and widgets from UID */

/* get colours */
   if (MrmFetchLiteral(s_DRMHierarchy,"LSL_COLORS",xdisplay,
		&items,&type) != MrmSUCCESS) {
      printf("cannot fetch LSL_COLORS\n");
      exit(0);
   }

   for (colour_number=1;colour_number<=*items;colour_number++) {
      sprintf(&lslcolourname[LSL_COLOUR_INDEX],"%d",colour_number);
      if (MrmFetchLiteral(s_DRMHierarchy,lslcolourname,xdisplay,
		&name,&type) != MrmSUCCESS) {
         printf("cannot fetch %s\n",lslcolourname);
         exit(0);
      }

/* read the rgb colours out of the string */
      i = sscanf(name,"%20s%f%f%f",&colourname[COLOUR_INDEX],&red,&green,&blue);
      if (i==4) {
/* Read 4 items, so it's an RGB colours */
         sprintf(colour_resource,"#%04x%04x%04x",
            (int) (red*65535), (int) (green*65535), (int) (blue*65535) );
         resource.default_addr = colour_resource;
      } else {
/* Not RGB, so assume the rest of line is a colour name */
         resource.default_addr = name + strlen(&colourname[COLOUR_INDEX]) + 1;
      }

      resource.resource_name = &colourname[COLOUR_INDEX];
      resource.resource_class = &colourname[COLOUR_INDEX];
      resource.resource_type = XtRPixel;
      resource.resource_size = sizeof(Pixel);
      resource.resource_offset = 0;
      resource.default_type = XtRString;

      XtGetApplicationResources(toplevel,&pixel,&resource,1,NULL,0);

/* define UIL identifier to inform it of the color index */
      regarg[0].name = colourname;
      regarg[0].value = (caddr_t) pixel;
      MrmRegisterNames(regarg, 1);
   }

/* get fonts */
   if (MrmFetchLiteral(s_DRMHierarchy,"LSL_FONTS",xdisplay,
		&items,&type) != MrmSUCCESS) {
      printf("cannot fetch LSL_FONTS\n");
      exit(0);
   }

   for (font_number=1;font_number<=*items;font_number++) {
      sprintf(&lslfontname[LSL_FONT_INDEX],"%d",font_number);
      if (MrmFetchLiteral(s_DRMHierarchy,lslfontname,xdisplay,
		&name,&type) != MrmSUCCESS) {
         printf("cannot fetch %s\n",lslfontname);
         exit(0);
      }

/* read the name out of the string */
      sscanf(name,"%20s",&fontname[FONT_INDEX]);
      resource.default_addr = name + strlen(&fontname[FONT_INDEX]) + 1;

      resource.resource_name = &fontname[FONT_INDEX];
      resource.resource_class = &fontname[FONT_INDEX];
      resource.resource_type = XmRFontList;
      resource.resource_size = sizeof(XmFontList);
      resource.resource_offset = 0;
      resource.default_type = XtRString;

      XtGetApplicationResources(toplevel,&fontlist,&resource,1,NULL,0);

/* define UIL identifier to inform it of the font */
      regarg[0].name = fontname;
      regarg[0].value = (caddr_t) fontlist;
      MrmRegisterNames(regarg, 1);
   }

/* get names of root boxes */
   if (MrmFetchLiteral(s_DRMHierarchy,"LSL_MENUS",xdisplay,
		&items,&type) != MrmSUCCESS) {
      printf("cannot fetch LSL_MENUS\n");
      exit(0);
   }

   if (*items<=0) {
      printf("no root boxes specified\n");
      exit(0);
   }

   for (menu_number=1;menu_number<=*items;menu_number++) {
      sprintf(&lslmenuname[LSL_MENU_INDEX],"%d",menu_number);
      if (MrmFetchLiteral(s_DRMHierarchy,lslmenuname,xdisplay,
		&name,&type) != MrmSUCCESS)
      {
         printf("cannot fetch %s\n",lslmenuname);
         exit(0);
      }

/* insert the box in the tree */
      if (!(wptr=lookup_name(name,&toplevel_wotsit,TRUE))) exit(0);

      if (menu_number==1) {

/* fetch our top level dialog box, retrieve its intended x,y */
/* and set the shell to that position, set title of shell */
         fetch_widget(wptr);
         XtManageChild(wptr->widget);
         narg = 0;
         XtSetArg(arglist[narg],XmNx,&x);narg++;
         XtSetArg(arglist[narg],XmNy,&y);narg++;
         XtGetValues(wptr->widget,arglist,narg);
         narg = 0;
         XtSetArg(arglist[narg],XmNx,x);narg++;
         XtSetArg(arglist[narg],XmNy,y);narg++;
         XtSetArg(arglist[narg],XtNtitle,name);narg++;
         XtSetArg(arglist[narg],XtNiconName,name);narg++;
         XtSetValues(toplevel,arglist,narg);

         topwidget = wptr->widget;
         XtRealizeWidget(toplevel);
      }
   }

/* and any other root windows */
   wptr = toplevel_wotsit.child;
   while (wptr) {
      if (wptr->widget!=topwidget) {
         fetch_widget(wptr);
         XtManageChild(wptr->widget);
      }
      wptr = wptr->sibling;
   }
}

/************************************************************************/
/************************************************************************/
/************************************************************************/
/************************************************************************/
/************************************************************************/
/*									*/
/*	get_dcl - decode DCL command line				*/
/*									*/
/************************************************************************/
static void get_dcl()
{
   int ok,absent,had_qual,present,negated,i;
   strdesc(p1,"P1");
   strdesc(p1def,"LSL$UIL:.UID");
   strdesc(output,"OUTPUT");
   strdesc(input,"INPUT");
   strdesc(symbol,"SYMBOL");
   strdesc(command,"COMMAND");
   strdesc(logical,"LOGICAL");
   strdesc(classname,"CLASSNAME");
   strdesc(abort,"ABORT");
   strdesc(blank," ");

   ok = dcl_startup(s_Desc("UILMENUS"),&FALSE,UILMEN_CLD,&TRUE);
   if (!(ok&1)) exit(0);

   ok = dcl_file(&p1,&p1def,&absent,&TRUE,&TRUE);
   if (!(ok&1)) exit(0);
   
   uid_numfil = LSL_CLD.NUMFIL;
   uid_file_vec = (char **) malloc(uid_numfil * sizeof(char *));
   
   for (i=0;i<uid_numfil;i++) {
      LSL_CLDCHR.FILARY[i][LSL_CLD.FIL_LEN[i]] = 0;
      uid_file_vec[i] = (char *) malloc(LSL_CLD.FIL_LEN[i]+1);
      strcpy(uid_file_vec[i],LSL_CLDCHR.FILARY[i]);
   }

   absent = TRUE;
   ok = dcl_qual(&output,&had_qual,&present,&negated,&TRUE);
   if (!(ok&1)) exit(0);
   if (had_qual) {
      ok = dcl_file(&output,&blank,&absent,&FALSE,&TRUE);
      if (!(ok&1)) exit(0);
   }
   if (absent) {
      output_file = "LSL$LITES2AUX:";
   } else {
      LSL_CLDCHR.FILARY[0][LSL_CLD.FIL_LEN[0]] = 0;
      output_file = (char *) malloc(LSL_CLD.FIL_LEN[0]+1);
      strcpy(output_file,LSL_CLDCHR.FILARY[0]);
   }

   absent = TRUE;
   ok = dcl_qual(&input,&had_qual,&present,&negated,&TRUE);
   if (!(ok&1)) exit(0);
   if (had_qual) {
      ok = dcl_file(&input,&blank,&absent,&FALSE,&TRUE);
      if (!(ok&1)) exit(0);
   }
   if (!absent) {
      LSL_CLDCHR.FILARY[0][LSL_CLD.FIL_LEN[0]] = 0;
      input_file = (char *) malloc(LSL_CLD.FIL_LEN[0]+1);
      strcpy(input_file,LSL_CLDCHR.FILARY[0]);
   }

   ok = dcl_str(&symbol,&TRUE);
   if (!(ok&1)) exit(0);
   if (LSL_CLD.NUMSTR==0) {
      symbol_name = "LSL$UILMENUSTEXT";
   } else {
      LSL_CLDCHR.CARRAY[0][LSL_CLD.STR_LEN[0]] = 0;
      symbol_name = (char *) malloc(LSL_CLD.STR_LEN[0]+1);
      strcpy(symbol_name,LSL_CLDCHR.CARRAY[0]);
   }

   ok = dcl_str(&command,&TRUE);
   if (!(ok&1)) exit(0);
   if (LSL_CLD.NUMSTR!=0) {
      LSL_CLDCHR.CARRAY[0][LSL_CLD.STR_LEN[0]] = 0;
      command_string = (char *) malloc(LSL_CLD.STR_LEN[0]+1);
      strcpy(command_string,LSL_CLDCHR.CARRAY[0]);
   }

   ok = dcl_str(&logical,&TRUE);
   if (!(ok&1)) exit(0);
   if (LSL_CLD.NUMSTR==0) {
      logical_name = "LSL$UILMENUSTEXT";
   } else {
      LSL_CLDCHR.CARRAY[0][LSL_CLD.STR_LEN[0]] = 0;
      logical_name = (char *) malloc(LSL_CLD.STR_LEN[0]+1);
      strcpy(logical_name,LSL_CLDCHR.CARRAY[0]);
   }

   ok = dcl_str(&classname,&TRUE);
   if (!(ok&1)) exit(0);
   if (LSL_CLD.NUMSTR==0) {
      class_name = "LSLUILMENUS";
   } else {
      LSL_CLDCHR.CARRAY[0][LSL_CLD.STR_LEN[0]] = 0;
      class_name = (char *) malloc(LSL_CLD.STR_LEN[0]+1);
      strcpy(class_name,LSL_CLDCHR.CARRAY[0]);
   }

   absent = TRUE;
   ok = dcl_qual(&abort,&had_qual,&present,&negated,&TRUE);
   if (!(ok&1)) exit(0);
   if (had_qual) {
      ok = dcl_file(&abort,&blank,&absent,&FALSE,&TRUE);
      if (!(ok&1)) exit(0);
   }
   if (!absent) {
      LSL_CLDCHR.FILARY[0][LSL_CLD.FIL_LEN[0]] = 0;
      abort_file = (char *) malloc(LSL_CLD.FIL_LEN[0]+1);
      strcpy(abort_file,LSL_CLDCHR.FILARY[0]);
   }

}

/************************************************************************/
/************************************************************************/
/************************************************************************/
/************************************************************************/
/************************************************************************/
/*									*/
/*	fetch_widget - to fetch widget from UID				*/
/*									*/
/************************************************************************/
static void fetch_widget(Wotsit *wptr)
{
   int x,y;
   int narg;
   Arg arglist[3];
   Atom proto_atom;
   Widget shell;

   if (MrmFetchWidget(s_DRMHierarchy,wptr->name,
         toplevel,&wptr->widget,&dummy_class) != MrmSUCCESS)
   {
      printf("cannot fetch widget %s\n",wptr->name);
      exit(0);
   }

   shell = XtParent(wptr->widget);
   narg = 0;
/* Set available functions and decorations */

/* Just move and minimise functions (always get lower) */
   XtSetArg(arglist[narg],XmNmwmFunctions,12);narg++;

/* Border, title, system menu, and minimise decorations */
   XtSetArg(arglist[narg],XmNmwmDecorations,
		strchr(wptr->control,'n')?0:58);narg++;

/* Do we want any input */
/* Use a 'real' TRUE since DECwindows objected to a large number */
   XtSetArg(arglist[narg],XmNinput,
		strchr(wptr->control,'i')?TRUE:FALSE);narg++;

   XtSetValues(shell,arglist,narg);

/* add obscure atom to the WM_PROTOCOLS property */
/* Allows mwm not to give us the input focus */
   proto_atom = XmInternAtom(xdisplay,"WM_TAKE_FOCUS",FALSE);
   XmAddWMProtocols(shell,&proto_atom,1);
}

/************************************************************************/
/*									*/
/*	write_output - to write a string to the output			*/
/*									*/
/************************************************************************/

static void write_output(char *string)
{
   fprintf(output_stream,"%s\n",string);
}

/************************************************************************/
/*									*/
/*	write_abort - to write a string to the abort stream		*/
/*									*/
/************************************************************************/

static void write_abort(char *string)
{
   if (abort_file) fprintf(abort_stream,"%s\n",string);
}

/************************************************************************/
/************************************************************************/
/************************************************************************/
/************************************************************************/
/************************************************************************/
/*									*/
/*	do_display - display a menu and all its ancestors		*/
/*									*/
/************************************************************************/

static void do_display(Widget w,char *name)
{
   Wotsit *tptr;
   Window window;

/* lookup, and possibly create name */
   if (!lookup_name(name,&toplevel_wotsit,TRUE)) return;

/* lookup the name in all root trees (must succeed) */
   tptr = toplevel_wotsit.child;
   while (tptr) {
      if (lookup_name(name,tptr,FALSE)) break;
      tptr = tptr->sibling;
   }

   if (w) {
      window = XtWindow(XtParent(w));
      XDefineCursor(xdisplay,window,watch_cursor);
      XFlush(xdisplay);
   }
   is_visible(name,tptr);
   if (w) XUndefineCursor(xdisplay,window);
}

/************************************************************************/
/*									*/
/*	do_add - display a menu						*/
/*									*/
/************************************************************************/

static void do_add(Widget w,char *name)
{
   Item *iptr;
   Wotsit *popw;
   Widget temp_w = NULL;
   iptr = lookup_item(name,FALSE);
   if (iptr)
      temp_w = iptr->widget;
   else {
      popw = do_fetch(w,name);
      if (popw) temp_w = popw->widget;
   }
   if (temp_w && !XtIsManaged(temp_w)) XtManageChild(temp_w);
}

/************************************************************************/
/*									*/
/*	do_fetch - fetch a box from the UID file			*/
/*									*/
/************************************************************************/

static Wotsit *do_fetch(Widget w,char *name)
{
   Wotsit *popw;
   Window window;
   if (popw=lookup_name(name,&toplevel_wotsit,TRUE)) {
      if (!popw->widget) {
         if (w) {
            window = XtWindow(XtParent(w));
            XDefineCursor(xdisplay,window,watch_cursor);
            XFlush(xdisplay);
         }
         fetch_widget(popw);
         if (w) XUndefineCursor(xdisplay,window);
      }
   }
   return popw;
}

/************************************************************************/
/*									*/
/*	do_remove - remove a menu					*/
/*									*/
/************************************************************************/

static void do_remove(w, name)
    Widget w;
    char *name;
{
   Item *iptr;
   Wotsit *popw;
   Widget temp_w = NULL;
   iptr = lookup_item(name,FALSE);
   if (iptr)
      temp_w = iptr->widget;
   else {
      popw = do_fetch(w,name);
      if (popw) temp_w = popw->widget;
   }
   if (temp_w) {
      if (temp_w==topwidget)
         printf("cannot remove root widget\n");
      else
         if (XtIsManaged(temp_w)) XtUnmanageChild(temp_w);
   }
}

/************************************************************************/
/*									*/
/*	do_position - position a menu					*/
/*									*/
/************************************************************************/

static void do_position(w, name)
    Widget w;
    char *name;
{
   Wotsit *popw = do_fetch(w,name);
   Window window;
   Window root,child;
   int rx,ry,wx,wy;
   unsigned int state;
   int narg;
   Arg arglist[2];
   if (popw) {
      if (LSL_CMDCOM.ARGMSG) {
         XQueryPointer(xdisplay,XRootWindowOfScreen(xscreen),
			&root,&child,&rx,&ry,&wx,&wy,&state);
         rx = rx/xfac;		/* to font units */
         ry = ry/yfac;
      } else {
         rx = LSL_CMDCOM.INTARG[0];
         ry = LSL_CMDCOM.INTARG[1];
      }
      narg = 0;
      XtSetArg(arglist[narg],XmNx,rx);narg++;
      XtSetArg(arglist[narg],XmNy,ry);narg++;
      XtSetValues(popw->widget,arglist,narg);

/* Top level shell refuses to move, so force it, using pixel position */
      if (popw->widget==topwidget) {
         rx = rx*xfac;		/* to pixel units */
         ry = ry*yfac;
         narg = 0;
         XtSetArg(arglist[narg],XmNx,rx);narg++;
         XtSetArg(arglist[narg],XmNy,ry);narg++;
         XtSetValues(XtParent(popw->widget),arglist,narg);
      }
   }
}

/************************************************************************/
/*									*/
/*	do_scale - set value of scale widget				*/
/*									*/
/************************************************************************/

static void do_scale(name, value)
    char *name;
    float value;
{
   Item *iptr;
   Arg	arglist[1];
   short dp;
   int	ivalue;

   iptr = lookup_item(name,FALSE);
   if (!iptr) {
      printf("scale widget %s not found\n",name);
   } else if (iptr->type!=SCALE) {
      printf("widget %s is not a SCALE\n",name);
   } else {
      XtSetArg(arglist[0],XmNdecimalPoints,&dp);
      XtGetValues(iptr->widget,arglist,1);
      if (dp>0)
         ivalue = floor( (double) value * pow(10.0, (double) dp) + 0.5);
      else
         ivalue = value;
      XmScaleSetValue(iptr->widget,ivalue);
   }
}

/************************************************************************/
/*									*/
/*	do_prompt - set label of prompt dialog box			*/
/*									*/
/************************************************************************/

static void do_prompt(w, name, label)
    Widget w;
    char *name;
    char *label;
{
   Wotsit *popw = do_fetch(w,name);
   XmString comp_label;
   Arg	arglist[1];
   Widget temp_w;

   if (popw) {
      if (XtClass(popw->widget)==xmSelectionBoxWidgetClass) {
         comp_label = XmStringCreate(label,"");
         XtSetArg(arglist[0],XmNlabelString,comp_label);
         temp_w = XmSelectionBoxGetChild(popw->widget,XmDIALOG_SELECTION_LABEL);
         XtSetValues(temp_w,arglist,1);
         XmStringFree(comp_label);
      } else {
         printf("widget %s is not a prompt box\n",popw->name);
      }
   }
}

/************************************************************************/
/*									*/
/*	do_list - set things in list widget				*/
/*									*/
/************************************************************************/

static void do_list()
{
   char ch;
   Item *iptr,*d_iptr;
   XmString item=NULL,do_string;
   Arg	arglist[4];
   int	narg;
   unsigned char policy;
   char *callarg,*d_callarg;
   int	nitem,sitem;
   XtCallbackList old_call,new_call;
   XmStringTable selected_items;
   int	i,length,selected;

   *( (char *) (LSL_CMDCOM.STARST[1]) + LSL_CMDCOM.STARLE ) = 0;
   format.pointer = NULL;
   if (LSL_CMDCOM.SECMDN==1) {		/* ADD */
      if (rdchs(&ch)) {
         lsl_putmsg(&LSL__UNEXPEOL);
         return;
      }
      if (ch!='\'' && ch!='\"') {
         lsl_putmsg(&LSL__UNEXPCH,&ch);
         return;
      }
      format.length = 256;
      format.pointer = (char *) malloc(256);
      length = readstr(&format,&ch,&ON_CHAR2);
      format.pointer[length] = 0;
   }
   if (LSL_CMDCOM.SECMDN==6) {		/* MOVE */
      length = readstr(&comdsc,0,&ON_SPACE);
   } else {
      length = readstr(&comdsc);
   }
   combuf[length] = 0;

   iptr = lookup_item(combuf,FALSE);
   if (!iptr) {
      printf("list widget %s not found\n",combuf);
   } else if (iptr->type!=LIST) {
      printf("widget %s is not a LIST\n",combuf);
   } else {
      narg = 0;
      XtSetArg(arglist[narg],XmNselectionPolicy,&policy); narg++;
      XtGetValues(iptr->widget,arglist,narg);
      callarg = (policy==XmMULTIPLE_SELECT)?
         XmNmultipleSelectionCallback:
         ((policy==XmBROWSE_SELECT)?
            XmNbrowseSelectionCallback:XmNsingleSelectionCallback);

      switch (LSL_CMDCOM.SECMDN) {
         case 1:	/* ADD */
            item = XmStringCreate(LSL_CMDCOM.STARST[1],"");
            XmListAddItemUnselected(iptr->widget,item,0);
            narg = 0;
            XtSetArg(arglist[narg],XmNitemCount,&nitem); narg++;
            XtSetArg(arglist[narg],callarg,&old_call); narg++;
            XtGetValues(iptr->widget,arglist,narg);
            new_call = (XtCallbackList) malloc(2 * sizeof (XtCallbackRec));
            new_call[0].callback = old_call[0].callback;
            new_call[1].callback = NULL;
            new_call[0].closure = (XmStringTable) realloc(
			old_call[0].closure ,nitem * sizeof(XmString));
            ((XmStringTable) new_call[0].closure)[nitem-1] =
		XmStringCreate(format.pointer,"");
            XtRemoveAllCallbacks(iptr->widget,callarg);
            XtAddCallbacks(iptr->widget,callarg,new_call);
            free(new_call);
            break;
         case 2:	/* REMOVE */
            item = XmStringCreate(LSL_CMDCOM.STARST[1],"");
            narg = 0;
            XtSetArg(arglist[narg],XmNitemCount,&nitem); narg++;
            XtSetArg(arglist[narg],callarg,&old_call); narg++;
            XtGetValues(iptr->widget,arglist,narg);
            i = XmListItemPos(iptr->widget,item)-1;
            if (i<0) {
               printf("list widget %s does not contain item %s\n",
				combuf,LSL_CMDCOM.STARST[1]);
               break;
            }
            XmListDeletePos(iptr->widget,i+1);nitem--;
            new_call = (XtCallbackList) malloc(2 * sizeof (XtCallbackRec));
            new_call[0].callback = old_call[0].callback;
            new_call[1].callback = NULL;
            new_call[0].closure = old_call[0].closure;
            XmStringFree(((XmStringTable) new_call[0].closure)[i]);
            for (;i<nitem;i++) {
               ((XmStringTable) new_call[0].closure)[i] =
			((XmStringTable) new_call[0].closure)[i+1];
            }
            new_call[0].closure = (XmStringTable) realloc(
			new_call[0].closure ,nitem * sizeof(XmString));
            XtRemoveAllCallbacks(iptr->widget,callarg);
            XtAddCallbacks(iptr->widget,callarg,new_call);
            free(new_call);
            break;
         case 3:	/* CLEAR */
            narg = 0;
            XtSetArg(arglist[narg],XmNitemCount,&nitem); narg++;
            XtSetArg(arglist[narg],callarg,&old_call); narg++;
            XtGetValues(iptr->widget,arglist,narg);
            XmListDeleteAllItems(iptr->widget);
            for (i=0;i<nitem;i++) {
               XmStringFree(((XmStringTable) old_call[0].closure)[i]);
            }
            new_call = (XtCallbackList) malloc(2 * sizeof (XtCallbackRec));
            new_call[0].callback = old_call[0].callback;
            new_call[1].callback = NULL;
            new_call[0].closure = NULL;
            free((XmStringTable) old_call[0].closure);
            XtRemoveAllCallbacks(iptr->widget,callarg);
            XtAddCallbacks(iptr->widget,callarg,new_call);
            free(new_call);
            break;
         case 4:	/* SELECT */
            if (LSL_CMDCOM.ARGMSG) {
               narg = 0;
               XtSetArg(arglist[narg],XmNitemCount,&nitem); narg++;
               XtGetValues(iptr->widget,arglist,narg);

/* Do a deselect first, because select toggles the item if
   using multiple selection mode */
               XmListDeselectAllItems(iptr->widget);
   	       for (i=1;i<=nitem;i++) XmListSelectPos(iptr->widget,i,FALSE);
            } else {
               item = XmStringCreate(LSL_CMDCOM.STARST[1],"");

/* Do a deselect first, because select toggles the item if
   using multiple selection mode */
               XmListDeselectItem(iptr->widget,item,FALSE);
               XmListSelectItem(iptr->widget,item,FALSE);
            }
	    break;
         case 5:	/* DESELECT */
            if (LSL_CMDCOM.ARGMSG) {
   	       XmListDeselectAllItems(iptr->widget);
            } else {
               item = XmStringCreate(LSL_CMDCOM.STARST[1],"");
               XmListDeselectItem(iptr->widget,item);
            }
	    break;
         case 6:	/* MOVE */

/* get selected items, and callback */
            item = XmStringCreate(LSL_CMDCOM.STARST[1],"");
            narg = 0;
            XtSetArg(arglist[narg],XmNitemCount,&nitem); narg++;
            XtSetArg(arglist[narg],XmNselectedItemCount,&sitem); narg++;
            XtSetArg(arglist[narg],XmNselectedItems,&selected_items); narg++;
            XtSetArg(arglist[narg],callarg,&old_call); narg++;
            XtGetValues(iptr->widget,arglist,narg);

/* find if item is selected, and its position in the list */
            for (i=0;i<sitem;i++) {
               if (XmStringCompare(selected_items[i],item)) break;
            }
            selected = (i<sitem);
            i = XmListItemPos(iptr->widget,item)-1;
            if (i<0) {
               printf("list widget %s does not contain item %s\n",
				combuf,LSL_CMDCOM.STARST[1]);
               break;
            }

/* read name of destination widget from command line */
            length = readstr(&comdsc);
            combuf[length] = 0;
            d_iptr = lookup_item(combuf,FALSE);
            if (!d_iptr) {printf("list widget %s not found\n",combuf);break;}
            if (d_iptr->type!=LIST) {
               printf("widget %s is not a LIST\n",combuf);break;}
            narg = 0;
            XtSetArg(arglist[narg],XmNselectionPolicy,&policy); narg++;
            XtGetValues(d_iptr->widget,arglist,narg);
            d_callarg = (policy==XmMULTIPLE_SELECT)?
               XmNmultipleSelectionCallback:
               ((policy==XmBROWSE_SELECT)?
                  XmNbrowseSelectionCallback:XmNsingleSelectionCallback);

/* delete item from list, saving its DO string */
            XmListDeletePos(iptr->widget,i+1);nitem--;
            new_call = (XtCallbackList) malloc(2 * sizeof (XtCallbackRec));
            new_call[0].callback = old_call[0].callback;
            new_call[1].callback = NULL;
            new_call[0].closure = old_call[0].closure;
            do_string = ((XmStringTable) new_call[0].closure)[i];
            for (;i<nitem;i++) {
               ((XmStringTable) new_call[0].closure)[i] =
			((XmStringTable) new_call[0].closure)[i+1];
            }
            new_call[0].closure = (XmStringTable) realloc(
			new_call[0].closure ,nitem * sizeof(XmString));
            XtRemoveAllCallbacks(iptr->widget,callarg);
            XtAddCallbacks(iptr->widget,callarg,new_call);
            free(new_call);

/* add the item to destination list */
            XmListAddItemUnselected(d_iptr->widget,item,0);
   	    if (selected) {
/* Do a deselect first, because select toggles the item if
   using multiple selection mode */
               XmListDeselectItem(d_iptr->widget,item,FALSE);
               XmListSelectItem(d_iptr->widget,item,FALSE);
            }
            narg = 0;
            XtSetArg(arglist[narg],XmNitemCount,&nitem); narg++;
            XtSetArg(arglist[narg],callarg,&old_call); narg++;
            XtGetValues(d_iptr->widget,arglist,narg);
            new_call = (XtCallbackList) malloc(2 * sizeof (XtCallbackRec));
            new_call[0].callback = old_call[0].callback;
            new_call[1].callback = NULL;
            new_call[0].closure = (XmStringTable) realloc(
			old_call[0].closure ,nitem * sizeof(XmString));
            ((XmStringTable) new_call[0].closure)[nitem-1] = do_string;
            XtRemoveAllCallbacks(d_iptr->widget,d_callarg);
            XtAddCallbacks(d_iptr->widget,d_callarg,new_call);
            free(new_call);
            break;
      }
   }
   if (format.pointer) free(format.pointer);
   if (item) XmStringFree(item);
}

/************************************************************************/
/*									*/
/*	do_text - set value of text widget				*/
/*									*/
/************************************************************************/

static void do_text(name, value)
    char *name;
    char *value;
{
   Item *iptr;

   iptr = lookup_item(name,FALSE);
   if (!iptr) {
      printf("text widget %s not found\n",name);
   } else if (iptr->type!=TEXT) {
      printf("widget %s is not a TEXT\n",name);
   } else {
      XmTextSetString(iptr->widget,value);
   }
}

/************************************************************************/
/*									*/
/*	do_file - perform file search in file select box		*/
/*									*/
/************************************************************************/

static void do_file(w, name, dir)
    Widget w;
    char *name;
    char *dir;
{
   Wotsit *popw = do_fetch(w,name);
   XmString comp_dir;
   if (popw) {
      if (XtClass(popw->widget)==xmFileSelectionBoxWidgetClass) {
         comp_dir = *dir ? XmStringCreate(dir,"") : NULL;
         XmFileSelectionDoSearch(popw->widget,comp_dir);
         if (comp_dir) XmStringFree(comp_dir);
      } else {
         printf("widget %s is not a file selection box\n",popw->name);
      }
   }
}

/************************************************************************/
/*									*/
/*	do_label - set label of label widget				*/
/*									*/
/************************************************************************/

static void do_label(name, value)
    char *name;
    char *value;
{
   Item *iptr;
   XmString comp_label;
   Arg	arglist[1];

   iptr = lookup_item(name,FALSE);
   if (!iptr) {
      printf("label widget %s not found\n",name);
   } else if (iptr->type!=LABEL && iptr->type!=BUTTON &&
	      iptr->type!=TOGGLE && iptr->type!=OPTION_MENU &&
	      iptr->type!=CASCADE) {
      printf("widget %s does not have a LABEL\n",name);
   } else {
      comp_label = XmStringCreate(value,"");
      XtSetArg(arglist[0],XmNlabelString,comp_label);
      XtSetValues(iptr->widget,arglist,1);
      XmStringFree(comp_label);
   }
}

/************************************************************************/
/*									*/
/*	do_color - set the color in a color mix				*/
/*									*/
/************************************************************************/

static void do_color(w, name, rgb)
    Widget w;
    char *name;
    float rgb[3];
{
   Wotsit *popw = do_fetch(w,name);
   XColor color;
   Arg arglist[6];
   int narg;

   if (rgb[0]<0.0 || rgb[0]>1.0 ||
       rgb[1]<0.0 || rgb[1]>1.0 ||
       rgb[2]<0.0 || rgb[2]>1.0) {
      printf("rgb value out of range\n");
      return;
   }

   if (popw) {
      if (XtClass(popw->widget)==dxmColorMixWidgetClass) {
         color.red = rgb[0]*65535.0;
         color.green = rgb[1]*65535.0;
         color.blue = rgb[2]*65535.0;
         narg = 0;                     
         XtSetArg (arglist[narg],DXmNorigRedValue,color.red);narg++;
         XtSetArg (arglist[narg],DXmNorigGreenValue,color.green);narg++;
         XtSetArg (arglist[narg],DXmNorigBlueValue,color.blue);narg++;
         XtSetArg (arglist[narg],DXmNnewRedValue,color.red);narg++;
         XtSetArg (arglist[narg],DXmNnewGreenValue,color.green);narg++;
         XtSetArg (arglist[narg],DXmNnewBlueValue,color.blue);narg++;
         XtSetValues(popw->widget,arglist,narg);     
      } else {
         printf("widget %s is not a colour mix box\n",popw->name);
      }
   }
}

/************************************************************************/
/*									*/
/*	choice_proc - create callback for choice/toggle buttons		*/
/*	Insert the toggle into our list of them, turn it on if,		*/
/*	required, and if in radio_box group, and our callback for	*/
/*	value_changed to set all buttons in the group.			*/
/*									*/
/************************************************************************/

static void choice_proc(w, string, reason)
    Widget w;
    char *string;
    XmAnyCallbackStruct *reason;
{
   int group;
   char *parent;
   Wotsit *pptr;
   Toggle *tptr;
   int length;
   int type;
   Arg arglist[1];

   length = strlen(string);
   setaux(string,&length);
   type = rdcomm(CHOICE_CMD_TABLE);
   if (type<=0) {
      printf("bad command to choice_proc %s\n",string);
      return;
   }
   group = LSL_CMDCOM.INTARG[0];
   *( (char *) (LSL_CMDCOM.STARST[1]) + LSL_CMDCOM.STARLE ) = 0;
   parent = LSL_CMDCOM.STARST[1];
   if (!(pptr=lookup_name(parent,&toplevel_wotsit,FALSE))) {
      printf("parent widget %s not found\n",parent);
      return;
   }
   if (type==OPTION) {
      tptr=toggle_ptr;
      while (tptr) {
         if (tptr->parent_widget==pptr->widget &&
             tptr->type==OPTION &&
             tptr->group==-group) break;
         tptr = tptr->next;
      }
      if (tptr) {
         if (group>0) {		/* this is the option menu */
            tptr->on = tptr->widget;
            tptr->widget = w;
         } else			/* this is its default button */
            tptr->on = w;
         XtSetArg(arglist[0],XmNmenuHistory,tptr->on);
         XtSetValues(tptr->widget,arglist,1);
         return;
      }
   }
   tptr = (Toggle *) malloc(sizeof (Toggle));
   tptr->widget = w;
   tptr->parent_widget = pptr->widget;
   tptr->group = group;
   tptr->type = type;
   tptr->on = FALSE;
   tptr->next = toggle_ptr;
   toggle_ptr = tptr;
   if (type==GROUP || type==RADIO) {
      if (group<0) set_toggle(tptr->widget,TRUE);
   }
   if (type==GROUP && group) {
      XtAddCallback(w,XmNvalueChangedCallback,toggle_proc,group);
   }
   return;
}

/************************************************************************/
/*									*/
/*	zap_help_proc - create callback for selection box		*/
/*	Remove the HELP child button					*/
/*									*/
/************************************************************************/

static void zap_help_proc(w, string, reason)
    Widget w;
    char *string;
    XmAnyCallbackStruct *reason;
{
   XtUnmanageChild(XmSelectionBoxGetChild(w,XmDIALOG_HELP_BUTTON));
   return;
}

/************************************************************************/
/*									*/
/*	create_proc - general create callback				*/
/*	Copy the callback argument list					*/
/*									*/
/************************************************************************/

static void create_proc(w, string, reason)
    Widget w;
    char *string;
    XmAnyCallbackStruct *reason;
{
   int length;
   int type;
   char *name;
   Item *iptr;

   length = strlen(string);
   setaux(string,&length);
   type = rdcomm(CREATE_CMD_TABLE);
   if (type<=0) {
      printf("bad command to create_proc %s\n",string);
      return;
   }

   if (type==LIST) list_create(w,string,reason);
/*   Think text widgets become tab group anyway (CCB 10/2/92) */
/*   and calling this upsets NavigationType for other widgets */
/*   if (type==TEXT) XmAddTabGroup(w); */

   if (LSL_CMDCOM.ARGMSG) return;

   *( (char *) (LSL_CMDCOM.STARST[1]) + LSL_CMDCOM.STARLE ) = 0;
   name = LSL_CMDCOM.STARST[1];

   if (iptr = lookup_item(name,TRUE)) {
      iptr->type = type;
      iptr->widget = w;
   } else {
      printf("widget name %s has been used already\n",name);
   }
   return;
}

/************************************************************************/
/*									*/
/*	list_create - create callback for list box			*/
/*	Copy the callback argument list					*/
/*									*/
/************************************************************************/

static void list_create(w, string, reason)
    Widget w;
    char *string;
    XmAnyCallbackStruct *reason;
{
   Arg	arglist[2];
   int	narg;
   unsigned char policy;
   int	nitem;
   char	*callarg;
   XtCallbackList old_call,new_call;
   XmStringTable old_strings,new_strings;
   int	i;

   narg = 0;
   XtSetArg(arglist[narg],XmNselectionPolicy,&policy); narg++;
   XtGetValues(w,arglist,narg);
   callarg = (policy==XmMULTIPLE_SELECT)?
      XmNmultipleSelectionCallback:
      ((policy==XmBROWSE_SELECT)?
         XmNbrowseSelectionCallback:XmNsingleSelectionCallback);

   narg = 0;
   XtSetArg(arglist[narg],XmNitemCount,&nitem); narg++;
   XtSetArg(arglist[narg],callarg,&old_call); narg++;
   XtGetValues(w,arglist,narg);

   new_call = (XtCallbackList) malloc(2 * sizeof (XtCallbackRec));
   new_call[0].callback = old_call[0].callback;
   new_call[1].callback = NULL;

   new_strings = (XmStringTable) malloc(nitem * sizeof(XmString));
   new_call[0].closure = new_strings;
   old_strings = old_call[0].closure;

   for (i=0;i<nitem;i++) {
      new_strings[i] = XmStringCopy(old_strings[i]);
   }

   XtRemoveAllCallbacks(w,callarg);
   XtAddCallbacks(w,callarg,new_call);
   free(new_call);

   return;
}

/************************************************************************/
/*									*/
/*	toggle_proc - internal value_changed callback for toggles	*/
/*	toggle buttons should use choice_proc as create callback,	*/
/*	so will be registered in our list.				*/
/*	This callback is inserted for value_changed reason by		*/
/*	choice_proc if the button is part of a radio group.		*/
/*	We ensure the selected button is on, and the others off.	*/
/*									*/
/************************************************************************/
static void toggle_proc(w, group, reason)
    Widget w;
    int group;
    XmToggleButtonCallbackStruct *reason; /* contains value if required */
{
   Toggle *bptr=toggle_ptr;
   Toggle *tptr;

   if (!group) return;		/* toggle not part of a group */
   while (bptr) {		/* locate this toggle */
      if (bptr->widget==w) break;
      bptr = bptr->next;
   }
   if (!bptr) return;		/* error */
   if (bptr->group) {		/* should agree with group */
      tptr=toggle_ptr;
      while (tptr) {
         if ( tptr->parent_widget==bptr->parent_widget &&
              abs(tptr->group)==abs(bptr->group) )
            set_toggle(tptr->widget,tptr==bptr);
         tptr = tptr->next;
      }
   }
}

/************************************************************************/
/*									*/
/*	command_proc - command entered callback for command window	*/
/*									*/
/************************************************************************/
static void command_proc(w, tag, data)
    Widget w;
    char *tag;
    XmCommandCallbackStruct *data;
{
   char	*command = get_string(data->value);
   do_subs(w, tag, data, command);
   XtFree(command);
}

/************************************************************************/
/*									*/
/*	file_proc - activated callback for file selection widget	*/
/*									*/
/************************************************************************/
static void file_proc(w, string, data)
    Widget w;
    char *string;
    XmFileSelectionBoxCallbackStruct *data;
{
   char	*filename = get_string(data->value);
   do_subs(w, string, data, filename);
   XtFree(filename);
}

/************************************************************************/
/*									*/
/*	list_proc - browse select callback for list box			*/
/*									*/
/************************************************************************/
static void list_proc(w, string, data)
    Widget w;
    XmStringTable string;
    XmListCallbackStruct *data;
{
   char	*text = get_string(string[data->item_position-1]);
   do_subs(w, text, data, "");
   XtFree(text);
}

/************************************************************************/
/*									*/
/*	scale_proc - value changed callback for scale widget		*/
/*									*/
/************************************************************************/
static void scale_proc(w, string, data)
    Widget w;
    char *string;
    XmScaleCallbackStruct *data;
{
   Arg	arglist[1];
   short dp;
   char	value[12];
   double fvalue;

   XtSetArg(arglist[0],XmNdecimalPoints,&dp);
   XtGetValues(w,arglist,1);
   if (dp>0) {
      fvalue = (double) data->value / pow(10.0, (double) dp);
      sprintf(value,"%f",fvalue);
   } else {
      sprintf(value,"%d",data->value);
   }
   do_subs(w, string, data, value);
}

/************************************************************************/
/*									*/
/*	select_proc - activated callback for selection widget		*/
/*									*/
/************************************************************************/
static void select_proc(w, string, data)
    Widget w;
    char *string;
    XmSelectionBoxCallbackStruct *data;
{
   char	*text = get_string(data->value);
   do_subs(w, string, data, text);
   XtFree(text);
   XmTextSetString(XmSelectionBoxGetChild(w,XmDIALOG_TEXT),"");
}

/************************************************************************/
/*									*/
/*	text_proc - activate callback for simple text			*/
/*									*/
/************************************************************************/
static void text_proc(w, string, data)
    Widget w;
    char *string;
    XmAnyCallbackStruct *data;
{
   char *text;
   text = XmTextGetString(w);
   do_subs(w, string, data, text);
   XtFree(text);
}

/************************************************************************/
/*									*/
/*	color_proc - activated callback for colormix widget		*/
/*									*/
/************************************************************************/
static void color_proc(w, string, data)
    Widget w;
    char *string;
    DXmColorMixCallbackStruct *data;
{
   double color[3];
   char	value[80];
   Arg arglist[3];
   int narg;
   
   color[0] = data->newred/65535.0;
   color[1] = data->newgrn/65535.0;
   color[2] = data->newblu/65535.0;

   if (data->reason==XmCR_CANCEL) {
      XtUnmanageChild(w);
   } else if (data->reason==XmCR_ACTIVATE) {
      XtUnmanageChild(w);
      narg = 0;                     
      XtSetArg (arglist[narg],DXmNorigRedValue,data->newred);narg++;
      XtSetArg (arglist[narg],DXmNorigGreenValue,data->newgrn);narg++;
      XtSetArg (arglist[narg],DXmNorigBlueValue,data->newblu);narg++;
      XtSetValues(w,arglist,narg);     
   }
        
   sprintf(value,"%f %f %f",color[0],color[1],color[2]);
   do_subs(w, string, data, value);
}

/************************************************************************/
/*									*/
/*	input_proc - callback for input available			*/
/*									*/
/************************************************************************/
static void input_proc()
{
   if (!iosb[0]) return;	/* nothing happened? */
   if (!(iosb[0]&1) && iosb[0]!=SS$_ENDOFFILE) {
      printf("error reading input\n");
      lsl_putmsg(iosb);
      exit(0);
   }
   ibuf[iosb[1]] = 0;		/* terminate string  */
   do_subs(NULL, ibuf, NULL, "");
   start_input();
}

/************************************************************************/
/************************************************************************/
/************************************************************************/
/************************************************************************/
/*									*/
/*	add_wotsit - add a new menu to hierarchy			*/
/*									*/
/************************************************************************/

static Wotsit *add_wotsit(char *name,char *parent,char *control)
{
   Wotsit *wotptr,*pptr;
   if (!parent) {
      printf("null parent for box %s\n",name);
      return NULL;
   }

   pptr = lookup_name(parent,&toplevel_wotsit,TRUE);
   if (!pptr) return NULL;

   wotptr = (Wotsit *) malloc(sizeof (Wotsit));
   wotptr->name = strcpy((char *)malloc(strlen(name)+1),name);
   wotptr->control = strcpy((char *)malloc(strlen(control)+1),control);
   wotptr->widget = 0;
   wotptr->sibling = NULL;
   wotptr->child = NULL;
   wotptr->sibling = pptr->child;
   pptr->child = wotptr;
   return wotptr;
}

/************************************************************************/
/*									*/
/*	lookup_name - return pointer to Wotsit for given name		*/
/*									*/
/************************************************************************/

static Wotsit *lookup_name(char *name,Wotsit *wotptr,int create)
{
   Wotsit *wptr;
   char *string,*widget_control,*widget_parent,*lslname;
   MrmCode type;

   if (wotptr) {
      if (!strcmp(wotptr->name,name)) return wotptr;
      wotptr = wotptr->child;
      while (wotptr) {
         if (wptr=lookup_name(name,wotptr,FALSE)) return wptr;
         wotptr = wotptr->sibling;
      }
   }

/* not found, so try fetching name as a literal */
   if (!create) return NULL;
   lslname = (char *)malloc(strlen(name)+5);
   strcpy(lslname,"LSL_");
   strcat(lslname,name);
   if (MrmFetchLiteral(s_DRMHierarchy,lslname,xdisplay,
		&string,&type) != MrmSUCCESS) {
      free(lslname);
      printf("box %s not found\n",name);
      return NULL;
   }
   free(lslname);
   widget_control = strtok(string," ");
   widget_parent = strtok(NULL," ");

/* insert widget into our hierarchy */
   wptr = add_wotsit(name,widget_parent,widget_control);
   return wptr;
}

/************************************************************************/
/*									*/
/*	lookup_item - return pointer to Item for given name.		*/
/*	If create FALSE, then returns NULL if item not found.		*/
/*	If create TRUE, then return NULL if item exists already,	*/
/*	otherwise create item and return pointer to it.			*/
/*									*/
/************************************************************************/

static Item *lookup_item(char *name, int create)
{
   Item **ptradr = &item_ptr;
   Item *iptr = *ptradr;
   int cmp;

   while (iptr) {
      cmp = strcmp(name,iptr->name);
      if (!cmp) break;
      ptradr = (cmp>0)?&iptr->gtr:&iptr->lss;
      iptr = *ptradr;
   }
   if (create) {
      if (iptr) return NULL;
      iptr = (Item *) malloc(sizeof (Item));
      *ptradr = iptr;
      iptr->name = strcpy((char *)malloc(strlen(name)+1),name);
      iptr->lss = NULL;
      iptr->gtr = NULL;
/* leave caller to fill in type and widget fields */
   }
   return iptr;
}

/************************************************************************/
/*									*/
/*	is_visible							*/
/*	Returns whether menu name is this, or a descendent of this menu	*/
/*	Recursively makes menus visible/invisible according whether	*/
/*	name is descendent.						*/
/*									*/
/************************************************************************/

static int is_visible(char *name,Wotsit *wotptr)
{
   int vis = FALSE;
   Wotsit *wptr=wotptr;

   if (!wptr) return FALSE;
   if (!strcmp(wptr->name,name)) vis = TRUE;
   wptr = wptr->child;
   while (wptr) {
      if (is_visible(name,wptr)) vis = TRUE;
      wptr = wptr->sibling;
   }
   if (vis) {
      if (!wotptr->widget) fetch_widget(wotptr);
      if (!XtIsManaged(wotptr->widget)) {
         XtManageChild(wotptr->widget);
      }
   } else if (wotptr->widget) {
      if (XtIsManaged(wotptr->widget)) {
         XtUnmanageChild(wotptr->widget);
      }
   }
   return vis;
}

/************************************************************************/
/*									*/
/*	set_all_toggles							*/
/*									*/
/************************************************************************/
static void set_all_toggles(Widget w,char *name,int on)
{
   Wotsit *popw;
   Item *iptr;
   Toggle *tptr;

/* Try looking up as a single named widget */
   if (iptr=lookup_item(name,FALSE)) {
      if (iptr->type!=TOGGLE) {
         printf("widget %s is not a TOGGLE\n",name);
      } else {
         set_toggle(iptr->widget,on);
      }

/* or failing that as a box */
   } else if (popw=do_fetch(w,name)) {
      tptr = toggle_ptr;
      while (tptr) {
         if (tptr->parent_widget==popw->widget &&
             tptr->type==GROUP &&
             tptr->group==0) set_toggle(tptr->widget,on);
         tptr = tptr->next;
      }
   }
}

/************************************************************************/
/*									*/
/*	reset_all_toggles						*/
/*									*/
/************************************************************************/
static void reset_all_toggles(Widget w,char *name)
{
   Wotsit *popw;
   Toggle *tptr=toggle_ptr;
   Arg arglist[1];
   if (popw=do_fetch(w,name)) {
      while (tptr) {
         if (tptr->parent_widget==popw->widget) {
            if (tptr->type==OPTION && tptr->on) {
               XtSetArg(arglist[0],XmNmenuHistory,tptr->on);
               XtSetValues(tptr->widget,arglist,1);
            } else
               set_toggle(tptr->widget,tptr->group<0);
         }
         tptr = tptr->next;
      }
   }
}

/************************************************************************/
/*									*/
/*	set_toggle							*/
/*									*/
/************************************************************************/
static void set_toggle(Widget w,int on)
{
   if (XmToggleButtonGetState(w)?!on:on) XmToggleButtonSetState(w,on,FALSE);
}

/************************************************************************/
/*									*/
/*	do_proc - general callback routine				*/
/*									*/
/************************************************************************/

static void do_proc(w, string, reason)
    Widget w;
    char *string;
    XmAnyCallbackStruct *reason;
{
   do_subs(w, string, reason, "");
}

static void 
do_subs(w, string, reason, value)
    Widget w;
    char *string;
    XmAnyCallbackStruct *reason;
    char *value;
{
   int command,length;
   char *comptr,*valptr,ch;

   do_commands = TRUE;

   while (*string) {
      comptr = combuf;
      while (ch = *string) {		/* read a character	*/
         if (comptr-combuf>=comdsc.length) {
            printf("DO string too long\n");
            break;
         }
         if (ch == ';') {		/* first ;		*/
            string++;
            if (!(ch = *string)) break;/* end of string	*/
            if (ch != ';') break;	/* end of command	*/
            string++;			/* repeated ;		*/
            *comptr++ = ';';
         } else if (ch != '?') {
            string++;
            *comptr++ = ch;		/* ordinary char	*/
         } else {
            string++;
            if ((ch = *string) == '?') {
               string++;		/* repeated ?		*/
               *comptr++ = '?';
            } else {
               valptr = value;		/* replace ? by value	*/
               while (*valptr && comptr-combuf<comdsc.length) {
                  *comptr++ = *valptr++;
               }
            }
         }
      }
      length = comptr-combuf;
      setaux(combuf,&length);
      command = rdcomm(UIL_CMD_TABLE);
      if (command>0) do_command(w,command,reason);
   }
}

static void do_command(
	Widget w,
	int command,
	XmAnyCallbackStruct *reason)
{
   int length,savlen;

   switch (command) {

      case 1: /* SEND */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         write_output(combuf);
         return;

      case 2: /* SET */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         savlen = comdsc.length; comdsc.length = length;
         lib$set_symbol(s_Desc(symbol_name),&comdsc,&1);
         comdsc.length = savlen;
         return;

      case 3: /* DISPLAY */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         do_display(w,combuf);
         return;

      case 4: /* TOGGLE ON/OFF */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         switch (LSL_CMDCOM.SECMDN) {
            case 1:
               set_all_toggles(w,combuf,TRUE); return;
            case 2:
               set_all_toggles(w,combuf,FALSE); return;
         }

      case 5: /* RESET */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         reset_all_toggles(w,combuf);
         return;

      case 6: /* EXIT */
         if (!do_commands) return;
         fclose(output_stream);
         if (input_file) sys$cancel(ichan);
         if (abort_file) fclose(abort_stream);
         exit(1);

      case 7: /* REMOVE */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         do_remove(w,combuf);
         return;

      case 8: /* ON */
         if (w&&reason) do_commands = widget_is_on(w,reason);
         return;

      case 9: /* OFF */
         if (w&&reason) do_commands = !widget_is_on(w,reason);
         return;

      case 10: /* ADD */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         do_add(w,combuf);
         return;

      case 11: /* POSITION */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         do_position(w,combuf);
         return;

      case 12: /* SCALE VALUE */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         do_scale(combuf,LSL_CMDCOM.REALAR[0]);
         return;

      case 13: /* LIST */
         if (!do_commands) return;
         do_list();
         return;

      case 14: /* FETCH */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         do_fetch(w,combuf);
         return;

      case 15: /* PROMPT LABEL */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         *( (char *) (LSL_CMDCOM.STARST[1]) + LSL_CMDCOM.STARLE ) = 0;
         do_prompt(w,combuf,LSL_CMDCOM.STARST[1]);
         return;

      case 16: /* SHOW */
      {
         unsigned int context = 0;
         unsigned int zone;
         lib$show_vm(&0); lib$show_vm(&4);
         if (!LSL_CMDCOM.ARGMSG) {
            while (lib$find_vm_zone(&context,&zone)&1) {
               lib$show_vm_zone(&zone,&LSL_CMDCOM.INTARG[0]);
            }
         }
         return;
      }

      case 17: /* BOTH */
         do_commands = TRUE;
         return;

      case 18: /* TEXT VALUE */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         *( (char *) (LSL_CMDCOM.STARST[1]) + LSL_CMDCOM.STARLE ) = 0;
         do_text(combuf,LSL_CMDCOM.STARST[1]);
         return;

      case 19: /* FILE SEARCH */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         *( (char *) (LSL_CMDCOM.STARST[1]) + LSL_CMDCOM.STARLE ) = 0;
         do_file(w,combuf,LSL_CMDCOM.STARST[1]);
         return;

      case 20: /* LABEL LABEL */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         *( (char *) (LSL_CMDCOM.STARST[1]) + LSL_CMDCOM.STARLE ) = 0;
         do_label(combuf,LSL_CMDCOM.STARST[1]);
         return;

      case 21: /* DEFINE */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         savlen = comdsc.length; comdsc.length = length;
	 ierr=lib$set_logical(s_Desc(logical_name),&comdsc,&lnm_table);
	 if (!(ierr&1)) {
	    printf("Cannot define logical name %s in table %s\n",
		   logical_name,
		   lnm_table);
	    lsl_putmsg(&ierr);
	 }
         comdsc.length = savlen;
         return;

      case 22: /* ABORT */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         write_abort(combuf);
         return;

      case 23: /* COLOR RGB */
         if (!do_commands) return;
         length = readstr(&comdsc);
         combuf[length] = 0;
         *( (char *) (LSL_CMDCOM.STARST[1]) + LSL_CMDCOM.STARLE ) = 0;
         do_color(w,combuf,LSL_CMDCOM.REALAR);
         return;

   }
}

static int widget_is_on(Widget w,XmAnyCallbackStruct *reason)
{
   int i;
   WidgetClass class = XtClass(w);
   if (class==xmToggleButtonWidgetClass) {
      return ((XmToggleButtonCallbackStruct *)reason)->set;
   } else if (class==xmListWidgetClass) {
      register XmListCallbackStruct *lc=reason;
      Arg arglist[2];
      int narg,sitem;
      XmStringTable selected_items;
      if (lc->reason==XmCR_MULTIPLE_SELECT) {
         sitem = lc->selected_item_count;
         selected_items = lc->selected_items;
      } else {
         narg = 0;
         XtSetArg(arglist[narg],XmNselectedItemCount,&sitem); narg++;
         XtSetArg(arglist[narg],XmNselectedItems,&selected_items); narg++;
         XtGetValues(w,arglist,narg);
      }
      for (i=0;i<sitem;i++) {
         if (XmStringCompare(lc->item,selected_items[i])) return TRUE;
      }
      return FALSE;
   } else if (class==xmSelectionBoxWidgetClass ||
              class==xmFileSelectionBoxWidgetClass) {
      return reason->reason==XmCR_OK;
   } else if (class==dxmColorMixWidgetClass) {
      return reason->reason!=XmCR_CANCEL;
   } else {
      return TRUE;
   }
}

static char *get_string(
	XmString string)
{
   XmStringContext context;
   XmStringCharSet charset;
   XmStringDirection dir_r_to_l;
   Boolean separator;
   char *text;

   XmStringInitContext(&context,string);
   XmStringGetNextSegment(context,&text,&charset,&dir_r_to_l,&separator);
   XmStringFreeContext(context);
   return text;
}

static void start_input()
{
   ierr = sys$qio(IEFN,ichan,IO$_READVBLK,&iosb,0,0,&ibuf,255,0,0,0,0);
   if (!(ierr&1)) {
      printf("error reading input\n");
      lsl_putmsg(&ierr);
      exit(0);
   }
}

static void ctrlcast()
{
/* just re-enable the AST */
   set_ctrlc_ast(ctrlcast);
}
