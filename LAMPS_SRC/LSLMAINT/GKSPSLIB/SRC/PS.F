C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1997-11-25 13:35:12.000000000 +0000
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
C
C Postscript specific routines
C
	INTEGER FUNCTION PS_OPEN(WKID,LW,HWFM)
C
CDEC$	IDENT	'25NO97'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	28-July-1992
C
C Open and initialise postscript file
C
	IMPLICIT NONE
C
	INCLUDE		'($JPIDEF)'
	INCLUDE		'($SSDEF)'
	INCLUDE		'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE		'LSL$CMNLSL:TXTC.CMN'
	INCLUDE		'PS.CMN'
C
C Arguments
	INTEGER		WKID	! workstation ident (only for LSG_SET_LUT)
	REAL		LW	! returned nom. line width, copy of NOMLW
	INTEGER		HWFM	! returned h/w fill max (copy of MAXPATH)
C
C Functions
	INTEGER		EXPAND
	INTEGER		SIGCHS
	INTEGER		TRNALL
	INTEGER 	LIB$GET_LUN
	INTEGER		FLWOPN,FLROPN,FLRLIN
	LOGICAL		RDLONG,RDREAL
C
C workspace
	INTEGER		OK,IERR
	CHARACTER*80	TRAN,FONTS
	INTEGER		ILUN
	LOGICAL		COLORIMAGE
	INTEGER		FLEN
	LOGICAL		DEF_SIZE	! are sizes default?
	REAL		DX,DY		! size in device coords (metres)
	REAL		RX,RY		! size in raster coords (pixels)
C
C call back to main code to set things in GKSDAT1.CMN
C
	CALL GKS_GET_LOGICALS('PS',DEF_SIZE,DX,DY,RX,RY)
C
C Get LUN to use
	OK = LIB$GET_LUN(PSLUN)
	IF (.NOT.OK) THEN
	   CALL TTWSTR('Unable to allocate LUN for Postscript file')
	   CALL LSL_PUTMSG(OK)
	   GOTO 999
	ENDIF
C
C Create PS file
	IF (TRNALL('LSL$PS',TRAN).NE.SS$_NOLOGNAM) THEN
	   OK = FLWOPN(PSLUN,'LSL$PS:',IERR)
	ELSE
	   TRAN = 'PLOTFILE.PS'
	   OK = FLWOPN(PSLUN,'PLOTFILE.PS',IERR)
	ENDIF
	IF (.NOT.OK) THEN
	   CALL TTWSTR('Unable to create Postscript file')
	   CALL LSL_PUTMSG(OK)
	   IF (OK.EQ.LSL__SYSOPEN) CALL LSL_ADDMSG(IERR)
	   GOTO 999
	ENDIF
C
	IF (TRNALL('LSL$PS_DOCUMENTFONTS',FONTS)) THEN
	   FLEN = SIGCHS(FONTS)
	ELSE
	   FLEN = 0
	ENDIF
C
	CALL FLWSTR('%!PS-Adobe-3.0')
	IF (FLEN.GT.0) CALL FLWRTF(
     &		'%%%%DocumentFonts: %S',FONTS(:FLEN))
	CALL FLWRTF('%%%%Title: %S',TRAN(:SIGCHS(TRAN)))
C
C try for a nominal line width from LSL$PS_NOMLW
	NOMLW = 0.0635				! width 1/400 inch
	IF (TRNALL('LSL$PS_NOMLW',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDREAL(NOMLW)) THEN
	      CALL TTWSTR(
     &	'Error translating LSL$PS_NOMLW - using default value')
	      NOMLW = 0.0635
	   ELSEIF (NOMLW.LE.0.0) THEN
	      CALL TTWSTR(
     &	'Value for LSL$PS_NOMLW must be >0.0 - using default value')
	      NOMLW = 0.0635
	   ENDIF
	ENDIF
	NOMLW = NOMLW/1000.0		! convert to metres
	LW = NOMLW			! return copy to caller
C
C check for maximum path length - LSL$PS_MAXPATH
	MAXPATH = 1000
	IF (TRNALL('LSL$PS_MAXPATH',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDLONG(MAXPATH)) THEN
	      CALL TTWSTR(
     &	'Error translating LSL$PS_MAXPATH - using default value')
	      MAXPATH = 1000
	   ENDIF
	   IF (MAXPATH.LT.100) THEN
	      CALL TTWSTR(
     &	'Value of LSL$PS_MAXPATH must be >100 - using default value')
	      MAXPATH = 1000
	   ENDIF
	ENDIF
	HWFM = MAXPATH		! return copy to caller
C
C check for number of sig. figs. - LSL$PS_SIGFIG
	PS_SF = 6
	IF (TRNALL('LSL$PS_SIGFIG',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDLONG(PS_SF)) THEN
	      CALL TTWSTR(
     &	'Error translating LSL$PS_SIGFIG - using default value')
	      PS_SF = 6
	   ENDIF
	   IF (PS_SF.LE.0.OR.PS_SF.GT.8) THEN
	      CALL TTWSTR(
     &	'Value of LSL$PS_SIGFIG must be 1-8 - using default value')
	      PS_SF = 6
	   ENDIF
	ENDIF
C
C check for image compression mode - LSL$PS_COMPRESS
	PS_COMP = 1
	IF (TRNALL('LSL$PS_COMPRESS',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDLONG(PS_COMP)) THEN
	      CALL TTWSTR(
     &	'Error translating LSL$PS_COMPRESS - using default value')
	      PS_COMP = 1
	   ENDIF
	   IF (PS_COMP.LT.0.OR.PS_COMP.GT.1) THEN
	      CALL TTWSTR(
     &	'Value of LSL$PS_COMPRESS must be 0-1 - using default value')
	      PS_COMP = 1
	   ENDIF
	ENDIF
C
C check for colorimage - LSL$PS_COLORIMAGE
	COLORIMAGE = .FALSE.
	IF (TRNALL('LSL$PS_COLORIMAGE',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDLONG(OK)) THEN
	      CALL TTWSTR(
     &	'Error translating LSL$PS_COLORIMAGE - using default value')
	   ELSEIF (OK.NE.0.AND.OK.NE.1) THEN
	      CALL TTWSTR(
     &	'Value of LSL$PS_COLORIMAGE must be 0-1 - using default value')
	   ELSEIF (OK.EQ.1) THEN
	      COLORIMAGE = .TRUE.
	   ENDIF
	ENDIF
C
C check for composite characters - LSL$COMPOSITE_CHARACTERS
	PSCCHR = .FALSE.
	IF (TRNALL('LSL$COMPOSITE_CHARACTERS',TRAN)) THEN
	   CALL SETAUX(%REF(TRAN),10)
	   IF (RDLONG(OK)) THEN
	      CALL TTWSTR(
     &	'Error translating LSL$COMPOSITE_CHARACTERS'//
     &	' - using default value')
	      OK = 0
	   ENDIF
	   IF (OK.LT.0.OR.OK.GT.1) THEN
	      CALL TTWSTR(
     &	'Value of LSL$COMPOSITE_CHARACTERS must be 0-1'//
     &	' - using default value')
	      OK = 0
	   ENDIF
	   IF (OK.EQ.1) PSCCHR = .TRUE.
	ENDIF
C
	PSPAGE = 0
	PSCOL = -1
	PSFCOL = -1
	PSWID = -1.0
	PSWIDM = 25.4/1000.0/72.0/2.0	! half line width in metres
	PSJOIN = -1
	PSCAP = -1
	PSFNT = -1
	PSTYPE = 1
	NPATH = 0
	PSLIM(1) = 1E30
	PSLIM(2) = 1E30
	PSLIM(3) = -1E30
	PSLIM(4) = -1E30
	PS_GLIMIT = 10**PS_SF
	GFLEN = EXPAND('%WS%%G0.%N ',PS_GFORMAT,PS_SF)
	FFLEN = EXPAND('%WS%%F0.%N ',PS_FFORMAT,PS_SF+2)
C
	TXTPTR = 12
	CALL LIB$GETJPI(JPI$_USERNAME,,,,TXTDSC)
	TXTPTR = SIGCHS(TXTDSC)
	CALL FLWRTF(
     &'%%%%Creator: Laser-Scan GKSPSLIB V2.6 25-Nov-1997 User %S',
     &	TXTDSC)
	TXTPTR = 255
	CALL SYS$ASCTIM(TXTPTR,TXTDSC,,)
	CALL FLWRTF('%%%%CreationDate: %S',TXTDSC)
	CALL FLWSTR('%%DocumentSuppliedResources: procset LSL-GKS 1.2 1')
	CALL FLWSTR('%%Pages: (atend)')
	CALL FLWSTR('%%BoundingBox: (atend)')
	CALL FLWSTR('%%EndComments')
C
C Document prolog
	CALL FLWSTR('%%BeginProlog')
	CALL PS_WRITE_PROCSET
	CALL FLWSTR('%%EndProlog')
	CALL FLWSTR('%%BeginSetup')
C
C initialise the proc set, stack bool whether to do colour
	CALL EXPAND('/USECOLOR where { pop USECOLOR} { ')
	IF (COLORIMAGE) THEN
	   CALL APPEND('true')
	ELSE
	   CALL APPEND('false')
	ENDIF
	CALL FLWAPP(' } ifelse')
	CALL FLWSTR('LSL-GKS /initialize get exec')
C
C write the colour table
	CALL LSG_SET_LUT(WKID,'LSL$PS_COLOUR:') ! load colour table
C
C check for font list LSL$PS_FONTLIST
	IF (TRNALL('LSL$PS_FONTLIST',TRAN).NE.SS$_NOLOGNAM) THEN
	   CALL GKS_SET_PS_FONT('LSL$PS_FONTLIST')
	ENDIF
C
C set the paper size if we read one from an LSL$PS_SIZE file
C
	IF (.NOT.DEF_SIZE) THEN
	   CALL FLWSTR('/setpagedevice where {')
	   CALL FLWSTR('  pop 1 dict dup begin')
	   CALL FLWRTF('    /PageSize [%N %N] def',
     &		INT(DX*1000./25.4*72.),INT(DY*1000./25.4*72.))
	   CALL FLWSTR('  end setpagedevice')
	   CALL FLWSTR('} if')
	ENDIF
C
C check for user header file LSL$PS_HEADER
	IF (TRNALL('LSL$PS_HEADER',TRAN).EQ.SS$_NOLOGNAM) GOTO 100
C
C Get LUN to use
	OK = LIB$GET_LUN(ILUN)
	IF (.NOT.OK) THEN
	   CALL TTWSTR(
     &		'Unable to allocate LUN for Postscript header file')
	   CALL LSL_PUTMSG(OK)
	   GOTO 100
	ENDIF
	OK = FLROPN(ILUN,'LSL$PS_HEADER:',IERR)
	IF (.NOT.OK) THEN
	   CALL TTWSTR(
     &		'Unable to open Postscript header file LSL$PS_HEADER')
	   CALL LSL_PUTMSG(OK)
	   IF (OK.EQ.LSL__SYSOPEN) CALL LSL_ADDMSG(IERR)
	   CALL LIB$FREE_LUN(ILUN)
	   GOTO 100
	ENDIF
50	OK = FLRLIN()		! read a line from header file
	IF (OK) THEN		! false at EOF
	   CALL FLWSTR(TXTDSC)	! write it to postscript file
	   GOTO 50
	ENDIF
	CALL FLRCLO(ILUN)
	CALL LIB$FREE_LUN(ILUN)
C
100	CALL FLWSTR('%%EndSetup')
	OK = SS$_NORMAL
C
999	PS_OPEN = OK
C
	RETURN
	END
C
	SUBROUTINE PS_CLOSE
C
CDEC$	IDENT	'21JL92'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	28-July-1992
C
C Write trailers and close postscript file
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C Document trailer
	CALL FLWSTR('%%Trailer')
C
C Terminate the procset
	CALL FLWSTR('LSL-GKS /terminate get exec')
C
C Trailer comments
	CALL FLWRTF('%%%%Pages: %N',PSPAGE)
C
C avoid traceback if limits not set (nothing drawn)
	IF (PSLIM(1).EQ.1E30) THEN
	   CALL FLWSTR('%%BoundingBox: 0 0 0 0')
	ELSE
	   CALL FLWRTF('%%%%BoundingBox: %N %N %N %N',
     &		NINT(PSLIM(1)*MTOP-0.5),
     &		NINT(PSLIM(2)*MTOP-0.5),
     &		NINT(PSLIM(3)*MTOP+0.5),
     &		NINT(PSLIM(4)*MTOP+0.5) )
	ENDIF
	CALL FLWSTR('%%EOF')
C
	CALL FLWCLO(PSLUN)
	CALL LIB$FREE_LUN(PSLUN)
	CALL GKS_C_FREE_FONTS
C
	RETURN
	END
C
	SUBROUTINE PS_PAGE
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Begin new page
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C forget previous settings so that they are set in new page
	PSCOL = -1
	PSFCOL = -1
	PSWID = -1.0
	PSWIDM = 25.4/1000.0/72.0/2.0	! half line width in metres
	PSJOIN = -1
	PSCAP = -1
	PSFNT = -1
	PSTYPE = 1
	PSPAGE = PSPAGE+1
	CALL FLWSEL(PSLUN)
	CALL FLWRTF('%%%%Page: %N %N',PSPAGE,PSPAGE)
	CALL FLWSTR('%%BeginPageSetup')
	CALL FLWSTR('save')
	CALL FLWSTR('%%EndPageSetup')
	RETURN
	END
C
	SUBROUTINE PS_SHOW
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Show (print) a page
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
	CALL PS_FLUSH(.FALSE.,.FALSE.)
	CALL FLWSEL(PSLUN)
	CALL FLWSTR('restore')
	CALL FLWSTR('showpage')
C
	RETURN
	END
C
	SUBROUTINE PS_FLUSH(FILL,CLOSE)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Flush out and draw any path in progress
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C arguments
	LOGICAL		FILL		! fill path as area
	LOGICAL		CLOSE		! close path
C
	IF (NPATH.GT.0) THEN
	   NPATH = 0
C
	   CALL EXPAND
	   CALL FLWSEL(PSLUN)
	   IF (FILL) THEN
	      CALL FLWAPP('F')
	   ELSE
	      IF (CLOSE) THEN
	         CALL FLWAPP('s')
	      ELSE
	         CALL FLWAPP('S')
	      ENDIF
	   ENDIF
	ENDIF
	RETURN
	END
C
	SUBROUTINE PS_LINE(X,Y)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Draw a line to position
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C Arguments
	REAL		X,Y	! position in DC (metres)
C
	IF (NPATH.EQ.0) THEN
	   CALL TTWSTR('PS error - no current point')
	   GOTO 999
	ENDIF
C
	IF (X.NE.PSX.OR.Y.NE.PSY) THEN
	   IF (NPATH.GE.MAXPATH) THEN
	      CALL PS_FLUSH(.FALSE.,.FALSE.)
	      IF (LSTLIN) THEN
	         NPATH = NPATH+1
	         CALL PS_COORD((LSTX+PSX)/2.0,(LSTY+PSY)/2.0,'m')
	         NPATH = NPATH+1
	         CALL PS_COORD(PSX,PSY,'l')
	      ELSE
	         CALL PS_MOVE(PSX,PSY,.FALSE.)
	      ENDIF
	   ENDIF
	   LSTX = PSX
	   LSTY = PSY
	   PSX = X
	   PSY = Y
	   CALL PS_LIM(PSX,PSY)
	   LSTLIN = .TRUE.	! was a line, not a move
	   NPATH = NPATH+1
	   CALL PS_COORD(PSX,PSY,'l')
	ENDIF
C
999	RETURN
	END
C
	SUBROUTINE PS_MOVE(X,Y,BREAK)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Move to position
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C Arguments
	REAL		X,Y	! position in DC (metres)
	LOGICAL		BREAK	! break path if finite move
C
	IF (X.NE.PSX.OR.Y.NE.PSY.OR.NPATH.EQ.0) THEN
	   IF (NPATH.GE.MAXPATH.OR.BREAK) THEN
	      CALL PS_FLUSH(.FALSE.,.FALSE.)
	   ENDIF
	   PSX = X
	   PSY = Y
	   CALL PS_LIM(PSX,PSY)
	   LSTLIN = .FALSE.	! was a move, not a line
	   NPATH = NPATH+1
	   CALL PS_COORD(PSX,PSY,'m')
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_TEXT(X,Y,STRING)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Output a text string
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C arguments
	REAL		X,Y
	CHARACTER*(*)	STRING
C
	CALL PS_FLUSH(.FALSE.,.FALSE.)	! flush out any linework
	CALL FLWSEL(PSLUN)
	CALL PS_SHOW_STRING(X,Y,STRING)
C
C pretend nothing in path (there is actually a single move, but it
C will be replaced by the next move)
	NPATH = 0
C
	RETURN
	END
C
	SUBROUTINE PS_SHOW_STRING(X,Y,STRING)
C
CDEC$	IDENT	'16JL93'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	14-July-1993
C
C Show a (possibly kerned) string using Display PostScript
C
	IMPLICIT NONE
C
	INCLUDE		'DDSC.PAR'
	INCLUDE		'PS.CMN'
C
C Arguments:
	REAL		X,Y
	CHARACTER*(*)	STRING
C
C functions
	REAL		GKS_C_GET_KERN_PAIR
	REAL		GKS_C_GET_CHAR_WIDTH
	INTEGER		GKS_C_GET_ARABIC
	INTEGER		PS_FIND_COMPOSITE
C
C w/s
	RECORD	/DDSC/	CSTR
	INTEGER		CLEN
	INTEGER		P,P0,P1,P2
	INTEGER		C1,C2		! two consecutive chars
	LOGICAL		CC1,CC2		! composite or not
	INTEGER		C1A,C2A		! after glyph substitution
	LOGICAL		ARABIC1,ARABIC2
	REAL		K,KK
	INTEGER		I
	INTEGER		N
	LOGICAL		COMP,DO_COMP,DO_ARABIC
	REAL		TX,TY
C
	TX = X
	TY = Y
C
C do composites if both LSL$COMPOSITE_CHARACTERS (PSCCHR),
C and we have AFM info (PSCWID)
C PSKERN and PSRTOL only true if have AFM widths also, so if no AFM
C info, we don't do this section at all.
C In principal, we could do Arabic glyph substitution with no AFM
C file (so long as going L to R), but for now, insist on AFM widths
	DO_COMP = PSCCHR.AND.PSCWID
	DO_ARABIC = PSARAB.AND.PSCWID
	IF (PSFPTR.NE.0.AND.
     &		(PSKERN.OR.DO_COMP.OR.PSRTOL.OR.DO_ARABIC)) THEN
	  P = 0
	  P0 = 1
	  P2 = 0
	  C2 = -1
	  CC2 = .FALSE.
	  K = 0.0
C
C get next character
5	  CONTINUE
C
C shuffle down one character position
	  C1 = C2
	  CC1 = CC2
	  C1A = C2A
	  ARABIC1 = ARABIC2
	  P1 = P2
	  P = P+1
	  P2 = P		! position of *start* of character
C
C get next char, or flag reached end of string
	  CC2 = .FALSE.
	  IF (P.GT.LEN(STRING)) THEN
	    C2 = -1
	  ELSE
	    C2 = ICHAR(STRING(P:P))
	    IF (DO_COMP.AND.CHAR(C2).EQ.'{') THEN
	      CC2 = .TRUE.
	      C2 = PS_FIND_COMPOSITE(PSCTAB,STRING(P:),N)
	      P = P+N-1		! position of *end* of character
	    ENDIF
	  ENDIF
C
	  IF (C2.GE.0) THEN
	    C2A = C2		! assume no Arabic glyph
	    ARABIC2 = .FALSE.
	    IF (DO_ARABIC.AND..NOT.CC2) THEN
	      C2A = GKS_C_GET_ARABIC(%VAL(PSFPTR),%REF(STRING),
     &					LEN(STRING),P2-1,DO_COMP)
	      IF (C2A.GT.0) THEN
	        ARABIC2 = .TRUE.
	      ELSE
	        C2A = C2
	      ENDIF
	    ENDIF
	  ENDIF
C
C once 2nd char has been read, then we have a char in C1
	  IF (C1.GE.0) THEN
C
C check if need to draw the char individually i.e. composite,
C right-to-left, Arabic
C draw composite character
	    IF (CC1 .OR. PSRTOL .OR. ARABIC1) THEN
C
C flush out accumulated string
	      IF (P1.GT.P0) THEN
	        CALL PS_WRITE_STRING(TX,TY,STRING(P0:P1-1))
	        TX = TX + K*PSCVEC
	        TY = TY + K*PSSVEC
	      ENDIF
C
C Kerning and Width use the glyphs *after* substitution
	      K = GKS_C_GET_CHAR_WIDTH(%VAL(PSFPTR),C1A)
	      IF (PSRTOL) THEN
	        TX = TX - K*PSCVEC
	        TY = TY - K*PSSVEC
	        K = 0.0
	      ENDIF
	      IF (CC1) THEN
	        CALL PS_SHOW_COMPOSITE(TX,TY,C1)
	      ELSE
	        CALL PS_WRITE_STRING(TX,TY,CHAR(C1A))
	      ENDIF
	      IF (PSKERN.AND.C2.GE.0) K = K +
     &			GKS_C_GET_KERN_PAIR(%VAL(PSFPTR),C1A,C2A)
	      IF (PSRTOL) K = -K
	      TX = TX + K*PSCVEC
	      TY = TY + K*PSSVEC
	      K = 0.0
	      P0 = P2
	    ELSE
C
C non-composite character
	      K = K + GKS_C_GET_CHAR_WIDTH(%VAL(PSFPTR),C1A)
	      KK = 0.0
	      IF (PSKERN.AND.C2.GE.0) THEN
	        KK = GKS_C_GET_KERN_PAIR(%VAL(PSFPTR),C1A,C2A)
	        K = K+KK
	      ENDIF
C
C if we got a kern pair, or at end of string, then flush out
	      IF (KK.NE.0.OR.C2.LT.0) THEN
	        CALL PS_WRITE_STRING(TX,TY,STRING(P0:P2-1))
	        TX = TX + K*PSCVEC
	        TY = TY + K*PSSVEC
	        K = 0
	        P0 = P2
	      ENDIF
	    ENDIF
	  ENDIF
C
C round again, unless we have reached end of string
	  IF (C2.GE.0) GOTO 5
C
	ELSE
C
C Not kerned, and not composite, so just display ordinarily.
C If composite was requested, but cannot be done, then approximate it.
	  IF (PSCCHR) THEN
	    CALL STR$GET1_DX(LEN(STRING),CSTR)
	    CALL PS_PROCESS_COMP(CSTR,STRING,CLEN)
	    CALL STR$LEFT(CSTR,CSTR,CLEN)
	    CALL PS_WRITE_STRING(TX,TY,CSTR)
	    CALL STR$FREE1_DX(CSTR)
	  ELSE
	    CALL PS_WRITE_STRING(TX,TY,STRING)
	  ENDIF
	ENDIF
C
999	RETURN
	END
C
	SUBROUTINE PS_SHOW_COMPOSITE(X,Y,C)
C
CDEC$	IDENT	'16JL93'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	14-July-1993
C
C Show a composite character
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C Arguments:
	REAL		X,Y
	INTEGER		C
C
C functions
	INTEGER		GKS_C_GET_COMPONENT
C
C w/s
	INTEGER		N
	INTEGER		CH
	REAL		DELTAX,DELTAY
	REAL		RX,RY
C
C Ordinary characters can be displayed simply, with a zero offset
	IF (C.LE.255) THEN
	  CALL PS_WRITE_STRING(X,Y,CHAR(C))
	ELSE
C
C but for a real composite, get each component in turn
	  N = 0
10	  CH = GKS_C_GET_COMPONENT(%VAL(PSFPTR),C,N,DELTAX,DELTAY)
	  IF (CH.LT.0) GOTO 999
	  RX = DELTAX*PSCVEC - DELTAY*PSSVEC
	  RY = DELTAX*PSSVEC + DELTAY*PSCVEC
	  CALL PS_WRITE_STRING(X+RX,Y+RY,CHAR(CH))
	  N = N+1
	  GOTO 10
	ENDIF
999	RETURN
	END
C
	SUBROUTINE PS_WRITE_STRING(X,Y,STRING)
C
CDEC$	IDENT	'16JL93'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	14-July-1993
C
C Write a string to PostScript file
C
	IMPLICIT NONE
C
	INCLUDE	'LSL$CMNLSL:EXPC.CMN'
	INCLUDE	'PS.CMN'
C
C Arguments:
	REAL		X,Y
	CHARACTER*(*)	STRING
C
C workspace
	INTEGER		I
	CHARACTER*1	CH
	INTEGER		ICH
C
	CALL EXPAND
	CALL PS_APP(PSANG*RTOD)
	CALL PS_APP(X*MTOP)
	CALL PS_APP(Y*MTOP)
	CALL PS_LIM(X,Y)
	CALL FLWAPP('e')
C
C n.b. LSLLIB bug - if %P0 at end of string then ignored
	CALL EXPAND('(%P0% ')		! use zero pad char
C
C process the string, escaping ()\, and using octal for unprintable
	DO 100 I=1,LEN(STRING)
	   IF (EXPLEN.GT.60) THEN
	      CALL FLWAPP('\')	! continuation character
C
C n.b. LSLLIB bug - if %P0 at end of string then ignored
	      CALL EXPAND('%P0% ')! use zero pad char
	   ENDIF
	   CH = STRING(I:I)
	   ICH = ICHAR(CH)
	   IF (ICH.LT.32.OR.ICH.GE.127) THEN
	      CALL APPEND('\%O3',ICH)		! use octal
	   ELSEIF (CH.EQ.'%') THEN
	      CALL APPEND('%%')			! single %
	   ELSE
	      IF (CH.EQ.'('.OR.CH.EQ.')'.OR.CH.EQ.'\') CALL APPEND('\')
	      CALL APPEND(CH)
	   ENDIF
100	CONTINUE
	CALL FLWAPP(')t')
	RETURN
	END
C
	LOGICAL FUNCTION PS_STRING_WIDTH(STRING,FONT,W)
C
CDEC$	IDENT	'12MY95'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-April-1984
C
C Get the width of a string if plotted at unit height
C Returns .TRUE. if unable to return the information
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C Arguments:
	CHARACTER*(*)	STRING
	INTEGER		FONT
	REAL		W
C
C functions
	INTEGER		GKS_C_FIND_FONT
	REAL		GKS_C_GET_KERN_PAIR
	REAL		GKS_C_GET_CHAR_WIDTH
	INTEGER		GKS_C_GET_ARABIC
	INTEGER		PS_FIND_COMPOSITE
C
C w/s
	INTEGER		FPTR
	REAL		SCALE
	LOGICAL		KERNED
	LOGICAL		GOT_WIDTH
	INTEGER*4	CHTAB
	LOGICAL		RTOL
	LOGICAL		ARABIC
	INTEGER		P
	INTEGER		C1,C2
	LOGICAL		CC2		! composite or not
	INTEGER		C1A,C2A		! after glyph substitution
	INTEGER		N
C
	PS_STRING_WIDTH = .TRUE.
C
	FPTR = GKS_C_FIND_FONT(FONT,SCALE,KERNED,GOT_WIDTH,
     &			CHTAB,RTOL,ARABIC)
	IF (FPTR.EQ.0.OR..NOT.GOT_WIDTH) GOTO 999
C
	W = 0.0
	P = 0
	C2 = -1
C
C get next character
5	CONTINUE
C
C shuffle down one character position
	C1 = C2
	C1A = C2A
	P = P+1
C
C get next char, or flag reached end of string
	CC2 = .FALSE.
	IF (P.GT.LEN(STRING)) THEN
	   C2 = -1
	ELSE
	   C2 = ICHAR(STRING(P:P))
	   IF (PSCCHR.AND.CHAR(C2).EQ.'{') THEN
	      CC2 = .TRUE.
	      C2 = PS_FIND_COMPOSITE(CHTAB,STRING(P:),N)
	      P = P+N-1
	   ENDIF
	ENDIF
C
	IF (C2.GE.0) THEN
	  C2A = C2		! assume no Arabic glyph
	  IF (ARABIC.AND..NOT.CC2) THEN
	    C2A = GKS_C_GET_ARABIC(%VAL(FPTR),%REF(STRING),
     &					LEN(STRING),P-1,PSCCHR)
	    IF (C2A.LT.0) C2A = C2
	  ENDIF
	ENDIF
C
C Kerning and Width use the glyphs *after* substitution
	IF (C1.GE.0) THEN
	  W = W + GKS_C_GET_CHAR_WIDTH(%VAL(FPTR),C1A)
	  IF (KERNED.AND.C2.GE.0) W = W +
     &			GKS_C_GET_KERN_PAIR(%VAL(FPTR),C1A,C2A)
	ENDIF
C
C round again, unless we have reached end of string
	IF (C2.GE.0) GOTO 5
C
C negative width if Right-TO-Left font
	IF (RTOL) W = -W
	W = W*SCALE
	PS_STRING_WIDTH = .FALSE.
C
999	RETURN
	END
C
	LOGICAL FUNCTION PS_STRING_BOUNDS(STRING,FONT,BORDER,ROUTINE)
C
CDEC$	IDENT	'12MY95'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	31-August-1984
C
C Call the callback ROUTINE for each character in the string, passing
C the width and bounding box of the character.
C It is used to build up a region around the string.
C Returns .TRUE. if unable to return the information
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C Arguments:
	CHARACTER*(*)	STRING
	INTEGER		FONT
	REAL		BORDER
	EXTERNAL	ROUTINE
C
C functions
	INTEGER		GKS_C_FIND_FONT
	REAL		GKS_C_GET_KERN_PAIR
	REAL		GKS_C_GET_CHAR_METRICS
	INTEGER		GKS_C_GET_ARABIC
	INTEGER		PS_FIND_COMPOSITE
C
C w/s
	INTEGER		FPTR
	REAL		SCALE
	LOGICAL		KERNED
	LOGICAL		GOT_WIDTH
	INTEGER*4	CHTAB
	LOGICAL		RTOL
	LOGICAL		ARABIC
	INTEGER		P
	INTEGER		C1,C2
	LOGICAL		CC2		! composite or not
	INTEGER		C1A,C2A		! after glyph substitution
	INTEGER		N
	REAL		W
	REAL		BOX(4)
C
	PS_STRING_BOUNDS = .TRUE.
C
	FPTR = GKS_C_FIND_FONT(FONT,SCALE,KERNED,GOT_WIDTH,
     &			CHTAB,RTOL,ARABIC)
	IF (FPTR.EQ.0.OR..NOT.GOT_WIDTH) GOTO 999
C
	P = 0
	C2 = -1
C
C get next character
5	CONTINUE
C
C shuffle down one character position
	C1 = C2
	C1A = C2A
	P = P+1
C
C get next char, or flag reached end of string
	CC2 = .FALSE.
	IF (P.GT.LEN(STRING)) THEN
	   C2 = -1
	ELSE
	   C2 = ICHAR(STRING(P:P))
	   IF (PSCCHR.AND.CHAR(C2).EQ.'{') THEN
	      CC2 = .TRUE.
	      C2 = PS_FIND_COMPOSITE(CHTAB,STRING(P:),N)
	      P = P+N-1
	   ENDIF
	ENDIF
C
	IF (C2.GE.0) THEN
	  C2A = C2		! assume no Arabic glyph
	  IF (ARABIC.AND..NOT.CC2) THEN
	    C2A = GKS_C_GET_ARABIC(%VAL(FPTR),%REF(STRING),
     &					LEN(STRING),P-1,PSCCHR)
	    IF (C2A.LT.0) C2A = C2
	  ENDIF
	ENDIF
C
C Kerning and Width use the glyphs *after* substitution
	IF (C1.GE.0) THEN
	  W = GKS_C_GET_CHAR_METRICS(%VAL(FPTR),C1A,BOX)
	  IF (KERNED.AND.C2.GE.0) W = W +
     &			GKS_C_GET_KERN_PAIR(%VAL(FPTR),C1A,C2A)
	  W = W*SCALE
	  IF (BOX(1).EQ.0.0.AND.BOX(2).EQ.0.0.AND.
     &	      BOX(3).EQ.0.0.AND.BOX(4).EQ.0.0) THEN
	    BOX(3) = W
	  ELSE
	    BOX(1) = BOX(1)*SCALE - BORDER
	    BOX(2) = BOX(2)*SCALE - BORDER
	    BOX(3) = BOX(3)*SCALE + BORDER
	    BOX(4) = BOX(4)*SCALE + BORDER
	  ENDIF
	  IF (RTOL) THEN
	    CALL ROUTINE(-W,BOX(3)-W,BOX(1)-W,BOX(2),BOX(4))
	  ELSE
	    CALL ROUTINE(W,BOX(1),BOX(3),BOX(2),BOX(4))
	  ENDIF
	ENDIF
C
C round again, unless we have reached end of string
	IF (C2.GE.0) GOTO 5
C
	PS_STRING_BOUNDS = .FALSE.
C
999	RETURN
	END
C
	SUBROUTINE PS_COORD(X,Y,OP)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Output a coordinate
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C Arguments
	REAL		X,Y	! position in DC (metres)
	CHARACTER*(*)	OP	! drawing operation
C
	CALL FLWSEL(PSLUN)
	CALL EXPAND
	CALL PS_APP(X*MTOP)
	CALL PS_APP(Y*MTOP)
	CALL FLWAPP('%S',OP)
C
	RETURN
	END
C
	SUBROUTINE PS_APP(X)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Append a single coordinate value
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C Arguments
	REAL		X	! position in DC (metres)
C
C avoid LSLLIB E format with positive exponent, since it includes a
C space which Postscript will not understand
CCC	IF (ABS(X).LT.0.1.AND.ABS(X).GE.0.001) THEN
	IF (ABS(X).LT.0.1) THEN
	   CALL APPEND(PS_FFORMAT(:FFLEN),X)
	ELSEIF (ABS(X).GE.PS_GLIMIT) THEN
	   CALL APPEND('%F0.0 ',X)
	ELSE
	   CALL APPEND(PS_GFORMAT(:GFLEN),X)
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_LIM(X,Y)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Update bounding box
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C Arguments
	REAL		X,Y	! position in DC (metres)
C
	IF (X-PSWIDM.LT.PSLIM(1)) PSLIM(1) = X-PSWIDM
	IF (X+PSWIDM.GT.PSLIM(3)) PSLIM(3) = X+PSWIDM
	IF (Y-PSWIDM.LT.PSLIM(2)) PSLIM(2) = Y-PSWIDM
	IF (Y+PSWIDM.GT.PSLIM(4)) PSLIM(4) = Y+PSWIDM
C
	RETURN
	END
C
	SUBROUTINE PS_DEFRGB(CI,R,G,B)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Define a colour in RGB
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C Arguments
	INTEGER		CI	! colour index
	REAL		R,G,B	! components
C
C Insert a procedure into CI element of the COLTAB array to set
C the required colour
	CALL FLWSEL(PSLUN)
	CALL FLWRTF(
     &		'COLTAB %N {%F0.3 %F0.3 %F0.3 setrgbcolor} put',
     &		CI,R,G,B)
	PSCOL = -1
	PSFCOL = -1
C
	RETURN
	END
C
	SUBROUTINE PS_CIRCLE(X,Y,ID)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Draw circle or arc
C ID = 1	Full circle - coords centre,edge
C ID = 2/3	Cw/ACw arc  - coords start,end,centre
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C Arguments
	REAL	X(3),Y(3)		! coordinates
	INTEGER	ID			! type 1-3
C
C w/s
	REAL	RAD,ANG1,ANG2
C
	CALL PS_FLUSH(.FALSE.,.FALSE.)	! flush out any linework
C
	CALL PS_LIM(X(1),Y(1))
	CALL PS_LIM(X(2),Y(2))
	CALL FLWSEL(PSLUN)
C
	IF (ID.EQ.1) THEN		! full circle
	   RAD = SQRT((X(1)-X(2))**2+(Y(1)-Y(2))**2)
	   CALL EXPAND
	   CALL PS_APP(X(1)*MTOP)
	   CALL PS_APP(Y(1)*MTOP)
	   CALL PS_APP(RAD*MTOP)
	   CALL FLWAPP('0 360 AA')
	ELSE				! arc
	   CALL PS_LIM(X(3),Y(3))
	   RAD = SQRT((X(1)-X(3))**2+(Y(1)-Y(3))**2)
	   ANG1 = ATAN2(Y(1)-Y(3),X(1)-X(3))*RTOD
	   IF (ANG1.LT.0.0) ANG1 = ANG1+360.0
	   ANG2 = ATAN2(Y(2)-Y(3),X(2)-X(3))*RTOD
	   IF (ANG2.LT.0.0) ANG2 = ANG2+360.0
	   CALL EXPAND
	   CALL PS_APP(X(3)*MTOP)
	   CALL PS_APP(Y(3)*MTOP)
	   CALL PS_APP(RAD*MTOP)
	   CALL APPEND('%F0.4 %F0.4 ',ANG1,ANG2)
	   IF (ID.EQ.2) THEN
	      CALL FLWAPP('AC')
	   ELSE
	      CALL FLWAPP('AA')
	   ENDIF
	ENDIF
	NPATH = 1	! persuade FLUSH that something there
	CALL PS_FLUSH(.FALSE.,.FALSE.)
C
	RETURN
	END
C
	SUBROUTINE PS_DASH(PECKC,REP1,REP2,PECK1,PECK2,GAP)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Set dash pattern
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
C
C Arguments
	LOGICAL	PECKC		! continue through points
	INTEGER	REP1,REP2	! repeat counts
	REAL	PECK1,PECK2	! peck lengths
	REAL	GAP		! gap length
C
C workspace
	INTEGER	I,REP
	REAL	PECK
	LOGICAL	FIRST
C
	CALL FLWSEL(PSLUN)
	FIRST = .TRUE.
	REP = REP1
	PECK = PECK1
C
	CALL EXPAND('[')
5	DO 10 I=1,REP
	   IF (EXPLEN.GT.60) THEN
	      CALL FLWLIN
	      CALL EXPAND
	   ENDIF
	   CALL PS_APP(PECK*MTOP)
	   CALL PS_APP(GAP*MTOP)
10	CONTINUE	
	IF (FIRST) THEN
	   FIRST = .FALSE.
	   REP = REP2
	   PECK = PECK2
	   GOTO 5
	ENDIF
	CALL FLWAPP(']0 d')
C
	RETURN
	END
C
	SUBROUTINE PS_BEGIN_IMAGE(NCOLS,NROWS,TMAT,BIT,COL,MONO,INV)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Begin an image
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C Arguments
	INTEGER	NCOLS,NROWS	! dimensions of image
	REAL	TMAT(6)		! image matrix
	LOGICAL	BIT		! bit image? else byte
	INTEGER	COL		! colour index if bit
	LOGICAL	MONO		! mono bit image
	LOGICAL	INV		! invert bit image
C
C workspace
	INTEGER	I
	REAL	D
C
C statement functions
	INTEGER	X,Y
	REAL	XC,YC
	XC(X,Y) = (TMAT(4)*(X-TMAT(5))-TMAT(3)*(Y-TMAT(6)))/D
	YC(X,Y) = (-TMAT(2)*(X-TMAT(5))+TMAT(1)*(Y-TMAT(6)))/D
C
	CALL PS_FLUSH(.FALSE.,.FALSE.)	! flush out any linework
C
C sort out extents
	D = TMAT(4)*TMAT(1)-TMAT(3)*TMAT(2)
	CALL PS_LIM(XC(0,0),YC(0,0))
	CALL PS_LIM(XC(NCOLS,NROWS),YC(NCOLS,NROWS))
C
	CALL FLWSEL(PSLUN)
	CALL EXPAND('%N %N ',NCOLS,NROWS)
	DO 10 I=1,4
	   CALL PS_APMAT(TMAT(I)/MTOP)
10	CONTINUE
	CALL PS_APMAT(TMAT(5))
	CALL PS_APMAT(TMAT(6))
C
	IF (BIT) CALL APPEND('%N ',COL)
	CALL APPEND('IM')
	IF (BIT) THEN
	   IF (MONO) THEN
	      CALL APPEND('M')
	   ELSE
	      CALL APPEND('B')
	   ENDIF
	ENDIF
	CALL FLWAPP('%N',PS_COMP)
C
C n.b. LSLLIB bug - if %P0 at end of string then ignored
	CALL EXPAND('%P0%^B')		! empty buffer for PS_IMAGE
	IMGCNT = -1			! no run length points
	IMGINV = INV			! invert bit image
	IMGCOL = NCOLS			! save size
	IMGROW = NROWS
	IMMONO = MONO
C
	RETURN
	END
C
	SUBROUTINE PS_APMAT(MVAL)
C
CDEC$	IDENT	'08DE93'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Append an image matrix value
C
	IMPLICIT NONE
C
C Arguments
	REAL	MVAL		! value of matrix element
C
C Always output the matrix to many sig figs since it is potentially
C multiplied by the number of rows and columns
C
C avoid LSLLIB E format with positive exponent, since it includes a
C space which Postscript will not understand
CCC	IF (ABS(MVAL).LT.0.1.AND.ABS(MVAL).GE.0.001) THEN
	IF (ABS(MVAL).LT.0.1) THEN
	   CALL APPEND('%F0.9 ',MVAL)
	ELSEIF (ABS(MVAL).GE.1E7) THEN
	   CALL APPEND('%F0.0 ',MVAL)
	ELSE
	   CALL APPEND('%G0.7 ',MVAL)
	ENDIF
	RETURN
	END
C
	SUBROUTINE PS_IMAGE(ARRAY,NVAL)
C
CDEC$	IDENT	'29JL94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Output some image samples
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
	INCLUDE		'PS.CMN'
C
C Arguments
	BYTE	ARRAY(*)
	INTEGER	NVAL
C
C workspace
	INTEGER	I
	INTEGER	START
	BYTE	BYT
C
	START = 0
C
	IF (PS_COMP.EQ.0) THEN
	   DO 5 I=1,NVAL
	      CALL PS_CHECK_BUFFER(78)
	      CALL APPEND('%X2',ARRAY(I))
5	   CONTINUE
	ELSE
C
C run-length encoded
	  DO 10 I=1,NVAL
	    BYT = ARRAY(I)
	    IF (IMGCNT.LT.0) THEN
C initialise
	      LSTBYT = BYT
	      START = I
	      IMGCNT = 1
	    ELSEIF (BYT.EQ.LSTBYT) THEN
C same
C part of run - is there a literal to output?
	      IF (START.LT.I-1) THEN
	        CALL PS_OUTPUT_BYTE_LITERAL(ARRAY,START,I-2)
	      ENDIF
	      START = I
	      IMGCNT = IMGCNT+1
C does the run need to be output
	      IF (IMGCNT.EQ.127) THEN
	        CALL PS_OUTPUT_BYTE_RUN(LSTBYT,IMGCNT)
	        IMGCNT = -1
	      ENDIF
	    ELSE
C different
C
C is there a run to be output, or single byte from end of last lot?
	      IF (IMGCNT.GT.1.OR.(IMGCNT.GT.0.AND.I.EQ.1)) THEN
	        CALL PS_OUTPUT_BYTE_RUN(LSTBYT,IMGCNT)
	        START = I
	        IMGCNT = 1
	      ENDIF
	      LSTBYT = BYT
C does the literal need to be output?
	      IF (I-START+1.EQ.127) THEN
	        CALL PS_OUTPUT_BYTE_LITERAL(ARRAY,START,I)
	        IMGCNT = -1
	      ENDIF
	    ENDIF
10	  CONTINUE
C
C we can't cope with literals spanning calls
	  IF (IMGCNT.GE.0.AND.START.LT.NVAL) THEN
	    CALL PS_OUTPUT_BYTE_LITERAL(ARRAY,START,NVAL)
	    IMGCNT = -1
	  ENDIF
	ENDIF
C
	RETURN
	END
C
C
	SUBROUTINE PS_BIT_IMAGE(ARRAY,NVAL)
C
CDEC$	IDENT	'25MR94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Output some image samples
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
	INCLUDE		'PS.CMN'
C
C Arguments
	BYTE		ARRAY(*)
	INTEGER		NVAL		! number of bits (not bytes!)
C
C NVAL will be multiple of 8, except for images with non-multiple
C of 8 in each scan line, in which case we are called at the
C end of each scan line, with some garbage in the last few bits.
C We just output the full number of bytes. 1 bit/pixel image will
C skip the padding, but 8 bit/pixel must allow for them in image
C procedure - to make this easier, we flush out after each call
C in this case.
C
C Note that 1 bit/pixel images (i.e. IMMONO) must be passed to the
C 'image' operator with each scan line padded to a byte boundary
C
C function
	INTEGER	PS_ROTB
C
C workspace
	INTEGER	I
	INTEGER	START
	BYTE	BYT
	INTEGER	COUNT
C
	COUNT = (NVAL-1)/8+1
	START = 0
C
	IF (PS_COMP.EQ.0) THEN
	  DO 5 I=1,COUNT
	    CALL PS_CHECK_BUFFER(78)
	    CALL APPEND('%X2',PS_ROTB(ARRAY(I)))
5	  CONTINUE
	ELSE
C
C run-length encoded
	  DO 10 I=1,COUNT
	    BYT = ARRAY(I)
	    IF (IMGCNT.LT.0) THEN
C initialise
	      LSTBYT = BYT
	      START = I
	      IMGCNT = 1
	    ELSEIF (BYT.EQ.LSTBYT) THEN
C same
C part of run - is there a literal to output?
	      IF (START.LT.I-1) THEN
	        CALL PS_OUTPUT_BIT_LITERAL(ARRAY,START,I-2)
	      ENDIF
	      START = I
	      IMGCNT = IMGCNT+1
C does the run need to be output
	      IF (IMGCNT.EQ.127) THEN
	        CALL PS_OUTPUT_BIT_RUN(LSTBYT,IMGCNT)
	        IMGCNT = -1
	      ENDIF
	    ELSE
C different
C is there a run to be output, or single byte from end of last lot?
	      IF (IMGCNT.GT.1.OR.(IMGCNT.GT.0.AND.I.EQ.1)) THEN
	        CALL PS_OUTPUT_BIT_RUN(LSTBYT,IMGCNT)
	        START = I
	        IMGCNT = 1
	      ENDIF
	      LSTBYT = BYT
C does the literal need to be output?
	      IF (I-START+1.EQ.127) THEN
	        CALL PS_OUTPUT_BIT_LITERAL(ARRAY,START,I)
	        IMGCNT = -1
	      ENDIF

	    ENDIF
10	  CONTINUE
C
C we can't cope with literals spanning calls
	  IF (IMGCNT.GE.0.AND.START.LT.COUNT) THEN
	    CALL PS_OUTPUT_BIT_LITERAL(ARRAY,START,COUNT)
	    IMGCNT = -1
	  ENDIF
C
C and for scan lines which are not multiples of 8, we always want
C to flush out at end of scanlines
	  IF (MOD(IMGCOL,8).NE.0) CALL PS_END_BIT_IMAGE
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_END_IMAGE(BIT)
C
CDEC$	IDENT	'25MR94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C End image by writing out last samples
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C argument
	LOGICAL		BIT	! bit image?
C
	IF (PS_COMP.EQ.1) THEN
	   IF (BIT) THEN
	      CALL PS_END_BIT_IMAGE
	   ELSE
	      IF (IMGCNT.GT.0) CALL PS_OUTPUT_BYTE_RUN(LSTBYT,IMGCNT)
	   ENDIF
	ENDIF
	CALL FLWLIN
	PSCOL = -1
	PSFCOL = -1
C
	RETURN
	END
C
C
	SUBROUTINE PS_END_BIT_IMAGE
C
CDEC$	IDENT	'25MR94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C End bit image by writing out last samples
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
	IF (IMGCNT.GT.0) THEN
	  IF (LSTBYT.EQ.0.OR.LSTBYT.EQ.-1.OR.IMGCNT.GT.1) THEN
	    CALL PS_OUTPUT_BIT_RUN(LSTBYT,IMGCNT)
	  ELSE
	    CALL PS_OUTPUT_BIT_LITERAL(LSTBYT,1,1)
	  ENDIF
	  IMGCNT = -1
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_BEGIN_CURVE(X,Y,LOOP)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Begin curved section
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C arguments
	REAL	X,Y		! starting position
	LOGICAL	LOOP		! closed loop?
C
	CNPTS = 1
	PS_LOOP = LOOP
	IF (PS_LOOP) THEN
	   CPTS(1,1) = X
	   CPTS(2,1) = Y
	ELSE
	   CPTS(1,3) = X
	   CPTS(2,3) = Y
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_END_CURVE
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C End curved section
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C Workspace
	INTEGER I
C
	IF (CNPTS.LE.1) GOTO 999
C
	IF (CNPTS.GE.5.OR.(.NOT.PS_LOOP.AND.CNPTS.GE.4)) THEN
	   IF (PS_LOOP) THEN
C
C complete last two segments, and first two segments using saved
C points from the start of the curve
	      DO 100 I=1,4
	         CPTS(1,6) = CSTART(1,I)
	         CPTS(2,6) = CSTART(2,I)
	         CALL PS_AKI(CPTS)
100	      CONTINUE
	   ELSE
C
C just complete last two segments by extrapolation
200	      DO 210 I=1,2
	         CALL PS_EXT(CPTS(1,3),.TRUE.)	! extrap. point 6
	         CALL PS_AKI(CPTS)
210	      CONTINUE	      
	   ENDIF
	   GOTO 999
	ENDIF
C
C so 4 or less points closed, 3 or less open
	IF (PS_LOOP) GOTO (999,300,400),CNPTS-1
	GOTO (250,500),CNPTS-1
C
C 2 points open - draw straight line
250	CALL PS_MOVE(CPTS(1,3),CPTS(2,3),.TRUE.)
	CALL PS_LINE(CPTS(1,4),CPTS(2,4))
	GOTO 999
C
C 3 points looped - draw straight line
300	CALL PS_MOVE(CPTS(1,1),CPTS(2,1),.TRUE.)
	CALL PS_LINE(CPTS(1,2),CPTS(2,2))
	GOTO 999
C
C 4 points looped
400	CSTART(1,4) = CSTART(1,1)
	CSTART(2,4) = CSTART(2,1)
	CPTS(1,5) = CSTART(1,1)
	CPTS(2,5) = CSTART(2,1)
	DO 410 I=1,3
	   CPTS(1,6) = CSTART(1,1+I)
	   CPTS(2,6) = CSTART(2,1+I)
	   CALL PS_AKI(CPTS)
410	CONTINUE
	GOTO 999
C
C 3 points open
500	CALL PS_EXT(CPTS(1,2),.FALSE.)	! extra point before start
	CALL PS_EXT(CPTS(1,1),.FALSE.)	! 2nd extra point before start
	GOTO 200			! horrid jump into IF block!!
C
999	RETURN
	END
C
	SUBROUTINE PS_CURVE(X,Y)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Curve to point
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C Arguments
	REAL		X,Y	! position in DC (metres)
C
C workspace
	INTEGER		IND
C
	IND = 6
	IF (PS_LOOP.AND.CNPTS.LT.6) THEN
	   IND = CNPTS
	ELSEIF (.NOT.PS_LOOP.AND.CNPTS.LT.4) THEN
	   IND = CNPTS+2
	ENDIF
C
C ignore duplicated points
	IF (X.EQ.CPTS(1,IND).AND.Y.EQ.CPTS(2,IND)) GOTO 999
C
	CNPTS = CNPTS+1
	IND = IND+1
	IF (IND.GT.6) IND = 6
C
C for loops, store points 2-5 in CSTART 1-4
	IF (PS_LOOP.AND.CNPTS.LE.5) THEN
	   CSTART(1,CNPTS-1) = X
	   CSTART(2,CNPTS-1) = Y
	ENDIF
C
	CPTS(1,IND) = X
	CPTS(2,IND) = Y
C
C for an open curve - if we have just had the 4th point, then extrpolate
C two more off the start, and then proceed as normal
	IF (.NOT.PS_LOOP.AND.CNPTS.EQ.4) THEN
	   CALL PS_EXT(CPTS(1,2),.FALSE.)
	   CALL PS_EXT(CPTS(1,1),.FALSE.)
	ENDIF
C
	IF (IND.EQ.6) CALL PS_AKI(CPTS)	! interpolate span 3-4
C
999	RETURN
	END
C
	SUBROUTINE PS_AKI(PTS)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Interpolate a section
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C argument
	REAL	PTS(2,6)
C
C workspace
	REAL	XPTS(4),YPTS(4)
	REAL	X0,X1,X2,X3,X4,X5,Y0,Y1,Y2,Y3,Y4,Y5
	REAL	W1,W2,W3,P0,P1,P2,P3,A1,A2,A3,A4,B1,B2,B3,B4
	REAL	SIN2,SIN3,COS2,COS3,Q0,Q1,Q2,Q3
	REAL	DZ,SW,R,Z,T2
	INTEGER	I,J
C
	EQUIVALENCE (X2,P0),(Y2,Q0),(T2,Q1)
	EQUIVALENCE (W2,Q2),(W3,Q3),(A1,P2),(B1,P3)
	EQUIVALENCE (A2,DZ),(SW,R,Z)
C
	DO 70 I = 1,2
C Calculate slopes at first end of span.
	   IF (I.GT.1) GOTO 20
	   X3 = PTS(1,3)
	   Y3 = PTS(2,3)
	   X4 = PTS(1,4)
	   Y4 = PTS(2,4)
	   X5 = PTS(1,5)
	   Y5 = PTS(2,5)
	   A3 = X4 - X3
	   B3 = Y4 - Y3
	   A2 = X3 - PTS(1,2)
	   A1 = PTS(1,2) - PTS(1,1)
	   B2 = Y3 - PTS(2,2)
	   B1 = PTS(2,2) - PTS(2,1)
	   A4 = X5 - X4
	   B4 = Y5 - Y4
	   GOTO 30
C Other end.
20	   X2 = X3
	   Y2 = Y3
	   X3 = X4
	   Y3 = Y4
	   X4 = X5
	   Y4 = Y5
	   X5 = PTS(1,6)
	   Y5 = PTS(2,6)
	   A1 = A2
	   B1 = B2
	   A2 = A3
	   B2 = B3
	   A3 = A4
	   B3 = B4
	   A4 = X5 - X4
	   B4 = Y5 - Y4
C
C Numerical differentiation.
C
	   COS2 = COS3
	   SIN2 = SIN3
30	   W2 = ABS(A3*B4 - A4*B3)
	   W3 = ABS(A1*B2 - A2*B1)
	   IF (W2  +  W3.NE.0.0) GOTO 40
	   W2 = SQRT(A3*A3  +  B3*B3)
	   W3 = SQRT(A2*A2  +  B2*B2)
40	   COS3 = W2*A2  +  W3*A3
	   SIN3 = W2*B2  +  W3*B3
	   R = COS3*COS3  +  SIN3*SIN3
	   IF (R.EQ.0.0) GOTO 50
	   R = SQRT(R)
	   COS3 = COS3/R
	   SIN3 = SIN3/R
50	   IF (I.EQ.1) GOTO 70
C
C Determine the coefficients.
C
	   R = SQRT(A2*A2  +  B2*B2)
	   P1 = R*COS2
	   P2 = 3.0*A2 - R*(COS2  +  COS2  +  COS3)
	   P3 = A2 - P1 - P2
	   Q1 = R*SIN2
	   Q2 = 3.0*B2 - R*(SIN2  +  SIN2  +  SIN3)
	   Q3 = B2 - Q1 - Q2
C
C calculate Bezier points from coefficients
	   XPTS(1) = PTS(1,3)
	   YPTS(1) = PTS(2,3)
	   XPTS(2) = XPTS(1) + P1/3.0
	   YPTS(2) = YPTS(1) + Q1/3.0
	   XPTS(3) = XPTS(2) + (P1+P2)/3.0
	   YPTS(3) = YPTS(2) + (Q1+Q2)/3.0
	   XPTS(4) = PTS(1,4)
	   YPTS(4) = PTS(2,4)
	   CALL PS_BEZIER(XPTS,YPTS)
70	CONTINUE
C
	DO 1000 I=1,5
	   PTS(1,I) = PTS(1,I+1)
	   PTS(2,I) = PTS(2,I+1)
1000	CONTINUE
C
	RETURN
	END
C
	SUBROUTINE PS_EXT(PTS,FWD)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Extrapolate point 4 from points 1,2,3,
C  or 1 from 4,3,2
C
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C argument
	REAL	PTS(2,4)
	LOGICAL	FWD
C
C workspace
	REAL	R
	REAL	X23,Y23,X12,Y12
C
C calculate differences 1->2 and 2->3
	IF (FWD) THEN
	   X12 = PTS(1,2)-PTS(1,1)
	   Y12 = PTS(2,2)-PTS(2,1)
	   X23 = PTS(1,3)-PTS(1,2)
	   Y23 = PTS(2,3)-PTS(2,2)
	ELSE
	   X12 = PTS(1,3)-PTS(1,4)
	   Y12 = PTS(2,3)-PTS(2,4)
	   X23 = PTS(1,2)-PTS(1,3)
	   Y23 = PTS(2,2)-PTS(2,3)
	ENDIF
C
C R is amount of 2->3 vector to be added to point 1
C to give point 4
	R = 1.0 + 2.0*(X23*X12 + Y23*Y12)/(X23**2 + Y23**2)
C
C extrapolate point
	IF (FWD) THEN
	   PTS(1,4) = PTS(1,1) + X23*R
	   PTS(2,4) = PTS(2,1) + Y23*R
	ELSE
	   PTS(1,1) = PTS(1,4) + X23*R
	   PTS(2,1) = PTS(2,4) + Y23*R
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_BEZIER(X,Y)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	23-Feb-1991
C
C Bezier curve section
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C arguments
	REAL	X(4),Y(4)
C
C workspace
	INTEGER	I
C
	IF (NPATH.GE.MAXPATH-4) THEN
	   CALL PS_FLUSH(.FALSE.,.FALSE.)
	   IF (LSTLIN) THEN
	      NPATH = NPATH+1
	      CALL PS_COORD((LSTX+PSX)/2.0,(LSTY+PSY)/2.0,'m')
	      NPATH = NPATH+1
	      CALL PS_COORD(PSX,PSY,'l')
	   ENDIF
	ENDIF

	CALL PS_MOVE(X(1),Y(1),.TRUE.)
C
	PSX = X(4)
	PSY = Y(4)
	CALL PS_LIM(PSX,PSY)
	LSTLIN = .FALSE.		! pretend not a line
	NPATH = NPATH+3
C
	CALL FLWSEL(PSLUN)
	CALL EXPAND
	DO 10 I=2,4
	   CALL PS_APP(X(I)*MTOP)
	   CALL PS_APP(Y(I)*MTOP)
10	CONTINUE
	CALL FLWAPP('c')
C
	RETURN
	END
C
	SUBROUTINE PS_SETCOL(COLI,FILL)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C argument
	INTEGER	COLI
	LOGICAL	FILL
C
	IF (FILL) THEN
	   IF (COLI.NE.PSFCOL) THEN
	      PSFCOL = COLI
	      IF (PSFCOL.NE.PSCOL) PSCOL = -1
	      CALL FLWSEL(PSLUN)
	      CALL FLWRTF('%N k',PSFCOL)
	   ENDIF
	ELSE
	   IF (COLI.NE.PSCOL) THEN
	      PSCOL = COLI
	      IF (PSCOL.NE.PSFCOL) PSFCOL = -1
	      CALL FLWSEL(PSLUN)
	      CALL FLWRTF('%N K',PSCOL)
	   ENDIF
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_SETWID(LWID)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C argument
	REAL	LWID
C
	IF (LWID.NE.PSWID) THEN
	   PSWID = LWID
	   CALL FLWSEL(PSLUN)
	   CALL EXPAND
	   PSWIDM = PSWID*NOMLW
	   CALL PS_APP(PSWIDM*MTOP)	! convert to points
	   PSWIDM = PSWIDM/2.0
	   CALL FLWAPP('w')
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_SETTYP(LTYPE)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C argument
	INTEGER	LTYPE
C
C deal with 1000 case in PS_SETPAT
	IF (LTYPE.NE.PSTYPE.AND.LTYPE.NE.1000) THEN
	   PSTYPE = LTYPE
	   IF (PSTYPE.EQ.2) THEN
	      PS_PECKC = .TRUE.
	      PS_REP1 = 1
	      PS_REP2 = 0
	      PS_PECK1 = 0.001
	      PS_GAP = 0.001
	   ELSEIF (PSTYPE.EQ.3) THEN
	      PS_PECKC = .TRUE.
	      PS_REP1 = 1
	      PS_REP2 = 0
	      PS_PECK1 = 0.0002
	      PS_GAP = 0.0004
	   ELSEIF (PSTYPE.EQ.4) THEN
	      PS_PECKC = .TRUE.
	      PS_REP1 = 1
	      PS_REP2 = 1
	      PS_PECK1 = 0.001
	      PS_PECK1 = 0.0002
	      PS_GAP = 0.0005
	   ELSE
	      PS_PECKC = .TRUE.
	      PS_REP1 = 0
	      PS_REP2 = 0
	   ENDIF
	   CALL PS_DASH(PS_PECKC,PS_REP1,PS_REP2,
     &			PS_PECK1,PS_PECK2,PS_GAP)
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_SETPAT(PECKC,REP1,REP2,PECK1,PECK2,GAP)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C Called after PS_SETTYP when LTYPE=1000 to set current line pattern
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C arguments
	LOGICAL	PECKC
	INTEGER	REP1,REP2
	REAL	PECK1,PECK2,GAP
C
	IF (PS_PECKC.NE.PECKC.OR.PS_GAP.NE.GAP.OR.
     &	    PS_REP1.NE.REP1.OR.PS_REP2.NE.REP2.OR.
     &	    PS_PECK1.NE.PECK1.OR.PS_PECK2.NE.PECK2) THEN
	   PSTYPE = 1000
	   PS_PECKC = PECKC
	   PS_GAP = GAP
	   PS_REP1 = REP1
	   PS_REP2 = REP2
	   PS_PECK1 = PECK1
	   PS_PECK2 = PECK2
	   CALL PS_DASH(PS_PECKC,PS_REP1,PS_REP2,
     &			PS_PECK1,PS_PECK2,PS_GAP)
	ENDIF
	RETURN
	END
C
	SUBROUTINE PS_SETJC(JOIN,CAP)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C arguments
	INTEGER	JOIN
	INTEGER	CAP
C
	IF (JOIN.NE.PSJOIN.OR.CAP.NE.PSCAP) THEN
	   CALL FLWSEL(PSLUN)
	   CALL EXPAND
	   IF (JOIN.NE.PSJOIN) THEN
	      PSJOIN = JOIN
	      CALL APPEND('%N j',PSJOIN)
	      IF (CAP.NE.PSCAP) CALL APPEND(' ')
	   ENDIF
	   IF (CAP.NE.PSCAP) THEN
	      PSCAP = CAP
	      CALL APPEND('%N J',PSCAP)
	   ENDIF
	   CALL FLWLIN
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_SETTXT(CHHGT,CHANG,CHFNT)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C arguments
	REAL	CHHGT
	REAL	CHANG
	INTEGER	CHFNT
C
C function
	INTEGER GKS_C_FIND_FONT
C
	IF ( CHHGT.NE.PSHGT.OR.
     &	     CHFNT.NE.PSFNT) THEN
	   PSHGT = CHHGT
	   PSFNT = CHFNT
	   PSANG = CHANG+1.0			! anything different
	   CALL FLWSEL(PSLUN)
	   CALL EXPAND
	   CALL PS_APP(PSHGT*MTOP)
	   CALL FLWAPP('/F%N z',PSFNT)	! find the font
	   PSFPTR = GKS_C_FIND_FONT(PSFNT,PSSCALE,PSKERN,PSCWID,
     &			PSCTAB,PSRTOL,PSARAB)
	ENDIF
C
	IF (CHANG.NE.PSANG) THEN
	   PSANG = CHANG
	   IF (PSFPTR.NE.0.AND.(PSKERN.OR.PSRTOL.OR.
     &		((PSCCHR.OR.PSARAB).AND.PSCWID))) THEN
	      PSCVEC = COS(PSANG)*PSHGT*PSSCALE
	      PSSVEC = SIN(PSANG)*PSHGT*PSSCALE
	   ENDIF
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE PS_BEGIN_AREA
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C A no-op - called just before drawing the boundary of an area
C
	IMPLICIT NONE
C
	RETURN
	END
C
	SUBROUTINE PS_END_AREA
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C A no-op - called just after drawing the boundary of an area.
C We rely on PS_FLUSH to fill the area.
C
	IMPLICIT NONE
C
	RETURN
	END
C
	SUBROUTINE PS_BEGIN_FEATURE
C
CDEC$	IDENT	'10DE93'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
	CALL PS_FLUSH(.FALSE.,.FALSE.)
	CALL FLWSEL(PSLUN)
	CALL FLWSTR('u')
C
	RETURN
	END
C
	SUBROUTINE PS_END_FEATURE
C
CDEC$	IDENT	'10DE93'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
	CALL PS_FLUSH(.FALSE.,.FALSE.)
	CALL FLWSEL(PSLUN)
	CALL FLWSTR('U')
C
	RETURN
	END
C
	SUBROUTINE PS_BEGIN_SEPARATION(COMMAND)
C
CDEC$	IDENT	'18NO97'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:READSTR.PAR'
	INCLUDE		'LSL$CMNLSL:CMDCOM.CMN'
	INCLUDE		'LSL$CMNLSL:TXTC.CMN'
	INCLUDE		'LSL$CMNLSL:WINDEF.CMN'
	INCLUDE		'PS.CMN'
C
C argument
	CHARACTER*(*)	COMMAND
C
C functions
	EXTERNAL	GKS_CSPACE_CMD_TABLE
	INTEGER		RDCOMM
	LOGICAL		RDCHS
	LOGICAL		RDLONG
	LOGICAL		RDREAL
	INTEGER		READSTR
C
C w/s
	LOGICAL*1	SAV_NOMESS
	INTEGER*2	SAVPTR
	INTEGER*2	SAVORIG
	INTEGER*4	SAVTXB(2)
	LOGICAL*1	SAVWIN
	BYTE		CH
	INTEGER		CMD
	INTEGER		I
	INTEGER		OVER
	REAL		COMP(4)
	INTEGER		NCOMP
	LOGICAL		SET
	CHARACTER*80	NAME
	INTEGER		NLEN
C
	SET = .FALSE.
C
C save line decoding context, including auxiliary buffer
	SAVPTR = DCPTR
	SAVORIG = ORIGTP
	SAVTXB(1) = AUXTXB(1)
	SAVTXB(2) = AUXTXB(2)
	SAVWIN = WINDEF
C
	CALL SETAUX(%REF(COMMAND),LEN(COMMAND))
C
	IF (RDCHS(CH)) GOTO 999		! nothing there, unset
C
	IF (CH.EQ.'"') THEN
	   NLEN = READSTR(NAME, CH, ON_CHAR2, .FALSE.)
	ELSE
	   CALL BSCH
	   NLEN = READSTR(NAME, 0, ON_SPACE, .FALSE.)
	ENDIF
C
	IF (NLEN.EQ.0) GOTO 999
C
	IF (RDLONG(OVER)) GOTO 999
C
	SAV_NOMESS = NOMESS
	NOMESS = .FALSE.
	CMD = RDCOMM(GKS_CSPACE_CMD_TABLE)
	NOMESS = SAV_NOMESS
	IF (CMD.LE.0) GOTO 999
	IF (CMD.EQ.1) THEN
	   NCOMP = 3	! RGB
	ELSE
	   NCOMP = 4	! CMYK
	ENDIF
C
	DO 10 I=1,NCOMP
	   IF (RDREAL(COMP(I))) GOTO 999
10	CONTINUE
C
	SET = .TRUE.
C
999	CALL PS_FLUSH(.FALSE.,.FALSE.)
	CALL FLWSEL(PSLUN)
	IF (SET) THEN
C
	   CALL EXPAND
	   DO 20 I=1,NCOMP
	      CALL APPEND('%F0.3 ',COMP(I))
20	   CONTINUE
	   IF (NCOMP.EQ.3) THEN
	      CALL APPEND('/RGB ')
	   ELSE
	      CALL APPEND('/CMYK ')
	   ENDIF
	   IF (OVER.EQ.0) THEN
	      CALL APPEND('false ')
	   ELSE
	      CALL APPEND('true ')
	   ENDIF
	   CALL FLWAPP('(%S) SETSEP',NAME(:NLEN))
	ELSE
	   CALL FLWSTR('-1 SETSEP')
	ENDIF
C
	PSCOL = -1
	PSFCOL = -1
C
	DCPTR = SAVPTR
	ORIGTP = SAVORIG
	AUXTXB(1) = SAVTXB(1)
	AUXTXB(2) = SAVTXB(2)
	WINDEF = SAVWIN
C
	RETURN
	END
C
	INTEGER FUNCTION PS_FIND_COMPOSITE(CHTAB,STRING,N)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	14-July-1993
C
C Look up name of composite character
C Called with STRING(1:1) = '{'
C Returns number of characters absorbed in N
C
	IMPLICIT NONE
C
	INCLUDE	'LSL$CMNLSL:CMDCOM.CMN'
	INCLUDE	'LSL$CMNLSL:TXTC.CMN'
	INCLUDE	'LSL$CMNLSL:WINDEF.CMN'
C
C Arguments:
	INTEGER		CHTAB	! character name table address
	CHARACTER*(*)	STRING
	INTEGER		N
C
C functions
	INTEGER		RDCOMM
	LOGICAL		RDCHS
C
C w/s
	LOGICAL*1	SAV_NOMESS
	INTEGER*2	SAVPTR
	INTEGER*2	SAVORIG
	INTEGER*4	SAVTXB(2)
	LOGICAL*1	SAVWIN
	BYTE		CH
	INTEGER		CMD
	LOGICAL		HADAUX
C
	HADAUX = .FALSE.
C
C '{' at end of line just turns into spce
	IF (LEN(STRING).LE.1) THEN
	   N = 1			! just absorb the '{'
	   PS_FIND_COMPOSITE = ICHAR(' ')	! return space
	   GOTO 999
	ENDIF
C
C repeated '{' is a single '{'
	IF (STRING(2:2).EQ.'{') THEN
	   N = 2
	   PS_FIND_COMPOSITE = ICHAR('{')
	   GOTO 999
	ENDIF
C
C otherwise we will be skipping up to '}' or end of line
	N = INDEX(STRING,'}')
	IF (N.EQ.0) N = LEN(STRING)
C
C save line decoding context, including auxiliary buffer
	SAVPTR = DCPTR
	SAVORIG = ORIGTP
	SAVTXB(1) = AUXTXB(1)
	SAVTXB(2) = AUXTXB(2)
	SAVWIN = WINDEF
C
	CALL SETAUX(%REF(STRING(2:)),N-1)	! includes '}'
	HADAUX = .TRUE.
	IF (RDCHS(CH)) THEN
C
C only get here if we have '{' followed only by spaces/tabs
	   PS_FIND_COMPOSITE = ICHAR(' ')	! return space
	   GOTO 999
	ENDIF
C
C First sig char after '{' is used if lookup fails
	PS_FIND_COMPOSITE = CH.AND.255	! first char as default
C
C No character name table, so can't do lookup
	IF (CHTAB.EQ.0) GOTO 999
C
C Look up name in table - command number is char+1, and char>=256
C are composites
	CALL BSCH
	SAV_NOMESS = NOMESS
	NOMESS = .FALSE.
	CMD = RDCOMM(%VAL(CHTAB))
	NOMESS = SAV_NOMESS
	IF (CMD.LE.0) THEN
	   CALL TTWSTR('??? Error in composite character name')
	   GOTO 999
	ENDIF
	PS_FIND_COMPOSITE = CMD-1
C
C check for rubbish after name
	IF (RDCHS(CH)) GOTO 999
	IF (CH.EQ.'}') GOTO 999
	CALL WRITEF('Unexpected "%S" after composite character name',
     &		STRING(DCPTR:N-1))
C
999	IF (HADAUX) THEN
	   DCPTR = SAVPTR
	   ORIGTP = SAVORIG
	   AUXTXB(1) = SAVTXB(1)
	   AUXTXB(2) = SAVTXB(2)
	   WINDEF = SAVWIN
	ENDIF
	RETURN
	END
C
	SUBROUTINE PS_PROCESS_COMP(DEST,SOURCE,DLEN)
C
CDEC$	IDENT	'16JL87'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	14-July-1993
C
C Remove {} sequences from string
C
	IMPLICIT NONE
C
C arguments
	INTEGER		DLEN
	CHARACTER*(*)	DEST,SOURCE
C
C functions
	INTEGER		PS_FIND_COMPOSITE
C
C w/s
	INTEGER		D,S
	INTEGER		N
	CHARACTER*1	C
C
	D = 0
	S = 0
C
C get next character
5	S = S+1
	IF (S.GT.LEN(SOURCE)) GOTO 999
	C = SOURCE(S:S)
	IF (C.EQ.'{') THEN
	  C = CHAR(PS_FIND_COMPOSITE(0,SOURCE(S:),N))
	  S = S+N-1
	ENDIF
	D = D+1
	DEST(D:D) = C
	GOTO 5
C
C rather grubby STR$ call - assumes argument is dynamic string
999	DLEN = D
	RETURN
	END
C
	SUBROUTINE PS_CHECK_BUFFER(SIZE)
C
CDEC$	IDENT	'15MR94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	14-July-1993
C
C Check if EXPBUF nearly full and flush out
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
C
C arguments
	INTEGER		SIZE
C
	IF (EXPLEN.GT.SIZE) THEN
	   CALL FLWLIN
C
C n.b. LSLLIB bug - if %P0 at end of string then ignored
	   CALL EXPAND('%P0%^B')
	ENDIF
	RETURN
	END
C
	INTEGER FUNCTION PS_ROTB(B)
C
CDEC$	IDENT	'16MR94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	14-July-1993
C
C Rotate the bit of a byte
C
	IMPLICIT NONE
C
	INCLUDE		'PS.CMN'
C
C arguments
	BYTE	B
C
C workspace
	INTEGER	IB
	INTEGER	T(0:15)/0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15/
C
	IB = B
	IF (IMGINV) IB=IB.XOR.-1
C
	PS_ROTB = T(IB.AND.'0F'X) * 16 + T((IB.AND.'F0'X)/16)
C
	RETURN
	END
C
	SUBROUTINE PS_OUTPUT_BYTE_LITERAL(ARRAY,START,END)
C
CDEC$	IDENT	'22MR94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	14-July-1993
C
C Output literal string of bytes
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
C
C arguments
	BYTE		ARRAY(*)
	INTEGER		START,END
C
C workspace
	INTEGER		I
C
	CALL PS_CHECK_BUFFER(78)
	CALL APPEND('%X2',END-START+1+128)
	DO 10 I=START,END
	  CALL PS_CHECK_BUFFER(78)
	  CALL APPEND('%X2',ARRAY(I))
10	CONTINUE
	RETURN
	END
C
	SUBROUTINE PS_OUTPUT_BYTE_RUN(BYT,COUNT)
C
CDEC$	IDENT	'22MR94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	14-July-1993
C
C Output run-length of bytes
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
	INCLUDE		'PS.CMN'
C
C arguments
	BYTE		BYT
	INTEGER		COUNT
C
C workspace
	INTEGER		I
C
	CALL PS_CHECK_BUFFER(76)
	CALL APPEND('%X2%X2',COUNT,BYT)
	RETURN
	END
C
	SUBROUTINE PS_OUTPUT_BIT_LITERAL(ARRAY,START,END)
C
CDEC$	IDENT	'16MR94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	14-July-1993
C
C Output literal string of bytes
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
C
C arguments
	BYTE		ARRAY(*)
	INTEGER		START,END
C
C function
	INTEGER		PS_ROTB
C
C workspace
	INTEGER		COUNT
	INTEGER		I
C
	COUNT = END-START+1
C
	IF (COUNT.EQ.1) THEN
	  CALL PS_CHECK_BUFFER(76)
	  CALL APPEND('00%X2',PS_ROTB(ARRAY(START)))
	ELSE
	  CALL PS_CHECK_BUFFER(76)
	  CALL APPEND('80%X2',COUNT+128)
	  DO 10 I=START,END
	    CALL PS_CHECK_BUFFER(78)
	    CALL APPEND('%X2',PS_ROTB(ARRAY(I)))
10	  CONTINUE
	ENDIF
	RETURN
	END
C
	SUBROUTINE PS_OUTPUT_BIT_RUN(BYT,COUNT)
C
CDEC$	IDENT	'16MR94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	14-July-1993
C
C Output run-length of bytes
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
	INCLUDE		'PS.CMN'
C
C arguments
	BYTE		BYT
	INTEGER		COUNT
C
C function
	INTEGER		PS_ROTB
C
C workspace
	INTEGER		I
	INTEGER		C
C
	C = COUNT
C
	IF (BYT.EQ.0.OR.BYT.EQ.-1) THEN
C output run of all 0 or all 1
	  CALL PS_CHECK_BUFFER(78)
	  IF (BYT.NE.0 .XOR. IMGINV) C=C+128
	  CALL APPEND('%X2',C)
	ELSE
C output run of anything else
	  IF (COUNT.EQ.1) THEN
	    CALL PS_CHECK_BUFFER(76)
	    CALL APPEND('00%X2',PS_ROTB(BYT))
	  ELSE
	    CALL PS_CHECK_BUFFER(74)
	    CALL APPEND('80%X2%X2',COUNT,PS_ROTB(BYT))
	  ENDIF
	ENDIF
	RETURN
	END
