	INTEGER*4 FUNCTION PROCESS()
C
CDEC$	IDENT	'27NO91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	06-Dec-1991
C
C Description:
C       The main loop which reads the IFF file, converts the selected
C       feature to DIGIT and adds them to the buffer.
C
C	Function PROCESS in package I2DIGIT
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'I2DIGITMSG.PAR'		! I2DIGIT messages
C
C Common:
	INCLUDE 'CODES.CMN'
	INCLUDE 'COMMANDS.CMN'
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'LSL$CMNIFF:MD2DES.CMN'
	INCLUDE 'LSL$CMNIFF:IFFHAN.CMN'
C
	INTEGER*2	X,Y
	INTEGER*2	N,I,WORD	! temporary/loop variable
	INTEGER*2	JJ,KK		! temporary/loop variable
	INTEGER*2	IENDS		! pen control for ST
	INTEGER*2  	NPTS		! points in line
	INTEGER*2  	IFC		! current feature code 
	INTEGER*2  	ISTAT(4)	! current feature code
	INTEGER*2	IELEN		! length of
	INTEGER*2	IECODE  	! ... current iff entry
	INTEGER*2	ITYPE		! current type of AC entry
	INTEGER*2	LAYER		! layer number
	INTEGER*2	DBX,DBY		! temps
C
	INTEGER*4	OK,IERR		! for error return
	INTEGER*4	NFNUM(2)	! feature number
	INTEGER*4	STATUS		! function success/failure
	INTEGER*4	TOTPTS		! total points in feature
	INTEGER*4  	PARENTRY	! position in parlist of current FC
	INTEGER*4  	PREVENTRY	! prev value of PARENTRY
	REAL*4		STBUF(2,200)	!
	REAL*4		SCALEFACTOR	!
	REAL*4		OFF(2)		! 
	REAL*4		RA(4)		! IFF range
C
	LOGICAL*4	HAD_ST		! had correct ST entry
	LOGICAL*4	HAD_MD		! had MD entry for scale
	LOGICAL*4	GOT_MATCH1	! true if feature in FC list
	LOGICAL*4	GOT_MATCH2	! true if feature in parameter list
C
C
C Presets:
	INTEGER*4 	SS$_NORMAL
	EXTERNAL  	SS$_NORMAL	! normal successful completion
	INTEGER*4	LIB$EXTV
C
C Functions:
	INTEGER*4	FIND_ENTRY	! find feature entry in parameter list
C
C ......................................................................
C
C Assume success
C
	STATUS = .TRUE.
	HAD_MD = .FALSE.
	PREVENTRY = UNDEFINED
C
C Write sector and partition headers
C
	CALL WRITE_SECTOR_HEADER
	CALL WRITE_PARTITION_HEADER
C
	CALL WRITEF('Processing IFF file...')
C
C-----------------------------------------------------------------------------
C			M A I N   L O O P
C
C Read the IFF file entry by entry and take action on certain types of entry
C
C Assumes:
C	Only ST entries used for coords.
C	
10	CALL IFFNXT(IECODE,IELEN)
11	IF (IELEN.EQ.-1) GOTO 999
	IF (IECODE.EQ.'RA') GOTO 40
	IF (IECODE.EQ.'NF') GOTO 50
	IF (IECODE.EQ.'EF') GOTO 130
	IF (IECODE.EQ.'FS') GOTO 60
	IF (IECODE.EQ.'ST') GOTO 110
	IF (IECODE.EQ.'NO') GOTO 30
	IF (IECODE.EQ.'EJ') GOTO 140
	GOTO 10
C
C ......................................................................
C
C NO - New Overlay
C
30	CALL EIHRI(LAYER,1,1)		! read layer number
C
	IF (HAD_LAYER) THEN
	   DO 35 JJ=1,NUM_LAYER
	      IF (LAYER.EQ.LAYER_LIST(JJ)) GOTO 10 ! we want this layer
35	   CONTINUE
C
C Skip this layer as it was not in the layer list
C
	   CALL IFFNXC('EO',IELEN)
	   IF (IELEN.EQ.-1) THEN
	      STATUS = I2DIGIT__MISSINGENTRY
	      CALL LSL_PUTMSG(STATUS,'EO')
	      GOTO 999
	   ENDIF
	ENDIF
C
	GOTO 10				! get next IFF entry
C
C ......................................................................
C
C RA - Range
C
C Hail to the Sun God,
C He sure is a fun God,
C Ra! Ra! Ra!.
C
40	CONTINUE
	CALL EIHRR(RA,4,1)
	OFF(1) = - RA(1)
	OFF(2) = - RA(3)
	SCALEFACTOR = 32766 / MAX(RA(2)-RA(1),RA(4)-RA(3))
	GOTO 10
C
C ......................................................................
C
C NF - New Feature
C
50	HAD_ST=.FALSE.			! reset string flag
C
	GOTO 10				! get next IFF entry
C
C ......................................................................
C
C FS - Feature Code
C
60	CALL EIHRI(ISTAT,4,1)		! read feature code
	IFC = ISTAT(1)
C
	GOT_MATCH1 = .FALSE.
	GOT_MATCH2 = .FALSE.
C
C Check that the current feature code does match the one
C specified by the /FC qualifier. IF /FC was not given, process all features
C that were specified in parameter file
C
	IF (HAD_FC) THEN
	   DO 65 JJ=1,NUM_FC
	      IF (IFC.EQ.FC_LIST(JJ)) THEN ! we have a match
		 IF (ABS(LIB$EXTV(14,2,ISTAT(3))).EQ.2) GOTO 70 ! ignore text
		 GOT_MATCH1 = .TRUE.	! got a match
	      ENDIF
65	   CONTINUE
	ELSE
	   GOT_MATCH1 = .TRUE.		! process all features
	ENDIF
C
C Check it was in parameter file
C
	PARENTRY = FIND_ENTRY(IFC)
	IF (PARENTRY.GT.0) GOT_MATCH2 = .TRUE.
C
70	IF (GOT_MATCH1.AND.GOT_MATCH2) THEN
C
C Get next entry
C
	   GOTO 10
	ELSE
C
C Skip this feature as it was not in the FC list or parameter file (or text)
C
	   CALL IFFNXC('EF',IELEN)
	   IF (IELEN.EQ.-1) THEN
	      STATUS = I2DIGIT__MISSINGENTRY
	      CALL LSL_PUTMSG(STATUS,'EF')
	      GOTO 999
	   ENDIF
	   GOTO 10
	ENDIF
C
C ......................................................................
C
C ST - string
C
C Put coordinate data into buffer
C
110	TOTPTS=0
C
C Start new feature
C
	CALL WRITE_NEW_FEATURE(PARENTRY,PREVENTRY)
	PREVENTRY = PARENTRY
C
	HAD_ST=.TRUE.
115	CONTINUE
	IF(IECODE.EQ.'ST')THEN
	   CALL EIHRS( NPTS, IENDS)
	   IF (TOTPTS.GT.0.AND.IENDS.EQ.0) GOTO 125    ! ignore invisible lines
	   CALL EIHRR(STBUF(1,1),NPTS*2,1)
	   DO 120 JJ=1,NPTS
C	      X = INT(STBUF(1,JJ))      ! for testing purposes
C	      Y = INT(STBUF(2,JJ))      ! for testing purposes
	      X =       INT((STBUF(1,JJ)+OFF(1)) * SCALEFACTOR + 1)
	      Y = 32767-INT((STBUF(2,JJ)+OFF(2)) * SCALEFACTOR + 1)
	      CALL CHECK_RANGE(X,Y)
	      CALL ADD_WORD(Y)
	      CALL ADD_WORD(X)
120	   CONTINUE
	   TOTPTS=TOTPTS+NPTS
125	   CALL IFFNXT(IECODE,IELEN)
	   GOTO 115
	ELSE
	   IF (TOTPTS.EQ.1) THEN	! output single points as lines
	      CALL ADD_WORD(Y)
	      CALL ADD_WORD(X)
	   ENDIF
	   GOTO 11
	ENDIF
C
C ......................................................................
C
C EF - End Feature
C
130	GOTO 10
C                        
C ......................................................................
C
C EJ - End Job
C
C If a data block has been started fill with unspecified records
C
140	CALL ADD_WORD(END_OF_DATA)
	IF (DISKBUFPTR.GT.1) THEN
	   DO 150 KK = DISKBUFPTR,DISKBUFSIZE
	      DBY = (KK-1) / DISKBLOCKSIZE + 1
	      DBX = (KK-((DBY-1)*DISKBLOCKSIZE))
	      DISKBLOCK(DBX,DBY)=0
150	   CONTINUE
	ENDIF
	CALL FLUSH()
C
C And finish..
C
999	PROCESS = STATUS
	RETURN
	END
