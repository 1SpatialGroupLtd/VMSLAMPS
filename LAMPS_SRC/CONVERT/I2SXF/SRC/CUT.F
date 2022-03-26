C process each pair of co-ordinates
C (note that text and symbol coordinates are not output here, although
C  angle calculations, etc, may be done)
C
	DO 350 I = 1,STPTR
C
C get the next point in hand
C
	  X     = STBUF(1,I)
	  Y     = STBUF(2,I)
	  Z     = ZBUF(I)
C..	  DZ    = DZBUF(I)
C..	  CAPXY = CXYBUF(I)
C..	  CAPZ  = CZBUF(I)
C..	  CAPCH = BLANK
C
C check whether we have only just had the first point
C - if we are a text or symbol, then skip straight away to look for the 
C   next point
C - if we are a line, just output the point
C
	  IF (I.EQ.1) THEN
C..	     IF (TEXT.OR.SYMBOL) GOTO 350	! get next point
C..	     IF (NEW_FEATURE) GOTO 330		! output point
	  ENDIF
C
C we need to know the displacement over the first 2 points, in order
C to calculate an angle...
C for lines, we also need to know the displacement over the previous 
C and current points, in order to check for duplicates...
C - if it is a line then we want to calculate the angle in terms of the 
C   OSTF output coordinates, rather than the input IFF coordinates...
C
 	  IF ( .NOT.SYMBOL .AND. .NOT.TEXT ) THEN
	     CALL CNVTOS(SAV_X,SAV_Y,BGI,GX1,GY1,OX1,OY1)
	     CALL CNVTOS(    X,    Y,BGI,GX2,GY2,OX2,OY2)
	     DX = BGI*( (GX2+OX2/1000.0) - (GX1+OX1/1000.0) )
	     DY = BGI*( (GY2+OY2/1000.0) - (GY1+OY1/1000.0) )
C
C - if it is a symbol or text, we use the input IFF coordinates to 
C   ensure we get an angle even when the OSTF coordinates are 
C   duplicated, since we only output one point
C
	  ELSE
	     DX = X - SAV_X
	     DY = Y - SAV_Y
	  ENDIF
C
C if the displacement is 0, then complain, and ignore the current
C point (in an appropriate manner)
C
	  IF ( (DX.EQ.0.0) .AND. (DY.EQ.0.0) ) THEN
	     CALL LSL_PUTMSG( I2OSTF__DUPPTS, NFNUM, PREV_PTS+I )
	     IF (NEW_FEATURE .AND. I.EQ.2) THEN
	        CALL LSL_PUTMSG( I2OSTF__FIRST2, NFNUM )
	     ENDIF
	     IF (.NOT.SYMBOL) GOTO 350
	     X     = SAV_X		! why do we do this ?
	     Y     = SAV_Y		! (they should be the same)
	     Z     = SAV_Z
C..	     DZ    = SAV_DZ
C..	     CAPXY = SAV_CAPXY
C..	     CAPZ  = SAV_CAPZ
C..	     GOTO 330			! goes to 350 anyway
	  ENDIF
C
C once we have the first two valid points, we can find the angle of the 
C thing, otherwise (i.e. for subsequent points) just output them
C
C..	  IF (HAD2PT) GOTO 330		! just output the point
C
C now we use DX,DY to compute an angle for any feature with two
C or more points
C
	  ROT = ATAN2(DY,DX)
C
	  IF (ROT.LT.0.0) ROT = ROT+TWOPI	! make +ve by adding 2 pi
	  DEG = (ROT*180.0/PI)*10		! angle in degrees*10
	  DEG = MOD(DEG,3600)			! mod full circle
C..	  HAD2PT = .TRUE.			! & thus we had 2 pts
C
C if this is a text feature, get the next point at once
C if this is a symbol, then if we are here it is a scaled symbol
C
	  IF (TEXT) GOTO 350			! only output lines
C
C if it is a symbol, then it is scaled - calculate the magnitude
C (distance). If it is not a symbol, just output the angle
C
	  IF (SYMBOL) THEN
	     R1 = SQRT(DX*DX + DY*DY)		! real distance
	     R1 = AMOD(R1,BGI)*(1000/BGI)	! into basic grid units
	     IF (R1.LT.0.0) R1 = R1+1000	! ensure positive
	     DIST = R1 + 0.5			! round to integer
 	     GOTO 350				! and end this loop
	  ELSE
	     CALL FORMB(-12, DEG)		! output angle
	  ENDIF					! and output point
	GO TO 10
C
	ELSEIF (TEXT) THEN
	GO TO 10	
C
	ELSEIF (SYMBOL) THEN
C
	ENDIF
