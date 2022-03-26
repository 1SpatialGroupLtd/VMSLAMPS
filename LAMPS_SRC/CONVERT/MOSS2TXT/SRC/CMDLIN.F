        INTEGER*4 FUNCTION CMDLIN()
C
CDEC$	IDENT	'22AP91'
C
C 	Copyright Laser-Scan Laboratories Ltd.,England
C
	IMPLICIT NONE
C
C Parameters
C
	INCLUDE 'PARAMS.PAR'
	INCLUDE '($SSDEF)/NOLIST'
C
C Common
C
	INCLUDE 'LSL$CMNLSL:CLD.CMN'
	INCLUDE 'LSL$CMNLSL:FILENAME.CMN'
	INCLUDE 'COMMAND.CMN'
C
C Command Language Definitions
C
	EXTERNAL	MOSS2TXT_CLD
C
C Longword
C
	INTEGER		I	   ! tmp var.
	INTEGER		TMP_LEN	   ! length of tmp. file-spec
C
C Logical*4
C
	LOGICAL		ABSENT	   ! .T. if file param. not found
	LOGICAL		HAD_AC	   ! had /HEIGHT_AC qualifier
	LOGICAL		HAD_BLK	   ! had /BLOCK_SIZE qualifier
	LOGICAL		HAD_DEN	   ! had /DENSITY qualifier
	LOGICAL		HAD_NAME   ! had /NAME qualifier
	LOGICAL		HAD_TER	   ! had /TERMINATOR qualifier
 	LOGICAL		LOCAL      ! .T. if qual. is local
	LOGICAL		LOCNEG     ! set .T. if qual. locally negated
        LOGICAL		WHINGE     ! .T. - local error reporting
C
C Functions called:
	INTEGER*4	DCL_FILE   ! reads & parses file title from DCL 
C			           ! command line
	INTEGER*4	DCL_INT	   ! looks for qualifier integer args.
	INTEGER*4	DCL_QUAL   ! looks for specified qualifier
	INTEGER*4	DCL_REAL   ! looks for qualifier real args.
        INTEGER*4       DCL_STARTUP! looks for command line
        INTEGER*4       DCL_STR	   ! looks for qualifier string args.
C
C Character:
	CHARACTER*256	TMP_FIL	   ! temp file-spec for parsing
C
C...................................................................
C
C	    I N I T I A L I S E   T H I N G S 
C
	WHINGE=.TRUE.		 ! local error reporting
C
C....................................................................
C
C	    G E T   C O M M A N D   L I N E
C
	CMDLIN=DCL_STARTUP('MOSS2TXT',.FALSE.,MOSS2TXT_CLD,WHINGE)
C
C DCL_STARTUP will return set to SS$_NORMAL if all well.
C
        IF (.NOT.CMDLIN) GOTO 10 		! return
C
C....................................................................
C
C	     C H E C K   F O R   Q U A L I F I E R S
C
C Check for /PARAMETER
C
!	CMDLIN=DCL_QUAL('PARAMETER',HAD_PAR,LOCAL,LOCNEG,WHINGE)
!	IF (HAD_PAR) THEN    	  
!	  CMDLIN=DCL_FILE('PARAMETER','GENCODE.DAT',
!     &	            ABSENT,.FALSE.,WHINGE)
!	  IF (.NOT.CMDLIN) GOTO 10 	! return
!          PAR_FIL=FILARY(1)(1:FIL_LEN(1))
!	  PAR_LEN=FIL_LEN(1)
!	ELSE
!	  CMDLIN = .FALSE.
!	  GOTO 10
!	ENDIF
C
C Get input file-spec
C
	CMDLIN=DCL_FILE('P1','SYS$DISK:[]',ABSENT,.FALSE.,WHINGE)
C
C Transfer file-spec to a local variable
C
        IF (CMDLIN) THEN
          P1_FIL=FILARY(1)(1:FIL_LEN(1))
	  P1_LEN=FIL_LEN(1)
        ELSE
          GOTO 10 			! return
        ENDIF 
C
C Get output filename
C
	CMDLIN=DCL_FILE('P2','SYS$DISK:[]',ABSENT,.FALSE.,WHINGE)
C
C Transfer file-spec to a local variable
	IF (CMDLIN) THEN
          P2_FIL=FILARY(1)(1:FIL_LEN(1))
	  P2_LEN=FIL_LEN(1)
	ENDIF
C
10	IF (CMDLIN) CMDLIN=SS$_NORMAL
	RETURN
   	END