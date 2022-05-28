C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1988-04-14 13:44:32.000000000 +0100
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
	BYTE		DOLLAR,COMMA
	PARAMETER	(DOLLAR = '$')
	PARAMETER	(COMMA  = ',')
C
C function
	LOGICAL		GETCRD
C
C this is an example for the ALTEK table format
C format is '$L,xxxxx,yyyyy, where L can be 0-F or H (when table
C is probed)
C
	DECODE = .TRUE.			! assume failure
	IF (BUFLEN.NE.14) GOTO 9999	! wrong length
	IF (BUFF(1).NE.DOLLAR.OR.
     &	    BUFF(3).NE.COMMA .OR.
     &	    BUFF(9).NE.COMMA) GOTO 9999
	IF (GETCRD(X,BUFF(4),5)) GOTO 9999	! get x
	IF (GETCRD(Y,BUFF(10),5)) GOTO 9999	! get y
C
C If these units are not 0.02mm, then they should be scaled.
C eg. if the table produces coordinates in 0.001mm then the following
C lines should be uncommented
C
CCCC	X = X * 0.05
CCCC	Y = Y * 0.05
C
	IF (BUFF(2).GE.'0'.AND.BUFF(2).LE.'9') THEN
	   BUT = BUFF(2) - 48		! a numeral
	ELSE
	   BUT = BUFF(2) - 55		! a letter
	ENDIF
C
C check value of button (note H is returned when table is interrogated)
	IF ((BUT.LT.0.OR.BUT.GT.'F'X).AND.BUT.NE.17) GOTO 9999
C
9000	DECODE = .FALSE.		! success
C
9999	RETURN
	END
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
