C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-09-25 12:53:38.000000000 +0100
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
CDEC$	IDENT	'06DE91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	6-Dec-1991
C
C Description:
C
C	Module INIT_TAPE called by I2DIGIT in package CONVERT
C	Initialised tape device specified as input filename
C	
C-----------------------------------------------------------------------------
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'I2DIGITMSG.PAR'		! I2DIGIT messages
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE 'LSL$CMNLSL:MTOVCM.CMN'		! Magtape input
	INCLUDE	'FILES.CMN'			! I2DIGIT filenames
	INCLUDE	'COMMANDS.CMN'			! Command line results
	INCLUDE	'GENERAL.CMN'			! General variables
C
C Functions
C
	LOGICAL*4	MTONIT			! Initialise a tape for write
	LOGICAL*4	MTOEOV			! Find end of volume
	LOGICAL*4	TEST_FOREIGN		! Test if file is magtape
C
C Local Variables
C
	INTEGER*4	STATUS			! Return error status
	INTEGER*4	ERROR			! System error status
	LOGICAL*4	FOREIGN			! True if file is MOUNT/FOREIGN
C
C------------------------------------------------------------------------------
C
	STATUS = TEST_FOREIGN( DEVICENAME,FOREIGN,ERROR )
C
	IF ( STATUS .EQ. LSL__NORMAL .AND. FOREIGN ) THEN
C
C Initialise tape
C
	   IF (HAD_LOG) THEN
	      CALL WRITEF('Initialising tape %S for write - Please wait.',
     &		       DEVICENAME(1:DEVICELEN))
	   ENDIF
C
	   STATUS = MTONIT( DEVICENAME(1:DEVICELEN),,.FALSE., )
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG(I2DIGIT__ERRINITTAPE,DEVICENAME(1:DEVICELEN))
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	      GOTO 999
	   ENDIF	
C
C If appending to a tape, place tape head between two tape marks
C
	   IF (HAD_APPEND) THEN
	      IF (HAD_LOG) CALL WRITEF('Searching for end of tape mark...')
	      STATUS = MTOEOV()
	      IF (.NOT.STATUS ) THEN
		 CALL LSL_PUTMSG(I2DIGIT__NOEOV)
		 IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
		 GOTO 999
	      ENDIF
	   ENDIF
C
	ELSEIF ( STATUS .EQ. LSL__NORMAL .AND. .NOT.FOREIGN ) THEN
	   IF ( DEVICENAME(1:1) .EQ. 'M' .OR. DEVICENAME(1:1) .EQ. 'm' ) THEN
	      CALL LSL_PUTMSG(I2DIGIT__NOTMNTFOR,DEVICENAME(1:DEVICELEN) )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	      STATUS = .FALSE.
	      GOTO 999
	   ELSE
C
C Some other error
C
	      STATUS = .FALSE.
	      CALL LSL_PUTMSG(I2DIGIT__ERRINITTAPE,DEVICENAME(1:DEVICELEN))
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	      GOTO 999
	   ENDIF
C
	ELSEIF ( .NOT.STATUS ) THEN
	   CALL LSL_PUTMSG(I2DIGIT__ERRINITTAPE,DEVICENAME(1:DEVICELEN))
	   GOTO 999
	ENDIF
C
999	CONTINUE
	INIT_TAPE = STATUS
C
	RETURN
	END
