C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-05-18 09:16:18.000000000 +0100
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
C **************************************************************************
C Test prog for DSR_VIAK shared image which to allows a stereplotter
C to act as a 3D input device for LITES2.
C SSPI version for VIAK in Sweden			PGH	11-May-1990
C **************************************************************************
C
C
	PROGRAM SSPI_TEST
C
CDEC$	IDENT	'18MY90'
C
C common
	INCLUDE	'DSR_SSPI_CMN.CMN'
C
C workspace
	BYTE		BUFF		! buffer
	INTEGER*2	IOSB(4)		! I/O status block
	INTEGER*4	EFN		! event flag
	REAL*8		X,Y,Z		! coords
	INTEGER*4	BUTTON		! button number
	INTEGER*4	IERR		! error code
	LOGICAL		OK		! error flag
	BYTE		CH		! a character
C
C functions
	INTEGER		DSR_TRN
	LOGICAL		DSR_INIT
	LOGICAL		DSR_START
C
C simple tests on DSR 
	OK=DSR_INIT()
	IF (.NOT.OK) THEN
	   TYPE *,'!!!  DSR_INIT failed'
	   GOTO 999
	ENDIF
	TYPE *,'DSR_INIT successful'
	EFN = 3
100	OK = DSR_START(3,IOSB,,BUFF)
	IF (.NOT.OK) THEN
	   TYPE *,'!!!  DSR_START failed'
	   GOTO 999
	ENDIF
	TYPE *,'DSR_START successful'
	TYPE *,'Awaiting input of X,Y,Z,N'
200	CALL LIB$WAIT(1.0)
	IF (IOSB(1).EQ.0) GOTO 200
	TYPE *,'Number of characters read is ',IOSB(2)
	IF (IOSB(2).EQ.0) GOTO 100
	TYPE *,'String is "',SSPILINE(1:IOSB(2)),'"'
	BUTTON = DSR_TRN(CH)
	CALL DSR_READ(X,Y,Z)
	TYPE *,'X,Y,Z  =',X,Y,Z
	TYPE *,'Button =',BUTTON
	CALL DSR_MOVE(X,Y,Z,.TRUE.)
	IF (BUTTON.GE.0) GOTO 100
C
999	CALL EXIT
	END
C
