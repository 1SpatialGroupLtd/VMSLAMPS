	SUBROUTINE WRITE_MD_HEAD
C
CDEC$	IDENT	'12OC94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created 					RJH	22-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Write the MAPDATA header
C
C Description
C
C	Writes a header to the MAPDATA output file. The header consists of
C	two blank lines followed by third containing arbitrary values in the
C	specified format.
C
C       Assumes the MAPDATA output file is already selected for writing.
C
	IMPLICIT NONE
C
C Just write the three lines.
C
	CALL FLWRTF
	CALL FLWRTF
	CALL FLWRTF('     100.000     100.000  0.01')
C
C Return
C
10000	RETURN
	END
