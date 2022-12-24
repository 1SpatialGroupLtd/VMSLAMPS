C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-08-30 10:06:30.000000000 +0100
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
C
	IMPLICIT NONE
C
C DECODE routine for Table Monitor and Calcomp 9100 table
C Must be linked as a shareable image with universal symbol DECODE.
C e.g.
C	$ FORTRAN DECODE
C	$ LINK/SHARE DECODE,SYS$INPUT:/OPT
C	UNIVERSAL=DECODE
C	$ ...
C It will be used by the Table Monitor if logical name
C LSL$TABMON_ROUTINE or LSL$TABMON_ROUTINE_terminal (for a named
C monitor) in group or system table points to the shareable image.
C
C Decode string from Calcomp 9100 table using preset format 2
C
C return TRUE if fail, FALSE if succeed
C
	BYTE		BUFF(*)
	INTEGER*2	BUFLEN
	INTEGER		BUT
	INTEGER		X
	INTEGER		Y
C
	LOGICAL		GETCRD
C
C format is 'xxxxx,yyyyy,zzb' where b is 0-F
C the z's are tablet and mode status :-
C					tablet should always be A
C 					mode should be P for point
C NB the co-ords may contain leading spaces
C
	DECODE = .TRUE.			! assume failure
C
	IF (BUFLEN.NE.15) GOTO 9999	! wrong length
	IF (GETCRD(X,BUFF(1),5)) GOTO 9999	! get x
	IF (GETCRD(Y,BUFF(7),5)) GOTO 9999	! get y
	IF (BUFF(15).GE.'0'.AND.BUFF(15).LE.'9')THEN
	   BUT=BUFF(15)-48
	ELSE IF (BUFF(15).GE.'A'.AND.BUFF(15).LE.'F')THEN
	   BUT=(BUFF(15)-64)+9			! A=65 => BUT=10 etc
	ELSE
	   GOTO 9999				! invalid button
	ENDIF
C
9000	DECODE = .FALSE.		! success
C
9999	RETURN
	END
C
	LOGICAL FUNCTION GETCRD(C,BUFF,NUM)
	IMPLICIT NONE
	INTEGER	C
	INTEGER	NUM
	BYTE	BUFF(NUM)
C
	INTEGER	I,J
C
	GETCRD = .TRUE.
	C = 0
	DO 100 I = 1,NUM
	   J=BUFF(I)
	   IF(J.EQ.32)J=48			! change space to 0
	   IF (J.LT.48.OR.J.GT.57) GOTO 9999
	   C = C*10 + J - 48
100	CONTINUE
	GETCRD = .FALSE.
9999	RETURN
	END
