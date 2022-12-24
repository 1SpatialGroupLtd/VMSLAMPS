$!
$! * This file is part of the LAMPS distribution, released as a software
$! * preservation project to archive digital history for future historians.
$! * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
$! *
$! * Timestamp of this file for the 2002 release was: 1986-08-15 10:01:08.000000000 +0100
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
$!
$! Command file to build TVES DTE (DIGITAL TERRAIN EDITOR)
$! Modified 						ATT July 1986
$!
$!      declare the logical name for DTE globally
$	DTE :== $LSL$DISK:[TVES.DTE]DTE
$!
$	DEF DTM$PAR LSL$DISK:[MCE.DTM]
$!
$	open/write output DTEBAT.COM
$	wo="write output"
$	on control_y then goto close_file
$	wo "$! "
$	wo "$! Command file to build DTE "
$	wo "$! "
$	wo "$sd lsl$disk:[tves.dte]"
$	wo "$! "
$	wo "$on error then goto end "
$	wo "$! "
$	wo "$DEF DTM$PAR LSL$DISK:[MCE.DTM]"
$	wo "$set ver "
$!
$	SET NOVERIFY
$	DEB = ""
$	MBUG = ""
$	LBUG = ""
$	INQUIRE DEBG "DEBUG"
$	IF DEBG THEN DEB = "/DEBUG/NOOPT/CHECK=(B,O)"
$	IF DEB.NES."" THEN MBUG = "/DEBUG"
$	IF DEB.NES."" THEN IBUG = "/DEBUG"
$	INQUIRE FOR  "COMPILE"
$	INQUIRE MAR  "MAR"
$	INQUIRE LNK  "LINK"
$!
$	open/write output DTEBAT.COM
$	wo="write output"
$	on control_y then goto close_file
$!
$	IF.NOT.FOR THEN GOTO NOFOR
$!
$	INQUIRE ALL  "Everything "
$	if all then goto all1
$	INQUIRE FOR  "compile DTE,CONTOR,BORDER,REDRAW"
$	IF.NOT.FOR THEN GOTO NOFOR1
$all1:
$	wo "$! "
$	wo "$ ADC DTE = DTE,CONTOR,BORDER,REDRAW"
$	wo "$ FORTRAN''DEB' DTE"
$	wo "$ PVV DTE"
$	wo "$! "
$	if all then goto all2
$!
$NOFOR1:INQUIRE FOR  "compile SETMENU,SETMAP"
$	IF.NOT.FOR THEN GOTO NOFOR2
$all2:
$	wo "$! "
$	wo "$ ADC DTE1 = SETMENU,SETMAP		
$	wo "$ FORTRAN''DEB'  DTE1"
$	wo "$ PVV DTE1"
$	wo "$! "
$	if all then goto all3
$!
$NOFOR2:INQUIRE FOR  "compile GETNUM,PUTNUM,DTIHGT,STREQ,SHOWERR"
$	IF.NOT.FOR THEN GOTO NOFOR3
$all3:
$	wo "$! "
$	wo "$	ADC DTE2 = GETNUM,PUTNUM,DTIHGT,STREQ,SHOWERR"
$	wo "$	FORTRAN''DEB'  DTE2"
$	wo "$	PVV DTE2"
$	wo "$! "
$	if all then goto all4
$!
$NOFOR3:INQUIRE FOR  "compile TRANSF,SETWINDOW"
$	IF.NOT.FOR THEN GOTO NOFOR4
$all4:
$	wo "$! "
$	wo "$	ADC DTE3 = TRANSF,SETWINDOW"
$	wo "$	FORTRAN''DEB'  DTE3"
$	wo "$	PVV DTE3"
$	wo "$! "
$	if all then goto all5
$!
$NOFOR4:INQUIRE FOR  "compile GETINT,GETDTI,GETTAB,WRTINT"
$	IF.NOT.FOR THEN GOTO NOFOR5
$all5:
$	wo "$! "
$	wo "$	ADC DTE4 = GETINT,GETDTI,GETTAB,WRTINT"
$	wo "$	FORTRAN''DEB'  DTE4"
$	wo "$	PVV DTE4"
$	wo "$! "
$	if all then goto all6
$!
$NOFOR5:INQUIRE FOR  "compile EXECOM,READTAB,READDTI"
$	IF.NOT.FOR THEN GOTO NOFOR6
$all6:
$	wo "$! "
$	wo "$	ADC DTE5 = EXECOM,READTAB,READDTI"
$	wo "$	FORTRAN''DEB'  DTE5"
$	wo "$	PVV DTE5"
$	wo "$! "
$	if all then goto all7
$!
$NOFOR6:INQUIRE FOR  "compile WAIT,TERMIN"
$	IF.NOT.FOR THEN GOTO NOFOR7
$all7:
$	wo "$! "
$	wo "$	ADC DTE6 = WAIT,TERMIN"
$	wo "$	FORTRAN''DEB'  DTE6"
$	wo "$	PVV DTE6"
$	wo "$! "
$	if all then goto all8
$!
$NOFOR7:INQUIRE FOR  "compile SETPIX,SETPIXMOD,BARCHART"
$	IF.NOT.FOR THEN GOTO NOFOR8
$all8:
$	wo "$! "
$	wo "$	ADC DTE7 = SETPIX,SETPIXMOD,BARCHART"
$	wo "$	FORTRAN''DEB'  DTE7"
$	wo "$	PVV DTE7"
$	wo "$! "
$	if all then goto all9
$!
$NOFOR8:INQUIRE FOR  "compile EDITCELL,DTEMSG"
$	IF.NOT.FOR THEN GOTO NOFOR9
$all9:
$	wo "$! "
$	wo "$	ADC DTE8 = EDITCELL,DTEMSG"
$	wo "$	FORTRAN''DEB'  DTE8"
$	wo "$	PVV DTE8"
$	wo "$! "
$	if all then goto all10
$!
$NOFOR9:INQUIRE FOR  "compile MAGNIFY"
$	IF.NOT.FOR THEN GOTO NOF10
$all10:
$	wo "$! "
$	wo "$	ADC DTE9 = MAGNIFY"
$	wo "$	FORTRAN''DEB'  DTE9"
$	wo "$	PVV DTE9"
$	wo "$! "
$	if all then goto all11
$!
$NOF10 :INQUIRE FOR  "compile DTEEXIT,HADCTRLC,CTRLCAST"
$	IF.NOT.FOR THEN GOTO NOF11
$all11:
$	wo "$! "
$	wo "$	ADC DTE10 = DTEEXIT,HADCTRLC,CTRLCAST"
$	wo "$	FORTRAN''DEB'  DTE10"
$	wo "$	PVV DTE10"
$	wo "$! "
$	if all then goto all12
$!
$NOF11 :INQUIRE FOR  "compile HELP"
$	IF.NOT.FOR THEN GOTO NOF12
$all12:
$	wo "$! "
$	wo "$	ADC DTE11 = HELP"
$	wo "$	FORTRAN''DEB'  DTE11"
$	wo "$	PVV DTE11"
$	wo "$! "
$	if all then goto all13
$!
$NOF12 :INQUIRE FOR  "compile FILE"
$	IF.NOT.FOR THEN GOTO NOF13
$all13:
$	wo "$! "
$	wo "$	ADC DTE12 = FILE"
$	wo "$	FORTRAN''DEB'  DTE12"
$	wo "$	PVV DTE12"
$	wo "$! "
$	if all then goto all14
$!
$NOF13 :INQUIRE FOR  "compile FINDRANGE,SHOWRANGE,SIGCSWT,DTELIN"
$	IF.NOT.FOR THEN GOTO NOF14
$all14:
$	wo "$! "
$	wo "$	ADC DTE13 = FINDRANGE,SHOWRANGE,SIGCSWT,DTELIN"
$	wo "$	FORTRAN''DEB'  DTE13"
$	wo "$	PVV DTE13"
$	wo "$! "
$	if all then goto all15
$!
$NOF14 :INQUIRE FOR  "compile GETPOLY,POLYEDIT,PATHEDIT,INTERPEDT"
$	IF.NOT.FOR THEN GOTO NOF15
$all15:
$	wo "$! "
$	wo "$	ADC DTE14 = GETPOLY,POLYEDIT,PATHEDIT,INTERPEDT"
$	wo "$	FORTRAN''DEB'  DTE14"
$	wo "$	PVV DTE14"
$	wo "$! "
$	if all then goto all16
$!
$NOF15 :INQUIRE FOR  "compile INMENU,ICOL,BASEHGT"
$	IF.NOT.FOR THEN GOTO NOF16
$all16:
$	wo "$! "
$	wo "$	ADC DTE15 = INMENU,ICOL,BASEHGT"
$	wo "$	FORTRAN''DEB'  DTE15"
$	wo "$	PVV DTE15"
$	wo "$! "
$	if all then goto all17
$!
$!
$NOF16 :INQUIRE FOR  "compile READ_FB,READ_TRKB,FLOOD,LUTSET,SIGINIT,SIGCLO"
$	IF.NOT.FOR THEN GOTO NOF17
$all17:
$	wo "$! "
$	wo "$ADC DTE16 = READ_FB,READ_TRKB,FLOOD,LUTSET,SIGINIT,SIGCLO"
$	wo "$	FORTRAN''DEB'  DTE16"
$	wo "$	PVV DTE16"
$	wo "$! "
$!
$NOF17 :
$	wo "$! "
$	wo "$	PURGE/NOLOG *.OBJ"
$	wo "$! "
$	wo "$	PURGE/NOLOG *.FOR"
$	wo "$! "
$	wo "$	DELETE ADC.IDE;*"
$	wo "$! "
$!
$NOFOR:	
$	IF.NOT.MAR THEN GOTO NOMAR
$	wo "$! "
$	wo "$	MACRO''MBUG' DTECMD+LSL$LIBRARY:LSLMACLIB/LIB"
$	wo "$! "
$!
$NOMAR:	IF.NOT.LNK THEN GOTO CLOSE_FILE
$	wo "$! "
$	wo "$	LINK/MAP''IBUG' DTE,- "
$	wo "	DTE1,DTE2,DTE3,DTE4,- "
$	wo "	DTE5,DTE6,DTE7,DTE8,- "
$	wo "	DTE9,DTE10,DTE11,DTE12,-"
$	wo "	DTE13,DTE14,DTE15,DTE16,-"
$	wo "	DTECMD,-		 "
$	wo "	LSL$LIBRARY:TABLIB/LIB,- "
$	wo "	LSL$LIBRARY:VSLIB/LIB,-	 "
$	wo "	LSL$LIBRARY:WOSPLIB/LIB,-"
$	wo "	LSL$LIBRARY:CMDLIB/LIB,- "
$	wo "	LSL$LIBRARY:VIOLIB/LIB " 
$!
$	wo "$! "
$	wo "$   set  ver "
$	wo "$	PURGE/NOLOG *.MAP"
$	wo "$! "
$!
$close_file:
$	wo "$! "
$	wo "$end: "
$	close output
$	inq/nop batch "Submit for BATCH ?"
$	if batch then goto submit
$	inq/nop int "Interactive ?"
$	if .not. int then goto end
$!
$	@dtebat
$	goto end
$!
$submit:
$	bat dtebat
$!
$end:
$	SET NOVERIFY
