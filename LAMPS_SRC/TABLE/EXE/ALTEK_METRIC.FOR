C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-03-02 15:59:22.000000000 +0000
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
	LOGICAL FUNCTION DECODE(BUFF,BUFLEN,BUT,X,Y)CC Copyright Laser Scan Laboratories Ltd., Cambridge, England.C Author	Clarke Brunt,	November 1985C Amended by	Tony J Ibbs,	November 1986C Amended by    Mike Bisset & Ron Streeter 25 Feb 1988C	IMPLICIT NONECC function to decode a digitising table stringC - returns TRUE if it fails, FALSE if it succeedsCC	 * * * * * * * * * * * * * * * * * * * * * * * * *C	 * * *   T E M P L A T E     v e r s i o n   * * *C	 * * * * * * * * * * * * * * * * * * * * * * * * *CC argumentsC	BYTE		BUFF(*)		! byte string to decode	INTEGER*2	BUFLEN		! length of byte string	INTEGER		BUT		! button number pressed	INTEGER		X		! x coordinate	INTEGER		Y		! y coordinateCC ----------------------------------------------------------------------C Example DECODE routine for use by programs to interpret digitisingC table input. It must be linked as a shareable image with universalC symbol DECODE, so that the program can pull it in at run-time.C e.g.C	$ FORTRAN DECODEC	$ LINK/SHARE DECODE,SYS$INPUT:/OPTC	UNIVERSAL=DECODEC      	$ ...CC The command file DECODE.COM in the same directory as the example willC perform this task for you.CC			 Use by programsC			 ---------------C In order to be used by a program, a logical name in either the groupC or system tables must be defined to point to the sharable image. TheC following programs currently use this facility:CC - Table MonitorC   Logical names LSL$TABMON_ROUTINEC	       or LSL$TABMON_ROUTINE_<terminal> (for a named monitor)CC - LITES2C   Logical name LSL$TABMON_ROUTINE_<terminal>CC - DIGSYSC   Logical name LSL$DIGSYS_DECODE<n>C   (where <n> is the same number used in the table name LSL$DIG<n>)CC ----------------------------------------------------------------------C - this version for Altek metric 0.01mmC	LOGICAL		GETCRD		! function to read a numberCC format is '$b,sxxxxxx,syyyyyy' where b is 0-9,A-F,HC	DECODE = .TRUE.			! assume failureC	IF (BUFLEN.NE.18) GOTO 9999	! wrong length	IF (BUFF(4).NE.'+'.OR.BUFF(12).NE.'+') GOTO 9999	IF (GETCRD(X,BUFF(5))) GOTO 9999	! get x	IF (GETCRD(Y,BUFF(13))) GOTO 9999	! get yC	IF (.NOT.((BUFF(2).GE.'0'.AND.BUFF(2).LE.'9').OR.     &            (BUFF(2).GE.'A'.AND.BUFF(2).LE.'F').OR.     &            (BUFF(2).EQ.'H'                   )) ) GOTO 9999 	BUT = BUFF(2)-'0'	IF (BUT.GT.9) BUT = BUT-7C9000	DECODE = .FALSE.		! successC9999	RETURN	ENDC ----------------------------------------------------------------------	LOGICAL FUNCTION GETCRD(C,BUFF)C	IMPLICIT NONEC	INTEGER	C	BYTE	BUFF(6)C	INTEGER	IC	GETCRD = .TRUE.	C = 0	DO 100 I = 1,6	   IF (BUFF(I).LT.'0'.OR.BUFF(I).GT.'9') GOTO 9999	   C = C*10 + BUFF(I) - 48100	CONTINUE	GETCRD = .FALSE.9999	RETURN	END