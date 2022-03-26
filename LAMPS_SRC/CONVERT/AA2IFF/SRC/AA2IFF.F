	PROGRAM AA2IFF
CDEC$	IDENT	'18AP91'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jun-1990	John Cadogan
C	Mod					09-Apr-1991	Jon Barber
C
C Description:
C
C	Conversion for AA MAP format - AA ASCII format to IFF
C
	IMPLICIT	NONE
C
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE 'CMN:FILE.CMN'
C
	INTEGER		OBEY
	INTEGER		STATUS
C
C-------------------------------------------------------------------------------
C
	CALL LSL_INIT		! Initialise LSLLIB
C
	STATUS = OBEY()		! decode command line
	IF (.NOT.STATUS) GOTO 999
C
	CALL PROCESS		! do the conversion
C
999	CALL LSL_EXIT(STATUS)
	END
C
