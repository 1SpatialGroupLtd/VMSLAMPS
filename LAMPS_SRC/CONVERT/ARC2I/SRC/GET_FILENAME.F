C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-01-28 11:43:26.000000000 +0000
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
	LOGICAL FUNCTION GET_FILENAME
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	19-Nov-1990
C
C Description:
C
C	Module GET_FILENAME called by ARC2I in package CONVERT
C	Reads the magtape file to get it's filename and us this to
C	update TMPFILE and IFFFILE
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
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! Text input
	INCLUDE	'HERE:FILES.CMN'		! ARC2I filenames
	INCLUDE	'HERE:COMMANDS.CMN'		! Command line results
	INCLUDE	'HERE:EXTENSIONS.CMN'		! EXPORT filename extensions
	INCLUDE	'HERE:GENERAL.CMN'		! General variables
C
C Functions
C
	LOGICAL		GET_EXP_LINE		! Read a tape block
	LOGICAL		REWIND_FILE		! Rewind tape or disk file
C
C Local Variables
C
	INTEGER*4	STATUS			! Return error status
	INTEGER*4	ERROR			! System error status
	INTEGER*4	OK			! Success of calls
	INTEGER*4	I,J			! Loop counter
	INTEGER*4	IND			! Index posn of name
	INTEGER*4	OFFSET			! Offset into MTBUF
	CHARACTER*32	LINE			! Line of EXPORT file
C
	EQUIVALENCE(TXTBUF(1),LINE)
C
C-------------------------------------------------------------------------------
C
	IF ( HAD_LOG ) CALL WRITEF('Searching file for coverage name...')
C
50	STATUS = GET_EXP_LINE()
	IF ( .NOT.STATUS ) GOTO 999
	IF ( LAST_LINE ) THEN
	   STATUS = ARC2I__NOCOVERNAM
	   CALL LSL_PUTMSG( STATUS )
	   GOTO 999
	ENDIF
C
	IND = INDEX(LINE(1:32),AAT(1:4))
	IF (IND.LE.0) IND = INDEX(LINE(1:32),PAT(1:4))
	IF (IND.LE.0) IND = INDEX(LINE(1:32),BND(1:4))
	IF (IND.LE.0) IND = INDEX(LINE(1:32),TIC(1:4))
C
	IF (IND.GT.0) GOTO 200		! Found filename
100	CONTINUE
C
C Name was not found, get next block...
C
	GOTO 50
C
C Name was found, save it.
C
200	IND = IND - 1
C
C Give EXPORT file the name held in file.
C
	EXPLEN = IND + 4
	EXPFILE(1:EXPLEN) = LINE(1:IND)//'.E00'
C
C Give TMP file the name of the EXPORT file with extension ARC2I_TMP.
C
	TMPLEN = IND + 19
	TMPFILE(1:TMPLEN) = 'SYS$DISK:'//LINE(1:IND)//'.ARC2I_TMP'
C
C Create IFF filename with .IFF extension. The dir-spec is LSL$IF:
C
	IFFLEN = IND + 11
	IFFFILE(1:IFFLEN) = 'LSL$IF:'//LINE(1:IND)//'.IFF'
C
C Rewind EXPORT file
C
	STATUS = REWIND_FILE( EXPLUN )
	IF ( .NOT. STATUS ) GOTO 999
C
999	GET_FILENAME = STATUS
C
	RETURN
	END
