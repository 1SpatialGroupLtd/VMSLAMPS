	SUBROUTINE COORD( X, Y, Z )
C
CDEC$	IDENT	'07FE90'
C
C Copyright (C) Laser-Scan Ltd, Cambridge, England
C
C	Created					JMC	12-Jan-1990
C
C	CONVERT SIF2IFF Utility
C
C Description 
C
C Add coordinate points to the output list 
C
	IMPLICIT NONE
C
C arguments
C
	REAL*8		X	! X coordinate
	REAL*8		Y	! Y coordinate
	REAL*8		Z	! Z coordinate
C
C common blocks
C
	INCLUDE	'CMN:SIF2IFFMSG.PAR'	! 
	INCLUDE	'CMN:SIF2IFF.CMN'	! 
	INCLUDE	'CMN:FLAGS.CMN'	! 
	INCLUDE	'CMN:IFF_FEATURE.CMN'	! 
	INCLUDE	'CMN:IFF_MAP.CMN'	! for the range
	INCLUDE	'CMN:IFF_POINTS.CMN'	! for the points
C
C local variables
C
	REAL*4	XNEW, YNEW ,ZNEW	! co-ords relative to new origin
C
C *********************************************************************
C do we have room for this point?
C
	IF ( ZSPTR.GE.200 ) CALL FLUSH
C
C subtract the origin offset
C
	XNEW = X - XOFF
	YNEW = Y - YOFF
	ZNEW = Z - ZOFF
C
C check if this point is the first, and if not if it is the same
C as the last one - we don't want to duplicate points
C
	IF (DONE_ZS .OR. (ZSPTR.GT.0)) THEN
	   IF (XNEW.EQ.ZSBUF(1,ZSPTR).AND.YNEW.EQ.ZSBUF(2,ZSPTR).AND.
     &	       ZNEW.EQ.ZSBUF(3,ZSPTR)) 
     &		GO TO 999
	ENDIF
C
C so we can now add this new point to our output list
C
	ZSPTR = ZSPTR+1
	ZSBUF(1,ZSPTR) = XNEW
	ZSBUF(2,ZSPTR) = YNEW
	ZSBUF(3,ZSPTR) = ZNEW
C
C and check the range
C
	IF ( ZSBUF(1,ZSPTR).GT.RANGE(X_MAX) ) THEN 
              RANGE(X_MAX) = ZSBUF(1,ZSPTR)
	ENDIF
	IF ( ZSBUF(1,ZSPTR).LT.RANGE(X_MIN) ) 
     &				RANGE(X_MIN) = ZSBUF(1,ZSPTR)
	IF ( ZSBUF(2,ZSPTR).GT.RANGE(Y_MAX) ) 
     &				RANGE(Y_MAX) = ZSBUF(2,ZSPTR)
	IF ( ZSBUF(2,ZSPTR).LT.RANGE(Y_MIN) ) 
     &				RANGE(Y_MIN) = ZSBUF(2,ZSPTR)
C	IF ( ZSBUF(3,ZSPTR).GT.RANGE(Z_MAX) ) 
C     &				RANGE(Z_MAX) = ZSBUF(3,ZSPTR)
C	IF ( ZSBUF(3,ZSPTR).LT.RANGE(Z_MIN) ) 
C     &				RANGE(Z_MIN) = ZSBUF(3,ZSPTR)
C
C that's all
C
999	RETURN
	END
