/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1993-05-11 09:51:36.000000000 +0100
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
/* defines */

#ifndef TRUE
  #define TRUE            1
#endif
#ifndef FALSE
  #define FALSE           0
#endif


#define ACK             0x06    /* acknowledge */
#define NAK             0x15    /* not acknowledge */

/* DAT/EM SI commands */
#define INITIALIZE                       1

#define PAN_XYZ                          2
#define PAN_XY                           3

#define Z_DISPLAY_TEXT                   4

#define UPDATE_DISPLAY                   5

#define DRAW_MODE                        6

#define SI_SCALE                         7

#define DISPLAY_SWITCH                   8

#define COM_MODE                         9

#define SCREEN_SELECT                    10

#define SET_ORIGIN                       11

#define SI_ROTATE                        12

#define MENU_CURSOR_ON                   13

#define MENU_CURSOR_OFF                  14

#define MENU_TEXT                        15

#define OPEN_WINDOW                      16

#define CLEAR_MENU_SCREEN                17

#define MENU_LINE                        18

#define SET_MENU_COLOR                   19

#define CLEAR_MENU_PIXELS                20

/* commands with color */
#define MOVE_XYZ                         8<<4  /* 128 */
#define DRAW_XYZ                         9<<4  /* 144 */

#define MOVE_XY                         10<<4  /* 160 */
#define DRAW_XY                         11<<4  /* 176 */

#define MOVE_SCREEN                     13<<4  /* 208 */
#define DRAW_SCREEN                     14<<4  /* 224 */

/* draw mode definitions */
#define REPLACE                          0
#define XOR                             10

/* com mode definitions */
#define IMAGE_DUMP                       1
#define NORM                             2

/* open_window border types */
#define DOUBLE_LINE			 1
#define SINGLE_LINE 			 2
#define BLANK_LINE			 3

/* DAT/EM SI typedefs and structs */
typedef struct
{
  char command;
  char dta;
  char checksum;
} ShortCmd;

typedef struct
{
  char command;
  unsigned long x, y, z;
  char checksum;
} VectorXYZ;

typedef struct
{
  char command;
  unsigned long x, y;
  char checksum;
} VectorXY;

typedef struct
{
  char command;
  char len;     /* strlen(ds) */
  short x, y;
  short color;             /* for menu text color is ignored */
  char ds[82];
} Text;

typedef struct
{
  char command;
  unsigned long scale;
  short xoff, yoff;
  short view;
  char checksum;
} SiScale;

typedef struct
{
  char command;
  unsigned long ra;
  char checksum;
} SiRotate;

typedef struct
{
  char command;
  short x1, y1;
  short x2, y2;
  short type;
  short color;
  char checksum;
} OpenWindow;

typedef struct
{
  char command;
  short x1, y1;
  short x2, y2;
  short color;
  char checksum;
} MenuLine;

typedef struct
{
  char command;
  unsigned char r, g, b;
  char checksum;
} MenuColor;
