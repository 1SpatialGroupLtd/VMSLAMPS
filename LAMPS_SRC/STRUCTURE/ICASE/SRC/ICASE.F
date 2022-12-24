C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-11-01 13:32:58.000000000 +0000
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
	PROGRAM ICASE
C
CDEC$	IDENT	'12SE91'
C
C
C	Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C	Created					ST	25-Sep-1991
C
C Description
C       Main program ICASE which is kept simple and calls routines which
C       decode the command line, opens files, reads the parameter file and
C       calls the main routine which processes the IFF file.
C
	IMPLICIT NONE
C
	INCLUDE 'LSL$ICASE:ICASE.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
C
C Functions called
C
	LOGICAL		GET_COMMAND	! get and decode command line
	LOGICAL		OPEN_FILES	! open in,out file
	LOGICAL		RDPAR		! open and read parameter file
	LOGICAL		FIRST_PASS	! perform initial pass of IFF file
	LOGICAL		SCAN_IFF	! scan IFF file node structure
	LOGICAL		CLOSE_FILES	! close any open files
C
	INTEGER*4	STATUS
C
C------------------------------------------------------------------------------
C
C Initialise libraries
C
	CALL LSL_INIT(.TRUE.)
C
C Get and decode the command line
C
	STATUS = GET_COMMAND()
	IF (.NOT.STATUS) GOTO 999
C
C Open input, output annd FRT files
C
	STATUS = OPEN_FILES()
	IF (.NOT.STATUS) GOTO 800
C
C Read in a check parameter file
C
	STATUS = RDPAR()
	IF (.NOT.STATUS) GOTO 800
C
C Perform initial pass of IFF file
C
	STATUS = FIRST_PASS()
	IF (.NOT.STATUS) GOTO 800
C
C Main routine which processes IFF file
C
	STATUS = SCAN_IFF()
	IF (.NOT.STATUS) GOTO 800
C
C Close any open files
C
800	IF (STATUS) CALL WRITEF('Operation successful.')
	STATUS = CLOSE_FILES()
	IF (.NOT.STATUS) GOTO 999
C

C
C Set the return status and finish up
C
999	CALL LSL_EXIT()
	END
