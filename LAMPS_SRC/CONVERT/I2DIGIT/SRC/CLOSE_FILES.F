C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1992-01-07 16:36:04.000000000 +0000
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
	LOGICAL FUNCTION CLOSE_FILES(DEL_TMP)
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	9-Dec-1991
C
C Description:
C
C	Module CLOSE_FILES called by I2DIGIT in package CONVERT
C	Closes temporary and IFF files
C	
C------------------------------------------------------------------------------
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
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'		! For access to IERCD
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE	'FILES.CMN'			! I2DIGIT filenames
	INCLUDE	'COMMANDS.CMN'			! Command line results
	INCLUDE	'GENERAL.CMN'			! General variables
C
C Arguments
C
	LOGICAL*4	DEL_TMP			! Delete temp file
C
C Functions
C
	LOGICAL*4	FLWCLO			! Close file
C
C Local Variables
C
	INTEGER*4	STATUS			! Function return error status
	INTEGER*4	OK			! Call success status
	INTEGER*4	IERR			! System error status
C
C------------------------------------------------------------------------------
C
C Assume success
C
	STATUS = .TRUE.
C
C Close TMP disk file.
C
	IF (TMP_OPEN) THEN
	   OK = FLWCLO(TMPLUN,IERR)
	   IF (OK) THEN
	      TMP_OPEN = .FALSE.
	   ELSE
	      STATUS = I2DIGIT__ERRCLOTMP
	      CALL LSL_PUTMSG(STATUS)
	      IF ( OK.EQ.LSL__SYSCLOSE ) CALL LSL_ADDMSG( IERR )
	   ENDIF
	ENDIF
C
C There is no LSLLIB routine to delete a file opened for read. (only write)
C We must therefore use LIB$DELETE_FILE.
C
	IF (DEL_TMP) CALL LIB$DELETE_FILE(TMPFILE(1:TMPLEN)//';*')
C
C Close IFF file.
C
	CALL IFFERM(.FALSE.)            ! turn off error messages
	CALL IFFCLO(IFFLUN,,)		! Close IFF file.
	CALL IFFERM(.TRUE.)             ! turn on error messages
	IFF_OPEN = IERCD.NE.0
	IF (IFF_OPEN) THEN
	   STATUS = I2DIGIT__ERRCLO
	   CALL LSL_PUTMSG( STATUS,IFFFILE(1:IFFLEN) )
	   CALL IFFERR
	   GOTO 999
	ENDIF
C
	IF (HAD_LOG) CALL WRITEF('Disk files closed.')
C
999	CLOSE_FILES = STATUS.AND.OK
C
	RETURN
	END
