	INTEGER*4 FUNCTION GET_AC_CODE(CODE_OUT,NAME_IN)
C
CDEC$	IDENT	'21SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	14-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Get AC code from name
C
C Description
C
C	Gets an AC code, given the associated name.
C
C	Returns the error code held in LSL_STATUS if something goes wrong,
C	LSL__NORMAL otherwise.
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:I2MAPDATAMSG.PAR'		! message definitions
C
C Arguments
C
	INTEGER*4	CODE_OUT		! output AC code
	CHARACTER*(*)	NAME_IN			! input AC name
C
C Common Blocks
C
	INCLUDE 'LSL$CMNFRT:FRTACD.CMN'		! FRTLIB ACD interface
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
C
C Functions called
C
	LOGICAL		ACDFND_NAME		! get AC definition from name
C
C Assume success
C
	GET_AC_CODE = LSL__NORMAL
C
C Find the given name in the ACD table
C
	IF ( ACDFND_NAME(NAME_IN,) ) THEN
	   CALL LSL_ADDMSG(I2MD__UNKATTNAME,NAME_IN)
	   LSL_STATUS = I2MD__UNKATTNAME		! reset status
	   GOTO 9999
	ENDIF
C
C and set the AC code
C
	CODE_OUT = ACD_CODE
C
	GOTO 10000
C
C Failure
C
9999	GET_AC_CODE = LSL_STATUS
C
C Return
C
10000	RETURN
	END