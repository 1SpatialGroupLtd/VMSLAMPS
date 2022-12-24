C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-27 13:24:08.000000000 +0100
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
	INTEGER*4 FUNCTION CHECK_FC(WHICH_FC)
C
CDEC$	IDENT	'27SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	14-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Check FC
C
C Description
C
C	Checks the validity of a feature code.
C
C	Returns the error code held in LSL_STATUS if the FC is invalid,
C	LSL__NORMAL otherwise.
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:I2MAPDATAMSG.PAR'		! message definitions
	INCLUDE	'CMN:GEN.PAR'			! general parameters
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
C
C Arguments
C
	INTEGER*4	WHICH_FC		! feature code
C
C Assume success
C
	CHECK_FC = LSL__NORMAL
C
C Just check the FC is within the allowed range
C
 	IF ( WHICH_FC.LT.0 .OR. WHICH_FC.GT.WORD_MAX ) THEN
	   CALL LSL_PUTMSG(I2MD__BADFC,WHICH_FC,0,WORD_MAX)
	   GOTO 9999
	ENDIF
C
	GOTO 10000
C
C Failure
C
9999	CHECK_FC = LSL_STATUS
C
C Return
C
10000	RETURN
	END
