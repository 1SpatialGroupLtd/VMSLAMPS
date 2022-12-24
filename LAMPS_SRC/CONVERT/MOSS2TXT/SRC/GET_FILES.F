C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-06-11 19:07:56.000000000 +0100
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
        INTEGER*4  FUNCTION GET_FILES()
C
CDEC$	IDENT	'22AP91'
C
C 	Copyright Laser-Scan Laboratories Ltd.,England
C
	IMPLICIT NONE
C
	INCLUDE 'PARAMS.PAR'
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'
	INCLUDE 'LSL$CMNLSL:MTOVCM.CMN'
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE 'COMMAND.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
C
C
C System parameters
	INCLUDE		'($DCDEF)/NOLIST'
	INCLUDE 	'($DVIDEF)/NOLIST'
	INCLUDE		'($MTDEF)/NOLIST'
	INCLUDE 	'($SSDEF)/NOLIST'
C
C Functions:
C
	INTEGER*4	IFFOPEN		! open IFF file for readonly
	INTEGER		LIB$GETDVI
	INTEGER		MTONIT		! init magtape
	INTEGER		MTOSPC		! space forward through magtape
	INTEGER		MTOEOV		! find end of volume
	INTEGER		MTORWD		! rewind magtape
	INTEGER		FLROPN		! open file for read
	INTEGER		FLWOPN		! open file for writing
C
C Workspace:
	INTEGER		VAL
	LOGICAL		START,EOF
	LOGICAL		NORWND
	INTEGER*4	IERR		! for error return	
	INTEGER*4	OK		! for error return	
C
C
C ......................................................................
C
	GET_FILES=SS$_NORMAL
C
C Open MOSS input file
C
	IF (.NOT.FLROPN(MOSSLUN,P1_FIL(1:P1_LEN),,)) GOTO 20
	CALL WRITEF('Opened MOSS file %S for read',
     &	     P1_FIL(1:P1_LEN))
C
C Open TXT output file
C
	IF (.NOT.FLWOPN(TXTLUN,P2_FIL(1:P2_LEN),,)) GOTO 20
	CALL WRITEF('Opened TXT file %S for write',
     &	     P2_FIL(1:P2_LEN))
C
C Error opening GEN file for output
C
20	CALL ERRSNS(,IERR,OK)
	IF (OK.EQ.0) OK=IERR
	CALL LSL_ADDMSG(OK)
C
C ......................................................................
C
30	IF (GET_FILES) GET_FILES=SS$_NORMAL        ! normal completion?
	RETURN
	END

