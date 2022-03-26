	INTEGER*4 FUNCTION OPEN_MD
C
CDEC$	IDENT	'22SE94'
C
C	Copyright (C) Laser-Scan Ltd., Cambridge, England.
C
C	Created						RJH	22-Sep-1994
C
C	CONVERT I2MAPDATA Utility - Open MAPDATA File
C
C Description
C
C	Opens the output MAPDATA file for writing.
C
C	Returns the error code held in LSL_STATUS if something goes wrong,
C	LSL__NORMAL otherwise.
C
	IMPLICIT NONE
C
C Parameter Files
C
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB message definitions
	INCLUDE	'CMN:I2MAPDATAMSG.PAR'		! message definitions
	INCLUDE	'CMN:LUN.PAR'			! logical unit numbers
C
C Common Blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'   	! LSLLIB filename expansion
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'		! LSLLIB status flag
	INCLUDE	'CMN:FILES.CMN'      		! filenames
	INCLUDE	'CMN:CONTROL.CMN'      		! control variables
C
C Functions called
C
	INTEGER*4	FLWOPN			! open file for writing
C
C Local Variables
C
	INTEGER*4	ERRCOD			! LSLLIB error code
	INTEGER*4	RETCOD			! system error code
C
C Assume success
C
	OPEN_MD = LSL__NORMAL
C
C Open the MAPDATA file for writing
C
	ERRCOD = FLWOPN(MAPLUN,MAPFIL(1:MAPLEN),RETCOD)
C
	IF (.NOT. ERRCOD) THEN
	   CALL LSL_PUTMSG(I2MD__ERROPNMAP,MAPFIL(1:MAPLEN))
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSOPEN) CALL LSL_ADDMSG(RETCOD)
	   GOTO 9999
	ELSE IF (HAD_LOG) THEN
	   CALL LSL_PUTMSG(I2MD__MAPOPENED,MAPFIL(1:MAPLEN))
	ENDIF
C
	GOTO 10000
C
C Failure
C
9999	OPEN_MD = LSL_STATUS
C
C Return
C
10000	RETURN
	END
