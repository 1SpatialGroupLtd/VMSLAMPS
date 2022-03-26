	INTEGER*4 FUNCTION CHECK_MD_CODE(CODE_STR)
C
CDEC$	IDENT	'25SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	14-Sep-1994
CMOD	Used in MAPDATA2I to ensure compatibility	ST	20-Sep-1994
C       Mod 1400.
C
C	CONVERT MAPDATA2I Utility - Check MAPDATA code
C
C Description
C
C	Checks the validity of a MAPDATA code.
C
C	Returns the error code held in LSL_STATUS if the code is invalid,
C	LSL__NORMAL otherwise.
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:MAPDATA2IMSG.PAR'		! message definitions
C
C Common Blocks
C
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
C
C Arguments
C
	CHARACTER*(*)	CODE_STR		! MAPDATA code
C
C Functions
C
	INTEGER*4	STR$MATCH_WILD		! match wildcard string
C
C------------------------------------------------------------------------------
C Assume success
C
	CHECK_MD_CODE = LSL__NORMAL
C
C Just check the format for now
C
 	IF (.NOT. STR$MATCH_WILD( CODE_STR,'*.*' )) THEN
	   CALL LSL_PUTMSG(MD2I__BADMDCODE,CODE_STR)
	   GOTO 9999
	ENDIF
C
	GOTO 10000
C
C Failure
C
9999	CHECK_MD_CODE = LSL_STATUS
C
C Return
C
10000	RETURN
	END
