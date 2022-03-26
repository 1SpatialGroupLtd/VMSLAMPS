	LOGICAL FUNCTION CREATE_FILES
C
CDEC$	IDENT	'08MR93'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	4-Nov-1990
C
C Description:
C
C	Module CREATE_FILES called by ARC2I in package CONVERT
C	Creates a temporay file which will hold a copy of the IFO section
C	from the EXPORT file so that it may be read in parallel with
C	the ARC section.
C	
C------------------------------------------------------------------------------
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'HERE:ARC2IMSG.PAR'		! ARC2I messages
	INCLUDE 'HERE:LUN.PAR'			! Logical units for file I/O
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE 'LSL$CMNLSL:TXTC.CMN'		! Text input
	INCLUDE	'HERE:FILES.CMN'		! ARC2I filenames
	INCLUDE	'HERE:GENERAL.CMN'		! General global variables
	INCLUDE	'HERE:COMMANDS.CMN'		! Command line results
	INCLUDE	'HERE:EXTENSIONS.CMN'		! Extensions in EXPORT file
C
C Functions
C
	INTEGER*4	GET_EXP_LINE		! Read EXPORT line into TXTBUF
	LOGICAL		GET_CP			! Get Corner Points
	LOGICAL		GET_FILENAME		! Get filename
	LOGICAL		REWIND_FILE		! Rewind tape or disk file
C
	LOGICAL		FLROPN			! Open a file read
	LOGICAL		FLRLIN			! Read a record
	LOGICAL		FLRCLO			! Close read file
	LOGICAL		FLRREW			! Rewind file
C
	LOGICAL		FLWOPN			! Open a file write
	LOGICAL		FLWLIN			! Write a record
	LOGICAL		FLWCLO			! Close write file
	LOGICAL		RDINT			! Read integer
C
C Local Variables
C
	INTEGER*4	STATUS			! Function return error status
	INTEGER*4	OK			! Call success status
	INTEGER*4	IERR			! System error status
	INTEGER*4	IND			! Position of index 
	LOGICAL		COPY_LINE		! Copy line to TMP file
	LOGICAL		GOT_CP			! Do we have Corner Points
	LOGICAL		FIRST_LINE		! At first line of EXPORT file
	LOGICAL		NODIG			! Failed to read integer
	INTEGER*2	WIDTYPE			! Single or double precision
	CHARACTER*32	LINE			! first 32 chars of EXPORT line	
C
	EQUIVALENCE(TXTBUF(1),LINE)
C
C------------------------------------------------------------------------------
C
C Assume success
C
	STATUS = .TRUE.
C
C Set up some flags
C
	LAST_BLOCK = .FALSE.		! We are not at the end of the file yet
	LAST_LINE  = .FALSE.
	FOUND_ARC  = .FALSE.
	FOUND_LAB  = .FALSE.
	FOUND_TXT  = .FALSE.
	FOUND_TX6  = .FALSE.
C
C Set MTBUFPTR to a larger value than MTBYTES to force the first block
C to be read in
C
	MTBLOCKS = 0
	MTBUFPTR = 1000000
	MTBYTES = 0
C
	IF ( MAGTAPE ) THEN
	   IF ( HAD_OUTPUT .AND. HAD_SELECT .AND. NUM_SEL.EQ.1 ) THEN
C
C Name was given on command  line
C
	   ELSE
C
C If no output filename given, then get filename from EXPORT file
C
	      OK = GET_FILENAME()
	      IF ( .NOT.OK ) THEN
	         STATUS = OK
	         GOTO 9000
	      ENDIF
	   ENDIF
C
C Again, set MTBUFPTR to a larger value than MTBYTES to force the first block
C to be read in
C
	   MTBLOCKS = 0
	   MTBUFPTR = 1000000
	   MTBYTES = 0
C
	ELSE
C
C Open disk EXPORT file for read
C
	   OK = FLROPN( EXPLUN,EXPFILE(1:EXPLEN) )
	   IF ( .NOT.OK ) THEN
	      STATUS = ARC2I__ERROPN
	      CALL LSL_PUTMSG( STATUS,EXPFILE(1:EXPLEN) )
	      CALL LSL_ADDMSG( OK )
	      GOTO 9000
	   ENDIF
	   CALL WRITEF('EXPORT file %S opened for read',EXPFILE(1:EXPLEN))
	ENDIF
C
C Open temporary disk file for write.
C
	OK = FLWOPN( TMPLUN,TMPFILE(1:TMPLEN) )
	IF ( .NOT.OK ) THEN
	   STATUS = ARC2I__ERROPN
	   CALL LSL_PUTMSG( STATUS,TMPFILE(1:TMPLEN) )
	   CALL LSL_ADDMSG( OK )
	   IF ( OK.EQ.LSL__SYSOPEN ) CALL LSL_ADDMSG( IERR )
	   GOTO 9000
	ENDIF
C
C Read EXPORT file and write IFO section to the temporary file.
C
	GOT_CP = .FALSE.		! haven't got CPs yet
	COPY_LINE = .FALSE.		! don't copy line until get 'IFO'
	LAST_LINE = .FALSE.
	FIRST_LINE = .TRUE.		! We are at the first line of file
C
C Read record into TXTBUF
C
200	OK = GET_EXP_LINE(.TRUE.)	! TRUE will suppress message on EOF
	IF ( .NOT.OK .OR. LAST_LINE ) THEN
	   STATUS = OK
	   GOTO 999
	ENDIF
	IF ( FIRST_LINE ) THEN
	   IF (LINE(1:3).NE.'EXP') THEN
	      STATUS = ARC2I__NOEXP
	      CALL LSL_PUTMSG( STATUS )
	      GOT_CP = .TRUE.		! prevent output of message ARC2I__NOCP
              GOTO 999
	   ENDIF
	   FIRST_LINE = .FALSE.
	ENDIF
C
	IF (LINE(1:3).EQ.'ARC') THEN
	   FOUND_ARC = .TRUE.
	   CALL SETWIN(4)
	   NODIG = RDINT(WIDTYPE)
	   IF (WIDTYPE.EQ.3) WIDEREALS = .TRUE.
	ENDIF
	IF (LINE(1:3).EQ.'LAB') THEN
	   FOUND_LAB = .TRUE.
	   CALL SETWIN(4)
	   NODIG = RDINT(WIDTYPE)
	   IF (WIDTYPE.EQ.3) WIDEREALS = .TRUE.
	ENDIF
	IF (LINE(1:3).EQ.'TXT') THEN
	   FOUND_TXT = .TRUE.
	   CALL SETWIN(4)
	   NODIG = RDINT(WIDTYPE)
	   IF (WIDTYPE.EQ.3) WIDEREALS = .TRUE.
	ENDIF
	IF (LINE(1:3).EQ.'TX6') THEN
	   FOUND_TX6 = .TRUE.
	   CALL SETWIN(4)
	   NODIG = RDINT(WIDTYPE)
	   IF (WIDTYPE.EQ.3) WIDEREALS = .TRUE.
	ENDIF
	IF (LINE(1:3).EQ.'IFO') COPY_LINE = .TRUE.
C
C Test for .BND section to get Corner Points
C
	IF ( .NOT.GOT_CP ) THEN
	   IND = INDEX(LINE(1:32),BND(1:4))
	   IF (IND.GT.0) THEN
	      GOT_CP = .TRUE.
	      OK = GET_CP()
	      IF ( .NOT.OK ) THEN
	         STATUS = OK
	         GOTO 999
	      ENDIF
	      GOTO 200
	   ENDIF
	ENDIF
C
C Copy line across once IFO section found.
C
	IF ( COPY_LINE ) THEN
	   OK = FLWLIN(TXTBUF,TXTPTR,IERR)
	   IF ( .NOT.OK ) THEN
	      STATUS = ARC2I__ERRWRT
	      CALL LSL_PUTMSG( STATUS,TMPFILE(1:TMPLEN) )
	      CALL LSL_ADDMSG( OK )
	      IF ( OK.EQ.LSL__SYSWRITE ) CALL LSL_ADDMSG( IERR )
	      GOTO 999
	   ENDIF
	ENDIF
C
C Get next line..
C
	GOTO 200
C
C Close temp file
C
999	OK = FLWCLO(TMPLUN,IERR)
	IF ( .NOT.OK ) THEN
	   STATUS = ARC2I__ERRCLO
	   CALL LSL_PUTMSG( STATUS, TMPFILE(1:TMPLEN) )
	   CALL LSL_ADDMSG( OK )
	   IF ( OK.EQ.LSL__SYSCLOSE ) CALL LSL_ADDMSG( IERR )
	ENDIF
C
C No longer include this because NOCP is now a warning NOT an error message
C
C Was the .TIC section present ?
C
C	IF ( .NOT.GOT_CP ) THEN
C	   STATUS = ARC2I__NOCP
C	   CALL LSL_PUTMSG( STATUS )
C	   GOTO 9000
C	ENDIF	
C
C If everything OK, rewind EXPORT file and open TMP file for read
C
	IF ( STATUS ) THEN
C
C Make sure the EXPORT did contain an IFO section
C
	   IF ( .NOT.COPY_LINE ) THEN
	      STATUS = ARC2I__NOIFO
	      CALL LSL_PUTMSG( STATUS,EXPFILE(1:EXPLEN) )
	      GOTO 9000
	   ENDIF
C
C Rewind file
C
	   OK = REWIND_FILE( EXPLUN )
	   IF ( .NOT.OK ) THEN
	      STATUS = OK
	      GOTO 9000
	   ENDIF
C
C Reopen temporary disk file but this time for read.
C
	   OK = FLROPN( TMPLUN,TMPFILE(1:TMPLEN) )
	   IF ( .NOT.OK ) THEN
	      STATUS = ARC2I__ERROPN
	      CALL LSL_PUTMSG( STATUS,TMPFILE(1:TMPLEN) )
	      CALL LSL_ADDMSG( OK )
	      IF ( OK.EQ.LSL__SYSOPEN ) CALL LSL_ADDMSG( IERR )
	      GOTO 9000
	   ENDIF
	ELSE
C
C Close EXPORT file due to an error
C
	   OK = FLRCLO(EXPLUN,IERR)
	   IF ( .NOT.OK ) THEN
	      STATUS = ARC2I__ERRCLO
	      CALL LSL_PUTMSG( STATUS,EXPFILE(1:EXPLEN) )
	      CALL LSL_ADDMSG( OK )
	      IF ( OK.EQ.LSL__SYSCLOSE ) CALL LSL_ADDMSG( IERR )
	      GOTO 9000 ! in case more code added, still jumps to end
	   ENDIF
	ENDIF
C
9000	CREATE_FILES = STATUS
C
	RETURN
	END
