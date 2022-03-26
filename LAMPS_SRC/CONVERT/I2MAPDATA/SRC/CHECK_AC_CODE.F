	INTEGER*4 FUNCTION CHECK_AC_CODE(WHICH_CODE)
C
CDEC$	IDENT	'15SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	13-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Check AC code
C
C Description
C
C	Checks the validity of an AC code.
C
C	Returns the error code held in LSL_STATUS if the code is invalid,
C	LSL__NORMAL otherwise.
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:I2MAPDATAMSG.PAR'		! message definitions
C
C Common Blocks
C
	INCLUDE 'LSL$CMNFRT:FRTACD.CMN'		! FRTLIB ACD interface
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
C
C Arguments
C
	INTEGER*4	WHICH_CODE		! AC code
C
C Assume success
C
	CHECK_AC_CODE = LSL__NORMAL
C
C Just check the code is within the allowed range
C
 	IF ( WHICH_CODE.LT.1 .OR. WHICH_CODE.GT.ACD_CODE_MAX ) THEN
	   CALL LSL_PUTMSG(I2MD__BADATTCODE,WHICH_CODE,1,ACD_CODE_MAX)
	   GOTO 9999
	ENDIF
C
	GOTO 10000
C
C Failure
C
9999	CHECK_AC_CODE = LSL_STATUS
C
C Return
C
10000	RETURN
	END
