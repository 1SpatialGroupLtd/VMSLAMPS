C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-12-16 12:28:36.000000000 +0000
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
	PROGRAM	I2DIGIT
C
CDEC$	IDENT	'27NO91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	27-Nov-1991
C
C Description:
C
C	Module I2DIGIT in package CONVERT
C	Conversion utility to read in IFF file and write a Scitex DIGIT 
C       tape file
C
        IMPLICIT NONE
C
C Common blocks
C
	INCLUDE	'COMMANDS.CMN'			! Command line values
	INCLUDE	'GENERAL.CMN'			! General variables
C
C Functions
C
	LOGICAL		CMDLINE			! Command line interpreter
	LOGICAL		CLOSE_FILES		! Close disk files
	LOGICAL		INIT_TAPE		! Initialise magtape
	LOGICAL		OPEN_FILES		! Open IFF file
	LOGICAL		RDPAR			! Open IFF file
	LOGICAL		PROCESS			! Process EXPORT file
	LOGICAL		WRITE_DIGIT_TO_TAPE	! Copy disk file to tape
C
C Local Variables
C
	INTEGER*4	STATUS			! Return error status
	INTEGER*4	OK			! Routine success
C
C------------------------------------------------------------------------------
C
	TOTBUFSIZE = 0
	NUMBLOCKS  = 0
	DISKBUFPTR = 1
C
C Initialise LSLLIB
C
	CALL LSL_INIT
C
C Decode the command line
C
	STATUS = CMDLINE()
	IF ( .NOT.STATUS ) GOTO 9999
C
C Open IFF and TMP files
C
	STATUS = OPEN_FILES()
	IF ( .NOT.STATUS ) GOTO 900
C
C Read parameter file
C
	IF (HAD_PAR) THEN
	   STATUS = RDPAR()
	   IF ( .NOT.STATUS ) GOTO 900
	ENDIF
C
C Initialise magtape now. No point processing a huge file and then stopping
C because you can't initialise the tape
C
	STATUS = INIT_TAPE()
	IF ( .NOT.STATUS ) GOTO 900
C
C Process the IFF file
C
	STATUS = PROCESS()
	IF ( .NOT.STATUS ) GOTO 900
C
C Close the TMP and IFF files
C
900	OK = CLOSE_FILES(.NOT.STATUS)
	IF (.NOT.(OK.AND.STATUS)) GOTO 9999
C
C Copy disk file to tape
C
	STATUS = WRITE_DIGIT_TO_TAPE()
	IF ( .NOT.STATUS ) GOTO 9999
C
9999	CALL LSL_EXIT
	END
