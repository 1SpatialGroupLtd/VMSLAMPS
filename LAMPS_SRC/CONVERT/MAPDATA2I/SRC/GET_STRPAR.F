	INTEGER*4 FUNCTION GET_STRPAR(STR_OUT,LEN_OUT,ALLOW_PREFIX)
C
CDEC$	IDENT	'23SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created (based on AUTOTEXT GET_STRING)		RJH	13-Sep-1994
CMOD	Used in MAPDATA2I to ensure compatibility	ST	20-Sep-1994
C       Mod 1400.
C
C	CONVERT MAPDATA2I Utility - Get string from parameter file
C
C Description
C
C	Reads a string from the current line in the parameter file.
C
C	Expects the line to be in the current text or auxiliary text input 
C	buffer, and the command line decoding pointer to be in position 
C	before the string.
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
	INCLUDE	'CMN:MAPDATA2IMSG.PAR'		! message definitions
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
C
C------------------------------------------------------------------------------
C Assume success
C
	GET_STRPAR = LSL__NORMAL
C
C If an equal or colon character is allowed, check for one
C
!	IF (ALLOW_PREFIX) THEN
!	   IF (.NOT. RDCHS(CH)) THEN			! if character found,
!	      IF ( CH.NE.EQUAL .AND. CH.NE.COLON ) THEN	! and not equal/colon,
!	         CALL BSCH				! unread it
!	      ENDIF
!	   ENDIF			! handle unexpected end of line later
!	ENDIF
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
	   CALL LSL_PUTMSG(MD2I__NOSTRING)
	   GOTO 9999
	ENDIF
C
	GOTO 10000
C
C Failure
C
9999	GET_STRPAR = LSL_STATUS
C
C------------------------------------------------------------------------------
C Return
C
10000	RETURN
	END
