C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-05-10 16:31:40.000000000 +0100
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
        SUBROUTINE REPORT
C
CDEC$	IDENT	'10MY90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	10-May-1990
C
C	CONVERT I2SXF Utility - Report on what we are doing
C
C Description
C
C
        IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filename parse
	INCLUDE 'LSL$CMNI2SXF:COMMANDS.CMN'	! command line things
C
C Report on things we get straight from the command line
C
100	CALL WRITEF(' ')
	CALL WRITEF('Parameter file      : %S',PARFIL(1:PARLEN))
	IF (HAD_FRT)
     +	CALL WRITEF('FRT file            : %S',FRTFIL(1:FRTLEN))
	CALL WRITEF('IFF input  file     : %S',IFFFIL(1:IFFLEN))
	CALL WRITEF('SXF output file     : %S',SXFFIL(1:SXFLEN))
C
	IF (NUM_LAY .NE. 0) CALL WRITEF('Selecting by layer')
	IF (NUM_FC  .NE. 0) CALL WRITEF('Selecting by feature code')
	IF (HAD_LOG) THEN
	   CALL WRITEF('Outputting supplementary messages')
	   CALL WRITEF(' ')
	ENDIF
C
C Return
C
	RETURN
        END
