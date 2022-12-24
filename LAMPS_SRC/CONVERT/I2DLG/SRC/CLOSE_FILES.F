C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1989-10-06 15:21:34.000000000 +0100
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
	SUBROUTINE CLOSE_FILES
C
CDEC$	IDENT	'06OC89'
C
C	Copyright LaserScan Laboratories Ltd., Cambridge, England
C
C	Created 					FJB 14-Aug-1989
C
C closes any open files
C
	IMPLICIT NONE
C                                                                  
C
C Parameters:
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:I2DLGMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR'
C
C Common:
	INCLUDE 'LSL$CMNI2DLG:COMMAND.CMN'
C
C Functions
C
C Workspace:
	INTEGER*4	OK,IERR		! error codes
C
C
C ......................................................................
C
C Close input
C
	IF (IFF_IS_OPEN) CALL IFFCLO(IFFLUN)	! IFF input file
C
C ......................................................................
C
C
	RETURN         
	END
 
                  
