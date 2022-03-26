	SUBROUTINE	GKS_CLIP_AREA(NPTS,COMP,NCOMP)
C
CDEC$	IDENT	'23FE94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-Jan-1991
C
C Clip fill area
C
	IMPLICIT NONE
C
	INCLUDE	'GFABUF.CMN'
C
C Arguments
	INTEGER	NPTS
	LOGICAL	COMP		! composite area
	INTEGER	NCOMP		! number of components if COMP
C
C call the routine that does the work, passing the workspace arrays
C
	CALL GKS_CLIP_AREA_SUB(NPTS,COMP,NCOMP,GFAMAX,GFASCT,
     &	                       %VAL(PTS_ADDR),
     &	                       %VAL(SIDPTR_ADDR),
     &	                       %VAL(PTX_ADDR),
     &	                       %VAL(PTY_ADDR),
     &	                       %VAL(PPTR_ADDR),
     &	                       %VAL(POLPTR_ADDR),
     &	                       %VAL(NEWPOL_ADDR),
     &	                       %VAL(INTPT_ADDR))
	RETURN
	END


	SUBROUTINE     	GKS_CLIP_AREA_SUB(NPTS,COMP,NCOMP,GFAMAX,GFASCT,
     &	                                  PTS,SIDPTR,PTX,PTY,PPTR,
     &	                                  POLPTR,NEWPOL,INTPT)
C
CDEC$	IDENT	'21FE92'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England.
C
C Created				Clarke Brunt	26-Jan-1991
C
C Clip fill area
C
	IMPLICIT NONE
C
	INCLUDE	'GKSDAT1.CMN'
	INCLUDE	'GFADAT1.CMN'
C
C Points are in PTS(1/2,NPTS), CLIPLO/CLIPHI are limits
C Max size of PTS is GFAMAX
C
C Arguments
	INTEGER	NPTS
	LOGICAL	COMP		! composite area?
	INTEGER	NCOMP		! number of components if COMP
	INTEGER	GFAMAX		! maximum number of points in an area
	INTEGER	GFASCT		! maximum number of intersections
	REAL	PTS(2,GFAMAX)	! buffer array
	INTEGER	SIDPTR(GFAMAX)	! points in each components
	REAL 	PTX(GFAMAX)	! X array
	REAL 	PTY(GFAMAX)	! Y array
	INTEGER	PPTR(2,GFAMAX)	! pointers
	INTEGER	POLPTR(GFASCT)
	INTEGER	NEWPOL(GFASCT)
	INTEGER	INTPT(GFASCT)
C
C Functions used
	INTEGER	GKS_CLIP_POLY
C
C Internal variables
	INTEGER	I,J,K,FIRST,KTOT
	INTEGER	NPOLY
	LOGICAL	DOCOMP
C
C if a composite area, and attempting to miss out the invisibles
C in PostScript, then form separate polygons for each component
	DOCOMP = COMP.AND.FILLIV.AND.NCOMP.LE.GFASCT
	IF (DOCOMP) THEN
	   K = 1
	   DO 8 J=1,NCOMP
	      DO 6 I=K,K+SIDPTR(J)-1
	         PPTR(1,I) = I+1
	         PPTR(2,I) = I-1
6	      CONTINUE
	      PPTR(1,K+SIDPTR(J)-1) = K
	      PPTR(2,K) = K+SIDPTR(J)-1
	      POLPTR(J) = K
	      K = K+SIDPTR(J)
8	   CONTINUE
C
C This describes NCOMP polygons
	   NPOLY = NCOMP
	ELSE
C
C Point each point to its next and previous, and loop back to start
	   DO 10 I=1,NPTS
	      PPTR(1,I) = I+1
	      PPTR(2,I) = I-1
10	   CONTINUE
	   PPTR(1,NPTS) = 1
	   PPTR(2,1) = NPTS
C
C This describes one polygon
	   NPOLY = 1
	   POLPTR(1) = 1
	ENDIF
C
C Clip to 4 limits
	IF (GKS_CLIP_POLY(CLIPLO(1),1,1,
     &	 NPOLY,GFASCT,POLPTR,NEWPOL,NPTS,GFAMAX,PTS,PPTR,GFASCT,INTPT
     &		).EQ.0) GOTO 999
	IF (GKS_CLIP_POLY(CLIPLO(2),2,1,
     &	 NPOLY,GFASCT,POLPTR,NEWPOL,NPTS,GFAMAX,PTS,PPTR,GFASCT,INTPT
     &		).EQ.0) GOTO 999
	IF (GKS_CLIP_POLY(CLIPHI(1),1,-1,
     &	 NPOLY,GFASCT,POLPTR,NEWPOL,NPTS,GFAMAX,PTS,PPTR,GFASCT,INTPT
     &		).EQ.0) GOTO 999
	IF (GKS_CLIP_POLY(CLIPHI(2),2,-1,
     &	 NPOLY,GFASCT,POLPTR,NEWPOL,NPTS,GFAMAX,PTS,PPTR,GFASCT,INTPT
     &		).EQ.0) GOTO 999
C
C draw polygons
	IF (DOCOMP) THEN
	   CALL PS_BEGIN_AREA
	ENDIF
	KTOT = 0
	DO 200 I=1,NPOLY
	   FIRST = POLPTR(I)
	   J = FIRST
	   K = 0
C
C back into straight arrays
100	   K = K+1
	   PTX(K) = PTS(1,J)
	   PTY(K) = PTS(2,J)
	   J = PPTR(1,J)
	   IF (J.NE.FIRST) GOTO 100
C
C fill the area
	   IF (.NOT.DOCOMP) THEN
	      CALL PS_BEGIN_AREA
	   ENDIF
C
C NB the number of points was less than HWFMAX when we were called,
C so pretty unfortunate if it has grown. If we end up just outlining,
C (first arg to PS_FLUSH) then should do SET_AREA_COLOUR = .FALSE.
C for benefit of AI format. If doing components, then should be
C using KTOT, but don't know it yet. In any case, components won't
C work in AI format, so don't bother.
	   IF (K.GE.HWFMAX) SET_AREA_COLOUR = .FALSE.
	   CALL GFAIPL(1,K,PTX,PTY)
	   KTOT = KTOT+K
	   IF (.NOT.DOCOMP) THEN
	      CALL PS_END_AREA
	      CALL PS_FLUSH((K.LT.HWFMAX),.FALSE.)
	   ENDIF
200	CONTINUE
	IF (DOCOMP) THEN
	   CALL PS_END_AREA
	   CALL PS_FLUSH((KTOT.LT.HWFMAX),.FALSE.)
	ENDIF
C
999	RETURN
	END
