C
C * This file is part of the LAMPS distribution, released as a software
C * preservation project to archive digital history for future historians.
C * Copyright (c) 1980-2002 Laser-Scan Ltd, 1Spatial Group Ltd
C *
C * Timestamp of this file for the 2002 release was: 1994-09-27 13:55:32.000000000 +0100
C *
C * This program is free software: you can redistribute it and/or modify
C * it under the terms of the GNU General Public License as published by
C * the Free Software Foundation, version 3.
C *
C * This program is distributed in the hope that it will be useful, but
C * WITHOUT ANY WARRANTY; without even the implied warranty of
C * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
C * General Public License for more details.
C *
C * You should have received a copy of the GNU General Public License
C * along with this program. If not, see http://www.gnu.org/licenses/.
C
	LOGICAL FUNCTION PROCESS_LINE
C
CDEC$	IDENT	'27SE94'
C
C	Copyright (C)			Laser-Scan Ltd., Cambridge
C
C       Author				Steve Townrow	26-Jul-1994
C
C Description:
C       This routine is called from PROCESS and will have all the necessary
C       coordinate points in the array PTS.
C
C       If we are to smooth this feature and store the interpolated points,
C       then each section is put into LINE_IN, then smoothed which gives the
C       output in LINE_OUT. We later re-use the array LINE_IN to hold the
C       output points before writing out in WRITE_CB.
C
C       If we are BREAKing this feature, the breaking is done here and the
C       result is left in LINE_IN by this routine.
C
	IMPLICIT	NONE
C
C common blocks
C
	INCLUDE	'LSL$CMNFRT:FRTCOM.CMN'	! FRT definitions
	INCLUDE 'CMN:MAPDATA2IMSG.PAR'
	INCLUDE 'CMN:LINES.CMN'
	INCLUDE 'CMN:FILE.CMN'
	INCLUDE 'CMN:IFF.CMN'
	INCLUDE 'LSL$CMNIFF:CB.STR'
C
C Functions
C
	LOGICAL		OVER_LIMIT	! Check if we overflow our buffer
	LOGICAL		OUTPTS
	LOGICAL		WRITE_FEATURE
	LOGICAL		FRTFND
C
C workspace
C
	RECORD	/IFF_CBH/ CBH
	RECORD	/IFF_CBD/ CBD
C
	INTEGER*4	TEMPINT
	REAL*4		TEMPREAL
	CHARACTER*4	TEMPCHAR
	EQUIVALENCE	(TEMPINT,TEMPREAL,TEMPCHAR)
	INTEGER*4	I,J
	LOGICAL		OK
	LOGICAL		CURVE,PREV_CURVE
	REAL*4		DX,DY,ANG
C
C------------------------------------------------------------------------------
C
C Initialise some things
C
	PROCESS_LINE = .TRUE.
	I = 1
	NUM_IN = 0
	NUM_OUT = 0
	PREV_CURVE = .FALSE.
	IS_SYMBOL = NPTS.EQ.1
	ROTATE = 0.0
C
C Check FRT file for supplied FC's to get GT 
C
	IF (HAD_FRT) THEN
	   OK = FRTFND(FC,.FALSE.)
	   IF (OK) THEN		! FC not found
	      IF (HAD_LOG) CALL LSL_PUTMSG(MD2I__ERRFNDFC, FC)
	      DEFAULT_FC = .TRUE.
	   ELSE
C
C Check if this feature is a 2-point rotated symbol and if so, work
C out the RO entry
C
	      IF (FRTGT.EQ.ORITYP .AND. NPTS.EQ.2) THEN
		 DX = PTS(1,1)-PTS(1,2)
		 DY = PTS(2,1)-PTS(2,2)
		 IF (DX.EQ.0.0) THEN
		    IF (DY.LT.0.0) THEN
		       ANG = 90.0
		    ELSE
		       ANG = 270.0
		    ENDIF
		    GOTO 25
		 ENDIF
		 ANG = ATAND(DY/DX)
		 IF (DX.GE.0.0) THEN
		    ANG = ANG + 180.0
		 ELSEIF (DX.LT.0.0.AND.DY.GT.0.0) THEN
		    ANG = ANG + 360.0
		 ENDIF
C
25		 ROTATE = ANG/(180/PI)
		 IS_SYMBOL = .TRUE.
		 NPTS = 1
	      ENDIF
	   ENDIF
	ENDIF
C
C Determine default FC
C
	IF (DEFAULT_FC) THEN
	   FC_INDEX = 0
	   IF (IS_SYMBOL) THEN
	      FC = DEF_SYM_FC
	   ELSE
	      FC = DEF_LINE_FC
	   ENDIF
	ENDIF
C
C------------------------------------------------------------------------------
C Loop through all the points
C
50	CURVE = ((FLAGS(I).AND.'0004'X).EQ.4)
C
C If have a curve in hand, store it in the input list
C
	IF (CURVE) THEN
	   NUM_IN = NUM_IN + 1
	   PROCESS_LINE = .NOT.OVER_LIMIT(NUM_IN)
	   IF (.NOT.PROCESS_LINE) GOTO 999
	   LINE_IN(1,NUM_IN) = PTS(1,I)
	   LINE_IN(2,NUM_IN) = PTS(2,I)
	   LINE_IN_Z(NUM_IN) = PTS(3,I)
	   LINE_IN_FLAGS(NUM_IN) = FLAGS(I)
	ELSE
C
C This isn't a curve point. If previous one was, we've just changed
C interpretation so purge what we've had.
C
	   IF (PREV_CURVE) THEN
	      PROCESS_LINE = OUTPTS()
	      IF (.NOT.PROCESS_LINE) GOTO 999
	   ELSE
C
C Remember the first point of the input line
C
	      IF (NUM_IN.GT.0) THEN
		 NUM_OUT = NUM_OUT + 1
		 PROCESS_LINE = .NOT.OVER_LIMIT(NUM_OUT)
		 IF (.NOT.PROCESS_LINE) GOTO 999
		 LINE_OUT(1,NUM_OUT) = LINE_IN(1,1)
		 LINE_OUT(2,NUM_OUT) = LINE_IN(2,1)
		 LINE_OUT_Z(NUM_OUT) = LINE_IN_Z(1)
		 LINE_OUT_FLAGS(NUM_OUT) = LINE_IN_FLAGS(1)
	      ENDIF
	   ENDIF
C
C Store this point which will always be a non-curve point
C
	   LINE_IN(1,1) = PTS(1,I)
	   LINE_IN(2,1) = PTS(2,I)
	   LINE_IN_Z(1) = PTS(3,I)
	   LINE_IN_FLAGS(1) = FLAGS(I)
	   NUM_IN = 1
	ENDIF
	PREV_CURVE = CURVE
	I = I + 1
	IF (I.GT.NPTS) THEN
C
C For AA:
C The curving should be suppressed for the section of a line that ends
C in two curve points. Yes, it is inconsistent but that's the way the
C AA's Scitex handles that case.
C
CCCCCCC	   SUPPRESS_CURVE = NUM_IN.EQ.3
CCCCCCC	   PROCESS_LINE = OUTPTS(SUPPRESS_CURVE)
C
C Rely on OUTPTS to copy any remaining pts over
C
	   PROCESS_LINE = OUTPTS()
	   IF (PROCESS_LINE) THEN
	      GOTO 75
	   ELSE
	      GOTO 999
	   ENDIF
	ENDIF
	GOTO 50
C
75	CONTINUE
C
C Break a feature up into sections for curved and straight if required.
C
	IF (INTERP(FC_INDEX).EQ.INTERP_BREAK) THEN
	   NUM_IN = 0
	   PREV_CURVE = .FALSE.
	   DO 100 I = 1, NUM_OUT
	      CURVE = ((LINE_OUT_FLAGS(I).AND.'0004'X).EQ.4)
	      IF (I.EQ.1) PREV_CURVE = CURVE
C
C If there is a change in curve status, write the current points out
C
	      IF ((CURVE .AND. .NOT.PREV_CURVE).OR.
     &		  (.NOT.CURVE .AND. PREV_CURVE)) THEN
C
C Determine the feature code for this section
C
		 IF (PREV_CURVE) THEN
		    FC = IFF_FC(2,FC_INDEX)
		 ELSE
		    FC = IFF_FC(1,FC_INDEX)
		 ENDIF
C
C And write it
C
		 PROCESS_LINE = WRITE_FEATURE()
		 IF (.NOT.PROCESS_LINE) GOTO 999
C
C Remember the last point of the previous section as the first of the
C current section
C
		 LINE_IN(1,1) = LINE_IN(1,NUM_IN)
		 LINE_IN(2,1) = LINE_IN(2,NUM_IN)
		 LINE_IN_Z(1) = LINE_IN_Z(NUM_IN)
		 LINE_IN_FLAGS(1) = LINE_IN_FLAGS(NUM_IN)
		 NUM_IN = 1
	      ENDIF
C
C Store the current point
C
	      NUM_IN = NUM_IN + 1
	      LINE_IN(1,NUM_IN) = LINE_OUT(1,I)
	      LINE_IN(2,NUM_IN) = LINE_OUT(2,I)
	      LINE_IN_Z(NUM_IN) = LINE_OUT_Z(I)
	      LINE_IN_FLAGS(NUM_IN) = LINE_OUT_FLAGS(I)
	      PREV_CURVE = CURVE
100	   CONTINUE
C
C Determine the feature code for this section
C
	   IF (CURVE) THEN
	      FC = IFF_FC(2,FC_INDEX)
	   ELSE
	      FC = IFF_FC(1,FC_INDEX)
	   ENDIF
	   PROCESS_LINE = WRITE_FEATURE()
	   IF (.NOT.PROCESS_LINE) GOTO 999
	ELSE
C
C We're not breaking the feature so just write it
C
	   PROCESS_LINE = WRITE_FEATURE()
	   IF (.NOT.PROCESS_LINE) GOTO 999
	ENDIF
C
C and that's it
C------------------------------------------------------------------------------
C
999	RETURN
	END
C
