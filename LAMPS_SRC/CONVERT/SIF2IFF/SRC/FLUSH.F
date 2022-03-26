	SUBROUTINE 	FLUSH
C
CDEC$	IDENT	'31JA90'
C
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created			12-Jan-1990			J.M. Cadogan
C
C Description:
C
C	Flush the coordinate buffer
C
	IMPLICIT	NONE
C
C common blocks
C
	INCLUDE	'CMN:SIF2IFF.CMN'		! globals
	INCLUDE	'CMN:IFF_FEATURE.CMN'		! feature data
	INCLUDE	'CMN:IFF_POINTS.CMN'		! coordinate data
C
C workspace
C
	INTEGER*2	IENDS
	INTEGER		I,J			! loop counters
C
C-------------------------------------------------------------------------------
C
C if the buffer is empty, then RETURN at once, doing nothing
C
	IF ( ZSPTR.GT.0 ) THEN
C
C	 if we have not yet output the information that goes before the
C	 first ZS, output it now
C
	   IF (.NOT.DONE_START_FEATURE) CALL START_FEATURE
C
C	 and work out whether we are drawing through the ZS break
C
	   IF ( PEN_UP ) THEN
	      IENDS = 0		! pen up to the ZS
	   ELSE
	      IENDS = 1		! pen down to the ZS
	   ENDIF
C
C	 output any data we may have in our buffer
C
C For STs copy the ZS buffer to ST buffer
C
	   IF (DIMEN.EQ.2) THEN
	      DO 100 I = 1,2
	         DO 200 J = 0,ZSPTR
		    STBUF(I,J) = ZSBUF(I,J)
200		 CONTINUE		 
100	      CONTINUE		 
	      STPTR = ZSPTR
	      CALL IFFST( STBUF(1,1), STPTR, IENDS )
	   ELSE
	      CALL IFFZS( ZSBUF(1,1), ZSPTR, IENDS )
	   ENDIF
C
C	 set the continuity point
C
	   ZSBUF(1,0) = ZSBUF(1,ZSPTR)
	   ZSBUF(2,0) = ZSBUF(2,ZSPTR)
	   ZSBUF(3,0) = ZSBUF(3,ZSPTR)
	   ZSPTR = 0
C
C	 and signal that we've output an ZS for this feature
C
	   DONE_ZS = .TRUE.
C
C	 assume that we will be drawing through the next ZS break
C
	   PEN_UP = .FALSE.
C
	ENDIF
C
	RETURN
	END
