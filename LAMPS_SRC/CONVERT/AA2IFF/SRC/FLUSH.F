	SUBROUTINE 	FLUSH
C
CDEC$	IDENT	'15NO89'
C
C
C	Copyright (C)				Laser-Scan Ltd., Cambridge
C	Created			9-Nov-1989			A.P.Brown
C
C Description:
C
C	Flush the coordinate buffer
C
	IMPLICIT	NONE
C
C common blocks
C
	INCLUDE	'CMN:IFF.CMN'
C
C workspace
C
	INTEGER*2	IENDS
C
C-------------------------------------------------------------------------------
C
C if the buffer is empty, then RETURN at once, doing nothing
C
	IF ( STPTR.GT.0 ) THEN
C
C	 if we have not yet output the information that goes before the
C	 first ST, output it now
C
	   IF (.NOT.DONE_START_FEATURE) CALL START_FEATURE
C
C	 and work out whether we are drawing through the ST break
C
	   IF ( PEN_UP ) THEN
	      IENDS = 0		! pen up to the ST
	   ELSE
	      IENDS = 1		! pen down to the ST
	   ENDIF
C
C	 output any data we may have in our buffer
C
	   CALL IFFST( STBUF(1,1), STPTR, IENDS )
C
C	 set the continuity point
C
	   STBUF(1,0) = STBUF(1,STPTR)
	   STBUF(2,0) = STBUF(2,STPTR)
	   STPTR = 0
C
C	 and signal that we've output an ST for this feature
C
	   DONE_ST = .TRUE.
C
C	 assume that we will be drawing through the next ST break
C
	   PEN_UP = .FALSE.
C
	ENDIF
C
	RETURN
	END
