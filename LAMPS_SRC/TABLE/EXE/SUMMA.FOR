C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1986-04-11 17:59:48.000000000 +0100
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
C Example DECODE routine for Table Monitor.
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
C TABMON function to decode string from TDS table
C
C return TRUE if fail, FALSE if succeed
C
	BYTE		BUFF(18)
	INTEGER*2	BUFLEN
	INTEGER		BUT
	INTEGER		X
	INTEGER		Y
C
	LOGICAL		GETCRD
C
C format is 'sxxxxx,syyyyy,bb,0' where bb is 1-16
	DECODE = .TRUE.			! assume failure
	IF (BUFLEN.NE.18) GOTO 9999	! wrong length
	IF (GETCRD(X,BUFF(2),5)) GOTO 9999	! get x
	IF (GETCRD(Y,BUFF(9),5)) GOTO 9999	! get y
	IF (GETCRD(BUT,BUFF(15),2)) GOTO 9999	! get button
	BUT = BUT-1
C
9000	DECODE = .FALSE.		! success
C
9999	RETURN
	END
C
	LOGICAL FUNCTION GETCRD(C,BUFF,NUM)
	IMPLICIT NONE
	INTEGER	C
	BYTE	BUFF(5)
	INTEGER	NUM
C
	INTEGER	I
C
	GETCRD = .TRUE.
	C = 0
	DO 100 I = 1,NUM
	   IF (BUFF(I).LT.'0'.OR.BUFF(I).GT.'9') GOTO 9999
	   C = C*10 + BUFF(I) - 48
100	CONTINUE
	GETCRD = .FALSE.
9999	RETURN
	END
