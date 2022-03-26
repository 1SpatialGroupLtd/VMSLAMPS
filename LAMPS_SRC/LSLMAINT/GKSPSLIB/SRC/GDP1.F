C
C***********************************************************************
C
C	GDP PRIMITIVE
C	=============
C
	SUBROUTINE	GGDP(N,PX,PY,ID)
C
CDEC$	IDENT	'21JA94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Ron Russell	16-July-1987
C
C GENERALISED DRAWING PRIMITIVE
C
	IMPLICIT NONE
C
C Arguments:
	INTEGER N			! number of points
	REAL	PX(N)			! X coords of points in WC
	REAL	PY(N)			! Y coords of points in WC
	INTEGER	ID			! GDP identifier
C
C Workspace
	INTEGER	I
	REAL	QX(3),QY(3)
	REAL	PX1,PX2,PY1,PY2		! X and Y coordinates
	REAL	CURX,CURY		! current position
	LOGICAL	LOOP,VIS,CLIP
C
	INCLUDE	'GKSDAT1.CMN'
C
C Functions:
	LOGICAL	GKCLIP			! clips a straight line to
					! rectangular boundaries
C
	IF ((ID.LE.0.OR.ID.GT.3).AND.(ID.NE.6)) THEN
	   CALL GKSERR(102,'GGDP')
	   GOTO 9999
	ENDIF
	IF ((ID.EQ.1.AND.N.NE.2).OR.
     &	    ((ID.EQ.2.OR.ID.EQ.3).AND.N.NE.3).OR.
     &	    (ID.EQ.6.AND.N.LT.2)) THEN
	   CALL GKSERR(100,'GGDP')
	   GOTO 9999
	ENDIF
C
C Is this workstation active?
	IF (.NOT.WSACT) GOTO 100
C
C Make sure transformation is up to date
	IF (UPTRN) CALL GUPTRN
C
C Is everything clipped ?
	IF (CLPALL) GOTO 100
C
	IF (ID.NE.6) THEN		! circle
C
C Loop for each point
	   DO 90 I = 1, N
	      QX(I) = PX(I)
	      QY(I) = PY(I)
	      IF (ENCLIP) THEN
	         IF (QX(I).LT.CLIPLO(1).OR.QX(I).GT.CLIPHI(1) .OR.
     &		     QY(I).LT.CLIPLO(2).OR.QY(I).GT.CLIPHI(2) ) GOTO 100
	      ENDIF
C transform World Coordinates to Workstation Device Coordinates
	      QX(I) = (QX(I)*SCALEX)+OFFX
	      QY(I) = (QY(I)*SCALEY)+OFFY
90	   CONTINUE
C
C Make sure polyline attributes are up to date
	   IF (UPLIN) CALL GUPLIN
C
C Draw the circle or arc
C
	   CALL PS_CIRCLE(QX,QY,ID)
C
	ELSE				! curve
C
	   VIS = .TRUE.
	   LOOP = .TRUE.
C
C Check whether we have a closed loop - assume not if clipped anywhere
	   IF (ENCLIP) THEN
C
	      VIS = .FALSE.
	      DO 85 I = 1, N-1
	         PX1 = PX(I)
	         PY1 = PY(I)
	         PX2 = PX(I+1)
	         PY2 = PY(I+1)
	         IF (GKCLIP(PX1,PY1,PX2,PY2)) THEN
	            LOOP = .FALSE.	! definitely not loop
	            GOTO 85
	         ENDIF
	         VIS = .TRUE.		! some of it visible
	         IF (PX1.NE.PX(I).OR.PY1.NE.PY(I).OR.
     &		     PX2.NE.PX(I+1).OR.PY2.NE.PY(I+1)) THEN
	            LOOP = .FALSE.	! definitely not loop
	            GOTO 86
	         ENDIF
85	      CONTINUE
	   ENDIF
86	   IF (.NOT.VIS) GOTO 100	! completely clipped
	   CLIP = .NOT.LOOP		! is it clipped at all?
	   IF (LOOP) LOOP = (PX(1).EQ.PX(N).AND.PY(1).EQ.PY(N))
C
C Make sure polyline attributes are up to date
	   IF (UPLIN) CALL GUPLIN
C
C unset current position to force move
	   CURX = 1E38
	   CURY = 1E38
C
C Loop for each segment of this polyline.
	   DO 95 I = 1, N-1
	      PX1 = PX(I)
	      PY1 = PY(I)
	      PX2 = PX(I+1)
	      PY2 = PY(I+1)
	      IF (CLIP) THEN
	         IF (GKCLIP(PX1,PY1,PX2,PY2)) GOTO 95
	      ENDIF
C transform World Coordinates to Workstation Device Coordinates
	      PX1 = (PX1*SCALEX)+OFFX
	      PX2 = (PX2*SCALEX)+OFFX
	      PY1 = (PY1*SCALEY)+OFFY
	      PY2 = (PY2*SCALEY)+OFFY
	      IF (PX1.NE.CURX.OR.PY1.NE.CURY) THEN
	         IF (I.GT.1) CALL PS_END_CURVE
	         CALL PS_BEGIN_CURVE(PX1,PY1,LOOP)
	      ENDIF
	      CALL PS_CURVE(PX2,PY2)	! draw curve
	      CURX = PX2		! update current position
	      CURY = PY2
95	   CONTINUE
	   CALL PS_END_CURVE
	ENDIF
C
	IF (DEFER .EQ. GASAP) CALL GUWK(WKIDS,0)
100	CONTINUE
C
9999	RETURN
	END
