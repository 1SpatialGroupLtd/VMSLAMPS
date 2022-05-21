C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1995-04-03 12:04:28.000000000 +0100
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
C Text functions
C ==============
C
C *********************************************************************
C
C	TEXT OUTPUT PRIMITIVE
C	=====================
C
C
	SUBROUTINE	GTX(PX,PY,STRING)
C
CDEC$	IDENT	'03AP95'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	24-Jul-1985
C
C TEXT
C
	IMPLICIT NONE
C
C Arguments:
C
	REAL	PX			! X coord
	REAL	PY			! Y coord
	CHARACTER*(*) STRING		! text
C
C Functions
	LOGICAL	GKCLIP
C
C Workspace
	REAL	DX,DY			! device coordinate
C
	INCLUDE	'GKSDAT1.CMN'
C
C	 is this workstation active? - if not ignore it
C
	IF (.NOT.WSACT) GOTO 200
C
C	 ensure that our transformation is up to date
C
	IF (UPTRN) CALL GUPTRN		! update it
C
C	 is everything clipped (ie nothing visible)
C
	IF (CLPALL) GOTO 200
C
	IF (ENCLIP) THEN
	   IF (GKCLIP(PX,PY,PX,PY)) GOTO 200
	ENDIF
	CALL GKSW2D(1,PX,PY,DX,DY)
C
C Make sure text attributes are up to date
	IF (UPTX) CALL GUPTX
C
	CALL PS_TEXT(DX,DY,STRING)
C
200	RETURN
	END
C
C
C***********************************************************************
C
	SUBROUTINE	GSTXCI(COLI)
C
CDEC$	IDENT	'26AP84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-April-1984
C
C SET TEXT COLOUR INDEX
C (Don't bother with aspect source flags for now)
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER	COLI			! text colour index
C
	INCLUDE	'GKSDAT1.CMN'
C
C workspace
	LOGICAL	FST
C
	IF (COLI.LT.0) THEN
	   CALL GKSERR(85,'GSTXCI')		! colour index .LT. 0
	ELSE
	   ITXCOL = COLI		! fill area colour index set
	   UPTX = .TRUE.		! attributes need updating
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE	GSCHXP(CHXP)
C
CDEC$	IDENT	'26AP84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-April-1984
C
C SET CHARACTER EXPANSION FACTOR
C (Don't bother with aspect source flags for now)
C
	IMPLICIT NONE
C
C Arguments:
	REAL	CHXP		! character expansion factor
C
	INCLUDE	'GKSDAT1.CMN'
C
	IF (CHXP.LE.0.0) THEN
	   CALL GKSERR(72,'GSCHXP')		! expansion factor .le.0
	ENDIF
C
C ignore for now
C
	RETURN
	END
C
	SUBROUTINE	GSCHSP(CHSP)
C
CDEC$	IDENT	'26AP84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-April-1984
C
C SET CHARACTER SPACING
C (Don't bother with aspect source flags for now)
C
	IMPLICIT NONE
C
C Arguments:
	REAL	CHSP		! character expansion factor
C
	INCLUDE	'GKSDAT1.CMN'
C
	RETURN
	END
C
	SUBROUTINE	GSCHH(HGT)
C
CDEC$	IDENT	'26AP84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-April-1984
C
C SET CHARACTER HEIGHT
C
	IMPLICIT NONE
C
C Arguments:
	REAL	HGT			! height (w.c.)
C
	INCLUDE	'GKSDAT1.CMN'
C
	REAL	HX
C
	IF (HGT.LE.0) THEN
	   CALL GKSERR(73,'GSCHH')		! character height .le.0
	ELSE
	   CALL GW2D(1,HGT,HGT,HX,ICHHGT)
	   UPTX = .TRUE.		! attributes need updating
	ENDIF
C
	RETURN
	END
C
	SUBROUTINE	GSCHUP(CUX,CUY)
C
CDEC$	IDENT	'26AP84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-April-1984
C
C SET CHARACTER UP VECTOR
C
	IMPLICIT NONE
C
C Arguments:
	REAL	CUX,CUY			! vector (w.c.)
C
	INCLUDE	'GKSDAT1.CMN'
C
	REAL	HX,HY
C
	CALL GW2D(1,CUX,CUY,HX,HY)
	IF (HX.EQ.0.0.AND.HY.EQ.0.0) THEN
	   CALL GKSERR(74,'GSCHUP')		! vector length is 0.0
	ELSE
	   ICHANG = ATAN2(-HX,HY)
	   UPTX = .TRUE.		! attributes need updating
	ENDIF
C
	RETURN
	END
C
C**********************************************************************
C
	SUBROUTINE	GSTXFP(FNT,PREC)
C
CDEC$	IDENT	'26AP84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-April-1984
C
C SET TEXT FONT & PRECISION
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
C
C Arguments:
	INTEGER	FNT,PREC
C
	IF (FNT.LE.0) THEN
	   CALL GKSERR(70,'GSTXFP')	! font .le. 0
	ELSE
	   ICHFNT = FNT
	   UPTX = .TRUE.		! attributes need updating
	ENDIF
	RETURN
	END
C
C***********************************************************************
C
	SUBROUTINE GUPTX
C
CDEC$	IDENT	'27NO84'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-April-1984
C
C Update the text attributes
C
	IMPLICIT NONE
C
C local variables
	INTEGER		NCOLI
	LOGICAL		FST
C
	INCLUDE	'GKSDAT1.CMN'
C
	NCOLI = ITXCOL
C
	IF (NCOLI.NE.0) THEN
	   FST = .FALSE.
10	   FST = .NOT.FST
	   IF (POFF.NE.0) NCOLI = ISHFT(NCOLI,POFF)! apply offset
	   NCOLI = NCOLI.AND.PSEL.AND.'FF'X	! apply mask
	   IF (NCOLI.GT.MAXCOL.OR.NCOLI.EQ.0) THEN
C
C First attempt, try again with colour 1, otherwise just use 1
	      NCOLI = 1
	      IF (FST) GOTO 10
	   ENDIF
	   IF (NCOLI.EQ.0) NCOLI = 1
	ENDIF
C
	IF (BEGIN_FEATURE .OR. NCOLI.NE.CACOLI .OR.
     &	    ICHHGT.NE.CCHHGT .OR. ICHANG.NE.CCHANG .OR.
     &	    ICHFNT.NE.CCHFNT) THEN
C
	   CALL PS_FLUSH(.FALSE.,.FALSE.)
C
	   IF (BEGIN_FEATURE) THEN
	      BEGIN_FEATURE = .FALSE.
	      FEATURE_BEGUN = .TRUE.
	      CALL PS_BEGIN_FEATURE
	   ENDIF
C
	   IF (NCOLI.NE.CACOLI) THEN
	      CACOLI = NCOLI
	      IF (CACOLI.NE.CCOLI) CCOLI = -1
	      UPLIN  = .TRUE.			! and polyline update
	      UPFA  = .TRUE.			! and fill area update
	      CALL PS_SETCOL(CACOLI,.TRUE.)
	   ENDIF
C
	   IF (ICHHGT.NE.CCHHGT .OR. ICHANG.NE.CCHANG .OR.
     &	       ICHFNT.NE.CCHFNT) THEN
	      CCHHGT = ICHHGT
	      CCHANG = ICHANG
	      CCHFNT = ICHFNT
	      CALL PS_SETTXT(CCHHGT,CCHANG,CCHFNT)
	   ENDIF
C
	ENDIF
C
	UPTX = .FALSE.		! polyline now up to date
	RETURN
	END
C
C**********************************************************************
C
	LOGICAL FUNCTION LSG_STRING_WIDTH(STRING,FONT,WIDTH)
C
CDEC$	IDENT	'22MR94'
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
	INCLUDE		'GKSDAT1.CMN'
C
C Arguments:
	CHARACTER*(*)	STRING
	INTEGER		FONT
	REAL		WIDTH
C
C functions
	LOGICAL		PS_STRING_WIDTH
C
	LSG_STRING_WIDTH = .TRUE.
C
	IF (FONT.LE.0) THEN
	   CALL GKSERR(70,'LSG_STRING_WIDTH')	! font .le. 0
	   GOTO 999
	ENDIF
C
	IF (.NOT.WSACT) GOTO 999 		! not open
C
	LSG_STRING_WIDTH = PS_STRING_WIDTH(STRING,FONT,WIDTH)
C
999	RETURN
	END
C
C**********************************************************************
C
	LOGICAL FUNCTION LSG_STRING_BOUNDS(STRING,FONT,BORDER,ROUTINE)
C
CDEC$	IDENT	'31AU94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-August-1994
C
C Call the callback ROUTINE for each character in the string, passing
C the width and bounding box of the character.
C It is used to build up a region around the string.
C Returns .TRUE. if unable to return the information
C
	IMPLICIT NONE
C
	INCLUDE		'GKSDAT1.CMN'
C
C Arguments:
	CHARACTER*(*)	STRING
	INTEGER		FONT
	REAL		BORDER
	EXTERNAL	ROUTINE
C
C functions
	LOGICAL		PS_STRING_BOUNDS
C
	LSG_STRING_BOUNDS = .TRUE.
C
	IF (FONT.LE.0) THEN
	   CALL GKSERR(70,'LSG_STRING_BOUNDS')	! font .le. 0
	   GOTO 999
	ENDIF
C
	IF (.NOT.WSACT) GOTO 999 		! not open
C
	LSG_STRING_BOUNDS = PS_STRING_BOUNDS(STRING,FONT,BORDER,ROUTINE)
C
999	RETURN
	END
