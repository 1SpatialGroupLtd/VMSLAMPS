C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1993-02-17 14:33:48.000000000 +0000
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
	LOGICAL FUNCTION PROCESS
C
CDEC$	IDENT	'17FE93'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	7-Dec-1990
C
C Description:
C
C	Function PROCESS call by ARC2I in package CONVERT
C	Processes input EXPORT and TMP file to create output IFF file
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
	INCLUDE	'LSL$CMNLSL:CLD.CMN'		! DCL command interpretation
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! Text input
	INCLUDE	'HERE:FILES.CMN'		! ARC2I filenames
	INCLUDE	'HERE:GENERAL.CMN'		! General variables
	INCLUDE	'HERE:COMMANDS.CMN'		! Command line results
	INCLUDE	'HERE:IFFINFO.CMN'		! IFF information
C
C Functions
C
	LOGICAL		GET_ARCS		! Read arc section
	LOGICAL		GET_PTS			! Read points section
	LOGICAL		GET_TXT			! Read text section
	LOGICAL		GET_TXTSIX		! Read V6 tx6 section
C
C Local Variables
C
	INTEGER*4	OK			! Success/failure of calls
	INTEGER*4	STATUS			! Return error status
	INTEGER*4	ERROR			! System error status
	INTEGER*4	I			! Loop counter
	INTEGER*4	IND			! Index position
	INTEGER*2	IECODE			! IFF entry code 
	INTEGER*2	IELEN			! IFF entry length
	CHARACTER*80	EXPLINE			! Line from EXPORT file
	CHARACTER*80	TMPLINE			! Line from TMP file
C
	EQUIVALENCE(TXTBUF(1),EXPLINE,TMPLINE)
C
C-------------------------------------------------------------------------------
C
	STATUS = .TRUE.
	LAST_BLOCK = .FALSE.		! we are at start of file
	LAST_LINE  = .FALSE.
	MTBLOCKS = 0			! reset number of blocks read to 0
	INF = 0				! Initialise number of features
C
C Read ARC (lines) section
C
	IF ( FOUND_ARC ) THEN
	   STATUS = GET_ARCS()
	   IF ( .NOT.STATUS ) GOTO 9000
	   IF ( LAST_LINE ) GOTO 100
	ENDIF
C
C Read LAB (points) section
C
	IF ( FOUND_LAB ) THEN
	   STATUS = GET_PTS()
	   IF ( .NOT.STATUS ) GOTO 9000
	   IF ( LAST_LINE ) GOTO 100
	ENDIF
C
C Read TXT or section
C
	IF ( FOUND_TXT ) THEN
	   STATUS = GET_TXT()
	   IF ( .NOT.STATUS ) GOTO 9000
	   IF ( LAST_LINE ) GOTO 100
	ENDIF
C
C Read TX6 or section
C
	IF ( FOUND_TX6 ) THEN
	   STATUS = GET_TXTSIX()
	   IF ( .NOT.STATUS ) GOTO 9000
	   IF ( LAST_LINE ) GOTO 100
	ENDIF
C
C Finish off IFF file..
C
100	CALL IFFUNO(LPOSNO)	! set NO/EO pointer for last layer
	CALL IFFEO		! end the layer
	CALL IFFEM		! end the map
	CALL IFFEJ		! end the 'job'
C
C now go back and set the RA entry
C
	CALL IFFPKE( IECODE, IELEN, LPOSRA )
	IF ( IECODE.NE.'RA' ) THEN
	   CALL LSL_PUTMSG( ARC2I__NORA )
	   STATUS = .FALSE.
	   GOTO 9000
	ENDIF
	CALL EIHWR( RANGE, 4, 1 )
C
	IF (HAD_LOG) THEN
	   CALL WRITEF('%^L%I0 feature(s) written to IFF file.',TOTFEAT)
	ENDIF
C
9000	PROCESS = STATUS
C
	RETURN
	END
