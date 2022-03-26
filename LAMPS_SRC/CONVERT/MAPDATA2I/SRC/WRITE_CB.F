	LOGICAL FUNCTION WRITE_CB
CDEC$	IDENT	'11OC94'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C
C       Author				Steve Townrow	26-Jul-1994
C
C Description:
C       Writes the points out into CB blocks of 200. The points should be in
C       LINE_IN. This routine will force GT 6's to have corners (option
C       CURVE in parameter file) and STRAIGHT and UNDEFINED will have their
C       points copied across into this array.
C
C
	IMPLICIT	NONE
C
C common blocks
C
	INCLUDE 'CMN:MAPDATA2IMSG.PAR'
	INCLUDE 'CMN:LINES.CMN'
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'
	INCLUDE 'LSL$CMNIFF:CB.STR'
C
C Functions
C
	LOGICAL		OVER_LIMIT	! Check if we overflow our buffer
C
C workspace
C
	RECORD	/IFF_CBH/ CBH
	RECORD	/IFF_CBD/ CBD
C
	INTEGER*4	OUTBUF(1000)	! allow for 5 dimensions * 200 pts
	INTEGER*4	OUTCOLS
	INTEGER*4	TEMPINT
	REAL*4		TEMPREAL
	CHARACTER*4	TEMPCHAR
	EQUIVALENCE	(TEMPINT,TEMPREAL,TEMPCHAR)
	INTEGER*4	I,J
	LOGICAL		OK
	LOGICAL		CURVE,PREV_CURVE
	REAL*4		PREV_PT(3),NEW_PT(3)
C
C------------------------------------------------------------------------------
C
	WRITE_CB = .TRUE.
C
C Curve sections have new points inserted to constrain the corners and
C straight sections
C
	IF (INTERP(FC_INDEX).EQ.INTERP_CURVE) THEN
	   NUM_IN = 0
	   DO 50 I = 1, NUM_OUT
C
C If the second point is curved and we are dealing with the first then we
C don't want an inserted point near the first.
C
	      IF (((LINE_OUT_FLAGS(2).AND.'0004'X).EQ.4).AND.I.EQ.1) THEN
		 NUM_IN = 1
		 LINE_IN(1,NUM_IN) = LINE_OUT(1,1)
		 LINE_IN(2,NUM_IN) = LINE_OUT(2,1)
		 LINE_IN_Z(NUM_IN) = LINE_OUT_Z(1)
		 LINE_IN_FLAGS(NUM_IN) = LINE_OUT_FLAGS(1)
		 GOTO 50
	      ENDIF
C
C Is the current point a straight section?
C
	      IF ((LINE_OUT_FLAGS(I).AND.'0004'X).NE.4) THEN
C
C Don't create a point previous to first point as there isn't one!
C
		 IF (I.GT.1) THEN
		    PREV_PT(1) = LINE_OUT(1,I-1)
		    PREV_PT(2) = LINE_OUT(2,I-1)
		    PREV_PT(3) = LINE_OUT_Z(I-1)
C
C Generate point before current point
C
		    CALL INSERT_CONTROL_PT(PREV_PT(1),PREV_PT(2),PREV_PT(3),
     &			 LINE_OUT(1,I),LINE_OUT(2,I),
     &			 LINE_OUT_Z(I),NEW_PT)
		    NUM_IN = NUM_IN + 1
		    WRITE_CB = .NOT.OVER_LIMIT(NUM_IN)
		    IF (.NOT.WRITE_CB) GOTO 999
		    LINE_IN(1,NUM_IN) = NEW_PT(1)
		    LINE_IN(2,NUM_IN) = NEW_PT(2)
		    LINE_IN_Z(NUM_IN) = NEW_PT(3)
C
C Make it an interpolated point (with `I' flag)
C
		    LINE_IN_FLAGS(NUM_IN)='0008'X
C
C If two adjacent points have 'L' flag, then interpolated point should also
C have it.
C
		    IF (((LINE_OUT_FLAGS(I-1).AND.'0002'X).EQ.2).AND.
     &			 ((LINE_OUT_FLAGS(I)  .AND.'0002'X).EQ.2)) THEN
		       LINE_IN_FLAGS(NUM_IN)=LINE_IN_FLAGS(NUM_IN).OR.'0002'X
		    ENDIF
C
C If two adjacent points have 'H' flag, then interpolated point should also
C have it.
C
		    IF (((LINE_OUT_FLAGS(I-1).AND.'0001'X).EQ.1).AND.
     &			 ((LINE_OUT_FLAGS(I)  .AND.'0001'X).EQ.1)) THEN
		       LINE_IN_FLAGS(NUM_IN)=LINE_IN_FLAGS(NUM_IN).OR.'0001'X
		    ENDIF
		 ENDIF
C
C Copy over current point
C
		 NUM_IN = NUM_IN + 1
		 WRITE_CB = .NOT.OVER_LIMIT(NUM_IN)
		 IF (.NOT.WRITE_CB) GOTO 999
		 LINE_IN(1,NUM_IN) = LINE_OUT(1,I)
		 LINE_IN(2,NUM_IN) = LINE_OUT(2,I)
		 LINE_IN_Z(NUM_IN) = LINE_OUT_Z(I)
		 LINE_IN_FLAGS(NUM_IN)=LINE_OUT_FLAGS(I)
C
C Don't generate a new point for the last point
C
		 IF (I.LT.NUM_OUT) THEN
C
C Generate point after current point
C
		    CALL INSERT_CONTROL_PT(LINE_OUT(1,I+1),LINE_OUT(2,I+1),
     &			 		   LINE_OUT_Z(I+1),
     &			 		   LINE_OUT(1,I),LINE_OUT(2,I),
     &					   LINE_OUT_Z(I),
     &					   NEW_PT)
		    NUM_IN = NUM_IN + 1
		    WRITE_CB = .NOT.OVER_LIMIT(NUM_IN)
		    IF (.NOT.WRITE_CB) GOTO 999
		    LINE_IN(1,NUM_IN) = NEW_PT(1)
		    LINE_IN(2,NUM_IN) = NEW_PT(2)
		    LINE_IN_Z(NUM_IN) = NEW_PT(3)
C
C Make it an interpolated point (with `I' flag)
C
		    LINE_IN_FLAGS(NUM_IN)='0008'X
C
C If two adjacent points have 'L' flag, then interpolated point should also
C have it.
C
		    IF (((LINE_OUT_FLAGS(I+1).AND.'0002'X).EQ.2).AND.
     &			((LINE_OUT_FLAGS(I)  .AND.'0002'X).EQ.2)) THEN
		       LINE_IN_FLAGS(NUM_IN)=LINE_IN_FLAGS(NUM_IN).OR.'0002'X
		    ENDIF
C
C If two adjacent points have 'H' flag, then interpolated point should also
C have it.
C
		    IF (((LINE_OUT_FLAGS(I+1).AND.'0001'X).EQ.1).AND.
     &			 ((LINE_OUT_FLAGS(I)  .AND.'0001'X).EQ.1)) THEN
		       LINE_IN_FLAGS(NUM_IN)=LINE_IN_FLAGS(NUM_IN).OR.'0001'X
		    ENDIF
		 ENDIF
	      ELSE
C
C Copy over current point
C
		 NUM_IN = NUM_IN + 1
		 WRITE_CB = .NOT.OVER_LIMIT(NUM_IN)
		 IF (.NOT.WRITE_CB) GOTO 999
		 LINE_IN(1,NUM_IN) = LINE_OUT(1,I)
		 LINE_IN(2,NUM_IN) = LINE_OUT(2,I)
		 LINE_IN_Z(NUM_IN) = LINE_OUT_Z(I)
		 LINE_IN_FLAGS(NUM_IN)=LINE_OUT_FLAGS(I)
	      ENDIF
50	   CONTINUE
	ENDIF
C
C-----------------------------------------------------------------------------
C
C Undefined means just copy the feature over as is
C
	IF ((INTERP(FC_INDEX).EQ.INTERP_UNDEFINED).OR.
     &	    (INTERP(FC_INDEX).EQ.INTERP_STRAIGHT)) THEN
	   NUM_IN = NUM_OUT
	   DO 100 I = 1, NUM_OUT
	      LINE_IN(1,I) = LINE_OUT(1,I)
	      LINE_IN(2,I) = LINE_OUT(2,I)
	      LINE_IN_Z(I) = LINE_OUT_Z(I)
	      LINE_IN_FLAGS(I)=LINE_OUT_FLAGS(I)
100	   CONTINUE
	ENDIF
C
C-----------------------------------------------------------------------------
C
C set up the CB header - 
C
	CBH.FLAGS = 0		! pen up to the CB
C
C set up the graphical type
C
	CBH.GTYPE = 1
	IF (IS_SYMBOL) CBH.GTYPE = 7
C
C no fixed attributes yet
C
	CBH.NATT = 0
C
C Fill CBH columns with AC codes
C
	OUTCOLS = 3
	CBH.COLH(1) = IFF_C_X
	CBH.COLH(2) = IFF_C_Y
	CBH.COLH(3) = IFF_C_Z
	IF (CURVE_AC_CODE.GT.0) THEN	! if the user has specified the AC num
	   OUTCOLS = OUTCOLS + 1
	   CBH.COLH(OUTCOLS) = CURVE_AC_CODE
	ENDIF
	IF (PRIO_AC_CODE.GT.0) THEN	! if the user has specified the AC num
	   OUTCOLS = OUTCOLS + 1
	   CBH.COLH(OUTCOLS) = PRIO_AC_CODE
	ENDIF
	CBH.NCOL = OUTCOLS
C
C Write lines of data in blocks of 200s
C
	DO 500 I = 1,NUM_IN
	   J = MOD(I-1,200)+1			! J is always 1-200
	   TEMPREAL = LINE_IN(1,I)		! X coord
	   OUTBUF((J-1)*OUTCOLS+1) = TEMPINT	! calculate offset for X coord
	   TEMPREAL = LINE_IN(2,I)		! Y coord
	   OUTBUF((J-1)*OUTCOLS+2) = TEMPINT	! calculate offset for Y coord
	   TEMPREAL = LINE_IN_Z(I)		! Z coord
	   OUTBUF((J-1)*OUTCOLS+3) = TEMPINT	! calculate offset for Z coord
C
C Create a curve flag
C
	   IF (CURVE_AC_CODE.GT.0) THEN
	      IF ((LINE_IN_FLAGS(I).AND.'0008'X).EQ.8) THEN
		 TEMPCHAR(1:4) = 'I   '
	      ELSEIF ((LINE_IN_FLAGS(I).AND.'0004'X).EQ.4) THEN
		 TEMPCHAR(1:4) = 'C   '
	      ELSE
		 TEMPCHAR(1:4) = '    '
	      ENDIF
	      OUTBUF((J-1)*OUTCOLS+4) = TEMPINT
	   ENDIF
C
C Create a priority flag
C
	   IF (PRIO_AC_CODE.GT.0) THEN
	      IF ((LINE_IN_FLAGS(I).AND.'0002'X).EQ.2) THEN
		 TEMPCHAR(1:4) = 'L   '
	      ELSEIF ((LINE_IN_FLAGS(I).AND.'0001'X).EQ.1) THEN
		 TEMPCHAR(1:4) = 'H   '
	      ELSE
		 TEMPCHAR(1:4) = '    '
	      ENDIF
C
C If CURVE flags are not given, the PRIORITY flag should go into the 4th
C column of OUTBUF. OUTBUF is actually a linear array and the columns for
C the X, Y, Z, CURVE and PRIORITY are calculated as offsets. This caters
C for when CURVE or PRIO flag ACs are missing.
C
	      IF (CURVE_AC_CODE.GT.0) THEN
		 OUTBUF((J-1)*OUTCOLS+5) = TEMPINT
	      ELSE
		 OUTBUF((J-1)*OUTCOLS+4) = TEMPINT
	      ENDIF
	   ENDIF
C
C When we've got a block of 200 or the last block, write it out
C
	   IF (J.EQ.200 .OR. I.EQ.NUM_IN) THEN
	      CALL IFS_CB_WRITE(CBH,CBD,OUTBUF(1),CBH.NCOL,CBH.COLH(1),1,J)
	      CBH.NROW = J
C
C compress the CB
C
	      CALL IFS_CB_COMPRESS(CBH,CBD)
C
C and write it out
C
	      CALL IFFCB(CBH,CBD)
C
C IFS_CB_COMPRESS can compact the CBH.COLH array so the next CB will be wrong
C so we must rebuild the list AFTER the've been written with IFFCB
C
	      OUTCOLS = 3
	      CBH.FLAGS = 1
	      CBH.COLH(1) = IFF_C_X
	      CBH.COLH(2) = IFF_C_Y
	      CBH.COLH(3) = IFF_C_Z
	      IF (CURVE_AC_CODE.GT.0) THEN   ! if the user specified the AC num
		 OUTCOLS = OUTCOLS + 1
		 CBH.COLH(OUTCOLS) = CURVE_AC_CODE
	      ENDIF
	      IF (PRIO_AC_CODE.GT.0) THEN    ! if the user specified the AC num
		 OUTCOLS = OUTCOLS + 1
		 CBH.COLH(OUTCOLS) = PRIO_AC_CODE
	      ENDIF
	      CBH.NCOL = OUTCOLS
	   ENDIF
C
500	CONTINUE
C
C and that's it
C
999	RETURN
	END
C
