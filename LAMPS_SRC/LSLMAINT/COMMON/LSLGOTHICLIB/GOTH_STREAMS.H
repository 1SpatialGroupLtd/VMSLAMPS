/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1995-03-23 18:57:22.000000000 +0000
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
#ifndef _GOTH_STREAMS
#define _GOTH_STREAMS
/* $Header: /usr/users/jon/RCS/hdr.goth_streams.h,v 1.9 1995/01/22 20:01:40 jon Exp $								*/
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    David Radcliffe, 27-Apr-1990				*/
/************************************************************************/

/************************************************************************/
/*									*/
/*			G O T H _ S T R E A M S 			*/
/*									*/
/* Part of GOTHIC module GOTHLIB					*/
/* Version 0.1, David Radcliffe 27-Apr-1990				*/
/* This used to define the print stream datatype which is now defunct.	*/
/* This file now defines goth_stdout for input_output.c in GOTHLIB.	*/
/* This file now defines goth_tty for input_output.c in GOTHLIB.	*/
/* This file now defines goth_devnull for input_output.c in GOTHLIB.	*/
/* This file now defines goth_main_widget for input_output.c in GOTHLIB.*/
/************************************************************************/

#include "goth_config.h"
#include "goth_datatypes.h"


/*----------------------------------------------------------------------*/
/* goth_stdout is a descriptor which is defined to be of type DDT_STDOUT*/
/* For compatability people can pass NULL and it will be interpreted as */
/* goth_stdout. This enables people to write goth_stdout in their	*/
/* goth_printf(goth_stdout,"blah"); statement. Using goth_stdout directs*/
/*  output to the console window or batch window.			*/
/*----------------------------------------------------------------------*/

#ifndef _DEFINING_STDOUT
extern GOTH_DESCRIPTOR goth_stdout;
#else
struct _goth_descriptor goth_stdout_descriptor = 
{
   DDT_STDOUT,
   NULL,
   0
};
GOTH_DESCRIPTOR goth_stdout = &goth_stdout_descriptor;
#endif


/*----------------------------------------------------------------------*/
/* goth_tty is a descriptor which is defined to be of type DDT_TTY	*/
/* goth_printf(goth_tty, "blah"); statement. Using goth_tty directs	*/
/* output to the terminal window from which the application was started.*/
/*----------------------------------------------------------------------*/

#ifndef _DEFINING_TTY
extern GOTH_DESCRIPTOR goth_tty;
#else
struct _goth_descriptor goth_tty_descriptor = 
{
   DDT_TTY,
   NULL,
   0
};
GOTH_DESCRIPTOR goth_tty = &goth_tty_descriptor;
#endif


/*----------------------------------------------------------------------*/
/* goth_devnull is a descriptor which is defined to be of type		*/
/* DDT_DEVNULL. goth_printf(goth_devnull, "blah"); statement. Using	*/
/* goth_devnull directs output to nowhere. It is a convenient way of	*/
/* suppressing output from a device.					*/
/*----------------------------------------------------------------------*/

#ifndef _DEFINING_DEVNULL
extern GOTH_DESCRIPTOR goth_devnull;
#else
struct _goth_descriptor goth_devnull_descriptor = 
{
   DDT_DEVNULL,
   NULL,
   0
};
GOTH_DESCRIPTOR goth_devnull = &goth_devnull_descriptor;
#endif


/*----------------------------------------------------------------------*/
/* goth_main_widget is a descriptor which is defined to be of type	*/
/* DDT_MAIN_WIDGET. For compatability people can pass NULL and it will	*/
/* be interpreted as goth_main_widget. This enables people to pass NULL	*/
/* as the parent id of a shell when creating interfaces using		*/
/* mmi_create_blocking_shell().						*/
/*----------------------------------------------------------------------*/

#ifndef _DEFINING_MAIN_WIDGET
extern GOTH_DESCRIPTOR goth_main_widget;
#else
struct _goth_descriptor goth_main_widget_descriptor =
{
   DDT_MAIN_WIDGET,
   NULL,
   0
};
GOTH_DESCRIPTOR goth_main_widget = &goth_main_widget_descriptor;
#endif

#endif


