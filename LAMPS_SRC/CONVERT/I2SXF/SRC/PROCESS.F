	SUBROUTINE PROCESS
C
CDEC$	IDENT	'09MY90'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					RJH	09-May-1990
C
C	CONVERT I2SXF Utility - Main Loop
C
C Description
C
C	Read each feature in the IFF file and convert if to
C	output data in the SXF file
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'LSL$CMNI2SXF:I2SXFMSG.PAR'	! message definitions
C
C Common Blocks
C
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filename parse
	INCLUDE 'LSL$CMNI2SXF:COMMANDS.CMN'	! command line things
C
C Functions called
C
	LOGICAL		GET_COMMAND	! get and decode command line
	LOGICAL		RDPAR		! read parameter file
	LOGICAL		FRTINI		! read FRT file
	INTEGER*4	IFFOPEN		! open IFF file
	LOGICAL		CLOSE_IFF	! close IFF file
  	LOGICAL		USE_LAYER	! check if layer selected
	LOGICAL		USE_FC		! check if feature selected
	INTEGER*4	GET_SXF_CODE	! translation code lookup routine
C
C
C Local variables
C
	RECORD	/IFF_CBH/ CBH		! CB header part
	RECORD	/IFF_CBD/ CBD		! CB data part
C
	INTEGER*2	FC			! feature code at hand
	INTEGER*2	LAYER			! layer at hand
	INTEGER*2	IECODE			! entry type at hand
	INTEGER*2	IELEN			! length of entry at hand
	INTEGER*2	FSN			! feature serial number
	INTEGER*2	ISTAT(4)		! feature status words
	INTEGER*2	ITYPE			! temprary feature type word
C
	INTEGER*4	SXF_CODE		! SXF transfer code
C
	LOGICAL*4	LINE			! flag this is a line
	LOGICAL*4	TEXT			! flag this is a text
	LOGICAL*4	SYMBOL			! flag this is a symbol
	LOGICAL*4	NEW_FEATURE		! flag this is a new feature
C
	REAL*4		ROTATION		! text or symbol rotation
C
C Initiate local variables
C
	FC       = -1				! Not valid
	LAYER    = -1				! Not valid
	SXF_CODE = -1				! Not valid
	LINE     = .FALSE.
	TEXT     = .FALSE.
	SYMBOL   = .FALSE.
	ROTATION = 0.0
C
C First process the start of the IFF file to create the heading part
C of the SXF file
C
C...	CALL SXF_HEADING()
C
C
C
C
C Main loop
C
C Now start reading the rest of the features in the IFF file
C
10	CALL IFFNXT(IECODE,IELEN)
20	IF (IELEN .EQ. -1 .OR. IERCD .NE. 0) GO TO 991
	IF (IECODE .EQ. 'NO' ) GO TO 100
	IF (IECODE .EQ. 'NF' ) GO TO 200
	IF (IECODE .EQ. 'EO' ) GO TO 300
	IF (IECODE .EQ. 'FS' ) GO TO 400
	IF (IECODE .EQ. 'CB' ) GO TO 500
 	IF (IECODE .EQ. 'EF' ) GO TO 600
	IF (IECODE .EQ. 'AC' ) GO TO 700
	IF (IECODE .EQ. 'RO' ) GO TO 800
	IF (IECODE .EQ. 'TX' ) GO TO 850
	IF (IECODE .EQ. 'EJ' ) GO TO 900
C
C Thease entrys should have been dealtwith in heading processing
C if thay appere there, just skip them.
C
	IF (IECODE .EQ. 'RA' ) GO TO 10
	IF (IECODE .EQ. 'HI' ) GO TO 10
	IF (IECODE .EQ. 'MH' ) GO TO 10
	IF (IECODE .EQ. 'MD' ) GO TO 10
C
C Thease are entry types that we don't care about, so skip them.
C
	IF (IECODE .EQ. 'EM' ) GO TO 10
	IF (IECODE .EQ. 'NS' ) GO TO 10
	IF (IECODE .EQ. 'CC' ) GO TO 10
	IF (IECODE .EQ. 'CP' ) GO TO 10
	IF (IECODE .EQ. 'TH' ) GO TO 10
C
C Go back up and get the next record.
C
	GO TO 10
C
C
100	CONTINUE
C
C New Layer check if we want to output this layer
C
	CALL EIHR(LAYER,1,1)
	IF(.NOT. USE_LAYER(LAYER)) THEN
	   CALL IFFNXC('NO',IELEN)		! SKIP TO NEXT LAYER
	   GO TO 20
	ENDIF
	GO TO 10				! USE THIS LAYER
C
C
C
200	CONTINUE
C
C New Feature read the FSN and set a flag that we got a new feature
C
	CALL EIHR(FSN,1,1)
	NEW_FEATURE = .TRUE.
	GO TO 10
C
300	CONTINUE
C
C End of layer (overlay) mark that the layer is no longer valid
C by setting to -1
C
	LAYER = -1
	GO TO 10
C
C
400	CONTINUE
C
C Feature status FS read the feature code FC and set feature type flags
C
	CALL EIHR(ISTAT,4,1)
	FC = ISTAT(1)
C
C Check what type of feature is at hand
C
	ITYPE  = ISTAT(3) .AND. 'C000'X
	SYMBOL = (ITYPE .EQ. '4000'X)
	TEXT   = (ITYPE .EQ. '8000'X)
	LINE   = (ITYPE .EQ. '0000'X)
C
	GO TO 10
C
C
500	CONTINUE
C
C Coordinate block CB. This is there the real processing takes place
C
C If this is a new feature do some checking
C
	IF(NEW_FEATURE) THEN
C
C Check what we have a valid layer at hand
C
	   IF (LAYER .EQ. -1) THEN
C...	      CALL LSL_PUTMSG(SXF__    )
	      GO TO 10
	   ENDIF
C
C Check what we have a valid feature code at hand
C
	   IF (FC .EQ. -1) THEN
C...	      CALL LSL_PUTMSG(SXF__  )
	      GO TO 10
C
C
	   ELSEIF(FC .EQ. -2) THEN
C
C This is a valid but not wanted feature
C
 	      GO TO 10
C
	   ENDIF
C
C
C Check if we want to output this feature
C
	   IF(.NOT. USE_FC(FC)) THEN
C
C Mark this feature as not wanted (FC = -2)
C
	      FC = -2 
	      GO TO 10
C
	   ENDIF
C
C Get the SXF code from the code table
C
	   SXF_CODE = GET_SXF_CODE(FC)
C
C Check for  missing code
C
	   IF (SXF_CODE .EQ. -1) THEN
C
C Output error message
C
C...	   CALL LSL_PUTMSG(SXF__ )
C
C...  set up dummy SXF_CODE ?????
C
	   ENDIF
C
C Add it to internal table to be output to summary file at end of program
C
C...	   CALL ADD_SUMMARY(FC,SXF_CODE)
	   NEW_FEATURE = .FALSE.
	ENDIF
C
C
C If this is a line it is OK to start processing coordinates now
C
40	IF (LINE) THEN
C
C CB entry - produce co-ord data units
C	   - basic grid square data unit if changed
C	   - invisible line flag data unit if pen up
C          - height data unit if changed
C          - and subsequent string in feature
C
290	CALL EIHRCB_HEAD(CBH)
	CALL EIHRCB_DATA(CBD)
C
C if this is not the start of a feature, and we have the pen up flag,
C then output an invisible line flag
C
C
C read the points into buffers for convenience
C
	STCOL(1) = CODE_X
	STCOL(2) = CODE_Y
	STPTR = CBH.NROW
C
C if it's an empty entry (which should never happen!) ignore it
C
	IF (STPTR.EQ.0) THEN
	   CALL LSL_PUTMSG(I2OSTF__NOPTS,FSN)
	   GOTO 130
	ENDIF
C
	CALL IFS_CB_READ(CBH,CBD,STBUF,2,STCOL,1,STPTR)
C
	IF (PLUS) THEN
	   CALL IFS_CB_READ(CBH,CBD,ZBUF,1,CODE_Z,1,STPTR)
	   CALL IFS_CB_READ(CBH,CBD,DZBUF,1,CODE_DZ,1,STPTR)
	   CALL IFS_CB_READ(CBH,CBD,CXYBUF,1,CODE_CAPXY,1,STPTR)
	   CALL IFS_CB_READ(CBH,CBD,CZBUF,1,CODE_CAPZ,1,STPTR)
	ELSEIF (.NOT. (SIMPLE_XY .OR. CHUCKED_OUT)) THEN
	   CALL LSL_PUTMSG(I2OSTF__CHUCKED)
	   CHUCKED_OUT = .TRUE.
	ENDIF
C
C remember the first point of the feature (for texts and symbols)
C
	IF (NEWF) THEN
	   SAV_X     = STBUF(1,1)
	   SAV_Y     = STBUF(2,1)
	   SAV_Z     = ZBUF(1)
	   SAV_DZ    = DZBUF(1)
	   SAV_CAPXY = CXYBUF(1)
	   SAV_CAPZ  = CZBUF(1)
	ENDIF
C
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
	  DZ    = DZBUF(I)
	  CAPXY = CXYBUF(I)
	  CAPZ  = CZBUF(I)
	  CAPCH = BLANK
C
C check whether we have only just had the first point
C - if we are a text or symbol, then skip straight away to look for the 
C   next point
C - if we are a line, just output the point
C
	  IF (I.EQ.1) THEN
	     IF (TEXTF.OR.SYMBF) GOTO 350	! get next point
	     IF (NEWF) GOTO 330			! output point
	  ENDIF
C
C we need to know the displacement over the first 2 points, in order
C to calculate an angle...
C for lines, we also need to know the displacement over the previous 
C and current points, in order to check for duplicates...
C - if it is a line then we want to calculate the angle in terms of the 
C   OSTF output coordinates, rather than the input IFF coordinates...
C
 	  IF ( .NOT.SYMBF .AND. .NOT.TEXTF ) THEN
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
	     IF (NEWF .AND. I.EQ.2) THEN
	        CALL LSL_PUTMSG( I2OSTF__FIRST2, NFNUM )
	     ENDIF
	     IF (.NOT.SYMBF) GOTO 350
	     X     = SAV_X		! why do we do this ?
	     Y     = SAV_Y		! (they should be the same)
	     Z     = SAV_Z
	     DZ    = SAV_DZ
	     CAPXY = SAV_CAPXY
	     CAPZ  = SAV_CAPZ
	     GOTO 330			! goes to 350 anyway
	  ENDIF
C
C once we have the first two valid points, we can find the angle of the 
C thing, otherwise (i.e. for subsequent points) just output them
C
	  IF (HAD2PT) GOTO 330		! just output the point
C
C now we use DX,DY to compute an angle for any feature with two
C or more points
C
	  ROT = ATAN2(DY,DX)
C
	  IF (ROT.LT.0.0) ROT = ROT+TWOPI	! make +ve by adding 2 pi
	  DEG = (ROT*180.0/PI)*10		! angle in degrees*10
	  DEG = MOD(DEG,3600)			! mod full circle
	  HAD2PT = .TRUE.			! & thus we had 2 pts
C
C if this is a text feature, get the next point at once
C if this is a symbol, then if we are here it is a scaled symbol
C
	  IF (TEXTF) GOTO 350			! only output lines
C
C if it is a symbol, then it is scaled - calculate the magnitude
C (distance). If it is not a symbol, just output the angle
C
	  IF (SYMBF) THEN
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
	GO TO 10
C
C
C
600	CONTINUE
C
C End of feature. 
C Check if this was a text or a symbol. Now is the time to output it
C
	IF(TEXT .OR. SYMBOL) THEN
C....
C
	ENDIF
C
C Set FC to none valid (FC = -1)
C
	FC = -1
	GO TO 10
C
C
700	CONTINUE
C
C AC record
C
C.........
	GO TO 10
C
C
800	CONTINUE
C
C Rotation
C
C...	CALL EIHRR(ROTATION,1,1)
    	GO TO 10
C
850	CONTINUE
C
C Text
C
C read the text in
C
	CALL EIHRI(CHRS,IELEN,1)
	IF (CHRS(N).EQ.0) N = N-1	! remove padding null at end?
C
	GO TO 10
C
C
C
900	CONTINUE
C
C End of job   output the terminationg character to output file
C and return to main
C
C...
C
	GO TO 9999
C
C
C

C Error handling
C
991	CONTINUE
C	IFF file internal structure error
C	GO TO 9999
C
9999	RETURN
	END
