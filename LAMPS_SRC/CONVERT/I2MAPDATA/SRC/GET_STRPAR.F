C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-15 17:32:04.000000000 +0100
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
	INTEGER*4 FUNCTION GET_STRPAR(STR_OUT,LEN_OUT,ALLOW_PREFIX)
C
CDEC$	IDENT	'15SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created (based on AUTOTEXT GET_STRING)		RJH	13-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Get string from parameter file
C
C Description
C
C	Reads a string from the current line in the parameter file.
C
C	Expects the line to be in the current text or auxiliary text input 
C	buffer, and the command line decoding pointer to be in position 
C	before the string. The string may be optionally prefixed by an '=' or
C	a ':' character.
C
C	Returns the error code held in LSL_STATUS if something goes wrong,
C	LSL__NORMAL otherwise.
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE	'LSL$CMNLSL:READSTR.PAR'	! LSLLIB string reading
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:I2MAPDATAMSG.PAR'		! message definitions
C
C Local Parameters
C
	BYTE		EQUAL			! equal character
	PARAMETER	(EQUAL = '=')
	BYTE		COLON			! colon character
	PARAMETER	(COLON = ':')
C
C Arguments
C
	CHARACTER*(*)	STR_OUT			! string to be returned
	INTEGER*4	LEN_OUT			! its length
	LOGICAL		ALLOW_PREFIX		! allow equal/colon prefix?
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
C
C Functions called
C
	LOGICAL		RDCHS			! read next character
	INTEGER*4	READSTR			! read a string
C
C Local Variables
C
	BYTE		CH			! character read
	INTEGER*4	ERRCOD			! LSLLIB error code
C
C Assume success
C
	GET_STRPAR = LSL__NORMAL
C
C If an equal or colon character is allowed, check for one
C
	IF (ALLOW_PREFIX) THEN
	   IF (.NOT. RDCHS(CH)) THEN			! if character found,
	      IF ( CH.NE.EQUAL .AND. CH.NE.COLON ) THEN	! and not equal/colon,
	         CALL BSCH				! unread it
	      ENDIF
	   ENDIF			! handle unexpected end of line later
	ENDIF
C
C Now read in the string
C
	STR_OUT = ' '			! but first initialise it
C
	LEN_OUT = READSTR(STR_OUT,,ON_SPACE,.TRUE.,ERRCOD)
C
	IF (.NOT. ERRCOD) THEN
	   CALL LSL_PUTMSG(ERRCOD)
	   GOTO 9999
	ELSEIF (LEN_OUT .EQ. 0) THEN
	   CALL LSL_PUTMSG(I2MD__NOSTRING)
	   GOTO 9999
	ENDIF
C
	GOTO 10000
C
C Failure
C
9999	GET_STRPAR = LSL_STATUS
C
C Return
C
10000	RETURN
	END
