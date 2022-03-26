	LOGICAL FUNCTION COORD( X, Y, Z )
CDEC$	IDENT	'23SE94'
C
C Copyright (C) Laser-Scan Ltd, Cambridge, England
C
C	Created					ST	23-Sep-1994
C
C	CONVERT MAPDATA2I Utility
C
C Description 
C
C Add coordinate points to the output list PTS
C
	IMPLICIT NONE
C
C arguments
C
	REAL*4		X	! X coordinate
	REAL*4		Y	! Y coordinate
	REAL*4		Z	! Z coordinate
C
C common blocks
C
	INCLUDE	'CMN:LINES.CMN'
	INCLUDE	'CMN:IFF.CMN'	
C
C Functions
C
	LOGICAL		OVER_LIMIT	! Check if we overflow our buffer
C
C local variables
C
	REAL*4	XNEW, YNEW ,ZNEW	! co-ords relative to new origin
C
C------------------------------------------------------------------------------
C
	COORD = .TRUE.
C
C subtract the origin offset
C
	XNEW = X*SCALE_FACTOR - XOFF
	YNEW = Y*SCALE_FACTOR - YOFF
	ZNEW = Z
C
C Check for duplicate points
C
	IF (NPTS.GT.0) THEN
	   IF (XNEW.EQ.PTS(1,NPTS) .AND. YNEW.EQ.PTS(2,NPTS)) GOTO 999
	ENDIF
C
C Use first coordinate to start off the range
C
	IF (.NOT.HAD_RANGE_SET) THEN
	   RANGE(X_MIN) = XNEW
	   RANGE(X_MAX) = XNEW
	   RANGE(Y_MIN) = YNEW
	   RANGE(Y_MAX) = YNEW
	   HAD_RANGE_SET = .TRUE.
	ENDIF
C
C so we can now add this new point to our output list
C
	NPTS = NPTS + 1
	COORD = .NOT.OVER_LIMIT(NPTS)
	IF (.NOT.COORD) GOTO 999
C
	PTS(1,NPTS) = XNEW
	PTS(2,NPTS) = YNEW
	PTS(3,NPTS) = ZNEW
C
C and check the range
C
	IF (XNEW.GT.RANGE(X_MAX)) THEN
	   RANGE(X_MAX) = XNEW
	ELSEIF (XNEW.LT.RANGE(X_MIN)) THEN
	   RANGE(X_MIN) = XNEW
	ENDIF
C
	IF (YNEW.GT.RANGE(Y_MAX)) THEN
	   RANGE(Y_MAX) = YNEW
	ELSEIF (YNEW.LT.RANGE(Y_MIN)) THEN
	   RANGE(Y_MIN) = YNEW
	ENDIF
C
C------------------------------------------------------------------------------
C that's all
C
999	RETURN
	END
C
