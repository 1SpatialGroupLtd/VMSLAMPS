	PROGRAM 	AAGAZ2IFF
CDEC$	IDENT	'17AP91'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jun-1990	John Cadogan
C
C Description:
C
C	Conversion for AA benchmark - AA ascii format to IFF
C
	IMPLICIT	NONE
C
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE 'CMN:FILE.CMN'
C
	LOGICAL		GAZOBEY
	INTEGER		STATUS
C
C-------------------------------------------------------------------------------
C
	CALL LSL_INIT		! Initialise LSLLIB
C
	STATUS = GAZOBEY()		! decode command line
	IF (.NOT.STATUS) GOTO 999
C
	CALL CONGAZ		! do the conversion
C
	CALL IFFCLO(IFFLUN)     ! Close IFF file
C
999	CALL LSL_EXIT(STATUS)
	END
C
