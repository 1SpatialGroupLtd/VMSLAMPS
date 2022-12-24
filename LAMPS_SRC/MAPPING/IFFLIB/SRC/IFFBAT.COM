$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1997-06-06 10:41:08.000000000 +0100
$! *
$! * This program is free software: you can redistribute it and/or modify
$! * it under the terms of the GNU General Public License as published by
$! * the Free Software Foundation, version 3.
$! *
$! * This program is distributed in the hope that it will be useful, but
$! * WITHOUT ANY WARRANTY; without even the implied warranty of
$! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
$! * General Public License for more details.
$! *
$! * You should have received a copy of the GNU General Public License
$! * along with this program. If not, see http://www.gnu.org/licenses/.
$!
$	ASSIGN MAR:TR.MAR TR
$	SET DEF LSL$SOURCE_ROOT:[MAPPING.IFFLIB.SRC]
$	ASSIGN LSL$SOURCE_ROOT:[MAPPING.IFFLIB.SRC] SRC
$	ASSIGN LSL$SOURCE_ROOT:[MAPPING.IFFLIB.SRC] MAR
$	ASSIGN LSL$SOURCE_ROOT:[MAPPING.IFFLIB.SRC] EXE
$	ASSIGN LSL$PUBLIC_ROOT:[MAPPING.COMMON.IFFLIB] CMN
$	SET NOON
$!  +++++++++++++++  Everything   +++++++++++++++
$!  +++++++++++++++  Macro stuff  +++++++++++++++
$!  ++++++++++++++  Fortran stuff  ++++++++++++++
$!  ++++++++++++++++  Messages   ++++++++++++++++
$!  ++++++++++++++++++  IFFTB  ++++++++++++++++++
$	MACRO/NOLIST/ENA=DBG/OBJECT=IFFTB TR:+ -
		MAR:IFFDCL+IFFTB
$	PURGE IFFTB.OBJ
$!  +++++++++++++++  IFF_DEFACD   +++++++++++++++
$	MACRO/NOLIST/OBJECT=IFF_DEFACD TR:+ -
		MAR:IFF_DEFACD
$	PURGE IFF_DEFACD.OBJ
$!  ++++++++++++++++++  IFFBF  ++++++++++++++++++
$	MACRO/NOLIST/OBJECT=IFFBF TR:+ -
		MAR:IFFDCL+IFFBF
$	PURGE IFFBF.OBJ
$!  ++++++++++++++++++  IFFCY  ++++++++++++++++++
$	MACRO/NOLIST/OBJECT=IFFCY TR:+ -
		MAR:IFFDCL+IFFCY
$	PURGE IFFCY.OBJ
$!  ++++++++++++++++++  IFFEC  ++++++++++++++++++
$	MACRO/NOLIST/OBJECT=IFFEC TR:+ -
		MAR:IFFDCL+IFFEC
$	PURGE IFFEC.OBJ
$!  ++++++++++++++++++  IFFER  ++++++++++++++++++
$	MACRO/NOLIST/OBJECT=IFFER TR:+ -
		MAR:IFFDCL+IFFER
$	PURGE IFFER.OBJ
$!  ++++++++++++++++++  IFFFT  ++++++++++++++++++
$	MACRO/NOLIST/OBJECT=IFFFT TR:+ -
		MAR:IFFDCL+IFFFT
$	PURGE IFFFT.OBJ
$!  ++++++++++++++++++  IFFIO  ++++++++++++++++++
$	MACRO/NOLIST/OBJECT=IFFIO TR:+ -
		MAR:IFFDCL+IFFIO
$	PURGE IFFIO.OBJ
$!  ++++++++++++++++++  IFFOC  ++++++++++++++++++
$	MACRO/NOLIST/OBJECT=IFFOC TR:+ -
		MAR:IFFDCL+IFFOC
$	PURGE IFFOC.OBJ
$!  ++++++++++++++++++  IFFRD  ++++++++++++++++++
$	MACRO/NOLIST/OBJECT=IFFRD TR:+ -
		MAR:IFFDCL+IFFRD
$	PURGE IFFRD.OBJ
$!  ++++++++++++++++++  IFFTD  ++++++++++++++++++
$	MACRO/NOLIST/OBJECT=IFFTD TR:+ -
		MAR:IFFDCL+IFFTD
$	PURGE IFFTD.OBJ
$!  ++++++++++++++++++  IFFWT  ++++++++++++++++++
$	MACRO/NOLIST/OBJECT=IFFWT TR:+ -
		MAR:IFFDCL+IFFWT
$	PURGE IFFWT.OBJ
$!  +++++++++++++++++  IFFMND   +++++++++++++++++
$	MACRO/NOLIST/OBJECT=IFFMND TR:+ -
		MAR:IFFMND
$	PURGE IFFMND.OBJ
$!  +++++++++++++++  IFF_COORDS   +++++++++++++++
$	MACRO/NOLIST/OBJECT=IFF_COORDS TR:+ -
		MAR:IFFDCL+IFF_COORDS
$	PURGE IFF_COORDS.OBJ
$!  +++++++++++++++++  IFFEIH   +++++++++++++++++
$	ADC IFFEIH/CD:CMN:=TR:/TR,SRC:IFFEIH
$	FORTRAN/NOI4/NOLIST IFFEIH
$	DELETE IFFEIH.FOR;*
$	PVV IFFEIH
$	DELETE ADC.IDE;*
$	PURGE IFFEIH.OBJ
$!  +++++++++++++++++  IFFPUB   +++++++++++++++++
$	ADC IFFPUB/CD:CMN:=TR:/TR,SRC:IFFPUB,IFFVER
$	FORTRAN/NOI4/NOLIST IFFPUB
$	DELETE IFFPUB.FOR;*
$	PVV IFFPUB
$	DELETE ADC.IDE;*
$	PURGE IFFPUB.OBJ
$!  +++++++++++++++++  IFFPVT   +++++++++++++++++
$	ADC IFFPVT/CD:CMN:=TR:/TR,SRC:IFFPVT
$	FORTRAN/NOI4/NOLIST IFFPVT
$	DELETE IFFPVT.FOR;*
$	PVV IFFPVT
$	DELETE ADC.IDE;*
$	PURGE IFFPVT.OBJ
$!  +++++++++++++++++  IFFJRT   +++++++++++++++++
$	ADC IFFJRT/CD:CMN:=TR:/TR,SRC:IFFJRT
$	FORTRAN/NOI4/NOLIST IFFJRT
$	DELETE IFFJRT.FOR;*
$	PVV IFFJRT
$	DELETE ADC.IDE;*
$	PURGE IFFJRT.OBJ
$!  +++++++++++++++++  IFFWHI   +++++++++++++++++
$	ADC IFFWHI/CD:CMN:=TR:/TR,SRC:IFFWHI
$	FORTRAN/NOI4/NOLIST IFFWHI
$	DELETE IFFWHI.FOR;*
$	PVV IFFWHI
$	DELETE ADC.IDE;*
$	PURGE IFFWHI.OBJ
$!  ++++++++++++++++++  IFFCB  ++++++++++++++++++
$	ADC IFFCB/CD:CMN:=TR:/TR,SRC:IFFCB
$	FORTRAN/NOI4/NOLIST IFFCB
$	DELETE IFFCB.FOR;*
$	PVV IFFCB
$	DELETE ADC.IDE;*
$	PURGE IFFCB.OBJ
$ NEWMSG IFF/NUMBER=1028
$ @IFF.TEMP_COM
$ LIB IFFLIB/CRE=(BL:50) IFFTB
$ LIB IFFLIB/INS IFF_DEFACD,IFFBF,IFFCY,IFFEC,IFFER,IFFFT
$ LIB IFFLIB/INS IFFIO,IFFOC,IFFRD,IFFTD,IFFWT,IFFMND,IFF_COORDS
$ LIB IFFLIB/INS IFFEIH,IFFPVT,IFFPUB
$ LIB IFFLIB/INS IFFJRT,IFFWHI,IFFCB,IFF.PROMSG_OBJ
