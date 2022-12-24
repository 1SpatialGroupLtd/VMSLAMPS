C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-09 15:38:32.000000000 +0100
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
	INTEGER	FUNCTION PROCESS_PLOT
C
CDEC$	IDENT	'09SE94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	13-January-1994
C
C Process the plot data, translating as required
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
	INCLUDE		'LSL$CMNLSL:TXTC.CMN'
	INCLUDE		'PSEXPORTMSG.PAR'
	INCLUDE		'PSEXPORT.CMN'
C
C Functions
	INTEGER		FLRLIN
	LOGICAL		RDLONG
	LOGICAL		RDREAL
	LOGICAL		RDCHS,RDCH
	LOGICAL		ALPNUM
	INTEGER		COUNT_CHAR
C
C workspace
	INTEGER		OK
	INTEGER		I,N
	CHARACTER*(MAX_TXTLIM)	TXTSTR
	EQUIVALENCE	(TXTBUF,TXTSTR)
	REAL		C(4)
	BYTE		CH
	REAL		SIZE,ANG,X,Y,CA,SA
	CHARACTER*4	OPER
	INTEGER		COUNT
	RECORD	/DDSC/	TEXT
	LOGICAL		WAS_LINE,LAST_LINE
	REAL		TO_RAD
	PARAMETER	(TO_RAD=3.14159265/180.0)
C
	WAS_LINE = .FALSE.
C
10	LAST_LINE = WAS_LINE
	WAS_LINE = .FALSE.
	OK = FLRLIN()
	IF (.NOT.OK) GOTO 999
C
	IF (TXTPTR.GE.9 .AND.
     &	    TXTSTR(:9).EQ.'%%Trailer') GOTO 999
	IF (TXTPTR.GE.6 .AND.
     &	    TXTSTR(:6).EQ.'%%Page') THEN
	   CALL LSL_PUTMSG(PSEXP__MULTPAGES)
	   GOTO 999
	ENDIF
	IF (TXTPTR.EQ.0) GOTO 10
C
C find alphanumeric operator at end of line
	IF (TXTSTR(TXTPTR:TXTPTR).EQ.'\') THEN	! string continuation
C
C check for first part of string (beginning with '(')
	   CALL BSLN
	   CALL RDCHS(CH)
	   IF (CH.EQ.'(') THEN
	      CALL STR$FREE1_DX(TEXT)
	   ELSE
	      CALL BSLN		! no (, so must be a continuation
	   ENDIF
	   IF (DCPTR.LT.TXTPTR) CALL STR$APPEND(TEXT,TXTSTR(DCPTR:TXTPTR-1))
	   GOTO 10
	ELSE
C
	   I = TXTPTR
20	   IF (ALPNUM(TXTSTR(I:I))) THEN
	      I = I-1
	      IF (I.GT.0) GOTO 20
	   ENDIF
	   IF (I.EQ.TXTPTR) GOTO 800		! eh?
	   OPER = TXTSTR(I+1:)
C
C check for restore and showpage (skip)
	   IF (OPER.EQ.'rest'.OR.OPER.EQ.'show') GOTO 10
C
C check for illegal arcs (just skip)
	   IF (OPER.EQ.'AA'.OR.OPER.EQ.'AC') THEN
	      CALL LSL_PUTMSG(PSEXP__ILLEGALARC)
	      GOTO 10
	   ENDIF
C
C check for illegal images (terminate)
	   IF (OPER(:2).EQ.'IM') THEN
	      OK = PSEXP__ILLEGALIMAGE
	      CALL LSL_PUTMSG(OK)
	      GOTO 1000
	   ENDIF
C
C check for operators which need modifying
	   IF (OPER.EQ.'k'.OR.OPER.EQ.'K') THEN		! colour
	      CALL BSLN
	      IF (RDLONG(N)) GOTO 800		! colour number
	      IF (N.LT.0.OR.N.GE.MAXCOL) GOTO 800
	      IF (MAX(COLTAB(1,N),COLTAB(2,N),COLTAB(3,N))
     &				.LT.0.001) THEN
	         CALL EXPAND('%F0.3 ',1.0-COLTAB(4,N))
	         IF (OPER.EQ.'k') THEN
	            CALL FLWAPP('g')
	         ELSE
	            CALL FLWAPP('G')
	         ENDIF
	      ELSE
	         CALL FLWRTF('%F0.3 %F0.3 %F0.3 %F0.3 %S',
     &			COLTAB(1,N),COLTAB(2,N),COLTAB(3,N),COLTAB(4,N),
     &			OPER(1:1))
	      ENDIF
	      GOTO 10
	   ELSEIF (OPER.EQ.'z') THEN			! font
	      CALL BSLN
	      IF (RDREAL(SIZE)) GOTO 800
	      IF (RDCHS(CH)) GOTO 800
	      IF (CH.NE.'/') GOTO 800
	      IF (RDCH(CH)) GOTO 800
	      IF (CH.NE.'F') GOTO 800
	      IF (RDLONG(N)) GOTO 800		! font number
C
C look up font in our list
	      DO 200 I=1,NFONT
	         IF (FNTTAB(I).NUMBER.EQ.N) GOTO 210
200	      CONTINUE
C
	      CALL EXPAND('/Courier ')
	      CALL PS_APP(SIZE)
	      CALL FLWAPP('0 0 0 z')
	      GOTO 10
C
210	      CALL EXPAND('/%S ',FNTTAB(I).NAME)
	      CALL PS_APP(SIZE*FNTTAB(I).SCALE)
	      CALL FLWAPP('0 0 0 z')
	      GOTO 10
	   ELSEIF (OPER.EQ.'e') THEN			! text position
	      CALL BSLN
	      IF (RDREAL(ANG)) GOTO 800
	      IF (RDREAL(X)) GOTO 800
	      IF (RDREAL(Y)) GOTO 800
	      CALL EXPAND('[')
	      ANG = ANG*TO_RAD
	      CA = COS(ANG)
	      SA = SIN(ANG)
	      CALL PS_APP(CA)
	      CALL PS_APP(SA)
	      CALL PS_APP(-SA)
	      CALL PS_APP(CA)
	      CALL PS_APP(X)
	      CALL PS_APP(Y)
	      EXPLEN = EXPLEN-1		! knock off space
	      CALL FLWAPP(']e',)
	      GOTO 10
	   ELSEIF (OPER.EQ.'t') THEN			! text
C
C check for first part of string (beginning with '(')
	      CALL BSLN
	      CALL RDCHS(CH)
	      IF (CH.EQ.'(') THEN
	         CALL STR$FREE1_DX(TEXT)
	      ELSE
	         CALL BSLN		! no (, so must be a continuation
	      ENDIF
C
C now find the closing ')'
220	      IF (I.LE.0) GOTO 10	! eh?
	      IF (TXTSTR(I:I).EQ.' ') THEN
	         I = I-1
	         GOTO 220
	      ENDIF
	      IF (TXTSTR(I:I).NE.')') GOTO 10	! eh?
	      IF (DCPTR.LT.I) CALL STR$APPEND(TEXT,TXTSTR(DCPTR:I-1))
C
C now output the string - first count the chars if needed
	      IF (TEXT.DSC_LEN.EQ.0) GOTO 10
	      COUNT = COUNT_CHAR(TEXT)
C
C n.b. LSLLIB bug - if %P0 at end of string then ignored
	      CALL EXPAND('%N(%P0% ',COUNT)	! use zero pad char
	      CALL WRITE_STRING(TEXT)
	      GOTO 10
	   ELSEIF (OPER.EQ.'l'.OR.OPER.EQ.'c') THEN
	      WAS_LINE = .TRUE.			! line or curve
	   ELSEIF (OPER.EQ.'m') THEN
C
C AI doesn't allow move in the middle of a path, if just had a line,
C then stroke it out
	      IF (LAST_LINE) CALL FLWSTR('S')
	   ENDIF
C
C assume anything else is legal, and pass it through
C
	ENDIF
C
C pass line through to output
800	CALL FLWSTR(TXTDSC)
	GOTO 10
C
999	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(PSEXP__NOTRAILER)
	   CALL LSL_ADDMSG(OK)
	ENDIF
1000	PROCESS_PLOT = OK
	RETURN
	END
C
	LOGICAL FUNCTION ALPNUM(C)
C
CDEC$	IDENT	'13JA94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	13-January-1994
C
C Determine if character is alphanumeric
C
	IMPLICIT NONE
C
C argument
	CHARACTER*1	C
C
	ALPNUM = .FALSE.
	IF (C.GE.'A'.AND.C.LE.'Z' .OR.
     &	    C.GE.'a'.AND.C.LE.'z' .OR.
     &	    C.GE.'0'.AND.C.LE.'9' ) ALPNUM = .TRUE.
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
	INCLUDE		'PSEXPORT.CMN'
C
C Arguments
	REAL		X	! position in DC (metres)
C
C avoid LSLLIB E format with positive exponent, since it includes a
C space which Postscript will not understand
C NB AI does not understand E format AT ALL!
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
	INTEGER FUNCTION COUNT_CHAR(S)
C
CDEC$	IDENT	'14JA94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	14-January-1994
C
C Count number of characters in a PostScript string
C
	IMPLICIT NONE
C
C argument
	CHARACTER*(*)	S
C
C workspace
	INTEGER		I
C
	COUNT_CHAR = 0
	I = 0
10	IF (I.GE.LEN(S)) GOTO 999
	I = I+1
	IF (S(I:I).EQ.'\') THEN
	   IF (I.GE.LEN(S)) GOTO 999
	   I = I+1
	   IF (S(I:I).GE.'0'.AND.S(I:I).LE.'9') I = I+2	! 3 octal digits
	ENDIF
	COUNT_CHAR = COUNT_CHAR+1
	GOTO 10
C
999	RETURN
	END
C
	SUBROUTINE WRITE_STRING(S)
C
CDEC$	IDENT	'14JA94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	14-January-1994
C
C Write out PS string, splitting lines if required
C
	IMPLICIT NONE
C
	INCLUDE		'LSL$CMNLSL:EXPC.CMN'
C
C argument
	CHARACTER*(*)	S
C
C workspace
	CHARACTER*1	C
	INTEGER		L
	INTEGER		I
C
	L = LEN(S)
	I = 0
10	IF (I.GE.LEN(S)) GOTO 999
	I = I+1
	IF (EXPLEN.GT.60) THEN
	   CALL FLWAPP('\')	! continuation character
C
C n.b. LSLLIB bug - if %P0 at end of string then ignored
	   CALL EXPAND('%P0% ')! use zero pad char
	ENDIF
	C = S(I:I)
	IF (C.EQ.'\') THEN
	   CALL APPEND('\')
	   IF (I.GE.LEN(S)) GOTO 999
	   I = I+1
	   C = S(I:I)
	   IF (C.GE.'0'.AND.C.LE.'9') THEN
	      CALL APPEND('%S',S(I:MIN(I+2,L)))	! 3 octal digits
	      I = I+2
	   ELSE
	      CALL APPEND(C)
	   ENDIF
	ELSEIF (C.EQ.'%') THEN
	   CALL APPEND('%%')
	ELSE
	   CALL APPEND(C)
	ENDIF
	GOTO 10
C
999	CALL FLWAPP(')t T')
	RETURN
	END
