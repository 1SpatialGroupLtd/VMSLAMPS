/*
 * This file is part of the LAMPS distribution, released as a software
 * preservation project to archive digital history for future historians.
 * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
 *
 * Timestamp of this file for the 2002 release was: 2001-12-24 11:11:20.000000000 +0000
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
/* LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.C generated from LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.PSW
   by unix XDPS$PSWRAP.EXE V1.009  Wed Apr 19 17:50:24 PDT 1989
 */

#include <xdps$include:dpsfriends.h>

#line 1 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.PSW"
/************************************************************************/
/* Copyright Laser-Scan Ltd, Cambridge CB4 4FY, England			*/
/* Author    Clarke Brunt, 16-Jan-1990					*/
/* MOD       Matt Wenham,  17-Jun-1997	WI/CC 1580			*/
/************************************************************************/

#include <string.h>

/* Wraps for GKSMOTIFLIB */

/* Take care to use /SOURCE_OUTPUT=ANSI qualifier on PSWRAP to get */
/* proper prototyes, otherwise there are problems passing real args */
/* which expect to be received by value as doubles. */

/* Also my attempts to pass a context seem to be ignored, and the */
/* default is used. Edit the resulting C to fix this. */

/* Initialize some things for use later. */
#line 27 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.C"
void GWRAP_INIT(DPSContext c)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char topLevelCount;
    unsigned short nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjGeneric obj1;
    DPSBinObjGeneric obj2;
    DPSBinObjGeneric obj3;
    DPSBinObjGeneric obj4;
    DPSBinObjGeneric obj5;
    DPSBinObjGeneric obj6;
    DPSBinObjGeneric obj7;
    DPSBinObjGeneric obj8;
    DPSBinObjGeneric obj9;
    DPSBinObjGeneric obj10;
    DPSBinObjGeneric obj11;
    DPSBinObjGeneric obj12;
    DPSBinObjGeneric obj13;
    DPSBinObjGeneric obj14;
    DPSBinObjGeneric obj15;
    DPSBinObjGeneric obj16;
    DPSBinObjGeneric obj17;
    DPSBinObjGeneric obj18;
    DPSBinObjGeneric obj19;
    DPSBinObjGeneric obj20;
    DPSBinObjGeneric obj21;
    DPSBinObjGeneric obj22;
    DPSBinObjGeneric obj23;
    DPSBinObjGeneric obj24;
    DPSBinObjGeneric obj25;
    DPSBinObjGeneric obj26;
    DPSBinObjGeneric obj27;
    DPSBinObjGeneric obj28;
    DPSBinObjGeneric obj29;
    DPSBinObjGeneric obj30;
    DPSBinObjGeneric obj31;
    DPSBinObjGeneric obj32;
    DPSBinObjGeneric obj33;
    DPSBinObjGeneric obj34;
    DPSBinObjGeneric obj35;
    DPSBinObjGeneric obj36;
    DPSBinObjGeneric obj37;
    DPSBinObjGeneric obj38;
    DPSBinObjGeneric obj39;
    DPSBinObjGeneric obj40;
    DPSBinObjGeneric obj41;
    DPSBinObjGeneric obj42;
    DPSBinObjGeneric obj43;
    DPSBinObjGeneric obj44;
    DPSBinObjGeneric obj45;
    DPSBinObjGeneric obj46;
    DPSBinObjGeneric obj47;
    DPSBinObjGeneric obj48;
    DPSBinObjGeneric obj49;
    DPSBinObjGeneric obj50;
    DPSBinObjGeneric obj51;
    DPSBinObjGeneric obj52;
    DPSBinObjGeneric obj53;
    DPSBinObjGeneric obj54;
    DPSBinObjGeneric obj55;
    DPSBinObjGeneric obj56;
    DPSBinObjGeneric obj57;
    DPSBinObjGeneric obj58;
    DPSBinObjGeneric obj59;
    DPSBinObjGeneric obj60;
    DPSBinObjGeneric obj61;
    DPSBinObjGeneric obj62;
    DPSBinObjGeneric obj63;
    DPSBinObjGeneric obj64;
    DPSBinObjGeneric obj65;
    DPSBinObjGeneric obj66;
    DPSBinObjGeneric obj67;
    DPSBinObjGeneric obj68;
    DPSBinObjGeneric obj69;
    DPSBinObjGeneric obj70;
    DPSBinObjGeneric obj71;
    DPSBinObjGeneric obj72;
    DPSBinObjGeneric obj73;
    DPSBinObjGeneric obj74;
    DPSBinObjGeneric obj75;
    DPSBinObjGeneric obj76;
    DPSBinObjGeneric obj77;
    DPSBinObjGeneric obj78;
    DPSBinObjGeneric obj79;
    DPSBinObjGeneric obj80;
    DPSBinObjGeneric obj81;
    DPSBinObjGeneric obj82;
    DPSBinObjGeneric obj83;
    DPSBinObjGeneric obj84;
    DPSBinObjGeneric obj85;
    DPSBinObjGeneric obj86;
    DPSBinObjGeneric obj87;
    DPSBinObjGeneric obj88;
    DPSBinObjGeneric obj89;
    DPSBinObjGeneric obj90;
    DPSBinObjGeneric obj91;
    DPSBinObjGeneric obj92;
    DPSBinObjGeneric obj93;
    DPSBinObjGeneric obj94;
    DPSBinObjGeneric obj95;
    DPSBinObjGeneric obj96;
    DPSBinObjGeneric obj97;
    DPSBinObjGeneric obj98;
    DPSBinObjGeneric obj99;
    DPSBinObjGeneric obj100;
    DPSBinObjGeneric obj101;
    DPSBinObjGeneric obj102;
    DPSBinObjGeneric obj103;
    DPSBinObjGeneric obj104;
    DPSBinObjGeneric obj105;
    DPSBinObjGeneric obj106;
    DPSBinObjGeneric obj107;
    DPSBinObjGeneric obj108;
    DPSBinObjGeneric obj109;
    DPSBinObjGeneric obj110;
    DPSBinObjGeneric obj111;
    DPSBinObjGeneric obj112;
    DPSBinObjGeneric obj113;
    DPSBinObjGeneric obj114;
    DPSBinObjGeneric obj115;
    DPSBinObjGeneric obj116;
    DPSBinObjGeneric obj117;
    DPSBinObjGeneric obj118;
    DPSBinObjGeneric obj119;
    DPSBinObjGeneric obj120;
    DPSBinObjGeneric obj121;
    DPSBinObjGeneric obj122;
    DPSBinObjGeneric obj123;
    DPSBinObjGeneric obj124;
    DPSBinObjGeneric obj125;
    DPSBinObjGeneric obj126;
    DPSBinObjGeneric obj127;
    DPSBinObjGeneric obj128;
    DPSBinObjGeneric obj129;
    DPSBinObjGeneric obj130;
    DPSBinObjGeneric obj131;
    DPSBinObjGeneric obj132;
    DPSBinObjGeneric obj133;
    DPSBinObjGeneric obj134;
    DPSBinObjGeneric obj135;
    DPSBinObjGeneric obj136;
    DPSBinObjGeneric obj137;
    DPSBinObjGeneric obj138;
    DPSBinObjGeneric obj139;
    DPSBinObjGeneric obj140;
    DPSBinObjGeneric obj141;
    DPSBinObjGeneric obj142;
    DPSBinObjGeneric obj143;
    DPSBinObjGeneric obj144;
    DPSBinObjGeneric obj145;
    DPSBinObjGeneric obj146;
    DPSBinObjGeneric obj147;
    DPSBinObjGeneric obj148;
    DPSBinObjGeneric obj149;
    DPSBinObjGeneric obj150;
    DPSBinObjGeneric obj151;
    DPSBinObjGeneric obj152;
    DPSBinObjGeneric obj153;
    DPSBinObjGeneric obj154;
    DPSBinObjGeneric obj155;
    DPSBinObjGeneric obj156;
    DPSBinObjGeneric obj157;
    DPSBinObjGeneric obj158;
    DPSBinObjGeneric obj159;
    DPSBinObjGeneric obj160;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 37, 1292,
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* PIXMAT */
    {DPS_LITERAL|DPS_ARRAY, 0, 6, 1240},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* MAXFNT */
    {DPS_LITERAL|DPS_INT, 0, 0, 127},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* FNTDICT */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* MAXFNT */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 53},	/* dict */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* SCALE */
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, DPSSYSNAME, 427},	/* z */
    {DPS_EXEC|DPS_ARRAY, 0, 13, 936},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 14},	/* bind */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* ReENCODE */
    {DPS_EXEC|DPS_ARRAY, 0, 19, 696},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 14},	/* bind */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* SET_COLOR */
    {DPS_EXEC|DPS_ARRAY, 0, 10, 616},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 14},	/* bind */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* SHOW_AT */
    {DPS_EXEC|DPS_ARRAY, 0, 11, 528},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 14},	/* bind */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* WIDTH */
    {DPS_EXEC|DPS_ARRAY, 0, 12, 432},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 14},	/* bind */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* BOX */
    {DPS_EXEC|DPS_ARRAY, 0, 17, 296},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 14},	/* bind */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 78},	/* gsave */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* SCALE */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 427},	/* z */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* SCALE */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 164},	/* store */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 107},	/* moveto */
    {DPS_LITERAL|DPS_BOOL, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 17},	/* charpath */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 68},	/* flattenpath */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 115},	/* pathbbox */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 77},	/* grestore */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 78},	/* gsave */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* SCALE */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 427},	/* z */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* SCALE */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 164},	/* store */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 166},	/* stringwidth */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 77},	/* grestore */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 78},	/* gsave */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 173},	/* translate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 136},	/* rotate */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 107},	/* moveto */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* SCALE */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 56},	/* dup */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 139},	/* scale */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 160},	/* show */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 77},	/* grestore */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentXgcdrawablecolor */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 56},	/* dup */
    {DPS_LITERAL|DPS_INT, 0, 0, 2},
    {DPS_LITERAL|DPS_INT, 0, 0, 8},
    {DPS_LITERAL|DPS_INT, 0, 0, -1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 135},	/* roll */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 120},	/* put */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* setXgcdrawablecolor */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* PIXMAT */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 156},	/* setmatrix */
    {DPS_LITERAL|DPS_INT, 0, 0, 3},
    {DPS_LITERAL|DPS_INT, 0, 0, -1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 135},	/* roll */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 56},	/* dup */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 98},	/* length */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 53},	/* dict */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 56},	/* dup */
    {DPS_LITERAL|DPS_INT, 0, 0, 3},
    {DPS_LITERAL|DPS_INT, 0, 0, -1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 135},	/* roll */
    {DPS_EXEC|DPS_ARRAY, 0, 7, 848},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 73},	/* forall */
    {DPS_LITERAL|DPS_INT, 0, 0, 3},
    {DPS_LITERAL|DPS_INT, 0, 0, -1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 135},	/* roll */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* Encoding */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 120},	/* put */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 290},	/* definefont */
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 88},	/* index */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* FID */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 109},	/* ne */
    {DPS_EXEC|DPS_ARRAY, 0, 2, 920},
    {DPS_EXEC|DPS_ARRAY, 0, 2, 904},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 85},	/* ifelse */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 120},	/* put */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 56},	/* dup */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 56},	/* dup */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* FNTDICT */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 13},	/* begin */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 186},	/* where */
    {DPS_EXEC|DPS_ARRAY, 0, 10, 1096},
    {DPS_EXEC|DPS_ARRAY, 0, 7, 1040},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 85},	/* ifelse */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 57},	/* end */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* SCALE */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 164},	/* store */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 149},	/* setfont */
    {DPS_LITERAL|DPS_NAME, 0, DPSSYSNAME, 199},	/* Courier */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 67},	/* findfont */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 56},	/* dup */
    {DPS_LITERAL|DPS_INT, 0, 0, 3},
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 135},	/* roll */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 56},	/* dup */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 100},	/* load */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 56},	/* dup */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 175},	/* type */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* dicttype */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 61},	/* eq */
    {DPS_EXEC|DPS_ARRAY, 0, 2, 1224},
    {DPS_EXEC|DPS_ARRAY, 0, 6, 1176},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 85},	/* ifelse */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 63},	/* exec */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 56},	/* dup */
    {DPS_LITERAL|DPS_INT, 0, 0, 3},
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 135},	/* roll */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, -1},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = c;
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  static long int _dpsCodes[23] = {-1};
  {
if (_dpsCodes[0] < 0) {
    static const char * const _dps_names[] = {
	"PIXMAT",
	(char *) 0 ,
	"MAXFNT",
	(char *) 0 ,
	"FNTDICT",
	(char *) 0 ,
	"SCALE",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"ReENCODE",
	"SET_COLOR",
	"SHOW_AT",
	"WIDTH",
	"BOX",
	"currentXgcdrawablecolor",
	"setXgcdrawablecolor",
	"Encoding",
	"FID",
	"dicttype"};
    long int *_dps_nameVals[23];
    _dps_nameVals[0] = &_dpsCodes[0];
    _dps_nameVals[1] = &_dpsCodes[1];
    _dps_nameVals[2] = &_dpsCodes[2];
    _dps_nameVals[3] = &_dpsCodes[3];
    _dps_nameVals[4] = &_dpsCodes[4];
    _dps_nameVals[5] = &_dpsCodes[5];
    _dps_nameVals[6] = &_dpsCodes[6];
    _dps_nameVals[7] = &_dpsCodes[7];
    _dps_nameVals[8] = &_dpsCodes[8];
    _dps_nameVals[9] = &_dpsCodes[9];
    _dps_nameVals[10] = &_dpsCodes[10];
    _dps_nameVals[11] = &_dpsCodes[11];
    _dps_nameVals[12] = &_dpsCodes[12];
    _dps_nameVals[13] = &_dpsCodes[13];
    _dps_nameVals[14] = &_dpsCodes[14];
    _dps_nameVals[15] = &_dpsCodes[15];
    _dps_nameVals[16] = &_dpsCodes[16];
    _dps_nameVals[17] = &_dpsCodes[17];
    _dps_nameVals[18] = &_dpsCodes[18];
    _dps_nameVals[19] = &_dpsCodes[19];
    _dps_nameVals[20] = &_dpsCodes[20];
    _dps_nameVals[21] = &_dpsCodes[21];
    _dps_nameVals[22] = &_dpsCodes[22];

    DPSMapNames(_dpsCurCtxt, 23, _dps_names, _dps_nameVals);
    }
  }

  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[0].val.nameVal = _dpsCodes[0];
  _dpsP[85].val.nameVal = _dpsCodes[1];
  _dpsP[3].val.nameVal = _dpsCodes[2];
  _dpsP[7].val.nameVal = _dpsCodes[3];
  _dpsP[6].val.nameVal = _dpsCodes[4];
  _dpsP[118].val.nameVal = _dpsCodes[5];
  _dpsP[10].val.nameVal = _dpsCodes[6];
  _dpsP[126].val.nameVal = _dpsCodes[7];
  _dpsP[72].val.nameVal = _dpsCodes[8];
  _dpsP[60].val.nameVal = _dpsCodes[9];
  _dpsP[55].val.nameVal = _dpsCodes[10];
  _dpsP[43].val.nameVal = _dpsCodes[11];
  _dpsP[38].val.nameVal = _dpsCodes[12];
  _dpsP[17].val.nameVal = _dpsCodes[13];
  _dpsP[21].val.nameVal = _dpsCodes[14];
  _dpsP[25].val.nameVal = _dpsCodes[15];
  _dpsP[29].val.nameVal = _dpsCodes[16];
  _dpsP[33].val.nameVal = _dpsCodes[17];
  _dpsP[77].val.nameVal = _dpsCodes[18];
  _dpsP[84].val.nameVal = _dpsCodes[19];
  _dpsP[102].val.nameVal = _dpsCodes[20];
  _dpsP[108].val.nameVal = _dpsCodes[21];
  _dpsP[142].val.nameVal = _dpsCodes[22];
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,1292);
}
#line 81 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.PSW"


/* Allow us to change the drawable for a context. */
/* Need to provide gc and x/y offset also. */
/* This operation resets the coordinate units, so ensure */
/* they are set to x pixels afterwards. */
#line 454 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.C"
void GWRAP_SET_GC_DRAWABLE(DPSContext c, int gc, int drawable, int x, int y)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char topLevelCount;
    unsigned short nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjGeneric obj1;
    DPSBinObjGeneric obj2;
    DPSBinObjGeneric obj3;
    DPSBinObjGeneric obj4;
    DPSBinObjGeneric obj5;
    DPSBinObjGeneric obj6;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 7, 60,
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: gc */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: drawable */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: x */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: y */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* setXgcdrawable */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* PIXMAT */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 156},	/* setmatrix */
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = c;
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  static long int _dpsCodes[2] = {-1};
  {
if (_dpsCodes[0] < 0) {
    static const char * const _dps_names[] = {
	"setXgcdrawable",
	"PIXMAT"};
    long int *_dps_nameVals[2];
    _dps_nameVals[0] = &_dpsCodes[0];
    _dps_nameVals[1] = &_dpsCodes[1];

    DPSMapNames(_dpsCurCtxt, 2, _dps_names, _dps_nameVals);
    }
  }

  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[0].val.integerVal = gc;
  _dpsP[1].val.integerVal = drawable;
  _dpsP[2].val.integerVal = x;
  _dpsP[3].val.integerVal = y;
  _dpsP[4].val.nameVal = _dpsCodes[0];
  _dpsP[5].val.nameVal = _dpsCodes[1];
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,60);
}
#line 90 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.PSW"


/* Change the drawable leaving other things the same. */
#line 511 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.C"
void GWRAP_CHANGE_DRAWABLE(DPSContext c, int drawable)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char topLevelCount;
    unsigned short nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjGeneric obj1;
    DPSBinObjGeneric obj2;
    DPSBinObjGeneric obj3;
    DPSBinObjGeneric obj4;
    DPSBinObjGeneric obj5;
    DPSBinObjGeneric obj6;
    DPSBinObjGeneric obj7;
    DPSBinObjGeneric obj8;
    DPSBinObjGeneric obj9;
    DPSBinObjGeneric obj10;
    DPSBinObjGeneric obj11;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 12, 100,
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentXgcdrawable */
    {DPS_LITERAL|DPS_INT, 0, 0, 3},
    {DPS_LITERAL|DPS_INT, 0, 0, -1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 135},	/* roll */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: drawable */
    {DPS_LITERAL|DPS_INT, 0, 0, 3},
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 135},	/* roll */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* setXgcdrawable */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* PIXMAT */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 156},	/* setmatrix */
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = c;
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  static long int _dpsCodes[3] = {-1};
  {
if (_dpsCodes[0] < 0) {
    static const char * const _dps_names[] = {
	"currentXgcdrawable",
	"setXgcdrawable",
	"PIXMAT"};
    long int *_dps_nameVals[3];
    _dps_nameVals[0] = &_dpsCodes[0];
    _dps_nameVals[1] = &_dpsCodes[1];
    _dps_nameVals[2] = &_dpsCodes[2];

    DPSMapNames(_dpsCurCtxt, 3, _dps_names, _dps_nameVals);
    }
  }

  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[5].val.integerVal = drawable;
  _dpsP[0].val.nameVal = _dpsCodes[0];
  _dpsP[9].val.nameVal = _dpsCodes[1];
  _dpsP[10].val.nameVal = _dpsCodes[2];
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,100);
}
#line 98 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.PSW"


/* Change the first_gray element of the color array. */
#line 578 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.C"
void GWRAP_SET_COLOR(DPSContext c, int col)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char topLevelCount;
    unsigned short nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjGeneric obj1;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 2, 20,
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: col */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* SET_COLOR */
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = c;
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  static long int _dpsCodes[1] = {-1};
  {
if (_dpsCodes[0] < 0) {
    static const char * const _dps_names[] = {
	"SET_COLOR"};
    long int *_dps_nameVals[1];
    _dps_nameVals[0] = &_dpsCodes[0];

    DPSMapNames(_dpsCurCtxt, 1, _dps_names, _dps_nameVals);
    }
  }

  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[0].val.integerVal = col;
  _dpsP[1].val.nameVal = _dpsCodes[0];
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,20);
}
#line 103 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.PSW"


/* Ordinary moveto. */
#line 619 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.C"
void GWRAP_MOVETO(DPSContext c, float x, float y)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char topLevelCount;
    unsigned short nBytes;

    DPSBinObjReal obj0;
    DPSBinObjReal obj1;
    DPSBinObjGeneric obj2;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 3, 28,
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: x */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: y */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 107},	/* moveto */
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = c;
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[0].val.realVal = x;
  _dpsP[1].val.realVal = y;
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,28);
}
#line 108 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.PSW"


/* Show text at a position. */
#line 650 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.C"
void GWRAP_SHOW_AT(DPSContext c, float x, float y, float ang, char *str)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char topLevelCount;
    unsigned short nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjReal obj1;
    DPSBinObjReal obj2;
    DPSBinObjReal obj3;
    DPSBinObjGeneric obj4;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 5, 44,
    {DPS_LITERAL|DPS_STRING, 0, 0, 40},	/* param str */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: ang */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: x */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: y */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* SHOW_AT */
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = c;
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  static long int _dpsCodes[1] = {-1};
  register int _dps_offset = 40;
  {
if (_dpsCodes[0] < 0) {
    static const char * const _dps_names[] = {
	"SHOW_AT"};
    long int *_dps_nameVals[1];
    _dps_nameVals[0] = &_dpsCodes[0];

    DPSMapNames(_dpsCurCtxt, 1, _dps_names, _dps_nameVals);
    }
  }

  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[2].val.realVal = x;
  _dpsP[3].val.realVal = y;
  _dpsP[1].val.realVal = ang;
  _dpsP[0].length = strlen(str);
  _dpsP[4].val.nameVal = _dpsCodes[0];
  _dpsP[0].val.stringVal = _dps_offset;
  _dps_offset += _dpsP[0].length;

  _dpsF.nBytes = _dps_offset+4;
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,44);
  DPSWriteStringChars(_dpsCurCtxt, (char *)str, _dpsP[0].length);
}
#line 113 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.PSW"


/* Set the font, size, and angle. */
#line 706 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.C"
void GWRAP_SET_FONT(DPSContext c, char *fnum, float size)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char topLevelCount;
    unsigned short nBytes;

    DPSBinObjReal obj0;
    DPSBinObjGeneric obj1;
    DPSBinObjGeneric obj2;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 3, 28,
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: size */
    {DPS_LITERAL|DPS_NAME, 0, 0, 24},	/* param fnum */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 427},	/* z */
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = c;
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  register int _dps_offset = 24;
  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[1].length = strlen(fnum);
  _dpsP[0].val.realVal = size;
  _dpsP[1].val.stringVal = _dps_offset;
  _dps_offset += _dpsP[1].length;

  _dpsF.nBytes = _dps_offset+4;
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,28);
  DPSWriteStringChars(_dpsCurCtxt, (char *)fnum, _dpsP[1].length);
}
#line 118 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.PSW"


/* Return the width of a string. */
#line 743 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.C"
void GWRAP_STRING_WIDTH(DPSContext c, char *string, char *fnum, float *width)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char topLevelCount;
    unsigned short nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjGeneric obj1;
    DPSBinObjGeneric obj2;
    DPSBinObjGeneric obj3;
    DPSBinObjGeneric obj4;
    DPSBinObjGeneric obj5;
    DPSBinObjGeneric obj6;
    DPSBinObjGeneric obj7;
    DPSBinObjGeneric obj8;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 9, 76,
    {DPS_LITERAL|DPS_STRING, 0, 0, 72},	/* param string */
    {DPS_LITERAL|DPS_NAME, 0, 0, 72},	/* param fnum */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* WIDTH */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 70},	/* flush */
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = c;
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  static long int _dpsCodes[1] = {-1};
  register int _dps_offset = 72;
  DPSResultsRec _dpsR[1];
  static const DPSResultsRec _dpsRstat[] = {
    { dps_tFloat, -1 },
    };
    _dpsR[0] = _dpsRstat[0];
    _dpsR[0].value = (char *)width;

  {
if (_dpsCodes[0] < 0) {
    static const char * const _dps_names[] = {
	"WIDTH"};
    long int *_dps_nameVals[1];
    _dps_nameVals[0] = &_dpsCodes[0];

    DPSMapNames(_dpsCurCtxt, 1, _dps_names, _dps_nameVals);
    }
  }

  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[0].length = strlen(string);
  _dpsP[1].length = strlen(fnum);
  _dpsP[2].val.nameVal = _dpsCodes[0];
  _dpsP[1].val.stringVal = _dps_offset;
  _dps_offset += _dpsP[1].length;
  _dpsP[0].val.stringVal = _dps_offset;
  _dps_offset += _dpsP[0].length;

  _dpsF.nBytes = _dps_offset+4;
  DPSSetResultTable(_dpsCurCtxt, _dpsR, 1);
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,76);
  DPSWriteStringChars(_dpsCurCtxt, (char *)fnum, _dpsP[1].length);
  DPSWriteStringChars(_dpsCurCtxt, (char *)string, _dpsP[0].length);
  DPSAwaitReturnValues(_dpsCurCtxt);
}
#line 123 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.PSW"


/* Return the bounding box of a string. */
#line 817 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.C"
void GWRAP_STRING_BOX(DPSContext c, char *string, char *fnum, float *minx, float *miny, float *maxx, float *maxy)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char topLevelCount;
    unsigned short nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjGeneric obj1;
    DPSBinObjGeneric obj2;
    DPSBinObjGeneric obj3;
    DPSBinObjGeneric obj4;
    DPSBinObjGeneric obj5;
    DPSBinObjGeneric obj6;
    DPSBinObjGeneric obj7;
    DPSBinObjGeneric obj8;
    DPSBinObjGeneric obj9;
    DPSBinObjGeneric obj10;
    DPSBinObjGeneric obj11;
    DPSBinObjGeneric obj12;
    DPSBinObjGeneric obj13;
    DPSBinObjGeneric obj14;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 15, 124,
    {DPS_LITERAL|DPS_STRING, 0, 0, 120},	/* param string */
    {DPS_LITERAL|DPS_NAME, 0, 0, 120},	/* param fnum */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* BOX */
    {DPS_LITERAL|DPS_INT, 0, 0, 3},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 2},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 4},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 70},	/* flush */
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = c;
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  static long int _dpsCodes[1] = {-1};
  register int _dps_offset = 120;
  DPSResultsRec _dpsR[4];
  static const DPSResultsRec _dpsRstat[] = {
    { dps_tFloat, -1 },
    { dps_tFloat, -1 },
    { dps_tFloat, -1 },
    { dps_tFloat, -1 },
    };
    _dpsR[0] = _dpsRstat[0];
    _dpsR[0].value = (char *)minx;
    _dpsR[1] = _dpsRstat[1];
    _dpsR[1].value = (char *)miny;
    _dpsR[2] = _dpsRstat[2];
    _dpsR[2].value = (char *)maxx;
    _dpsR[3] = _dpsRstat[3];
    _dpsR[3].value = (char *)maxy;

  {
if (_dpsCodes[0] < 0) {
    static const char * const _dps_names[] = {
	"BOX"};
    long int *_dps_nameVals[1];
    _dps_nameVals[0] = &_dpsCodes[0];

    DPSMapNames(_dpsCurCtxt, 1, _dps_names, _dps_nameVals);
    }
  }

  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[0].length = strlen(string);
  _dpsP[1].length = strlen(fnum);
  _dpsP[2].val.nameVal = _dpsCodes[0];
  _dpsP[1].val.stringVal = _dps_offset;
  _dps_offset += _dpsP[1].length;
  _dpsP[0].val.stringVal = _dps_offset;
  _dps_offset += _dpsP[0].length;

  _dpsF.nBytes = _dps_offset+4;
  DPSSetResultTable(_dpsCurCtxt, _dpsR, 4);
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,124);
  DPSWriteStringChars(_dpsCurCtxt, (char *)fnum, _dpsP[1].length);
  DPSWriteStringChars(_dpsCurCtxt, (char *)string, _dpsP[0].length);
  DPSAwaitReturnValues(_dpsCurCtxt);
}
#line 129 "LSL$SOURCE_ROOT:[LSLMAINT.GKSMOTIFLIB.SRC]WRAPS.PSW"


/* This is not a wrap - but this seems a convenient home for it */
#include <xdps$include:dpsclient.h>
extern void GKS_DPS_DESTROY_SPACE(DPSContext ctx)
{
   DPSDestroySpace(ctx->space);
}
