	PROGRAM MOBILE
CDEC$	IDENT	'24AP91'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Mod					09-Apr-1991	Jon Barber
C
C Description:
C
C	Conversion for Mobile format to TEXT for IFROMTEXT
C
	IMPLICIT	NONE
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
