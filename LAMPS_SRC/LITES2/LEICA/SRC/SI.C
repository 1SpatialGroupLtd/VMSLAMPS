/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 1993-05-12 07:04:26.000000000 +0100
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
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "si.h"

/* globals */
static VectorXYZ vectorxyz;
static VectorXY vectorxy;
static Text textpkt;
static ShortCmd shortpkt;
static OpenWindow openwindow;
static MenuLine menuline;
static MenuColor menucolor;
static MenuLine clearmenu;

static char *sendbuf;
static float last_x;
static float last_y;
static float last_z;
static char last_checksum;
static int buffered_mode=FALSE;
static int command_pending=FALSE;
static char iobuf[100];

static char makeheader(char , char );
static int ShortCmdComm(char, char);
static int VectorXYComm(char, char, float, float);
static int VectorXYZComm(char, char, float, float, float);
static int OpenWindowComm(int x1, int y1, int x2, int y2, int type, int color);
static int TextComm(char ,short x, short y, short color, char *ds, short len);
static int MenuLineComm(int x1, int y1, int x2, int y2, int color);
static int MenuColorComm(unsigned char r, unsigned char g, unsigned char b);
static int ClearMenuComm(int x1, int y1, int x2, int y2);
static int SendBuffer(char *, short);
static int WaitForAck(void);
static unsigned long cvt_ieee(float);

int SI_BUFFERED_MODE(void)
{
  buffered_mode = TRUE;
  command_pending = FALSE;
}

int SI_INIT(int *on)
{
  int errno;
  last_z = -1e38;	/* silly value */
  if (*on)
  {
    errno = com_install("LSL$SI:");
    if (errno) return errno;
    buffered_mode = FALSE;
    com_flush_rx();
    return ShortCmdComm(INITIALIZE, INITIALIZE);
  }
  else
  {
    errno = ShortCmdComm(INITIALIZE, INITIALIZE);
    com_deinstall();
    return errno;
  }
}

int SI_MOVE(float *x, float *y, float *z)
{
  if (*x==last_x && *y==last_y && *z==last_z) return FALSE;
  last_x = *x;
  last_y = *y;
  if (*z==last_z)
    return VectorXYComm(MOVE_XY, 0, *x, *y);

  last_z = *z;
  return VectorXYZComm(MOVE_XYZ, 0, *x, *y, *z);
}

int SI_LINE(int *color, float *x, float *y, float *z)
{
  if (*x==last_x && *y==last_y && *z==last_z) return FALSE;
  last_x = *x;
  last_y = *y;
  if (*z==last_z)
    return VectorXYComm(DRAW_XY, *color, *x, *y);

  last_z = *z;
  return VectorXYZComm(DRAW_XYZ, *color, *x, *y, *z);
}

int SI_DRAW_MODE(int *xor)
{
  return ShortCmdComm(DRAW_MODE, *xor?XOR:REPLACE);
}

int SI_VISIBLE(int *on)
{
  return ShortCmdComm(DISPLAY_SWITCH, *on);
}

int SI_UPDATE(void)
{
  int failed;

  if (buffered_mode && command_pending) {
    command_pending = FALSE;
    com_tx(last_checksum);
    failed = WaitForAck();
    if (failed) {
      command_pending = FALSE;
      printf("SI command failed\n");
      return TRUE;
    }
  }
  buffered_mode = FALSE;

  return ShortCmdComm(UPDATE_DISPLAY, UPDATE_DISPLAY);
}

int SI_CLEAR_MENU(void)
{
  return ShortCmdComm(CLEAR_MENU_SCREEN, CLEAR_MENU_SCREEN);
}

int SI_CLEAR_MENU_PIXELS(int *x1,int *y1,int *x2,int *y2)
{
  return ClearMenuComm(*x1,*y1,*x2,*y2);
}

int SI_OPEN_WINDOW(int *x1,int *y1,int *x2,int *y2,int *type)
{
  return OpenWindowComm(*x1,*y1,*x2,*y2,*type,0);
}

int SI_DRAW_TEXT(int *x1,int *y1,char *text,short *len)
{
  return TextComm(MENU_TEXT,*x1,*y1,0,text,*len);
}

int SI_DRAW_LINE(int *x1,int *y1,int *x2,int *y2)
{
  return MenuLineComm(*x1,*y1,*x2,*y2,0);
}

int SI_MENU_CURSOR(int *on)
{
  if (*on)
    return ShortCmdComm(MENU_CURSOR_ON, MENU_CURSOR_ON);
  else
    return ShortCmdComm(MENU_CURSOR_OFF, MENU_CURSOR_OFF);
}

int SI_PAN_XY(int *x,int *y)
{
  return VectorXYComm(PAN_XY, 0, (float) *x, (float) *y);
}

int SI_MENU_COLOR(int *r,int *g,int *b)
{
  return MenuColorComm(*r,*g,*b);
}


static char makeheader(char command, char color)
{
  /* if high bit set add color else just command */
  return ( command & 128 ) ? command + (color & 0x0f) : command;
}


static int WaitForAck(void)
{
  char ch;

  if ( (ch = com_rx()) == ACK ) return FALSE;  /* all's ok */

  /* send 2 ACK's to mark re-start of data */
  com_tx(ACK);
  com_tx(ACK);

  com_flush_rx();  /* bad response, flush buffers */

/* ch == NAK if acknowledged bad, otherwise probably no response */
  return TRUE;
}


static int SendBuffer(char *buf, short nchar)
{
  int i;
  char checksum = 0;
  int failed;
  int ioptr;

  for ( i=0; i<nchar-1; i++ ) {
    checksum += buf[i];
  }
  if (buffered_mode) {
    ioptr = 0;
    if (command_pending) {
       iobuf[0] = last_checksum;
       ioptr = 1;
    }
    for ( i=0; i<nchar-1; i++ ) iobuf[ioptr++] = buf[i];
    com_txs(iobuf,ioptr);
    last_checksum = checksum;
    if (command_pending) {
      failed = WaitForAck();
      if (failed) {
        command_pending = FALSE;
        printf("SI command failed\n");
        return TRUE;
      }
    }
    command_pending = TRUE;
    return FALSE;
  } else {
    buf[i] = checksum;
    i = 0;
    do
    {
      com_txs(buf,nchar);
      if (!WaitForAck()) return FALSE;
    } while (i++ < 1);
    printf("SI command failed\n");
    return TRUE;
  }
}


/* DAT/EM SI command set */

static int VectorXYZComm(char command, char color, float x, float y, float z)
{

  sendbuf = (char *) (&vectorxyz);
  vectorxyz.command = makeheader(command, color);

  vectorxyz.x = cvt_ieee( x );
  vectorxyz.y = cvt_ieee( y );
  vectorxyz.z = cvt_ieee( z );

  return SendBuffer(sendbuf, sizeof(VectorXYZ));
}


static int VectorXYComm(char command, char color, float x, float y)
{
  sendbuf = (char *) (&vectorxy);
  vectorxy.command = makeheader(command, color);

  vectorxy.x = cvt_ieee( x );
  vectorxy.y = cvt_ieee( y );

  return SendBuffer(sendbuf, sizeof(VectorXY));
}


static int ShortCmdComm(char cmd, char dta)
{
  sendbuf = (char *) (&shortpkt);
  shortpkt.command = makeheader(cmd, 0);
  shortpkt.dta = dta;

  return SendBuffer(sendbuf, sizeof(ShortCmd));
}


static int OpenWindowComm(int x1, int y1, int x2, int y2, int type, int color)
{
  sendbuf = (char *)(&openwindow);
  openwindow.command = makeheader(OPEN_WINDOW, 0);
  openwindow.x1 = x1;
  openwindow.y1 = y1;
  openwindow.x2 = x2;
  openwindow.y2 = y2;
  openwindow.type = type;
  openwindow.color = color;

  return SendBuffer(sendbuf, sizeof(OpenWindow));
}


static int ClearMenuComm(int x1, int y1, int x2, int y2)
{
  sendbuf = (char *)(&clearmenu);
  clearmenu.command = makeheader(CLEAR_MENU_PIXELS, 0);
  clearmenu.x1 = x1;
  clearmenu.y1 = y1;
  clearmenu.x2 = x2;
  clearmenu.y2 = y2;
  clearmenu.color = 0;

  return SendBuffer(sendbuf, sizeof(MenuLine));
}


static int TextComm(char command, short x, short y, short color, char *ds, short len)
{
  sendbuf = (char *) &textpkt;
  if ( len > 80 ) len = 80;  /* truncate overlong strings */

  textpkt.command = makeheader(command, 0);
  textpkt.len = len;
  textpkt.x = x;
  textpkt.y = y;
  textpkt.color = color;
  strncpy(textpkt.ds, ds, len);

  /*
   * packet length is:
   * command byte (1) + len byte (1) +
   * x word (2) + y word (2) + color word (2) +
   * string length (len) + checksum byte (1)
   * 1 + 1 + 2 + 2 + 2 + len + 1 = len + 9
   */
  return SendBuffer(sendbuf, len+9);
}
 
static int MenuLineComm(int x1, int y1, int x2, int y2, int color)
{
  sendbuf = (char *)(&menuline);
  menuline.command = makeheader(MENU_LINE, 0);
  menuline.x1 = x1;
  menuline.y1 = y1;
  menuline.x2 = x2;
  menuline.y2 = y2;
  menuline.color = color;
 
  return SendBuffer(sendbuf, sizeof(MenuLine));
}

static int MenuColorComm(unsigned char r, unsigned char g, unsigned char b)
{
  sendbuf = (char *)(&menucolor);
  menucolor.command = makeheader(SET_MENU_COLOR, 0);
  menucolor.r = r;
  menucolor.g = g;
  menucolor.b = b;

  return SendBuffer(sendbuf, sizeof(MenuColor));
}

static unsigned long cvt_ieee(float f)
{
  union {
    float f;
    unsigned long i;
    struct {
      unsigned f1 :  7;
      unsigned  e :  8;
      unsigned  s :  1;
      unsigned f2 : 16;
    } vax_float;
    struct {
      unsigned f2 : 16;
      unsigned f1 :  7;
      unsigned  e :  8;
      unsigned  s :  1;
    } ieee_float;
  } v_f, i_f;
  if (f==0.0) return 0;	/* integer zero is also IEEE float 0.0 */
  v_f.f = f;
  i_f.ieee_float.f1 = v_f.vax_float.f1;
  i_f.ieee_float.f2 = v_f.vax_float.f2;
  i_f.ieee_float.e  = v_f.vax_float.e - 2;
  i_f.ieee_float.s  = v_f.vax_float.s;
  return i_f.i;
}
