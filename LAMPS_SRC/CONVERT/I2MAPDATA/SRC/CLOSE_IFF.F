C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-22 16:41:08.000000000 +0100
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
	INTEGER*4 FUNCTION CLOSE_IFF
C
CDEC$	IDENT	'22SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	22-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Close IFF File
C
C Description
C
C	Closes the input IFF file.
C
C	Returns the error code held in LSL_STATUS if something goes wrong,
C	LSL__NORMAL otherwise.
C
	IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE	'($STSDEF)/NOLIST'
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:LUN.PAR'			! logical unit numbers
	INCLUDE	'CMN:I2MAPDATAMSG.PAR'		! message definitions
C
C Common Blocks
C
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'		! IFF handling
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
	INCLUDE	'CMN:CONTROL.CMN'      		! control variables
C
C Assume success
C
	CLOSE_IFF = LSL__NORMAL
C
C Close the IFF file
C
	CALL IFFCLO(IFFLUN)
C
	IF (IERCD.NE.0 .OR. IERNM.NE.1) THEN		! error closing file
	   CALL LSL_PUTMSG(I2MD__IFFCLOERR)
	   GOTO 9999
	ELSE IF (HAD_LOG) THEN				! confirm file closed
	   IF (LSL_STATUS .OR. IBITS(LSL_STATUS,0,3).EQ.STS$K_WARNING) THEN
	      CALL LSL_PUTMSG(I2MD__IFFCLOSED)		! simple message, but
	   ELSE						! if had previous error
	      CALL LSL_ADDMSG(I2MD__IFFCLOSED)		! continuation message
	   ENDIF
	ENDIF
C
	GOTO 10000
C
C Failure
C
9999	CLOSE_IFF = LSL_STATUS
C
C Return
C
10000	RETURN
	END
