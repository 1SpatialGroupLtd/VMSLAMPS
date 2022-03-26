        INTEGER*4  FUNCTION IFF_LINES()
C
CDEC$	IDENT	'03FE92'
C
C 	Copyright Laser-Scan Laboratories Ltd.,England
C
C	Created.					FJB  18-Aug-1989
CMOD	Find nodes at ends of lines properly		PGH   7-Aug-1991
C
C Transfer lines in input IFF file (open on lun IFFLUN) to 
C lines in DLG format
C
	IMPLICIT NONE
C
C Parameters:                                          
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:I2DLGMSG.PAR'
	INCLUDE 'LSL$CMNI2DLG:PARAMS.PAR'
C
C Common:
	INCLUDE 'LSL$CMNIFF:MD2DES.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
	INCLUDE 'LSL$CMNFRT:FRTCOM.CMN'
	INCLUDE 'LSL$CMNFRT:FRTACD.CMN'
  	INCLUDE 'LSL$CMNI2DLG:COMMAND.CMN/LIST'
  	INCLUDE 'LSL$CMNI2DLG:DLG_DATA.CMN/LIST'
  	INCLUDE 'LSL$CMNI2DLG:MAGBUF.CMN/LIST'
C
C Word:
	INTEGER*2	MM,JJ,II	! temporary/loop variables
	INTEGER*2 	NOVER	! layer number
	INTEGER*2 	NFNUM	! FSN number
	INTEGER*2	NPTS	! number of co-ordinates in ST entry
	INTEGER*2	NARMS	! number of junction arms
	INTEGER*2	NVERTX	! vertex number of junction
	INTEGER*2	IENDS	! pen up/down flag
	INTEGER*2	IECODE	! entry code
	INTEGER*2	IELEN	! return code
	INTEGER*2	JB_OFFSET ! junction offset
	INTEGER*2	STRLEN	! output string length
	INTEGER*2	DECIMAL_ATTS(10,3)
	DATA DECIMAL_ATTS/000,621,622,623,624,625,626,627,628,629,
     &			     600,601,602,603,604,605,606,607,608,609,
     &			     000,601,602,603,604,605,606,607,608,609/
C
C Real:
	REAL		RPOS(2,200) ! coordinates
	REAL		ANGLE	    ! rotation angle
	REAL		HEIGHT	    ! height AC value
	REAL		RR	    ! scratch real
C
C Longword:
	INTEGER		IFC	! Feature code
	INTEGER		N	! record counter
	INTEGER		J	! AC counter
	INTEGER		AC_FSN	! FSN derived from AC text
	INTEGER		TPTS	! number of co-ordinates in point or feature
	INTEGER		CHAR_PAIRS	! character pairs in D1 record
	INTEGER		IERR	! for error return
	INTEGER		IPOSX	! X coord
	INTEGER		IPOSY	! Y coord
	INTEGER		BASE_MAJOR_CODE	! DLG major code for definitive category
	INTEGER		MAJOR_CODE	! AC type number (DLG major code)
	INTEGER		MINOR_CODE	! AC integer value (DLG minor code)
        INTEGER		CODE_ARRAY(MAX_CODES,2)! stores AC type and value
	INTEGER		ST_POS  	! start of ST entry position
	INTEGER		JB_POS  	! junction block position
	INTEGER		JPOS	  	! junction position
	INTEGER		SAVE_POS  	! JP address
	INTEGER		START_NODE	! DLG node number at start of line
	INTEGER		END_NODE	! DLG node number at end of line
	INTEGER		LEFT_AREA	! DLG area number to left of line
	INTEGER		RIGHT_AREA	! DLG area number to right of line
C
C Binary chop variables
	INTEGER*4	L	! lower value
	INTEGER*4	U	! upper value
	INTEGER*4	V	! required array contents
	INTEGER*4	M	! current value
C
	LOGICAL		HAD_START	! flag start node reference
	LOGICAL		HAD_ST_POS	! flag located first ST entry
	LOGICAL		HAD_DEG_LINE	! flag degenerate line (point)
C
	BYTE		AC_BUFF(255)	! temp buffer for AC text
C
	CHARACTER*5	AC_LABEL	! temp buffer for AC text
C
C Functions:
	INTEGER*4	FRTFND		! get FRT parameters for FC
	INTEGER*4	OUTREC		! output data to mag tape
	REAL		DEGREE		! convert angle to degrees
C
C Presets:
	INTEGER*4 	SS$_NORMAL
	EXTERNAL  	SS$_NORMAL	! normal successful completion
C
C ....................................................................
C
C Assume the best
	IFF_LINES=%LOC(SS$_NORMAL)
C
C .....................................................................
C
C			M A I N   L O O P
C
C Skip through the IFF file using the positions for FS entries
C previously found in s/r IFF_SCAN
C
C
	DO 100,N=1,LINE_COUNT
C
	   J = 0
	   TPTS = 0
	   HAD_START = .FALSE.
	   HAD_ST_POS = .FALSE.
	   HAD_DEG_LINE = .FALSE.
	   AC_FSN = 0
	   LEFT_AREA = 0
	   RIGHT_AREA = 0
	   START_NODE = 0
	   END_NODE = 0
C
C Go to start of line feature
	   CALL IFFPKE(IECODE,IELEN,LINE_POS(N,1))
	   IF (IELEN.EQ.-1) THEN
	      IFF_LINES=I2DLG__UNEXPEOFL
	      CALL LSL_PUTMSG(IFF_LINES)
	      GOTO 1000
	   ENDIF
C
C Define FSN for error messages
	   NFNUM = LINE_POS(N,2)
C
C ......................................................................
C
C FS - Feature Code
C
	   IF(IECODE .NE. 'FS')GOTO 100
C
	      CALL EIHRI(IFC,1,1)		! read feature code
C
20	      CALL IFFNXT(IECODE,IELEN)
	      IF (IELEN.EQ.-1) THEN
	         IFF_LINES=I2DLG__UNEXPEOF
	         CALL LSL_PUTMSG(IFF_LINES)
	         GOTO 1000
	      ENDIF
C
C Remember the start of the co-ordinates and count them
	      IF(IECODE .EQ. 'ST')THEN
		 IF( .NOT. HAD_ST_POS) ST_POS = LPOSH
		 HAD_ST_POS = .TRUE.
		 CALL EIHRS(NPTS,IENDS)
		 IF(NPTS .LT. 1)THEN
		    IFF_LINES = I2DLG__NOCOORDS
		    CALL LSL_PUTMSG(IFF_LINES,NFNUM)
		    GOTO 1000
		 ENDIF
		 TPTS = TPTS + NPTS
		 IF(TPTS .GT. MAX_LINE_POINTS)THEN
		    IFF_LINES = I2DLG__TOOPTS
		    CALL LSL_PUTMSG(IFF_LINES,NFNUM)
		    GOTO 1000
		 ENDIF
	         GOTO 20	    
	      ENDIF
C RO
	      IF(IECODE .EQ. 'RO')THEN
C
C Create rotation attribute only if its a point feature
	   	 DO 30, MM=1,NUM_FC_POINT
		    IF (IFC.EQ.POINT_FC(MM)) GOTO 32
30		 CONTINUE
31		 GOTO 20
C
32		 CALL EIHRR(ANGLE,1,1)
		 MINOR_CODE = NINT(DEGREE(ANGLE))
C
		 IF(CATEGORY_NAME(CAT_NUM)(1:4).EQ.'HYDR') MAJOR_CODE=53
C
		 IF(CATEGORY_NAME(CAT_NUM)(1:4).EQ.'PIPE') MAJOR_CODE=193
C
		 IF(CATEGORY_NAME(CAT_NUM)(1:4).EQ.'MANM') MAJOR_CODE=203
C
C Save codes
		 J = J+1
		 IF (J .GT. MAX_CODES) THEN
		    CALL LSL_PUTMSG(I2DLG__TOOAC,MAJOR_CODE,MINOR_CODE)
		    J = J-1
		    GOTO 20
		 ENDIF
		 CODE_ARRAY(J,1) = MAJOR_CODE
		 CODE_ARRAY(J,2) = MINOR_CODE
	         GOTO 20			! get next IFF entry
C
	      ENDIF
C
C Get ACs
	      IF(IECODE .EQ. 'AC')THEN
	         DO 44,MM=1,255
		    AC_BUFF(MM) = ' '
44	 	 CONTINUE
		 AC_LABEL = ' '
		 CALL EIHR(MAJOR_CODE,1,1)
C
C Deal with height values
		 IF(MAJOR_CODE .EQ. 3)THEN
		   CALL EIHRR(HEIGHT,1,2)
C
		   IF(HAD_DECIMAL_HEIGHTS)THEN
		     RR = HEIGHT - INT(HEIGHT)
		     IF(RR.GE.0.95)THEN
		       MINOR_CODE = NINT(HEIGHT) !round upwards
		     ELSE
		       MINOR_CODE = INT(HEIGHT)
		     ENDIF
		   ELSE
		     MINOR_CODE = NINT(HEIGHT)
		   ENDIF
C
C Heights apply to hydrography, hypsography, and survey categories.
C
C Hydrography
		   IF(CATEGORY_NAME(CAT_NUM)(1:4).EQ.'HYDR') THEN
		     BASE_MAJOR_CODE = 50
C Feet
		     IF(HEIGHT_UNITS.EQ.'F') MAJOR_CODE=51
C Metres
		     IF(HEIGHT_UNITS.EQ.'M') MAJOR_CODE=52
C Feet below datum
		     IF(HEIGHT_UNITS.EQ.'F'.AND.HAD_DATUM) MAJOR_CODE=56
C Metres below datum
		     IF(HEIGHT_UNITS.EQ.'M'.AND.HAD_DATUM) MAJOR_CODE=57
C
C Hypsography
		   ELSEIF(CATEGORY_NAME(CAT_NUM)(1:4).EQ.'HYPS')  THEN
		     BASE_MAJOR_CODE = 20
C Feet
		     IF(HEIGHT_UNITS.EQ.'F') MAJOR_CODE=22
C Feet greater than or equal to 10000
		     IF((HEIGHT_UNITS.EQ.'F').AND.(MINOR_CODE.GE.10000)) THEN
			MINOR_CODE = MINOR_CODE - 10000
     			MAJOR_CODE=21
		     ENDIF
C Meters
		     IF(HEIGHT_UNITS.EQ.'M') MAJOR_CODE=24
C Feet below datum
		     IF(HEIGHT_UNITS.EQ.'F'.AND.HAD_DATUM) MAJOR_CODE=23
C Metres below datum
		     IF(HEIGHT_UNITS.EQ.'M'.AND.HAD_DATUM) MAJOR_CODE=25
C
		   ELSEIF(CATEGORY_NAME(CAT_NUM)(1:4).EQ.'SURV')  THEN
		     BASE_MAJOR_CODE = 150
C Feet
		     IF(HEIGHT_UNITS.EQ.'F') MAJOR_CODE=153
C Feet greater than or equal to 10000
		     IF((HEIGHT_UNITS.EQ.'F').AND.(MINOR_CODE.GE.10000)) THEN
			MINOR_CODE = MINOR_CODE - 10000
     			MAJOR_CODE=156
		     ENDIF
C Meters
		     IF(HEIGHT_UNITS.EQ.'M') MAJOR_CODE=154
		   ELSE
C
C ...otherwise current category does not require height
		     CALL LSL_PUTMSG(I2DLG__HEINOTREQ,
     &				     CATEGORY_NAME(CAT_NUM)(1:4),NFNUM)
		     GOTO 20
		   ENDIF
C
C Save codes
		   J = J+1
		   IF(J .GT. MAX_CODES)THEN
		     CALL LSL_PUTMSG(I2DLG__TOOAC,MAJOR_CODE,MINOR_CODE)
		     J = J-1
		     GOTO 20
		   ENDIF
		   CODE_ARRAY(J,1) = MAJOR_CODE
		   CODE_ARRAY(J,2) = MINOR_CODE
C
C Save codes for decimal value if required
		   IF(HAD_DECIMAL_HEIGHTS)THEN
		     J = J+1
		     IF(J .GT. MAX_CODES)THEN
		       CALL LSL_PUTMSG(I2DLG__TOOAC,MAJOR_CODE,MINOR_CODE)
		       J = J-1
		       GOTO 20
		     ENDIF
		     CODE_ARRAY(J,1) = BASE_MAJOR_CODE
C
		     IF(BASE_MAJOR_CODE.EQ.50)THEN
		       MM = 1
		     ELSEIF(BASE_MAJOR_CODE.EQ.20)THEN
		       MM = 2
		     ELSEIF(BASE_MAJOR_CODE.EQ.150)THEN
		       MM = 3
		     ENDIF
C
C get remainder to find out what the decimal is
		     CODE_ARRAY(J,2) = DECIMAL_ATTS(1,MM)	! default
		     RR = HEIGHT - INT(HEIGHT)
		     IF(RR.GE.0.85.AND.RR.LT.0.95)THEN
		       CODE_ARRAY(J,2) = DECIMAL_ATTS(10,MM)
		     ELSEIF(RR.GE.0.75.AND.RR.LT.0.85)THEN
		       CODE_ARRAY(J,2) = DECIMAL_ATTS(9,MM)
		     ELSEIF(RR.GE.0.65.AND.RR.LT.0.75)THEN
		       CODE_ARRAY(J,2) = DECIMAL_ATTS(8,MM)
		     ELSEIF(RR.GE.0.55.AND.RR.LT.0.65)THEN
		       CODE_ARRAY(J,2) = DECIMAL_ATTS(7,MM)
		     ELSEIF(RR.GE.0.45.AND.RR.LT.0.55)THEN
		       CODE_ARRAY(J,2) = DECIMAL_ATTS(6,MM)
		     ELSEIF(RR.GE.0.3.AND.RR.LT.0.45)THEN
		       CODE_ARRAY(J,2) = DECIMAL_ATTS(5,MM)
		     ELSEIF(RR.GE.0.25.AND.RR.LT.0.35)THEN
		       CODE_ARRAY(J,2) = DECIMAL_ATTS(4,MM)
		     ELSEIF(RR.GE.0.15.AND.RR.LT.0.25)THEN
		       CODE_ARRAY(J,2) = DECIMAL_ATTS(3,MM)
		     ELSEIF(RR.GE.0.05.AND.RR.LT.0.15)THEN
		       CODE_ARRAY(J,2) = DECIMAL_ATTS(2,MM)
		     ELSEIF(RR.GE.0.0)THEN
		       IF(MM.EQ.1.OR.MM.EQ.3)THEN
		         CODE_ARRAY(J,2) = DECIMAL_ATTS(2,MM)
		       ELSE
		         CODE_ARRAY(J,2) = DECIMAL_ATTS(1,MM)
		       ENDIF
		     ENDIF
		   ENDIF
C
		 ELSEIF(MAJOR_CODE .EQ. 4)THEN
		     CALL EIHR(AC_BUFF,(IELEN-3),4)
		     CALL EXPAND('%WS%A5',AC_LABEL,AC_BUFF)
		     READ(AC_LABEL,*,ERR=9001)AC_FSN
		     DO 45,MM=1,CAT_CODE(CAT_NUM,3)
			IF(AC_FSN .EQ. AREA_POS(MM,2))THEN
			   LEFT_AREA = MM
			   GOTO 20
			ENDIF
45		     CONTINUE
C
C Is this an area reference
		 ELSEIF(MAJOR_CODE .EQ. 5)THEN
		     CALL EIHR(AC_BUFF,(IELEN-3),4)
		     CALL EXPAND('%WS%A5',AC_LABEL,AC_BUFF)
		     READ(AC_LABEL,*,ERR=9002)AC_FSN
		     DO 46,MM=1,CAT_CODE(CAT_NUM,3)
			IF(AC_FSN .EQ. AREA_POS(MM,2))THEN
			   RIGHT_AREA = MM
			   GOTO 20
			ENDIF
46		     CONTINUE
C
C Remove ACD table ref.
		 ELSEIF(MAJOR_CODE .GT. 100)THEN
		    MAJOR_CODE = MAJOR_CODE - (MAJOR_CODE/1000 * 1000)
C
		    CALL EIHRI(MINOR_CODE,1,2)
C
C Save codes
		    J = J+1
		    IF(J .GT. MAX_CODES)THEN
		      CALL LSL_PUTMSG(I2DLG__TOOAC,MAJOR_CODE,MINOR_CODE)
		      J = J-1
		      GOTO 20
		    ENDIF
		    CODE_ARRAY(J,1) = MAJOR_CODE
		    CODE_ARRAY(J,2) = MINOR_CODE
C
		 ENDIF
	         GOTO 20			! get next IFF entry
C
	      ENDIF
C
C Junction Pointer
	      IF(IECODE .EQ. 'JP')THEN
		 SAVE_POS = LPOSH
		 CALL EIHRL(JB_POS,1,1)
		 CALL EIHRI(JB_OFFSET,1,3)
C
C 'Binary chop' search of array for node number
C
	         L = 1
		 U = NODE_COUNT
		 V = JB_POS + JB_OFFSET
C
C Check individually when less than 5
80	         IF ((L.GE.(U-5)))THEN
		    DO WHILE (L .LE. U)
		       M = L
		       JPOS = NODE_POS(M,1) + NODE_POS(M,2)
		       IF(JPOS .EQ. V) GOTO 90
		       L = L + 1
		    END DO
C
C No node found at the specified JB address and offset
		    GOTO 85
		 ENDIF		       
C
C Chop !
	         M = L + (U-L)/2
		 JPOS = NODE_POS(M,1) + NODE_POS(M,2)
	         IF (JPOS .EQ. V) THEN
	            GOTO 90
	         ELSEIF (JPOS .LT. V) THEN
	            L = M
	         ELSEIF (JPOS .GT. V) THEN
	            U = M
	         ENDIF
	         GOTO 80       ! loop back
C
C
C so search for a point feature with an ST referenced by the JB entry
85	         CALL IFJPKJ(RPOS(1,1),RPOS(2,1),NARMS,JB_POS,JB_OFFSET)
		 DO 89,II=1,NARMS
C
		    L = 1
		    U = NODE_COUNT
		    CALL JIHR(II,V,NVERTX)
		    IF(NVERTX .GT. 1)GOTO 89
C
C Check individually when less than 5
86	            IF ((L.GE.(U-5)))THEN
		       DO WHILE (L .LE. U)
		          M = L
		          JPOS = NODE_POS(M,1) + MAX(0,NODE_POS(M,2))
		          IF(JPOS .EQ. V) GOTO 90
		          L = L + 1
		       END DO
		       GOTO 89	! not this arm, keep looking
		    ENDIF		       
C
C Chop !
	            M = L + (U-L)/2
		    JPOS = NODE_POS(M,1) + MAX(0,NODE_POS(M,2))
	            IF (JPOS .EQ. V) THEN
	               GOTO 90
	            ELSEIF (JPOS .LT. V) THEN
	               L = M
	            ELSEIF (JPOS .GT. V) THEN
	               U = M
	            ENDIF
	            GOTO 86       ! loop back
C
89		 CONTINUE
C
C fall through if no node found for junction
C
		IFF_LINES = I2DLG__NOJUNCTN
		CALL LSL_PUTMSG(IFF_LINES,NFNUM)
		GOTO 1000
C
C Found a node reference - is the start or end of the line?
90		 CALL IFFPKE(IECODE,IELEN,SAVE_POS)
		 IF(HAD_START)THEN
		    END_NODE = M
		 ELSE
		    START_NODE = M
		    HAD_START = .TRUE.
CCCC (PGH) the following code was previously in the binary chop area (wrong)
CCCC was moved here, and is still doubtful for symbols lying on lines,
CCCC so see below under test for TPTS=1
CCCC		    IF(NODE_POS(M,2) .EQ. -1)THEN
CCCC		       HAD_DEG_LINE = .TRUE.
CCCC		       NODE_POS(M,2) = 0
CCCC		       END_NODE = START_NODE
CCCC		    ENDIF
		 ENDIF
C
	         GOTO 20			! get next IFF entry
C
	      ENDIF
C
C When end-of-feature found then write out line details
	      IF(IECODE .EQ. 'EF')THEN
C
C deal with point feature (degenerate line)
		 IF(TPTS.EQ.1) THEN
		    HAD_DEG_LINE = .TRUE.
		    END_NODE = START_NODE
		    TPTS = 2
		 ENDIF
C
C Check values are valid
		 IF(TPTS .LT. 2)THEN
		    IFF_LINES = I2DLG__NOCOORDS
		    CALL LSL_PUTMSG(IFF_LINES,NFNUM)
		    GOTO 1000
		 ENDIF
C
	  	 IF( START_NODE .LT. 1 .OR. END_NODE   .LT. 1)THEN
		    IFF_LINES = I2DLG__NONODES
		    CALL LSL_PUTMSG(IFF_LINES,NFNUM)
		    GOTO 1000
		 ENDIF
C
CC	  	 IF( LEFT_AREA  .LT. 1 .OR. RIGHT_AREA .LT. 1)THEN
CC		    IFF_LINES = I2DLG__NOAREAS
CC		    CALL LSL_PUTMSG(IFF_LINES,NFNUM)
CC		    GOTO 1000
CC		 ENDIF
C
		 ELEM_CODE(1:2) = 'L '
		 CHAR_PAIRS = 0
	   	 CALL EXPAND('%WS%S2%(8%I6%)',
     &	         	      OUTSTR,
     &			      ELEM_CODE,
     &		      	      N,
     &		              START_NODE,
     &		              END_NODE,
     &		              LEFT_AREA,
     &		              RIGHT_AREA,
     &		              TPTS,
     &		              J,
     &		              CHAR_PAIRS)
C
	   	 IF( .NOT. OUTREC(.FALSE.))THEN
		    IFF_LINES=I2DLG__ERROROUT
		    CALL LSL_PUTMSG(IFF_LINES)
		    GOTO 1000
		 ENDIF
C
C E.1-n records
C
C Go back to position of ST entry
		 IF(HAD_ST_POS)THEN
		    CALL IFFPKE(IECODE,IELEN,ST_POS)
	      	    IF (IELEN.EQ.-1) THEN
	               IFF_LINES=I2DLG__UNEXPEOF
	               CALL LSL_PUTMSG(IFF_LINES)
	               GOTO 1000
	            ENDIF
		    STRLEN = 1
5000		    FORMAT(2I6)
40		    CALL EIHRS(NPTS,IENDS)
		    IF(NPTS .LT. 1)THEN
		       IFF_LINES = I2DLG__NOCOORDS
		       CALL LSL_PUTMSG(IFF_LINES,NFNUM)
		       GOTO 1000
		    ENDIF
C
C Now write coordinates
		    CALL EIHRR(RPOS,NPTS*2,1)
C
C Force point feature to output a degenerate line of two identical coords
		    IF(HAD_DEG_LINE)THEN
		       NPTS = 2
		       RPOS(1,2)=RPOS(1,1)
		       RPOS(2,2)=RPOS(2,1)
		    ENDIF
C
		    DO 2000, JJ=1,NPTS
C
		       IPOSX = NINT(RPOS(1,JJ))
		       IPOSY = NINT(RPOS(2,JJ))
C
C Assemble first pair of coords in record
		       WRITE(OUTSTR(STRLEN:STRLEN+11),5000)
     &					IPOSX,IPOSY
		       STRLEN = STRLEN + 12
C
C Write out a record coordinate pairs
		       IF(STRLEN .GE. 144)THEN
	   	          IF( .NOT. OUTREC(.FALSE.))THEN
			     IFF_LINES=I2DLG__ERROROUT
			     CALL LSL_PUTMSG(IFF_LINES)
			     GOTO 1000
			  ENDIF
			  STRLEN = 1
		       ENDIF
C
2000		    CONTINUE
C
C Get any more coords
		    CALL IFFNXT(IECODE,IELEN)
	      	    IF (IELEN.EQ.-1) THEN
	         	IFF_LINES=I2DLG__UNEXPEOF
	         	CALL LSL_PUTMSG(IFF_LINES)
	         	GOTO 1000
	      	    ENDIF
		    IF( IECODE .EQ. 'ST')THEN
			GOTO 40
		    ELSEIF( STRLEN .GT. 1)THEN
	   	        IF( .NOT. OUTREC(.FALSE.))THEN
			   IFF_LINES=I2DLG__ERROROUT
			   CALL LSL_PUTMSG(IFF_LINES)
			   GOTO 1000
			ENDIF
			STRLEN = 1
		    ENDIF
		 ENDIF
C
C F.1-n Record
C	   
C Now ouput any ACs
		 IF(J .GT. 0)THEN
		    STRLEN = 1
		    DO 3000,MM=1,J
C
C Assemble first pair of codes in record
		       WRITE(OUTSTR(STRLEN:STRLEN+11),5000)
     &				CODE_ARRAY(MM,1),CODE_ARRAY(MM,2)
		       STRLEN = STRLEN + 12
C
C Write out a record of major and minor codes
		       IF((STRLEN .GE. 144) .OR. (MM .EQ. J))THEN
	   	          IF( .NOT. OUTREC(.FALSE.))THEN
			     IFF_LINES=I2DLG__ERROROUT
			     CALL LSL_PUTMSG(IFF_LINES)
			     GOTO 1000
			  ENDIF
			  STRLEN = 1
		       ENDIF
C
3000		    CONTINUE
C
		 ENDIF
C
C Completed writing this line so get next
	         GOTO 100
C
	      ENDIF
C
C Ignore any other entry
	      GOTO 20
C
100	CONTINUE
	GOTO 1000
C
C ......................................................................
C
C Errors
C
C Unable to read left-hand area FSN
9001	IFF_LINES = I2DLG__BADLEFTFSN
	CALL LSL_PUTMSG (IFF_LINES, NFNUM)
	GOTO 1000
C
C Unable to read left-hand area FSN
9002	IFF_LINES = I2DLG__BADRIGHTFSN
	CALL LSL_PUTMSG (IFF_LINES, NFNUM)
	GOTO 1000
C
C ......................................................................
C
C Finish
1000	IF (IFF_LINES) IFF_LINES=%LOC(SS$_NORMAL)
	RETURN
C
C ......................................................................
C
	END
