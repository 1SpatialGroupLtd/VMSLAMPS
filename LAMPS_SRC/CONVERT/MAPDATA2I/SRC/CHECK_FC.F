	INTEGER*4 FUNCTION CHECK_FC(WHICH_FC)
C
CDEC$	IDENT	'25SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	14-Sep-1994
CMOD	Used in MAPDATA2I to ensure compatibility	ST	20-Sep-1994
C       Mod 1400.
C
C	CONVERT MAPDATA2I Utility - Check FC
C
C Description
C
C	Checks the validity of a feature code.
C
C	Returns the error code held in LSL_STATUS if the FC is invalid,
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
	INCLUDE 'CMN:FILE.CMN'			! parameter tables
C
C Arguments
C
	INTEGER*4	WHICH_FC		! feature code
C
C------------------------------------------------------------------------------
C Assume success
C
	CHECK_FC = LSL__NORMAL
C
C Just check the FC is within the allowed range
C
 	IF ( WHICH_FC.LT.0 .OR. WHICH_FC.GT.WORD_MAX ) THEN
	   CALL LSL_PUTMSG(MD2I__BADFC,WHICH_FC,0,WORD_MAX)
	   GOTO 9999
	ENDIF
C
	GOTO 10000
C
C Failure
C
9999	CHECK_FC = LSL_STATUS
C
C Return
C
10000	RETURN
	END
