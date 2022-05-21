C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-05-24 16:14:18.000000000 +0100
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
	LOGICAL FUNCTION INIT_TAPE
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	4-Nov-1990
C
C Description:
C
C	Module INIT_TAPE called by ARC2I in package CONVERT
C	Initialised tape device specified as input filename
C	
C-------------------------------------------------------------------------------
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'HERE:ARC2IMSG.PAR'		! ARC2I messages
	INCLUDE 'HERE:LUN.PAR'			! Logical units for file I/O
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE 'LSL$CMNLSL:MTIVCM.CMN'		! Magtape input
	INCLUDE	'HERE:FILES.CMN'		! ARC2I filenames
	INCLUDE	'HERE:COMMANDS.CMN'		! Command line results
	INCLUDE	'HERE:GENERAL.CMN'		! General variables
C
C Functions
C
	LOGICAL		FLROPN			! Open a file for read
	LOGICAL		MTINIT			! Initialise a tape for read
	LOGICAL		TEST_FOREIGN		! Test if file is magtape
C
C Local Variables
C
	INTEGER		STATUS			! Return error status
	INTEGER		ERROR			! System error status
	LOGICAL		FOREIGN			! True if file is MOUNT/FOREIGN
	INTEGER		I			! Loop counter
C
C-------------------------------------------------------------------------------
C
	STATUS = TEST_FOREIGN( EXPFILE,FOREIGN,ERROR )
C
	IF ( STATUS .EQ. LSL__NORMAL .AND. FOREIGN ) THEN
	   MAGTAPE = .TRUE.
C
C Initialise tape
C
	   CALL WRITEF( 'Initializing tape %S for read - Please wait.',EXPFILE(1:EXPLEN))
	   STATUS = MTINIT( EXPFILE(1:EXPLEN), .NOT.HAD_REWIND, )
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG( ARC2I__MAGTAPE,EXPFILE(1:EXPLEN) )
	      CALL LSL_ADDMSG( STATUS )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	      GOTO 999
	   ENDIF	
C
C Either the tape is not mounted foreign or the user specified a device name
C that isn't a tape device, in which case the filename is missing
C
	ELSEIF ( STATUS .EQ. LSL__NORMAL .AND. .NOT.FOREIGN ) THEN
	   IF ( EXPFILE(1:1) .EQ. 'M' .OR. EXPFILE(1:1) .EQ. 'm' ) THEN
	      STATUS = ARC2I__NOTMNTFOR
	      CALL LSL_PUTMSG( STATUS,EXPFILE(1:EXPLEN) )
	      GOTO 999
	   ELSE
C
C Disk device name only
C
	      STATUS = ARC2I__NOFILNAM
	      CALL LSL_PUTMSG( STATUS,EXPFILE(1:EXPLEN) )
	      GOTO 999
	   ENDIF
C
C Error in device name
C
	ELSEIF ( .NOT.STATUS ) THEN
	   CALL LSL_PUTMSG( ARC2I__NODEVICE,EXPFILE(1:EXPLEN) )
	   GOTO 999
	ENDIF
C
999	CONTINUE
	INIT_TAPE = STATUS
C
	RETURN
	END
