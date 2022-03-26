	INTEGER*4 FUNCTION GET_AC_NAME(NAME_OUT,LEN_OUT,CODE_IN)
C
CDEC$	IDENT	'23SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	14-Sep-1994
CMOD	Used in MAPDATA2I to ensure compatibility	ST	20-Sep-1994
C       Mod 1400.
C
C	CONVERT MAPDATA2I Utility - Get AC name from code
C
C Description
C
C	Gets an AC name and length, given the AC code.
C
C	Returns the error code held in LSL_STATUS if something goes wrong,
C	LSL__NORMAL otherwise.
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:MAPDATA2IMSG.PAR'		! message definitions
C
C Arguments
C
	CHARACTER*(*)	NAME_OUT		! output AC name
	INTEGER*4	LEN_OUT			! output AC name length
	INTEGER*4	CODE_IN			! input AC code
C
C Common Blocks
C
	INCLUDE 'LSL$CMNFRT:FRTACD.CMN'		! FRTLIB ACD interface
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
C
C Functions called
C
	LOGICAL		ACDFND			! get AC definition from code
C
C------------------------------------------------------------------------------
C Assume success
C
	GET_AC_NAME = LSL__NORMAL
C
C Find the given code in the ACD table
C
	IF ( ACDFND(CODE_IN,) ) THEN
	   CALL LSL_ADDMSG(MD2I__UNKATTCODE,CODE_IN)
	   LSL_STATUS = MD2I__UNKATTCODE		! reset status
	   GOTO 9999
	ENDIF
C
C and set the AC name and length
C
	NAME_OUT = ACD_NAME
	LEN_OUT  = ACD_NAME_LEN
C
	GOTO 10000
C
C Failure
C
9999	GET_AC_NAME = LSL_STATUS
C
C------------------------------------------------------------------------------
C Return
C
10000	RETURN
	END
