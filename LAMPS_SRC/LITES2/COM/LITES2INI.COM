$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1994-02-28 15:18:26.000000000 +0000
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

$! LITES2INI.COM - Login-time initialisation for package LITES2
$!
$! Copyright Laser-Scan Ltd, Cambridge, England
$! version for LSLINSTALL				PGH	11-Jul-1990
$!MOD include FT devices (DECwindows Motif DECterms)	PGH	 6-Dec-1991
$!MOD Cope with Motif X-terminals			PGH	10-Apr-1992
$!MOD Find a working LITES2 if in batch			RWR	 2-Sep-1992
$!MOD Handle OpenVMS Alpha (just for trials at present)	PGH	 1-Dec-1992
$!MOD Cope with LAT X-terminals (no PORT specified)	WJJ	 1-Feb-1993
$!MOD Set LSL$LITES2CMD at top of file 			RWR	 2-Feb-1993
$!MOD Add _TV to shared image names if AXP		PGH	22-Jul-1993
$!MOD Set up LSL$LITES2GEOMSHR and tidy Alpha defns	PGH	17-Jan-1994
$!
$! Sets up logical names and DCL symbols for package LITES2.
$!
$! For most types of terminal, the sequence for the workstation name is:
$! (1) generate a terminal name, out of node name and device name
$! (2) see if this terminal specific startup file exists
$! (3) if so, use that, otherwise use just the device name
$!
$! Having got a workstation name, then look for a matching LSL$WSn_VDU
$! logical name to get the workstation number. This can then provide
$! corresponding GDU, table, and type information.
$! If no match then assume default type, same GDU, and no table.
$!
$	SET NOON
$	WS = "WRITE SYS$OUTPUT"
$!
$	IF F$TRNLNM("LSL$LITES2CMD").EQS."" THEN -
	   DEFINE LSL$LITES2CMD			LSL$SITE_ROOT:[LITES2.CMD]	
$!
$	NODENAME = F$LOGICAL("SYS$NODE")-"::"-"_"
$	TERMNAME=F$GETDVI("SYS$COMMAND","DEVNAM")-"_"
$!!!	TEMP = F$TRNLNM("LSL$LITES2TERMINAL")
$!!!	IF TEMP.NES."" THEN TERMNAME=TEMP	! overriding preset
$	WSNAME=TERMNAME		! starting guess
$	GDU = TERMNAME		! default is graphics on same terminal
$	TABLE = ""		! and no table
$!
$! switch on type of device we are on
$!
$	IF F$LOCATE("TT",TERMNAME).EQ.0 THEN GOTO TTTERM
$	IF F$LOCATE("TX",TERMNAME).EQ.0 THEN GOTO TXTERM	! TX same as TT
$	IF F$LOCATE("LT",TERMNAME).EQ.0 THEN GOTO LTTERM
$	IF F$LOCATE("WT",TERMNAME).EQ.0 THEN GOTO WTTERM
$	IF F$LOCATE("TW",TERMNAME).EQ.0 THEN GOTO TWTERM
$	IF F$LOCATE("MB",TERMNAME).EQ.0 THEN GOTO MBTERM	! MB same as TW
$	IF F$LOCATE("FT",TERMNAME).EQ.0 THEN GOTO FTTERM	! FT same as TW
$	IF F$LOCATE("TK",TERMNAME).EQ.0 THEN GOTO TKTERM
$	IF F$LOCATE("TJ",TERMNAME).EQ.0 THEN GOTO TJTERM
$	IF F$LOCATE("RT",TERMNAME).EQ.0 THEN GOTO RTTERM
$	WS "%LITES2INI-W-UNKTERM, Warning, unknown terminal type ",TERMNAME
$	GOTO RTTERM	! assume like a network line
$!
$!--------------------------------------------------------------------------
$! here for direct serial line (TT and TX) workstations
$TTTERM:
$TXTERM:
$	WSTYPE="SIG6000"	! a guess
$!
$! name is from node name and device name, else just device name
$!
$	TEMP_NAME = NODENAME + "_" + WSNAME
$	FILE_NAME = "LSL$LITES2CMD:" + TEMP_NAME + ".LCM"
$	IF (F$SEARCH(FILE_NAME).EQS."") THEN TEMP_NAME = WSNAME
$	WSNAME=TEMP_NAME
$	GOTO COMMON
$!
$!--------------------------------------------------------------------------
$! here for Ethernet terminal server line workstations
$LTTERM:
$	WSNAME="LTXX"
$	WSTYPE="SIG6000"	! a guess
$!
$! name is from server name and port name, else just workstation class
$!
$	TEMP_NAME = F$GETDVI("SYS$COMMAND","TT_ACCPORNAM")
$	SERVER_NAME=F$ELEMENT(0,"/",TEMP_NAME)
$	PORT_NAME=F$ELEMENT(1,"/",TEMP_NAME)
$	TEMP_NAME=SERVER_NAME
$	IF PORT_NAME .NES. "/" THEN TEMP_NAME = TEMP_NAME + "_" + PORT_NAME
$	FILE_NAME = "LSL$LITES2CMD:" + TEMP_NAME + ".LCM"
$	IF (F$SEARCH(FILE_NAME).EQS."") THEN TEMP_NAME = WSNAME
$	WSNAME=TEMP_NAME
$	GOTO COMMON
$!
$!--------------------------------------------------------------------------
$! here for VWS/UIS workstations
$WTTERM:
$	WSNAME="WTXX"
$	WSTYPE="UIS"
$	GOTO VAXSTATION		! common code for UIS/DECW
$!
$!--------------------------------------------------------------------------
$! here for DECW/Motif workstations
$TWTERM:		! a DECwindows/XUI DECterm
$FTTERM:		! a DECwindows Motif DECterm
$MBTERM:		! assume DECwindows if mailbox for now
$	WSNAME="TWXX"
$	WSTYPE="MOTIF"
$! find a display node name in case of X-terminals
$	DEFINE/USER SYS$OUTPUT NL:
$	SHOW DISPLAY/SYMBOL
$	IF "''DECW$DISPLAY_NODE'".NES."" .AND. - 
	   "''DECW$DISPLAY_NODE'".NES."0" THEN -
	      NODENAME=DECW$DISPLAY_NODE
$	NODENAME = NODENAME-"::"-"_"
$!!!	DEFINE LSL$CONSOLE			CSA0:
$	GOTO VAXSTATION		! common code for UIS/DECW
$!
$!--------------------------------------------------------------------------
$! here for generic VAXstation workstations
$!
$! name is from node name and workstation class, else just workstation class
$!
$VAXSTATION:
$	TEMP_NAME = NODENAME + "_" + WSNAME
$	FILE_NAME = "LSL$LITES2CMD:" + TEMP_NAME + ".LCM"
$	IF (F$SEARCH(FILE_NAME).EQS."") THEN TEMP_NAME = WSNAME
$	WSNAME=TEMP_NAME
$	DEFINE LSL$LITES2_KERN_ROUTINES		LSL$EXE:LITES2KRISSSHR
$	GOTO COMMON
$!
$!--------------------------------------------------------------------------
$! here for emulated TEK4014 workstations
$TKTERM:
$	WSNAME="TKXX"
$	WSTYPE="TEK_ARGS"
$	GOTO VAXSTATION
$!
$!--------------------------------------------------------------------------
$! here for emulated TEK4100/4200 workstations
$TJTERM:
$	WSNAME="TJXX"
$	WSTYPE="TEK4100"
$ 	DEFINE LSL$LITES2CMD:TEK.COL		LSL$TEK_COLOUR
$	GOTO VAXSTATION
$!
$!--------------------------------------------------------------------------
$! here for remote terminal, or unknown type
$RTTERM:
$	WSNAME="RTXX"
$	WSTYPE="TEK4100"	! guess
$ ! other possibilities
$	TYPES ="MOTIF/UIS/SIG6000/TEK4100/TEK_ARGS/HRD/SIG5000"
$
$! try to find a version of LITES2 that actually exists.
$	COUNT = 0
$NEXT_TYPE:
$	TYPE = F$ELEMENT(COUNT,"/",TYPES)
$	IF TYPE .EQS. "/" THEN GOTO COMMON
$	TEMP=F$SEARCH("LSL$EXE:LITES2''TYPE'.EXE")
$	IF TEMP .NES. "" 
$	THEN 
$	   WSTYPE=TYPE
$	   GOTO COMMON
$	ENDIF
$	COUNT = COUNT + 1
$	GOTO NEXT_TYPE
$!
$!
$!**************************************************************************
$! here for all versions, to set up common environment
$COMMON:
$!
$	WS_NUM = 1
$!
$! loop for all defined workstations to match table and GDU with VDU.
$! assumes LSL$WSn_VDU, LSL$WSn_GDU, LSL$WSn_TABLE, LSL$WSn_TYPE, are 
$! previously set up by LSTERMS.COM and LSPORTS.COM at system startup time.
$!
$LOOP:
$	WS_VDU = F$TRNLNM("LSL$WS''WS_NUM'_VDU")
$	IF WS_VDU .EQS. "" THEN GOTO NONE		! no more workstations
$	WS_GDU = F$TRNLNM("LSL$WS''WS_NUM'_GDU")
$	IF WS_VDU .EQS. WSNAME THEN GOTO GOT_WS		! on w/s vdu ?
$	IF WS_GDU .EQS. WSNAME THEN GOTO GOT_WS		! on w/s gdu ?
$	WS_NUM = WS_NUM + 1				! try next w/s
$	GOTO LOOP	
$!
$! we have a match, so set up corresponding values
$!
$GOT_WS:
$	IF WS_GDU.NES."" THEN GDU = WS_GDU
$	TABLE = F$TRNLNM("LSL$WS''WS_NUM'_TABLE")	! digitising table
$	TEMP = F$TRNLNM("LSL$WS''WS_NUM'_TYPE")
$	IF TEMP.NES."" THEN WSTYPE = TEMP		! ws type, eg SIG6000
$	WS " "
$	WS "You are on workstation ",WS_NUM,", type ",WSTYPE,", name ",WSNAME
$	WS " "
$	GOTO DONE
$!
$! here with no match, just keep quiet for now
$NONE:	
$	GOTO DONE
$!
$!--------------------------------------------------------------------------
$! here for all versions, to set up symbols and logicals
$DONE:
$!
$! Allow for differences for OpenVMS Alpha AXP
$!
$	ARCH_NAME=F$GETSYI("ARCH_NAME")
$	IF ARCH_NAME.EQS."Alpha"
$	THEN
$	  ON_ALPHA=1
$	  ATVS="_TV"
$	  AAXPS="_AXP"
$	ELSE
$	  ON_ALPHA=0
$	  ATVS=""
$	  AAXPS=""
$	ENDIF
$!
$	LITES2 == "$LSL$EXE:LITES2"+WSTYPE+ATVS
$	LCMSQUASH == "$LSL$EXE:LCMSQUASH"+ATVS
$!
$! Define terminal things
$!
$	DEFINE LSL$LITES2TERMINAL		'WSNAME'
$	IF TABLE.NES."" THEN -
	   DEFINE LSL$MONITOR_TABLE		'TABLE'
$	TABNAM=TABLE - ":" - "_"
$	DEFINE LSL$TK				'GDU'
$!
$! Define names for directories
$!
$	IF F$TRNLNM("LSL$LITES2JNL").EQS."" THEN -
	   DEFINE LSL$LITES2JNL			LSL$LOCAL_ROOT:[LITES2.JNL]	
$	IF F$TRNLNM("LSL$LITES2SETUP").EQS."" THEN -
	   DEFINE LSL$LITES2SETUP		LSL$LOCAL_ROOT:[LITES2.JNL]	
$	IF F$TRNLNM("LSL$LITES2WORK").EQS."" THEN -
	   DEFINE LSL$LITES2WORK		LSL$LOCAL_ROOT:[LITES2.WORK]	
$!
$! Define names for files
$!
$	CUSTOMER_NAME=F$TRNLNM("LSL$CUSTOMER_NAME")
$	IF CUSTOMER_NAME.EQS."" 
$	THEN 
$	   CUSTOMER_NAME="UNKNOWN"
$	   WS " "
$	   WS "%LITES2INI-W-UNKCUST, customer name not defined for LITES2 licence"
$	   WS "%LITES2INI-I-HINT, Define LSL$CUSTOMER_NAME as eg LSLCAM in LSDEFNS.COM"
$	   WS " "
$	ENDIF
$	DEFINE LSL$LITES2LOCK			LSL$EXE:'CUSTOMER_NAME''ATVS'.LIC
$	IF F$TRNLNM("LSL$LITES2_GEOG_ROUTINES").EQS."" THEN -
	   DEFINE LSL$LITES2_GEOG_ROUTINES'ATVS' LSL$EXE:LITES2GEOGSHR'ATVS'
$	IF F$TRNLNM("LSL$LITES2_GEOM_ROUTINES").EQS."" THEN -
	   DEFINE LSL$LITES2_GEOM_ROUTINES'ATVS' LSL$EXE:LITES2GEOMSHR'AAXPS'
$	IF F$TRNLNM("LSL$LITES2_VIEW_ROUTINES").EQS."" THEN -
	  DEFINE LSL$LITES2_VIEW_ROUTINES'ATVS'	LSL$EXE:LITES2VIEWSHR'ATVS'
$	IF F$TRNLNM("LSL$LITES2INI").EQS."" THEN -
	   DEFINE LSL$LITES2INI			LSL$LITES2CMD:SITEINIT.LCM
$!
$! The following are needed to satisfy the LITES2 checking, not actual use.
$	IF ON_ALPHA
$	THEN
$	   DEFINE LSL$LITES2_GEOG_ROUTINES LSL$EXE:LITES2GEOGSHR'ATVS'
$	   DEFINE LSL$LITES2_GEOM_ROUTINES LSL$EXE:LITES2GEOMSHR'AAXPS' 
$	   DEFINE LSL$LITES2_VIEW_ROUTINES LSL$EXE:LITES2VIEWSHR'ATVS'
$	ENDIF
$!
$	IF WSTYPE.EQS."TEK4100" THEN -
	   DEFINE LSL$TEK_COLOUR		LSL$LITES2CMD:TEK.COL
$	IF WSTYPE.EQS."TEK_ARGS" THEN -
	   DEFINE LSL$TEK_COLOUR		LSL$LITES2CMD:TEK.COL
$	IF WSTYPE.EQS."SIG6000" THEN -
	   DEFINE LSL$SIGMA_COLOUR		LSL$LITES2CMD:SIGMA.COL
$	IF WSTYPE.EQS."UIS" THEN -
 	   DEFINE LSL$VAX_COLOUR		LSL$LITES2CMD:VAX.COL
$	IF WSTYPE.EQS."MOTIF" THEN -
 	   DEFINE LSL$DECW_COLOUR		LSL$LITES2CMD:VAX.COL
$!
$! all done
$!
$	EXIT
