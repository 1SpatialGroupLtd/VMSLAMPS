	SUBROUTINE PROCESS
C
CDEC$	IDENT	'27SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created 					RJH	22-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Process IFF file
C
C Description
C
C	Processes the IFF file, writing the appropriate entries to the MAPDATA
C       output file as it goes along.
C
	IMPLICIT NONE
C
C Common Blocks
C
	INCLUDE 'CMN:CONTROL.CMN'		! control variables
C
C Just write some entries for now
C
	CALL WRITE_MD_HEAD
	CALL WRITE_MD_SEG(1,'--')
	CALL WRITE_MD_CODE('25.61')
	CALL WRITE_MD_COORD(113.963,117.704,0.0,'    ','    ')
	CALL WRITE_MD_COORD(113.910,117.626,0.0,'    ','    ')
	CALL WRITE_MD_SEG(5,'This is a text string')
	CALL WRITE_MD_CODE('35.61')
	CALL WRITE_MD_COORD(113.963,117.704,0.0,'    ','H   ')
	CALL WRITE_MD_COORD(114.007,117.363,0.0,'    ','L   ')
	CALL WRITE_MD_COORD(114.008,117.747,0.0,'    ','C   ')
	CALL WRITE_MD_COORD(114.009,117.843,0.0,'    ','    ')
	CALL WRITE_MD_COORD(114.019,117.878,0.0,'C   ','H   ')
	CALL WRITE_MD_COORD(114.017,117.388,0.0,'C   ','L   ')
C
C Return
C
10000	RETURN
	END
