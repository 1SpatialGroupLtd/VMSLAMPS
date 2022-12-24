C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-08-16 11:42:38.000000000 +0100
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
 	PROGRAM	DEM2DTI
C
CDEC$	IDENT	'09OC89'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					APB	03-Oct-1989
C
C Description:
C
C	Module DEM2DTI in package DTMCONVERT
C	Conversion utility to read in a USGS (United States Geological
C	Survey) DEM (Digital Elevation Model) file and write a LSL
C	(Laser Scan Ltd) DTI (Digital Terrain Image) file.
C
        IMPLICIT NONE
C
C Messages
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE	'LSL$DEM2DTI:DEM2DTIMSG.PAR'
C
C Functions
C
	LOGICAL		OBEY       		! Command line interpreter
	LOGICAL		OPEN_FILES		! Open DEM and DTI files
	LOGICAL		WRITE_DTI		! Write data to DTI file
	LOGICAL		CLOSE_FILES		! Close DEM and DTI files
C
C Local Variables
C
	INTEGER		STATUS			! Return error status
C
C-------------------------------------------------------------------------------
C
C Initialise LSLLIB and DTILIB
C
	CALL LSL_INIT
	CALL DTI_INIT
C
C Decode the command line
C
	STATUS = OBEY()
	IF ( .NOT.STATUS ) GOTO 999
C
C Open the input DEM file (magtape or disk) and the output DTI file
C
	STATUS = OPEN_FILES()
	IF ( .NOT.STATUS ) GOTO 999
C
C Write the DEM elevation data to the DTI file
C
	STATUS = WRITE_DTI()
	IF ( .NOT.STATUS ) GOTO 999
C
C Close the DEM and DTI files
C
	STATUS = CLOSE_FILES()
	IF ( .NOT.STATUS ) GOTO 999
C
C And exit with the success/error status from earlier
C
999	CONTINUE
C
C If STATUS is .TRUE. or .FALSE., change it to a proper message code
C
	IF ( STATUS ) THEN
	   STATUS = DEM2DTI__NORMAL
	ELSEIF ( .NOT.STATUS ) THEN
	   STATUS = DEM2DTI__ABORT
	ENDIF
C
	CALL LSL_EXIT( STATUS )
C
	END
C
