	SUBROUTINE WRITE_MD_SEG(WHICH_SEG,TEXT_STRING)
C
CDEC$	IDENT	'27SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created 					RJH	26-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Write a MAPDATA SEGMENT entry
C
C Description
C
C	Writes a SEGMENT entry to the MAPDATA output file. The SEGMENT entry
C	includes a text string in the attribute field after the segment number.
C
C       Assumes the MAPDATA output file is already selected for writing.
C
	IMPLICIT NONE
C
C Arguments
C
	INTEGER*4	WHICH_SEG	! segment number
	CHARACTER*(*)	TEXT_STRING	! text string for attribute field
C
C Just write the SEGMENT entry, including the text string.
C
	CALL FLWRTF('SEGMENT %N  **  %S  **',WHICH_SEG,TEXT_STRING)
C
C Return
C
10000	RETURN
	END
