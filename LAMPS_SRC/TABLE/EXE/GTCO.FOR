C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-05-24 10:49:54.000000000 +0100
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
 	LOGICAL FUNCTION DECODE(BUFF,BUFLEN,BUT,X,Y)
C
C Copyright Laser Scan Laboratories Ltd., Cambridge, England.
C Author	Clarke Brunt,	November 1985
C Amended by	Tony J Ibbs,	November 1986
C optional LF	Ron Russell	24-May-1988
C
	IMPLICIT NONE
C
C function to decode a digitising table string
C - returns TRUE if it fails, FALSE if it succeeds
C
C	 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
C	 * *  G T C O    v e r s i o n  (with optional linefeed) * * *
C	 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
C
C NOTE that:
C
C	1) optional CR (carriage-return) is required
C	2) optional LF (lin-feed) may or may not be disabled
C
C arguments
C
	BYTE		BUFF(*)		! byte string to decode
	INTEGER*2	BUFLEN		! length of byte string
	INTEGER		BUT		! button number pressed
	INTEGER		X		! x coordinate
	INTEGER		Y		! y coordinate
C
C ----------------------------------------------------------------------
C Example DECODE routine for use by programs to interpret digitising
C table input. It must be linked as a shareable image with universal
C symbol DECODE, so that the program can pull it in at run-time.
C e.g.
C	$ FORTRAN DECODE
C	$ LINK/SHARE DECODE,SYS$INPUT:/OPT
C	UNIVERSAL=DECODE
C	<CTRL/Z>
C      	$ ...
C
C			 Use by programs
C			 ---------------
C In order to be used by a program, a logical name in either the group
C or system tables must be defined to point to the sharable image. The
C following programs currently use this facility:
C
C - Table Monitor
C   Logical names LSL$TABMON_ROUTINE
C	       or LSL$TABMON_ROUTINE_<terminal> (for a named monitor)
C
C - LITES2
C   Logical name LSL$TABMON_ROUTINE_<terminal>
C
C - DIGSYS
C   Logical name LSL$DIGSYS_DECODE<n>
C   (where <n> is the same number used in the table name LSL$DIG<n>)
C
C ----------------------------------------------------------------------
C
	BYTE		TBUT		! temporary - button character
	LOGICAL		GETCRD		! function to read a number
	INTEGER		OFF
C
C The GTCO format is 'Fxxxxx yyyyy' terminated by <CR>, which last
C we don't see as it's our terminator...
C
	DECODE = .TRUE.			! assume failure
C
C
C check for line feed
	IF (BUFLEN.EQ.13.AND.BUFF(1).EQ.10) THEN
	   OFF = 1
	ELSE
	   OFF = 0
	ENDIF
C
	IF (BUFLEN-OFF.NE.12) GOTO 9999		! wrong length
C
	IF (BUFF(7+OFF).NE.' ') GOTO 9999	! bad separator
C
C work out the button number - the button 'digit' is one of the
C characters
C		0 1 2 3 4 5 6 7 8 9 : ; < = > ?
C
C which just happen to be the sixteen ASCII characters that start
C at '0' and run through. Thus the following gives us the decimal
C value of the button...
C
	TBUT = BUFF(1+OFF)
	IF (TBUT.GE.'0' .OR. TBUT.LE.'?') THEN
	   BUT = TBUT-'0'
	ELSE
	   GOTO 9999			! bad button digit
	ENDIF
C
	IF (GETCRD(X,BUFF(2+OFF))) GOTO 9999	! get x
	IF (GETCRD(Y,BUFF(8+OFF))) GOTO 9999	! get y
C
9000	DECODE = .FALSE.		! success
9999	RETURN
	END
C ----------------------------------------------------------------------
	LOGICAL FUNCTION GETCRD(C,BUFF)
C
	IMPLICIT NONE
C
	INTEGER	SIZE
	PARAMETER (SIZE=5)
C
	INTEGER	C
 	BYTE	BUFF(SIZE)
C
	INTEGER	I
C
	GETCRD = .TRUE.
	C = 0
	DO 100 I = 1,SIZE
	   IF (BUFF(I).LT.'0'.OR.BUFF(I).GT.'9') GOTO 9999
	   C = C*10 + BUFF(I) - 48
100	CONTINUE
	GETCRD = .FALSE.
9999	RETURN
	END
                         
