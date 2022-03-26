	LOGICAL FUNCTION CMDLIN
C
CDEC$	IDENT	'26MY94'
C
C Copyright Laser-Scan Laboratories Ltd., Cambridge, England
C
C Author 	09-June-1992	SG
C
C
	IMPLICIT NONE
C
C  
C  Common Blocks
	INCLUDE 'LSL$CMNLSL:CLD.CMN'
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'

	INCLUDE 'HERE:COMMANDS.CMN'
	INCLUDE 'HERE:FILENAME.CMN'
	INCLUDE 'HERE:LCMMSG.PAR'
	INCLUDE 'HERE:LUNS.PAR'
C
C Comand language definitions   
	EXTERNAL	LCMSQUASH_CLD

C Functions
	INTEGER*4	DCL_FILE	! reads and parses file title
	INTEGER*4	DCL_QUAL	! looks for specified qualifier
	INTEGER*4	DCL_INT		! looks for specified integer
	INTEGER*4	DCL_STR		! looks for specified string
	INTEGER*4	DCL_STARTUP	! gets and parses the DCL command line
 	INTEGER*4	EXPFLN 
C
C Local Variables
C
	LOGICAL		LOCAL		! .T. if qual. is local
	LOGICAL	     	ABSENT		! was a filename there
	LOGICAL		OK
	LOGICAL		HADQUAL
	INTEGER		I,C
C
C ......................................................................
C Get command line for our command verb LCMSQUASH. DCL_STARTUP will
C return set to SS$_NORMAL if all is well. 
C
	OK=DCL_STARTUP('LCMSQUASH',.FALSE.,LCMSQUASH_CLD,.TRUE.)
	IF (.NOT. OK) GOTO 9999
C
C ......................................................................
C Check for /LOG
C
	OK=DCL_QUAL('LOG',LOG,LOCAL, ABSENT, .TRUE.)
	IF (.NOT. OK) GOTO 9999
C
C ......................................................................
C Check for /QUIET
C
	OK=DCL_QUAL('QUIET',QUIET,LOCAL, ABSENT, .TRUE.)
	IF (.NOT. OK) GOTO 9999
C
C ......................................................................
C Check for /CHECK=QUOTE
C
	OK=DCL_QUAL('CHECK.QUOTE',CQUOTE,LOCAL, ABSENT, .TRUE.)
	IF (.NOT. OK) GOTO 9999
C
C ......................................................................
C Check for /CODE=code
C
	OK=DCL_QUAL('CODE',CODE,LOCAL, ABSENT, .TRUE.)
	IF (.NOT. OK) GOTO 9999
	IF (CODE) THEN
	  OK=DCL_INT('CODE', .TRUE.)
	  IF (.NOT. OK) GOTO 9999
	  E_CODE = IARRAY(1)
	ENDIF
C
C ......................................................................
C Check for /KEY=key (must have /CODE as well)
C
	OK=DCL_QUAL('KEY',HADQUAL,LOCAL, ABSENT, .TRUE.)
	IF (.NOT. OK) GOTO 9999
	IF (HADQUAL) THEN
	  OK=DCL_STR('KEY', .TRUE.)
	  IF (.NOT. OK) GOTO 9999
	  E_KLEN = STR_LEN(1)
	  IF (E_KLEN.GT.LEN(E_KEY)) THEN
	    OK = LCM__ILLEGALKEY
	    CALL LSL_PUTMSG(OK)
	    GOTO 9999
	  ENDIF
	  E_KEY = CARRAY(1)(:E_KLEN)
	ENDIF
	IF (CODE.NEQV.HADQUAL) CODE = .FALSE.
C
C alter key to match what is stored in LITES2 licence
C (see also LITES2 INSTGEN)
C
	DO 10 I=1,E_KLEN
	  C = ICHAR(E_KEY(I:I))
	  IF (C.LT.32.OR.C.GT.126) THEN
	    OK = LCM__ILLEGALKEY
	    CALL LSL_PUTMSG(OK)
	    GOTO 9999
	  ENDIF
	  C = C-32		! now 0-94
	  C = MOD( C+2*I-1, 95 )
	  C = C+32
	  IF (C.EQ.ICHAR('''')) C = ICHAR('"')	! avoid Fortran problem
	  IF (C.EQ.ICHAR(' ').AND.I.EQ.E_KLEN) C = ICHAR('~')
	  E_KEY(I:I) = CHAR(C)
10	CONTINUE
C
C ......................................................................
C Check for /COMMENT=comment
C
	OK=DCL_QUAL('COMMENT',HADQUAL,LOCAL, ABSENT, .TRUE.)
	IF (.NOT. OK) GOTO 9999
	COMMENTL = 0
	IF (HADQUAL) THEN
	  OK=DCL_STR('COMMENT', .TRUE.)
	  IF (.NOT. OK) GOTO 9999
	  COMMENTL = MIN(STR_LEN(1), LEN(COMMENT))
	  COMMENT = CARRAY(1)(:COMMENTL)
	ENDIF
C
C ......................................................................
C Now get the input files
C
	OK=DCL_FILE('IN_FILE','LSL$LITES2CMD:.LCM', ABSENT, .FALSE., .TRUE.)
	IF (.NOT. OK) GOTO 9999
C
C	................................................................
C	Transfer the file-spec to our local variable
C
	IN_LEN=FIL_LEN(1)
	IN_FNAME=FILARY(1)(:IN_LEN)	   	    	   
C
C ......................................................................
C	and work out default out file spec
C
C
	HAD_EXT = .TRUE.
	LEN_EXT = 3
C
	HAD_NOD = .FALSE.		! no node
	HAD_DEV = .FALSE.		! no device
	HAD_DIR = .FALSE.		! no directory
	HAD_VER= .FALSE.		! no version number
C
C	................................................................
C	default output file name
C
	STR_EXT = 'LCM'
	CALL EXPFLN( OUT_FNAME,OUT_LEN)
C
C	................................................................
C	default list file name
C
	STR_EXT = 'LIS'
	CALL EXPFLN( LIST_FNAME,LIST_LEN)
C
C	................................................................
C	default explode file name
C
	STR_EXT = 'EXP'
	CALL EXPFLN( EXPL_FNAME,EXPL_LEN)
C	
C ......................................................................
C /LIST=file - output a log file
C
	OK=DCL_QUAL('LIST',LIST,LOCAL,ABSENT,.TRUE.)
	IF (OK.AND.LIST) THEN
 	   OK=DCL_FILE('LIST',LIST_FNAME(1:LIST_LEN),ABSENT,.TRUE.,.TRUE.)
	   IF (OK.AND.(.NOT.ABSENT)) THEN
	     LIST_LEN =FIL_LEN(1)
	     LIST_FNAME=FILARY(1)(:LIST_LEN)
	   ENDIF
	ENDIF
C
	IF (.NOT.OK) GOTO 9999
C
C ......................................................................
C /EXPLODE - put commands onto individual lines
C
	OK=DCL_QUAL('EXPLODE',EXPLODE,LOCAL,ABSENT,.TRUE.)
	IF (OK.AND.EXPLODE) THEN
 	   OK=DCL_FILE('EXPLODE',EXPL_FNAME(1:EXPL_LEN),ABSENT,.TRUE.,.TRUE.)
	   IF (OK.AND.(.NOT.ABSENT)) THEN
	     EXPL_LEN =FIL_LEN(1)
	     EXPL_FNAME=FILARY(1)(:EXPL_LEN)
	   ENDIF
	ENDIF
C
	IF (.NOT.OK) GOTO 9999
C
C ......................................................................
C get the optional output file name. with this one it doesn't matter if
C there is no output filename as we have calculated what it is
C so thats why we are just CALLing
C
	CALL DCL_FILE('OUT_FILE' ,OUT_FNAME(1:OUT_LEN), ABSENT, .FALSE.,.TRUE.)

C	................................................................
C	Transfer the file-spec to our local variable
C
	IF (.NOT.ABSENT) THEN
	  OUT_LEN=FIL_LEN(1)
	  OUT_FNAME=FILARY(1)(:OUT_LEN)	   	    	   
	ENDIF
C
C ......................................................................
C
9999	CMDLIN = OK
	RETURN
	END
