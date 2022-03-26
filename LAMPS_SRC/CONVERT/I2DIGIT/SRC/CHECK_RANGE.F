	LOGICAL FUNCTION CHECK_RANGE(X,Y,FSN)
C
CDEC$	IDENT	'13DEC91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	13-Dec-1991
C
C Description:
C
C	Module CHECK_RANGE called by I2DIGIT in package CONVERT.
C	Modifies MIN/MAX X and Y if X,Y of point lies outside
C
        IMPLICIT NONE
C
C Parameters
C
	INCLUDE	'I2DIGITMSG.PAR'		! I2DIGIT messages
C
C Common blocks
C
	INCLUDE	'GENERAL.CMN'		! Globals
C
C Arguments
C
	INTEGER*4	STATUS
	INTEGER*4	X,Y
	INTEGER*2	FSN
C
C------------------------------------------------------------------------------
C
	STATUS = .TRUE.
C
	IF (X.GT.32767 .OR. X.LT.1) THEN
	   CALL LSL_PUTMSG(I2DIGIT__OUTOFRANGE,FSN)
	   STATUS = .FALSE.
	   GOTO 999
	ENDIF
	IF (Y.GT.32767 .OR. Y.LT.1) THEN
	   CALL LSL_PUTMSG(I2DIGIT__OUTOFRANGE,FSN)
	   STATUS = .FALSE.
	   GOTO 999
	ENDIF
	MINX = MIN(X,MINX)
	MAXX = MAX(X,MAXX)
	MINY = MIN(Y,MINY)
	MAXY = MAX(Y,MAXY)
C
999	CHECK_RANGE = STATUS
	RETURN
	END
