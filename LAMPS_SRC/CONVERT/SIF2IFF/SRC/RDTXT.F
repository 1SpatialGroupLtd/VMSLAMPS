	LOGICAL FUNCTION RDTXT
C
CDEC$	IDENT	'25MR92'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	12-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read parameters of SIF TXT command
C
C Description
C
C	Read parameters of SIF TXT command
C
C	Returns FALSE for error in SIF command line
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'    ! reading strings
C
C Common Blocks
C
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
	INCLUDE 'CMN:FLAGS.CMN'		! flags
	INCLUDE 'CMN:FILES.CMN'		! files
	INCLUDE 'CMN:TEXT.CMN'		! text variables
	INCLUDE 'CMN:IFF_FEATURE.CMN'	! IFF
	INCLUDE 'CMN:IFF_MAP.CMN'	! IFF
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'	! text buffer
C
C Functions called
C
	INTEGER*4	READSTR		! read a string
	INTEGER*4	RDCOMM		! read a command
	INTEGER*4	READLINE	! read line from file or tape
	LOGICAL		READ_SEP	! read a SIF command seperator
	LOGICAL		RDLONG		! read a long integer
	LOGICAL		RDREAL		! read a real
	LOGICAL		FINDFC		! find a feature code
	LOGICAL		CONT_LINE	! continuation line test
	LOGICAL		GET_XYZ		! get coord on line
	LOGICAL		RDCH		! read a character
	LOGICAL		SKIP_CONTLIN	! skip over continuation lines
	INTEGER		BACK_WORD_END	! find real end of text string
C
C Local Variables
C
	INTEGER*4	LEN		! string length
	INTEGER*4	I		! loop counter
	CHARACTER*80	DUMSTR		! dummy character string
	INTEGER*4	IDUMMY		! dummy integer
	REAL		RDUMMY		! dummy real
	INTEGER*4	RESULT		! command read result
	LOGICAL		EOLN
	LOGICAL		OK		! function return status
	INTEGER		AXIS		! flag x or y axis
	REAL		X,Y,Z		! coords
	REAL 		T11,T21		! rotation matrix
	BYTE		COMMA		! terminating character
	PARAMETER	(COMMA=',')
	BYTE		ICH
	BYTE		PTR		! decode pointer
	INTEGER		NOREAL		! real returned flag
	INTEGER		NOLONG		! integer returned flag
	REAL		DX,DY		! distance between x,y coords
	REAL		DSQ		! square of distance
	REAL		STRLEN,STRHGT	! text range block length & height
	INTEGER*4	ERRCOD		! LSLLIB error code
	INTEGER*4	RETCOD		! system error code
C
C External declaration
C
	INTEGER*4	TXTCMD_CMD_TABLE
	EXTERNAL	TXTCMD_CMD_TABLE
C
C...............................................................................
C	Assume that everything goes well
C
	RDTXT = .TRUE.
	IS_TEXT = .TRUE.
	TXT_TYPE1 = .FALSE.
	TXT_TYPE2 = .FALSE.
	IF (HAD_TX3) THEN
	   NOMESS = .TRUE.
	ELSE
	  NOMESS = .FALSE.
	ENDIF
	LINE_IN_HAND = .FALSE.
C
C	........................................................................
C	find feature code. If not found then output warning mess
C	and ignore the feature, skipping any continuation lines
C
	IF (.NOT.FINDFC()) THEN
	   OK = SKIP_CONTLIN()
	   GOTO 9999
	ENDIF
C
C	........................................................................
C	read the command from the line
C
500	RESULT = RDCOMM(TXTCMD_CMD_TABLE)
C
C	and check that there was one - but could be a text string
C
	IF (RESULT .LE. 0) THEN
	   IF (TXT_TYPE1.OR.TXT_TYPE2.OR.TXT_TYPE3) THEN
	      IF (.NOT.TXT_TYPE3) THEN
		 CALL DCPSET(PTR)
	      ELSE
		 CALL DCPSET(5)
	      ENDIF
	      GOTO 600
	   ENDIF   
	   GOTO 9999
	ENDIF
C
C	........................................................................
C	Look for ',' or '=' seperator - send warning mess if not found
C
	OK = READ_SEP(',')
	IF (.NOT.OK) THEN
	   CALL BSCH
	   OK = READ_SEP('=')
	   IF (.NOT.OK) THEN
	      IF (HAD_TX3) THEN			! might be a piece of text
		 CALL DCPSET(5)
		 GOTO 600
	      ENDIF
	      CALL DCPSET(PTR)
	      GOTO 600
	   ENDIF
	ENDIF
C
C	........................................................................
C	test for continuation line
C
	IF (.NOT.CONT_LINE()) GOTO 9999
C
C	........................................................................
C	Despatch according to command
C
	GOTO (510,520,530,540,550,560,570,580,590,610,620) RESULT
C
C	........................................................................
C	Unknown command - might be a text string if by now we know what form
C	the TXT command is in. Otherwise error.
C
	IF (TXT_TYPE1.OR.TXT_TYPE2.OR.TXT_TYPE3) THEN
	   CALL BSCH
	   GOTO 600
	ELSE
	   CALL LSL_PUTMSG(SIF2IFF__UNKCMD,CMDNST)	! warning mess
	   GOTO 9999
	ENDIF
C
C...............................................................................
C
C	........................................................................
C	MR - Ignore mirroring, continue reading rest of line
C
510	GOTO 500
C
C	........................................................................
C	TL - Top left
C
520	NOREAL = RDREAL(TLX)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999

	NOREAL = RDREAL(TLY)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999

	IF (DIMEN.EQ.3) THEN
	   NOREAL = RDREAL(TLZ)
	   OK = READ_SEP(',')
	   IF (.NOT.CONT_LINE()) GOTO 9999
	ENDIF

	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF

	GOTO 500
C
C	........................................................................
C	BL - bottom left
C
530	NOREAL = RDREAL(BLX)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999

	NOREAL = RDREAL(BLY)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999

	IF (DIMEN.EQ.3) THEN
	   NOREAL = RDREAL(BLZ)
	   OK = READ_SEP(',')
	   IF (.NOT.CONT_LINE()) GOTO 9999
	ENDIF

	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	GOTO 500
C
C	........................................................................
C	BR - bottom right
C
540	NOREAL = RDREAL(BRX)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	NOREAL = RDREAL(BRY)
	OK = READ_SEP(',')
C
C	now check for a text string testing for EOLN. If it is EOLN
C	get continuation line.
C
	EOLN = RDCH(ICH)
	IF (EOLN) THEN
	   IF (.NOT.CONT_LINE()) GOTO 9999
	ELSE
	   CALL BSCH
	ENDIF
	IF (DIMEN.EQ.3) THEN
	   NOREAL = RDREAL(BRZ)
	   OK = READ_SEP(',')
	   EOLN = RDCH(ICH)
	   IF (EOLN) THEN
	      IF (.NOT.CONT_LINE()) GOTO 9999
	   ELSE
	      CALL BSCH
	   ENDIF
	ENDIF
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	TXT_TYPE1 = .TRUE.
	TXT_TYPE3 = .FALSE.				!switch off TX3
	NOMESS = .TRUE.
	CALL DCPSAV(PTR)
	GOTO 500
C
C	........................................................................
C	OR - text origin
C
550	TXT_TYPE2 = .TRUE.	
	TXT_TYPE3 = .FALSE.				!switch off TX3
C
	IF (.NOT.GET_XYZ()) GOTO 9999			!get the coords
C
	NOMESS = .TRUE.
	CALL DCPSAV(PTR)
	GOTO 500				!get next command or text string
C
C	........................................................................
C	TH - text height
C
560	NOLONG = RDLONG(TXT_HEIGHT)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	HAD_TXT_TH = .TRUE.
	NOMESS = .TRUE.
	CALL DCPSAV(PTR)
	GOTO 500				!get next command or text string
C
C	........................................................................
C	TW - text width
C
570	NOLONG = RDLONG(TXT_WIDTH)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	IF (NOLONG) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	NOMESS = .TRUE.
	CALL DCPSAV(PTR)
	GOTO 500				!get next command or text string
C
C	........................................................................
C	AN - text angle in degrees
C
580	NOREAL = RDREAL(TXT_ANGLE)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999
	IF (NOREAL) THEN
	   CALL LSL_PUTMSG(SIF2IFF__NUMNOTFOU)	!warning mess
	   GOTO 9999
	ENDIF
	ANGLE = (TXT_ANGLE * PI)/180.0		! convert to radians
	HAD_TXT_AN = .TRUE.
	NOMESS = .TRUE.
	CALL DCPSAV(PTR)
	GOTO 500				!get next command or text string
C
C	........................................................................
C	MA - matrix. Get rotation only from matrix.
C
590	NOREAL = RDREAL(T11)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999

	NOREAL = RDREAL(T21)
	OK = READ_SEP(',')
	IF (.NOT.CONT_LINE()) GOTO 9999

	ANGLE = ATAN2(T21,T11)			!in radians
	DO 591 I = 1,2
	   NOREAL = RDREAL(RDUMMY)	
	   OK = READ_SEP(',')
	   IF (.NOT.CONT_LINE()) GOTO 9999
591	CONTINUE

	IF (DIMEN.EQ.3) THEN			!ignore rest of 3D matrix
	   DO 592 I = 1,5
	      NOREAL = RDREAL(RDUMMY)	
	      OK = READ_SEP(',')
	      IF (.NOT.CONT_LINE()) GOTO 9999
592	   CONTINUE
	ENDIF

	NOMESS = .TRUE.
	CALL DCPSAV(PTR)
	HAD_TXT_AN = .TRUE.
	GOTO 500				!get next command or text string
C
C	........................................................................
C	DE - dimension element - ignore
C
610	LEN = READSTR(DUMSTR,COMMA,ON_CHAR)
	GOTO 500
C
C	........................................................................
C	EN - trailing banks - ignore
C
620	LEN = READSTR(DUMSTR,COMMA,ON_CHAR)
	GOTO 500
C
C	........................................................................
C	didn't recognise command, must be text
C
600	DO 601 I = 1,255
	   TEXT(I:I) = ' '
601	CONTINUE
	NCHS = READSTR(TEXT)	!READ TEXT
	IF (NCHS.EQ.0) THEN
	   IF (HAD_LOG) THEN
	      CALL LSL_PUTMSG(SIF2IFF__NULLTXTSTR)	!warning mess
	      CALL LSL_ADDMSG(SIF2IFF__LINEINSIF,LINE)
	      LSL_STATUS = SIF2IFF__LINEINSIF		!reduce error status
	   ENDIF
	   RDTXT = .TRUE.			! treat as successful
	   GOTO 9000
	ENDIF
C
605	LINE = LINE+1
C
	ERRCOD = READLINE(RETCOD)
	IF (ERRCOD .EQ. LSL__EOF) THEN
	   RDTXT = .FALSE.
	   GOTO 9000
	ENDIF
	CALL BSLN
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   IF (MAGTAPE) THEN
	      CALL LSL_PUTMSG(SIF2IFF__ERRRDMAG,TAPEDEV(1:TAPEDEVLEN))
	      CALL LSL_ADDMSG(ERRCOD)
	   ELSE
	      CALL LSL_PUTMSG(SIF2IFF__ERRRDSIF,SIFFIL(1:SIFLEN),LINE)
	      CALL LSL_ADDMSG(ERRCOD)
	      IF (ERRCOD .EQ. LSL__SYSREAD) CALL LSL_ADDMSG(RETCOD)
	   ENDIF
	   GOTO 9999
	ENDIF
C
	LEN = READSTR(DUMSTR,,,.FALSE.,)
	IF (DUMSTR(1:4).EQ.'    '.AND.LEN.GT.0) THEN
	   DUMSTR(1:LEN) = DUMSTR(5:LEN)//'    '
	   LEN = LEN - 4
	   TEXT(NCHS+1:NCHS+LEN) = DUMSTR(1:LEN)
	   NCHS = NCHS + LEN
	ELSE
	   CALL BSLN			! unread line
	   LINE_IN_HAND = .TRUE.
	ENDIF
C
	IF (.NOT.LINE_IN_HAND) GOTO 605
C
	NCHS = BACK_WORD_END(TEXT,NCHS)
C
C...............................................................................
C Calculate text height and angle depending on the form of TXT
C
C	........................................................................
701	IF (TXT_TYPE1) THEN
C
C	   .....................................................................
C
	   DX = (BRX-BLX)
	   DY = (BRY-BLY)
	   RDUMMY = SQRT( DX*DX + DY*DY )
	   ANGLE = ATAN2((DY/RDUMMY),(DX/RDUMMY))
C
C	   .....................................................................
C
	   DX = (TLX-BLX)
	   DY = (TLY-BLY)
	   RDUMMY = SQRT( DX*DX + DY*DY )
	   HEIGHT = ABS(((RDUMMY*1000)/REAL(SCALE))*100)   ! convert to sheet mm
C
C	   .....................................................................
C
	   IF (HEIGHT.EQ.0) HEIGHT = 1
C
C	   .....................................................................
C	   calculate location point according to justification value
C
	   STRHGT = TLY-BLY
	   STRLEN = BRX-BLX
C
	   TORX = BLX
	   TORY = BLY
	   IF ((JUSTIF.EQ.2).OR.(JUSTIF.EQ.5).OR.(JUSTIF.EQ.8))
     &		TORY = BLY + STRHGT
	   IF ((JUSTIF.EQ.1).OR.(JUSTIF.EQ.4).OR.(JUSTIF.EQ.7))
     &          TORY = BLY + (STRHGT/2)
	   IF ((JUSTIF.EQ.8).OR.(JUSTIF.EQ.7).OR.(JUSTIF.EQ.6))
     & 	        TORX = BLX + STRLEN
	   IF ((JUSTIF.EQ.5).OR.(JUSTIF.EQ.4).OR.(JUSTIF.EQ.3))
     &	        TORX = BLX + (STRLEN/2)

	   TORX = (TORX - XMIN)/UNITS		!convert from UORs to mm
	   TORY = (TORY - YMIN)/UNITS		!convert from UORs to mm
	   TORZ = (BLZ - ZMIN)/UNITS		!convert from UORs to mm
C
C	........................................................................
C
	ELSE IF (TXT_TYPE2.OR.TXT_TYPE3) THEN
	   IF (HAD_TXT_TH) THEN
	      HEIGHT = ABS(TXT_HEIGHT)
	   ELSE	
	      HEIGHT = 1				!use default
	   ENDIF
	   IF (.NOT.HAD_TXT_AN) ANGLE = 0.0		!use default
	ENDIF
C
C...............................................................................
C get the pointsize if POINTSIZE has been specified in the FDF
C
	IF (HAD_POINTSIZE) THEN
	   CALL FINDPSIZE
	ELSE
	   IF (HAD_TXT_TH) THEN
	      RDUMMY = HEIGHT/REAL(UNITS)  !convert from UORS TO M
	      HEIGHT = ABS(((RDUMMY*1000)/REAL(SCALE))*100) !convert to sheet mm
	   ENDIF
	ENDIF
C
C...............................................................................
C put out feature
C
	CALL START_FEATURE					!start feature
C
	CALL COORD(TORX,TORY,TORZ)				!origin coord
C
	CALL WRITE_FEATURE
	RDTXT = .TRUE.
	GOTO 9000
C
C...............................................................................
C
9999	RDTXT = .FALSE.
	IF (DONE_START_FEATURE) CALL IFFDEL
	DONE_START_FEATURE = .FALSE.
C
C...............................................................................
C Return
C
9000	IS_TEXT = .FALSE.
	HAD_TX3 = .FALSE.
	TXT_TYPE1 = .FALSE.
	TXT_TYPE2 = .FALSE.
	TXT_TYPE3 = .FALSE.
	NOMESS = .FALSE.
C...............................................................................
	RETURN
	END
