C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1990-05-10 16:30:56.000000000 +0100
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
        LOGICAL FUNCTION CLOSE_IFF
C
CDEC$	IDENT	'10MY90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	10-May-1990
C
C	CONVERT I2SXF Utility - Close IFF file
C
C Description
C
C
        IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE	'($STSDEF)/NOLIST'
	INCLUDE 'LSL$CMNI2SXF:I2SXFMSG.PAR'	! message definitions
C
C Common Blocks
C
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'	! current position in IFF file
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filename parse
	INCLUDE 'LSL$CMNI2SXF:COMMANDS.CMN'	! command line things
C
C Close the input file 
C
	CALL IFFCLO(IFFLUN)
C
C Output an appropriate message
C
	IF ((IERCD .NE. 0) .OR. (IERNM .NE. 1)) THEN
	   CALL LSL_PUTMSG(I2SXF__IFFCLOERR)
	ELSE IF (HAD_LOG) THEN
	   IF (LSL_STATUS .OR. 
     &	      ((LSL_STATUS .AND. STS$M_SEVERITY) .EQ. STS$K_WARNING)) 
     &	      THEN
	      CALL LSL_PUTMSG(I2SXF__IFFCLOSED)
	   ELSE
	      CALL LSL_ADDMSG(I2SXF__IFFCLOSED)
	   ENDIF
	ENDIF
C
C Assign function value
C
	CLOSE_IFF = ((IERCD .EQ. 0) .AND. (IERNM .EQ. 1))
C
C Return
C
	RETURN
        END
