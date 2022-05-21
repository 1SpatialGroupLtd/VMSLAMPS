C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-22 17:41:08.000000000 +0100
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
	INTEGER*4 FUNCTION OPEN_IFF
C
CDEC$	IDENT	'22SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	22-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Open IFF File
C
C Description
C
C	Jacket to open the input IFF file for reading.
C
C	Returns the error code held in LSL_STATUS if something goes wrong,
C	LSL__NORMAL otherwise.
C
	IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:LUN.PAR'			! logical unit numbers
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
	INTEGER*4	IFFOPEN			! open IFF file for read
C
C Local Variables
C
	INTEGER*4	REV_LEVEL		! input revision level
	INTEGER*4	ERRCOD			! LSLLIB error code
C
C Assume success
C
	OPEN_IFF = LSL__NORMAL
C
C Open the IFF file for reading
C
	REV_LEVEL = 1
C
	ERRCOD = IFFOPEN( IFFLUN, IFFFIL(1:IFFLEN),, HAD_LOG, REV_LEVEL )
	IF (.NOT. ERRCOD) GOTO 9999
C
	GOTO 10000
C
C Failure
C
9999	OPEN_IFF = LSL_STATUS
C
C Return
C
10000	RETURN
	END
