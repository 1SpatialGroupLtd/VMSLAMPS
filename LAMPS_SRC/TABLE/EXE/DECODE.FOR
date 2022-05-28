C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1986-11-20 19:23:30.000000000 +0000
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
C
	IMPLICIT NONE
C
C function to decode a digitising table string
C - returns TRUE if it fails, FALSE if it succeeds
C
C	 * * * * * * * * * * * * * * * * * * * * * * * * *
C	 * * *   T E M P L A T E     v e r s i o n   * * *
C	 * * * * * * * * * * * * * * * * * * * * * * * * *
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
C      	$ ...
C
C The command file DECODE.COM in the same directory as the example will
C perform this task for you.
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
C - Insert your own code here - following is an example for a TDS table
C
	LOGICAL		GETCRD		! function to read a number
C
C format is 'sxxxxxxx,syyyyyyy,bb,0' where b is 1,2,4,8
C
	DECODE = .TRUE.			! assume failure
C
	IF (BUFLEN.NE.22) GOTO 9999	! wrong length
	IF (GETCRD(X,BUFF(2))) GOTO 9999	! get x
	IF (GETCRD(Y,BUFF(11))) GOTO 9999	! get y
C
	GOTO (100,200,9999,400,9999,9999,9999,800), BUFF(20)-48
	GOTO 9999
C
100	BUT = 0
	GOTO 9000
C
200	BUT = 1
	GOTO 9000
C
400	BUT = 2
	GOTO 9000
C
800	BUT = 3
9000	DECODE = .FALSE.		! success
C
9999	RETURN
	END
C ----------------------------------------------------------------------
	LOGICAL FUNCTION GETCRD(C,BUFF)
C
	IMPLICIT NONE
C
	INTEGER	C
	BYTE	BUFF(7)
C
	INTEGER	I
C
	GETCRD = .TRUE.
	C = 0
	DO 100 I = 1,7
	   IF (BUFF(I).LT.'0'.OR.BUFF(I).GT.'9') GOTO 9999
	   C = C*10 + BUFF(I) - 48
100	CONTINUE
	GETCRD = .FALSE.
9999	RETURN
	END
