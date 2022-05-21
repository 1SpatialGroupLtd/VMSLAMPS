C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-01-28 11:58:24.000000000 +0000
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
	LOGICAL FUNCTION REWIND_FILE( LUN )
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	18-Dec-1990
C
C Description:
C
C	Function REWIND_FILE called from PROCESS in ARC2I
C	This function rewinds the file specified by the LUN
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
	INCLUDE	'HERE:GENERAL.CMN'		! General global variables
	INCLUDE	'HERE:COMMANDS.CMN'		! Command line results
C
C Arguments
C
	INTEGER*4	LUN			! logical unit of file to rewind
C
C Functions
C
	LOGICAL		FLRREW			! Rewind file
	LOGICAL		MTIBCK			! Backspace a tape block
C
C Local Variables
C
	INTEGER*4	STATUS			! Return error status
	INTEGER*4	OK			! Call success status
	INTEGER*4	IERR			! System error status
	INTEGER*4	I			! Loop counter
C
C-------------------------------------------------------------------------------
C
	STATUS = .TRUE.
C
	IF ( MAGTAPE.AND.LUN.EQ.EXPLUN ) THEN
C
C Rewind magtape file
C
C NOTE:   MTISPC(-MTBLOCKS) does not work when EOF reached so a loop was used.
C
	   DO 500 I = 1,MTBLOCKS
	      STATUS = MTIBCK()
	      IF ( .NOT.STATUS ) THEN
	         STATUS = ARC2I__ERRBCKSPC
	         CALL LSL_PUTMSG( STATUS )
	         IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	         GOTO 9000
	      ENDIF
500	   CONTINUE
	   MTBLOCKS = 0
C
C Rewind disk file
C
	ELSE
	   OK = FLRREW(LUN,IERR)
	   IF ( .NOT.OK ) THEN
C
C Output message with filename of TMP file or EXP file
C
	      STATUS = ARC2I__ERRRWD
	      IF ( LUN.EQ.TMPLUN ) THEN
	         CALL LSL_PUTMSG( STATUS,TMPFILE(1:TMPLEN) )
	      ELSEIF ( LUN.EQ.EXPLUN ) THEN
	         CALL LSL_PUTMSG( STATUS,EXPFILE(1:EXPLEN) )
	      ENDIF
C
	      CALL LSL_ADDMSG( OK )
	      IF ( OK.EQ.LSL__SYSREW ) CALL LSL_ADDMSG( IERR )
	      GOTO 9000
	   ENDIF
	ENDIF
C
9000	REWIND_FILE = STATUS
C
	RETURN
	END
