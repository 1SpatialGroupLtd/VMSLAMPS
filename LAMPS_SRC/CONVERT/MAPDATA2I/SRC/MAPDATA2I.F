	PROGRAM MAPDATA2I
C
CDEC$	IDENT	'23SE94'
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created					11-Jun-1990	John Cadogan
C	Mod					09-Apr-1991	Jon Barber
C	Turned into MAPDATA2I from AA2IFF	01-Sep-1994	Steve Townrow
C
C Description:
C
C	Conversion from MAPDATA format to LSL IFF
C
	IMPLICIT	NONE
C
	INTEGER		OBEY
	INTEGER		STATUS
C
C------------------------------------------------------------------------------
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
