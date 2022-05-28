C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-04-29 11:48:46.000000000 +0100
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
	BYTE		BUFF(19)	! the string to decode
	INTEGER*2	BUFLEN		! its length
	INTEGER		BUT		! the button number
	INTEGER		X,Y		! the coords
C
C function
	LOGICAL		GETCRD
C
C workspace
	REAL		CX,CY
	INTEGER		I
C
C this routine is for the MUTOH CX3000 table format
C format is 'sxxxxxxxxsyyyyyyyyF<CR>'
C Where F is 1,2,4,8, s is possibly '-', and the coordinates may
C have a decimal point
C
	DECODE = .TRUE.			! assume failure
	IF (BUFLEN.NE.19) GOTO 9999	! wrong length
C
C strip parity bit
C
	DO 10 I=1,19
	   BUFF(I)=(BUFF(I).AND.127)
10	CONTINUE
C
C decode the two coordinates
C
	IF (GETCRD(CX,BUFF(1),9)) GOTO 9999	! get x
	IF (GETCRD(CY,BUFF(10),9)) GOTO 9999	! get y
C
C If these units are not 0.02mm, then they should be scaled.
C Assume we have mm here (and convert to integer)
C
	X = CX * 50
	Y = CY * 50
C
	IF (BUFF(19).EQ.'1') THEN
	   BUT = 0
	ELSEIF (BUFF(19).EQ.'2') THEN
	   BUT = 1
	ELSEIF (BUFF(19).EQ.'4') THEN
	   BUT = 2
	ELSEIF (BUFF(19).EQ.'8') THEN
	   BUT = 3
	ELSE
	   GOTO 9999
	ENDIF
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
	REAL	C
	BYTE	BUFF(9)
	INTEGER	NUM
C
	INTEGER	I,DP,IC
C
	GETCRD = .TRUE.
	IC = 0
	DP = 0
	DO 100 I = 2,NUM
	   IF (BUFF(I).EQ.'.') THEN
	      DP = I
	   ELSE
	      IF (BUFF(I).LT.'0'.OR.BUFF(I).GT.'9') GOTO 9999
	      IC = IC*10 + BUFF(I) - 48
	   ENDIF
100	CONTINUE
	C = IC
	IF (DP.NE.0) C = C/10**(NUM-DP)
	IF (BUFF(1).EQ.'-') C = -C
	GETCRD = .FALSE.
9999	RETURN
	END
