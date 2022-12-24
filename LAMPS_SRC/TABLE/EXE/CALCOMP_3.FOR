C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-10-25 11:08:08.000000000 +0000
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
C Calcomp version for Decca Hydro		RJH	21-Apr-1988
C
	IMPLICIT NONE
C
C Must be linked as a shareable image with universal symbol DECODE.
C e.g.
C	$ FORTRAN DECODE
C	$ LINK/SHARE DECODE,SYS$INPUT:/OPT
C	UNIVERSAL=DECODE
C	$ ...
C
C To probe the table directly, a prompt string is required. By default
C the string 'V' is used (the prompt for an ALTEK 40 controller)
C
C if another prompt string is required then a second entry point 
C GET_TABLE_PROMPT should be used. This must also be a universal symbol
C in the shared image, and the link instruction should be:
C
C	$ LINK/SHARE DECODE,SYS$INPUT:/OPT
C	UNIVERSAL=DECODE,GET_TABLE_PROMPT
C	$ ...
C
C The command file DECODE.COM in the same directory as the example will
C perform this task for you.
C
C ----------------------------------------------------------------------
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
C Laserscan programs expect tables to measure in units of 0.02mm.
C LITES2 can accept table output in other units (with the SETUP
C TABLE_COUNT command). If this routine is to be used by other programs
C then the coordinates should be scaled to units on 0.02mm
C ----------------------------------------------------------------------
C
C return TRUE if fail, FALSE if succeed
C
	BYTE		BUFF(14)
	INTEGER*2	BUFLEN
	INTEGER		BUT
	INTEGER		X
	INTEGER		Y
C
C function
C
	LOGICAL		GETCRD
C
C format is 'CPxxxxxxyyyyyy', where C can be '0'-'F' for the button 
C number, and P can be 'D' when a button is depressed, or 'U' when 
C button is up
C
	DECODE = .TRUE.			! assume failure
	IF (BUFLEN.NE.14) GOTO 9999	! wrong length
	IF (GETCRD(X,BUFF(3),6)) GOTO 9999	! get x
	IF (GETCRD(Y,BUFF(9),6)) GOTO 9999	! get y
C
C the table produces coordinates in 0.01mm, so the units should be 
C scaled to 0.02mm.
C
	X = X * 0.5
	Y = Y * 0.5
C
C get the button number
C
	IF (BUFF(1).GE.'0'.AND.BUFF(1).LE.'9') THEN
	   BUT = BUFF(1) - 48		! a numeral
	ELSE
	   BUT = BUFF(1) - 55		! a letter
	ENDIF
C
C check value of button if it was depressed
C
	IF ((BUT.LT.0.OR.BUT.GT.'F'X).AND.BUFF(2).EQ.'D') GOTO 9999
C
9000	DECODE = .FALSE.		! success
C
9999	RETURN
	END
C
C
C and another subroutine that defines the prompt string, and length to
C be used when interrogating the table position
C
	SUBROUTINE GET_TABLE_PROMPT(PBUF,PBUFMAX,PBUFL)
C
	IMPLICIT NONE
C
	INTEGER		PBUFMAX		! maximum length of buffer
	BYTE		PBUF(PBUFMAX)
	INTEGER*4	PBUFL
C
	PBUF(1) = 'V'
	PBUFL    = 1
C
	RETURN
	END
C
C
	LOGICAL FUNCTION GETCRD(C,BUFF,NUM)
C
	IMPLICIT NONE
C
	INTEGER	C
	BYTE	BUFF(6)
	INTEGER	NUM
C
	BYTE		SPACE
	PARAMETER	(SPACE = ' ')
C
	INTEGER	I
C
	GETCRD = .TRUE.
	C = 0
	DO 100 I = 1,NUM
	   IF (BUFF(I).EQ.SPACE) THEN
	      C = C*10
	   ELSEIF (BUFF(I).LT.'0'.OR.BUFF(I).GT.'9') THEN
	      GOTO 9999
	   ELSE
	      C = C*10 + BUFF(I) - 48
	   ENDIF
100	CONTINUE
	GETCRD = .FALSE.
9999	RETURN
	END
