	SUBROUTINE	WRITE_CB
CDEC$	IDENT	'28JL94'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C
C       Author				Steve Townrow	26-Jul-1994
C
C Description:
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
!!!***	COMMON/LSL$CMNIFILT:TOLERANCES/ ! tolerances for Bezier etc.
C
C External Subroutines
C
!	INTEGER*4	AKIMA		! Akima curve interpolation 
!	EXTERNAL	AKIMA
C
C workspace
C
	RECORD	/IFF_CBH/ CBH
	RECORD	/IFF_CBD/ CBD
C
	INTEGER*4	OUTBUF(5,200)
	INTEGER*4	TEMPINT
	REAL*4		TEMPREAL
	CHARACTER*4	TEMPCHAR
	EQUIVALENCE	(TEMPINT,TEMPREAL,TEMPCHAR)
	INTEGER*4	I,J
	LOGICAL		OK
	LOGICAL		CURVE,PREV_CURVE
!!!	INTEGER*4	NUM_IN
!!!	REAL*4		LINE_IN(2,200)
C
C------------------------------------------------------------------------------
C
C Smooth the line if necessary.
C
C Initialise some things
C
	I = 1
	NUM_IN = 0
	NUM_OUT = 0
	PREV_CURVE = .FALSE.
C
C Loop through all the points
C
50	CURVE = ((FLAGS(I).AND.'0004'X).EQ.4)
	IF (CURVE) THEN
	   NUM_IN = NUM_IN + 1
	   LINE_IN(1,NUM_IN) = PTS(1,I)
	   LINE_IN(2,NUM_IN) = PTS(2,I)
	   IF (I.GE.NPTS) CALL OUTPTS
	ELSE
	   IF (PREV_CURVE) CALL OUTPTS
	   NUM_OUT = NUM_OUT + 1
	   LINE_OUT(1,NUM_OUT) = PTS(1,I)
	   LINE_OUT(2,NUM_OUT) = PTS(2,I)
	ENDIF
	PREV_CURVE = CURVE
	I = I + 1
	IF (I.GT.NPTS) GOTO 75
	GOTO 50
C
75	CONTINUE
C
C Work out master points by comparing input list with output list.
C

C
C We no longer need our input points so set the counter to zero
C
	NUM_IN = 0
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
	CBH.NROW = NUM_OUT
	CBH.NCOL = 5
	CBH.COLH(1) = IFF_C_X
	CBH.COLH(2) = IFF_C_Y
	CBH.COLH(3) = IFF_C_Z
	CBH.COLH(4) = CURVE_AC
	CBH.COLH(5) = PRIORITY_AC
C
C Write lines of data in blocks of 200s
C
	DO 200 I = 1,NUM_OUT
	   TEMPREAL = LINE_OUT(1,I)		! X coord
	   OUTBUF(1,I) = TEMPINT
	   TEMPREAL = LINE_OUT(2,I)		! Y coord
	   OUTBUF(2,I) = TEMPINT
!	   TEMPREAL = PTS(3,I)
!	   OUTBUF(3,I) = TEMPINT	! Z coord
	   OUTBUF(3,I) = 0
	   IF ((FLAGS(I).AND.'0004'X).EQ.4) THEN
	      TEMPCHAR = 'M   '
	   ELSE
	      TEMPCHAR = '    '
	   ENDIF
	   OUTBUF(4,I) = TEMPINT
	   IF ((FLAGS(I).AND.'0002'X).EQ.2) THEN
	      TEMPCHAR = 'L   '
	   ELSEIF ((FLAGS(I).AND.'0001'X).EQ.1) THEN
	      TEMPCHAR = 'H   '
	   ELSE
	      TEMPCHAR = '    '
	   ENDIF
	   OUTBUF(5,I) = TEMPINT
200	CONTINUE
	CALL IFS_CB_WRITE(CBH,CBD,OUTBUF(1,1),CBH.NCOL,CBH.COLH(1),1,CBH.NROW)
C
C compress the CB
C
!	      CALL IFS_CB_COMPRESS(CBH,CBD)
C
C and write it out
C
	   CALL IFFCB(CBH,CBD)
C
C IFS_CB_COMPRESS can compact the CBH.COLH array so the next CB will be wrong
C so we must rebuild the list AFTER the've been written with IFFCB
C
C Set the pen down
C
!	      CBH.FLAGS = 1
!	   ENDIF
C
!500	CONTINUE
C
C and that's it
C
999	RETURN
	END
C
