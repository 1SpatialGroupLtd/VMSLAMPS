	SUBROUTINE PATCH_HEADER()
C
CDEC$	IDENT	'12DE91'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	12-Dec-1991
C
C Description:
C       Routine to insert various fields into the first and second sectors
C       of the first DIGIT block, just before writing it to tape
C
        IMPLICIT NONE
C
C Parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE 'CODES.CMN'
C
C Common Blocks
C
	INCLUDE	'GENERAL.CMN'			! General stuff
C
C Local Variables
C
	INTEGER*2	SECTOR_COUNT
C
C------------------------------------------------------------------------------
C
C Calculate sector count
C
	IF (MOD(TOTBUFSIZE,DIGITSECSIZE).EQ.0) THEN
	   SECTOR_COUNT = TOTBUFSIZE/DIGITSECSIZE
	ELSE
	   SECTOR_COUNT = TOTBUFSIZE/DIGITSECSIZE + 1
	ENDIF
C
C We don't care about DISKBUFPTR now so we can use it for inserting the fields
C The size we change DISKBUFPTR to will never force a flush
C
	DISKBUFPTR = 2
	CALL ADD_WORD(SECTOR_COUNT)
	DISKBUFPTR = 15
	CALL ADD_WORD(SECTOR_COUNT-1)
	DISKBUFPTR = 134
	CALL ADD_WORD(HEIGHT)		! height
	CALL ADD_WORD(WIDTH)		! width
	CALL ADD_WORD(RESOLUTION)	! resolution
	CALL ADD_WORD(OFFSET(2))	! min Y reference point
	CALL ADD_WORD(OFFSET(1))	! min X reference point
	CALL ADD_WORD(OFFSET(2)+HEIGHT)	! max Y reference point
	CALL ADD_WORD(OFFSET(1)+WIDTH)	! max X reference point
C
	RETURN
	END
