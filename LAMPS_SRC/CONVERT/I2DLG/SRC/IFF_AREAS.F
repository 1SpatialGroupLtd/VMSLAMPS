        INTEGER*4  FUNCTION IFF_AREAS()
C
CDEC$	IDENT	'06OC89'
C
C 	Copyright Laser-Scan Laboratories Ltd.,England
C
C Created.					  FJB  18-Aug-1989
C
C Transfer area point features in input IFF file (open on lun IFFLUN) to 
C area records in DLG format (open on lun DLGLUN)
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
	INTEGER*2	MM	! temporary/loop variable
	INTEGER*2 	NOVER	! layer number
	INTEGER*2 	NFNUM	! FSN number
	INTEGER*2	NPTS	! number of co-ordinates in point or feature
	INTEGER*2	IENDS	! pen up/down flag
	INTEGER*2	IECODE	! entry code
	INTEGER*2	IELEN	! return code
	INTEGER*2	STRLEN	! length of string of major and minor codes
C
C Real:
	REAL		RPOS(2,1) ! coordinates
C
C Longword:
	INTEGER		N	! record counter
	INTEGER		J	! AC counter
	INTEGER		CHAR_PAIRS	! character pairs in D1 record
	INTEGER		IERR	! for error return
	INTEGER		IPOSX	! X coord
	INTEGER		IPOSY	! Y coord
	INTEGER		MAJOR_CODE	! AC type number (DLG major code)
	INTEGER		MINOR_CODE	! AC integer value (DLG minor code)
        INTEGER		CODE_ARRAY(MAX_CODES,2)! stores AC type and value
C
	LOGICAL		START_REC	! flag beginning of code record
	LOGICAL		READ_AC 	! want to read an AC entry
	LOGICAL		HAD_OUTSIDE	! flag got the outside area feature
C
C Functions:
	INTEGER*4	FRTFND		! get FRT parameters for FC
	INTEGER*4	ACDFND          ! get ACD table parameters for AC
	INTEGER*4	OUTREC		! output data to mag tape
C
C Presets:
	INTEGER*4 	SS$_NORMAL
	EXTERNAL  	SS$_NORMAL	! normal successful completion
C
C ....................................................................
C
C Assume the best
	IFF_AREAS=%LOC(SS$_NORMAL)
C
C Initialize
	ELEM_CODE(1:2) = 'A '
	CHAR_PAIRS = 0
	HAD_OUTSIDE = .FALSE.
C
C .....................................................................
C
C			M A I N   L O O P
C
C Skip through the IFF file using the positions for FS and JB entries
C previously found in s/r IFF_SCAN
C
C
	DO 100,N=1,AREA_COUNT
C
	   J = 0
	   READ_AC = .TRUE.
	   HAD_BACKGROUND = .FALSE.
C
C First area is always the outside area
	   IF ( N .EQ. 1 .AND. AREA_POS(N,1) .EQ. 0) THEN
C
C Not found an outside area feature so write it at 0,0
	      IPOSX = 0
	      IPOSY = 0
	      J = 1
	      CHAR_PAIRS = 0
C
	      CALL EXPAND('%WS%S2%(5%I6%)',
     &	         	      OUTSTR,
     &		      	      ELEM_CODE(1:2),
     &		      	      N,
     &		              IPOSX,
     &		              IPOSY,
     &		              J,
     &		              CHAR_PAIRS)
C
	      IF( .NOT. OUTREC(.FALSE.)) THEN
		 IFF_AREAS=I2DLG__ERROROUT
		 CALL LSL_PUTMSG(IFF_AREAS)
		 GOTO 1000
	      ENDIF
C	   
C Now output 1 pair of ACs
	      CODE_ARRAY(1,1) = 0
	      CODE_ARRAY(1,2) = 0
C
C Assemble first pair of codes in record
	      STRLEN = 1
	      WRITE(OUTSTR(STRLEN:STRLEN+11),5000)
     &			CODE_ARRAY(1,1),CODE_ARRAY(1,2)
C
C Write out a record of major and minor codes
	      IF( .NOT. OUTREC(.FALSE.))THEN
	         IFF_AREAS=I2DLG__ERROROUT
	         CALL LSL_PUTMSG(IFF_AREAS)
                 GOTO 1000
	      ENDIF
	      HAD_OUTSIDE = .TRUE.
	      GOTO 100
	   ENDIF
C
C Examine area features
	   CALL IFFPKE(IECODE,IELEN,AREA_POS(N,1))
	   IF (IELEN.EQ.-1) THEN
	      IFF_AREAS=I2DLG__UNEXPEOF
	      CALL LSL_PUTMSG(IFF_AREAS)
	      GOTO 1000
	   ENDIF
C
C ......................................................................
C
C FS - Feature Code
C
	   IF(IECODE .NE. 'FS') GOTO 100
C
20	      CALL IFFNXT(IECODE,IELEN)
	      IF (IELEN.EQ.-1) THEN
	         IFF_AREAS=I2DLG__UNEXPEOF
	         CALL LSL_PUTMSG(IFF_AREAS)
	         GOTO 1000
	      ENDIF
C
C Get first pair of co-ordinates
	      IF((IECODE .EQ. 'ST') .OR. (IECODE .EQ. 'ZS'))THEN
		 CALL EIHRS(NPTS,IENDS)
		 IF(NPTS .LT. 1) THEN
		    IFF_AREAS = I2DLG__NOCOORDS
		    CALL LSL_PUTMSG(IFF_AREAS,NFNUM)
		    GOTO 1000
		 ENDIF
		 CALL EIHRR(RPOS,2,1)
		 IPOSX = NINT(RPOS(1,1))
		 IPOSY = NINT(RPOS(2,1))
	         GOTO 20	    
	      ENDIF
C
C Get ACs
	      IF(IECODE .EQ. 'AC' .AND. READ_AC)THEN
		 CALL EIHR(MAJOR_CODE,1,1)
		 IF(MAJOR_CODE .GT. 100)THEN
		    CALL EIHRI(MINOR_CODE,1,2)
C
C Check it is a valid AC
		    IF(ACDFND(MAJOR_CODE,.TRUE.))THEN
		       IFF_AREAS = I2DLG__UNKATYP
	   	       CALL LSL_PUTMSG(IFF_AREAS,MAJOR_CODE)
	   	       GOTO 1000
		    ENDIF
C
C Remove ACD table ref.
		    MAJOR_CODE = MAJOR_CODE - (MAJOR_CODE/1000 * 1000)
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
C Deal specially with Outside Area
		    IF(ACD_NAME(1:12) .EQ. 'OUTSIDE_AREA')THEN
C
C Ignore this AC if already had outside point feature
			IF(HAD_OUTSIDE)THEN
			   CALL LSL_PUTMSG(I2DLG__HADOUT,AREA_POS(N,2))
			   GOTO 20
			ENDIF
C
			J = 1
			CODE_ARRAY(1,1) = 0
			CODE_ARRAY(1,2) = 0
			HAD_OUTSIDE = .TRUE.
			GOTO 20
		    ENDIF
C
C Deal specially with Background Area
		    IF(ACD_NAME(1:15) .EQ. 'BACKGROUND_AREA')THEN
			J = 0		! no attributes
			READ_AC = .FALSE.
			HAD_BACKGROUND = .TRUE.
			GOTO 20
		    ENDIF
		 ENDIF
	         GOTO 20			! get next IFF entry
C
	      ENDIF
C
C When end-of-feature found then write out area details
	      IF(IECODE .EQ. 'EF')THEN
C
C Adjust coords if necessary
		 IF(HAD_BACKGROUND)THEN
		    IPOSX = 0
		    IPOSY = 0
		 ENDIF
C
	   	 CALL EXPAND('%WS%S2%(5%I6%)',
     &	         	      OUTSTR,
     &		      	      ELEM_CODE(1:2),
     &		      	      N,
     &		              IPOSX,
     &		              IPOSY,
     &		              J,
     &		              CHAR_PAIRS)
C
	   	 IF( .NOT. OUTREC(.FALSE.)) THEN
		    IFF_AREAS=I2DLG__ERROROUT
		    CALL LSL_PUTMSG(IFF_AREAS)
		    GOTO 1000
		 ENDIF
C	   
C Now ouput any ACs
5000		 FORMAT(2I6)
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
			     IFF_AREAS=I2DLG__ERROROUT
			     CALL LSL_PUTMSG(IFF_AREAS)
			     GOTO 1000
			  ENDIF
			  STRLEN = 1
		       ENDIF
C
3000		    CONTINUE
C
		 ENDIF
C
C Finished outputting this area feature so continue loop to get next one
	         GOTO 100
C
	      ENDIF
C
C Ignore any other entries
	      GOTO 20
C
100	CONTINUE
C
C
	GOTO 1000
C
C Error if not had an outside feature
1000	IF( .NOT. HAD_OUTSIDE)THEN
	   IFF_AREAS = I2DLG__NOOUT
	   CALL LSL_PUTMSG(IFF_AREAS)
	ENDIF
C
C ......................................................................
C
	IF (IFF_AREAS) IFF_AREAS=%LOC(SS$_NORMAL)
	RETURN
C
C ......................................................................
C
	END
