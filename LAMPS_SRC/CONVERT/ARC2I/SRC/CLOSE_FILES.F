C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1991-01-28 11:29:34.000000000 +0000
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
	LOGICAL FUNCTION CLOSE_FILES( DEL_IFF )
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	7-Nov-1990
C
C Description:
C
C	Module CLOSE_FILES called by ARC2I in package CONVERT
C	Closes EXPORT, TMP and IFF files
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
	INCLUDE	'HERE:FILES.CMN'		! ARC2I filenames
	INCLUDE	'HERE:COMMANDS.CMN'		! Command line results
	INCLUDE	'HERE:GENERAL.CMN'		! General variables
C
C Arguments
C
	LOGICAL		DEL_IFF			! Delete IFF file
C
C Functions
C
	LOGICAL		FLRCLO			! Close read file
C
C Local Variables
C
	INTEGER*4	STATUS			! Function return error status
	INTEGER*4	OK			! Call success status
	INTEGER*4	IERR			! System error status
C
C-------------------------------------------------------------------------------
C
C Assume success
C
	STATUS = .TRUE.
C
C Close EXPORT file.
C
	IF ( MAGTAPE ) THEN
C
	ELSE
	   OK = FLRCLO(EXPLUN,IERR)
	   IF ( .NOT.OK ) THEN
	      STATUS = ARC2I__ERRCLO
	      CALL LSL_PUTMSG( STATUS,EXPFILE(1:EXPLEN) )
	      CALL LSL_ADDMSG( OK )
	      IF ( OK.EQ.LSL__SYSCLOSE ) CALL LSL_ADDMSG( IERR )
	   ENDIF
	ENDIF
C
C Close TMP file.
C
	OK = FLRCLO(TMPLUN,IERR)
	IF ( .NOT.OK ) THEN
	   STATUS = ARC2I__ERRCLO
	   CALL LSL_PUTMSG( STATUS,EXPFILE(1:EXPLEN) )
	   CALL LSL_ADDMSG( OK )
	   IF ( OK.EQ.LSL__SYSCLOSE ) CALL LSL_ADDMSG( IERR )
	ENDIF
C
C There is no LSLLIB routine to delete a file opened for read. (only write)
C We must therefore use LIB$DELETE_FILE.
C
	CALL LIB$DELETE_FILE(TMPFILE(1:TMPLEN)//';*')
C
C Close IFF file. Delete it if an error
C
	IF ( DEL_IFF ) THEN
	   CALL IFFCDL( IFFLUN,, )		! Close and delete IFF file
	ELSE
	   CALL IFFCLO( IFFLUN,, )		! Close IFF file.
	ENDIF
C
	IF ( HAD_LOG.AND.STATUS ) CALL WRITEF('Files closed.')
C
9000	CLOSE_FILES = STATUS
C
	RETURN
	END
