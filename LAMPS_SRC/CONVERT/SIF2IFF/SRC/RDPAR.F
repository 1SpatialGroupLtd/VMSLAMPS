	LOGICAL FUNCTION RDPAR
C
CDEC$	IDENT	'26MY95'
C
C	Copyright Laser-Scan Ltd., Cambridge, England.
C
C	Created					JMC	10-Jan-1990
C
C	CONVERT SIF2IFF Utility - Read Parameter file
C
C Description
C
C	This function reads the Parameter file which translates 
C	feature code definitions
C
C	For ordinary errors, we attempt to continue with the file
C
C	Returns FALSE if something drastic goes wrong, TRUE otherwise
C
	IMPLICIT NONE
C
C Included Parameter Files
C
	INCLUDE 'CMN:FDF.PAR'	    
	INCLUDE 'CMN:LUN.PAR'	    ! message definitions
	INCLUDE 'CMN:SIF2IFFMSG.PAR'	    ! message definitions
	INCLUDE 'LSL$CMNLSL:LSLLIBMSG.PAR'  ! LSLLIB message definitions
C
C Local Parameters
C
	BYTE		PLING		! comment delimiter
	PARAMETER	(PLING = '!')
C
C Common Blocks
C
        INCLUDE '($SSDEF)'
	INCLUDE 'LSL$CMNLSL:CMDCOM.CMN'	! command decoding
	INCLUDE 'LSL$CMNLSL:STATUS.CMN'	! LSLLIB status flag
	INCLUDE 'CMN:SIF2IFF.CMN'	! globals
	INCLUDE 'CMN:FDF_LOOKUP.CMN'	! lookup arrays for param file
	INCLUDE 'CMN:FLAGS.CMN'		! flags
	INCLUDE 'CMN:FILES.CMN'		! filenames
C
C Functions called
C
	INTEGER*4	FLROPN		! open file for reading
	INTEGER*4	FLRCLO		! close file for reading
	INTEGER*4	FLRLIN		! read in line from file
	INTEGER*4	RDCOMM		! read a command
	INTEGER*4	SIGCHS		! significant chars in string
	LOGICAL		RDCH		! read next character
	LOGICAL		RDFDF		! read a feature description
	LOGICAL		READ_LUT	! read CCSM LUT
        LOGICAL         TRNALL          ! translate logical names
C
C Local Variables
C
	INTEGER*4	I		! counter
	INTEGER*4	J		! counter
	INTEGER*4	RESULT		! command read result
	INTEGER*4	ERRCOD		! LSLLIB error code
	INTEGER*4	RETCOD		! system error code
	LOGICAL		GOT_IT		! got FC in FC-layer table ?
	BYTE		CH		! character read
        CHARACTER*10	TMPSTR		! temp string
C
C External declaration
C
	INTEGER*4	PARCMD_CMD_TABLE
	EXTERNAL	PARCMD_CMD_TABLE
C
C Assume that everything goes well
C
	RDPAR = .TRUE.
C
C See if LSL$SIF2IFF_MAX_PATTERN is defined to set the maximum line pattern 
C number to be allowed.
	RESULT = TRNALL('LSL$SIF2IFF_MAX_PATTERN',TMPSTR)
        IF (RESULT.NE.SS$_NORMAL) THEN
	   IF (RESULT.NE.SS$_NOLOGNAM) THEN
	      GOTO 10
	   ELSE
	      MAX_PATTERN = MAX_LINE_PATTERN
	      IF (HAD_LOG) CALL LSL_PUTMSG(SIF2IFF__MAXPAT,MAX_PATTERN)
	   ENDIF
	ELSE
           I = SIGCHS(TMPSTR)
           READ(TMPSTR(1:I),'(I6)',ERR=10) MAX_PATTERN
	   IF (HAD_LOG) CALL LSL_PUTMSG(SIF2IFF__MAXPAT,MAX_PATTERN)
	ENDIF
	GOTO 11
C
10	CALL LSL_PUTMSG(SIF2IFF__NOPATLNM,'LSL$SIF2IFF_MAX_PATTERN')
	MAX_PATTERN = MAX_LINE_PATTERN
	IF (HAD_LOG) CALL LSL_PUTMSG(SIF2IFF__MAXPAT,MAX_PATTERN)
C
11	CONTINUE
C
C If the CCG qualifier is used dont try to read a parameter file.
C
	IF (HAD_CCG) THEN
	   IF (.NOT.READ_LUT()) GOTO 9999
	   GOTO 9000
	ENDIF
C
C Open our Parameter  file, read only
C
	ERRCOD = FLROPN(PARLUN,PARFIL,RETCOD)
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   CALL LSL_PUTMSG(SIF2IFF__ERROPNPAR,PARFIL(1:PARLEN))
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSOPEN) CALL LSL_ADDMSG(RETCOD)
	   GOTO 9999
C
C Otherwise let them know what we are doing if that's what they'd like
C
	ELSE
	   IF (HAD_LOG) CALL LSL_PUTMSG(SIF2IFF__READPAR)
	ENDIF
C
C Haven't got a line yet
C
	LINE = 0
C
C So let us read in the lines, one by one
C
500	LINE = LINE+1
C
	ERRCOD = FLRLIN(,,,RETCOD)
	IF (ERRCOD .EQ. LSL__EOF) GOTO 800
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   CALL LSL_PUTMSG(SIF2IFF__ERRRDPAR,PARFIL(1:PARLEN),LINE)
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSREAD) CALL LSL_ADDMSG(RETCOD)
	   GOTO 9999
	ENDIF
C
C Now reset the decoding pointer to the start of the line
C
	CALL BSLN
C
C Check for a comment delimiter - ignore an empty line
C
	IF ( RDCH( CH ) ) GOTO 500
	IF ( CH.EQ.PLING ) THEN
	   GOTO 500			! ignore line
	ELSE
	   CALL BSCH			! unread non-pling
	ENDIF
C
C Now, read the command from the line
C
	RESULT = RDCOMM(PARCMD_CMD_TABLE)
C
C and check that there was one
C
	IF (RESULT .LE. 0) GOTO 5555
C
C Despatch according to command
C
	GOTO (510,520) RESULT
C
C Unknown command
C
	CALL LSL_PUTMSG(SIF2IFF__UNKCMD,CMDNST)
	GOTO 5555
C
C Parameter file - feature description
C
510	IF ( .NOT. RDFDF() ) GOTO 5555
	GOTO 500
C
C Parameter file - pointsize specification
C
C Advance pointer to next position in POINTSIZE lookup arrays
520	NUM_PSIZE = NUM_PSIZE + 1
C
	IF ( INTARG(1).LT.1 .OR. INTARG(1).GT.MAX_PSIZE ) THEN
	   CALL LSL_PUTMSG(SIF2IFF__BADPSIZE,INTARG(1))
	   GOTO 5555
	ENDIF
C
	PSIZE_SIZE(NUM_PSIZE) = INTARG(1)
	PSIZE_HEIGHT(NUM_PSIZE) = INTARG(2)
	PSIZE_WIDTH(NUM_PSIZE) = INTARG(3)
C
	HAD_POINTSIZE = .TRUE.			! set pointsize flag
	GOTO 500
C
C Error decoding line
C
5555	CALL LSL_ADDMSG(SIF2IFF__LINEINPAR,LINE)
	LSL_STATUS = SIF2IFF__LINEINPAR		! reduce error status
	GOTO 500
C
C Close the file
C
800	ERRCOD = FLRCLO(PARLUN,RETCOD)
C
C If unsuccessful output message
C
	IF (.NOT. ERRCOD) THEN
	   CALL LSL_PUTMSG(SIF2IFF__ERRCLOPAR,PARFIL(1:PARLEN))
	   CALL LSL_ADDMSG(ERRCOD)
	   IF (ERRCOD .EQ. LSL__SYSCLOSE) CALL LSL_ADDMSG(RETCOD)
	   GOTO 9999
	ENDIF
	GOTO 9000
C
C Failure
C
9999	RDPAR = .FALSE.
C
C Return
C
9000	RETURN
	END
