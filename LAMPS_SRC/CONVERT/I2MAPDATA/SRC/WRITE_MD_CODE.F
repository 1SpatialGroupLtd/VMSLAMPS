	SUBROUTINE WRITE_MD_CODE(WHICH_CODE)
C
CDEC$	IDENT	'12OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created 					RJH	26-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Write a MAPDATA CODE entry
C
C Description
C
C	Writes the CODE entry for the current segment to the MAPDATA output
C	file.
C
C       Assumes the MAPDATA output file is already selected for writing.
C
	IMPLICIT NONE
C
C Arguments
C
	CHARACTER*(*)		WHICH_CODE	! MAPDATA code
C
C Functions
C
	INTEGER*4		SIGCHS
C
C Local variables
C
	CHARACTER*7		MDCHAR		! MapData feature code
	BYTE			MDCODE(7)	! MapData FC as byte array
	EQUIVALENCE		(MDCHAR,MDCODE)
C
C------------------------------------------------------------------------------
C Clear the byte array
C
	CALL VIOCLR(MDCODE,7,0)
	MDCHAR(1:SIGCHS(WHICH_CODE)) = WHICH_CODE
C
C Just write the CODE entry.
C
	CALL FLWRTF('CODE %A',MDCODE)
C
C Return
C
10000	RETURN
	END
