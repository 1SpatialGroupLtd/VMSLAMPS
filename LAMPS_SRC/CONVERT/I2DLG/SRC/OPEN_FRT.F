C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-10-06 15:17:44.000000000 +0100
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
        INTEGER*4  FUNCTION OPEN_FRT()
C
CDEC$	IDENT	'06OC89'
C
C 	Copyright Laser-Scan Ltd., Cambridge, England
C
C	Created.				FJB  25-Aug-1989
C
C Get input FRT file and open on lun FRTLUN.
C
	IMPLICIT NONE
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:I2DLGMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR'
C
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
	INCLUDE 'LSL$CMNI2DLG:COMMAND.CMN'
C
C
C System parameters
C
 	INTEGER*4	SS$_NORMAL ! normal successful completion
	EXTERNAL	SS$_NORMAL
C
C Functions:
C
	INTEGER*4	FRTINI		! open FRT file for readonly
C
C Workspace:
C
C
C ......................................................................
C
C
	OPEN_FRT=%LOC(SS$_NORMAL)
C
C Initialise FRT file
	IF(FRTINI(FRT_FILE(1:FRT_FILE_LEN)))THEN
	   OPEN_FRT=I2DLG__BADFRT
	   CALL LSL_PUTMSG(OPEN_FRT,FRT_FILE(1:FRT_FILE_LEN))
	   GOTO 10
	ENDIF
C
C ......................................................................
C
10	IF (OPEN_FRT) OPEN_FRT=%LOC(SS$_NORMAL)     ! normal completion?
	RETURN
	END
