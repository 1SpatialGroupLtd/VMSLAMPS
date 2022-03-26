	LOGICAL FUNCTION READ_FILE(FILETYPE)
C
CDEC$	IDENT	'13AP92'
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created 				ST	9-June-1992
C
C Description:
C
C	Function to read feature/attribute code file with the input
C       variable determining which.
C
C       if FILETYPE is .TRUE. we are reading the Feature Code file
C       if FILETYPE is .FALSE. we are reading the Attribute Code file
C
C	Function returns .TRUE. if all is well, .FALSE. if an error
C
	IMPLICIT NONE
C
C Argument
C
	LOGICAL FILETYPE
C
C Parameters
C
	INCLUDE 'DCW2IMSG.PAR'
	INCLUDE 'LSL$CMNLSL:READSTR.PAR'
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'
C
C Common blocks
C
	INCLUDE 'GENERAL.CMN'
	INCLUDE 'SELECTIONS.CMN'
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'
C
C Functions
C
	LOGICAL		FILE_EXISTS	! check if device is valid
	LOGICAL		READ_FC_LINE	! read line from fc file
	LOGICAL		READ_AC_LINE	! read line from ac file
	LOGICAL		SHOW_FC_INFO	! show the fc data
	LOGICAL		SHOW_AC_INFO	! show the ac data
	LOGICAL		GETFILNAM	! read file-spec
	INTEGER*4	LIB$GET_LUN	! get LUN for IFF file
	INTEGER*4	FLROPN		! open file for reading
	INTEGER*4	FLRCLO		! close file for reading
	INTEGER*4	FLRLIN		! read in line from file
	LOGICAL		RDCHS		! read next character
C
C Local workspace
C
	BYTE		PLING		! comment delimiter
	PARAMETER	(PLING = '!')
	INTEGER*4	LINE
	INTEGER*4	I	     	! loopy
	INTEGER*4	ERRCOD		! LSLLIB error code
	INTEGER*4	RETCOD		! system error code
	BYTE		CH		! character read
	CHARACTER*255	DEFNAM
	CHARACTER*255	INFILE
	INTEGER*4	INLUN
	INTEGER*4	INFILELEN
	LOGICAL*4	OK
C
C ......................................................................
C
	READ_FILE =.TRUE.		! assume success
C
	DEFNAM=' '
	OK = GETFILNAM(INFILE,INFILELEN,DEFNAM(1:1),.TRUE.,%REF(' !'))
C
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(OK)
	   CALL WRITEF
	   GOTO 999
	ENDIF
C
C Check for zero length filename
C	   
	IF (INFILELEN.LT.1) THEN
	   READ_FILE = .FALSE.
	   CALL LSL_PUTMSG(LSL__SRCFILNAM)
	   CALL WRITEF
	   GOTO 999
	ENDIF
C
C Upper case the actual device
C
	CALL STR$UPCASE(INFILE,INFILE)
C
C Check if it exists
C
	IF (.NOT.FILE_EXISTS(INFILE(1:INFILELEN))) THEN
	   CALL LSL_PUTMSG(DCW2I__NOSUCHFILE,INFILE(1:INFILELEN))
	   CALL WRITEF
	   GOTO 999
	ENDIF
C
C Get free LUN
C
	OK = LIB$GET_LUN(INLUN)
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(DCW2I__NOFREELUN)
	   GOTO 999
	ENDIF
C
C Open the file
C

	OK = FLROPN(INLUN,INFILE)
	IF (.NOT.OK) THEN
	   CALL LSL_PUTMSG(DCW2I__CANTOPEN,INFILE(1:INFILELEN))
	   CALL LSL_ADDMSG(OK)
	   CALL WRITEF
	   GOTO 999
	ENDIF
C
	CALL WRITEF ('Reading file : %S',INFILE(1:INFILELEN))
	CALL WRITEF
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
	   IF (FILETYPE) THEN
	      CALL LSL_PUTMSG(DCW2I__ERRINFILE,'Feature Code',LINE)
	   ELSE
	      CALL LSL_PUTMSG(DCW2I__ERRINFILE,'Attribute Code',LINE)
	   ENDIF
	   CALL LSL_ADDMSG(ERRCOD)
	   CALL WRITEF
	   GOTO 999
	ENDIF
C
C Now reset the decoding pointer to the start of the line
C
	CALL BSLN
C
C Check for a comment delimiter - ignore an empty line
C
	IF ( RDCHS( CH ) ) GOTO 500
	IF ( CH.EQ.PLING ) THEN
	   GOTO 500			! ignore line
	ELSE
	   CALL BSCH			! unread non-pling
	ENDIF
C
C Ignore anything beyond a comment within a line 
C
	DO 510 I = 1,TXTPTR
	   IF (TXTBUF(I).EQ.PLING) THEN
	      TXTPTR = I-1	 ! I cannot be 1 due to CALL BSCH above
	      GOTO 520
	   ENDIF
510	CONTINUE
C
C Now, read the info from the line
C
520	IF (FILETYPE) THEN
	   IF (.NOT.READ_FC_LINE(LINE)) GOTO 500
	ELSE
	   IF (.NOT.READ_AC_LINE(LINE)) GOTO 500
	ENDIF
C
C Get next line 
C
	GOTO 500
C
800	CALL FLRCLO(INLUN)
C
C For debugging...
C
C	IF (FILETYPE) THEN
C	   OK = SHOW_FC_INFO()
C	ELSE
C	   OK = SHOW_AC_INFO()
C	ENDIF
C
C ......................................................................
C
999	IF (FILETYPE) HAD_FCT = READ_FILE
	RETURN
	END
