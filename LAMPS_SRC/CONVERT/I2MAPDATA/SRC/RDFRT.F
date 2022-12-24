C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-16 17:25:14.000000000 +0100
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
	INTEGER*4 FUNCTION RDFRT
C
CDEC$	IDENT	'16SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	14-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Read FRT File
C
C Description
C
C	Reads the FRT file if one was specified on the command line,
C	otherwise just sets up standard ACD definitions.
C
C	Returns the error code held in LSL_STATUS if something goes wrong,
C	LSL__NORMAL otherwise.
C
	IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:I2MAPDATAMSG.PAR'		! message definitions
C
C Common Blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB filename expansion
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
	INCLUDE	'CMN:FILES.CMN'      		! filenames
	INCLUDE	'CMN:CONTROL.CMN'      		! control variables
C
C Functions called
C
	LOGICAL		FRTINI			! read FRT file
C
C Assume success
C
	RDFRT = LSL__NORMAL
C
C Read the FRT file if we have one
C
	IF (HAD_FRT) THEN
C
	   IF (FRTINI(FRTFIL(1:FRTLEN))) THEN
	      CALL LSL_PUTMSG(I2MD__ERRRDFRT,FRTFIL(1:FRTLEN))
	      GOTO 9999
	   ENDIF
C
	   IF (HAD_LOG) CALL LSL_PUTMSG(I2MD__READFRT,FRTFIL(1:FRTLEN))
C
C otherwise set up the standard ACD definitions
C
	ELSE
	   CALL FRT_ACDINI
	ENDIF
C
	GOTO 10000
C
C Failure
C
9999	RDFRT = LSL_STATUS
C
C Return
C
10000	RETURN
	END
