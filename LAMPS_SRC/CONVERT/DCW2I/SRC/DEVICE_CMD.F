C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-07-16 11:28:26.000000000 +0100
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
	LOGICAL FUNCTION DEVICE_CMD()
C
CDEC$	IDENT	'19MY92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	22-May-1992
C
C Description:
C
C	Function to read CD-ROM device name from command line
C	Function returns .TRUE. if all is well, .FALSE. if an error
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'DCW2IMSG.PAR'
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
C
C Functions
C
	LOGICAL		FILE_EXISTS	! check if device is valid
	LOGICAL		GETFILNAM	! read file-spec
C
C Local workspace
C
	CHARACTER*12	DEFNAM		! default device
	INTEGER*4	OK		! success status
C
C ......................................................................
C
	DEVICE_CMD=.TRUE.		! assume success
C
	DEFNAM=' '
	OK = GETFILNAM(DEVICENAM,DEVICELEN,DEFNAM(1:1),.TRUE.,%REF(' !'))
C
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(OK)
	   CALL WRITEF
	   GOTO 50
	ENDIF
C
C It is only valid if it GETFILNAM parsed a device name (STR_DEV is true)
C and nothing else is true.
C
	OK =     (HAD_DEV.AND.
     &	     .NOT.HAD_DIR.AND.
     &	     .NOT.HAD_NAM.AND.
     &	     .NOT.HAD_EXT.AND.
     &	     .NOT.HAD_VER)
C
	IF (.NOT.OK) THEN
	   DEVICE_CMD = .FALSE.
	   CALL LSL_PUTMSG(DCW2I__INVDEV)
	   CALL WRITEF
	   GOTO 50
	ENDIF
C
C Check for zero length filename
C	   
	IF (DEVICELEN.LT.1) THEN
	   DEVICE_CMD = .FALSE.
	   CALL LSL_PUTMSG(LSL__SRCFILNAM)
	   CALL WRITEF
	   GOTO 50
	ENDIF
C
C Upper case the actual device
C
	CALL STR$UPCASE(STR_DEV,STR_DEV)
C
C Check if it is valid
C
	HAD_DEVICE = FILE_EXISTS(STR_DEV(1:LEN_DEV)//':[000000]DCW.DIR')
C
C And complain if not
C
	IF (.NOT.HAD_DEVICE) THEN
	   CALL LSL_PUTMSG(DCW2I__NOTDCWROM,STR_DEV(1:LEN_DEV))
	   CALL WRITEF
	   GOTO 50
	ENDIF
C
	DEVICELEN = LEN_DEV
	DEVICENAM(1:DEVICELEN) = STR_DEV(1:LEN_DEV)
	CALL WRITEF ('Device name      : %S',DEVICENAM(1:DEVICELEN))
	CALL WRITEF
C
C ......................................................................
C
50	RETURN
	END
