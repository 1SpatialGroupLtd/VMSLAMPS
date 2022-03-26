	INTEGER*4 FUNCTION GET_EXP_LINE( NO_EOF_MSG )
C
CDEC$	IDENT	'09DE91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	7-Nov-1990
C
C Description:
C
C	Module GET_EXP_LINE called by ARC2I in package CONVERT
C	Reads a line from the EXPORT file (either from tape or disk) into TXTBUF
C	This is put into its own routine to save duplicating code
C	Routine will not fail if EOF read but set the global variable LAST_LINE
C	to true. An error message can be given if EOF was not expected or it may
C	be idsable with the fuinction parameter.
C
C	This routine returns TXTBUF containing a record of 80 bytes. If the
C	input file is on magtape then MTBUF will hold up to 65535 bytes. We
C	only read a new tape block when we have exhausted the contents of 
C	MTBUF. This is	so when the pointer equals the number of points read
C	(MTBUFPTR=MTBYTES).
C
C	In the case when the blocksize is not exactly divisible be 80, the last
C	record of a block will be incomplete and the rest will be found at the
C	start of the following block unless it is the last block in the file.
C	
C-------------------------------------------------------------------------------
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
	INCLUDE	'HERE:COMMANDS.CMN'		! Command line results
	INCLUDE	'HERE:GENERAL.CMN'		! General variables
C
C Arguments
C
	LOGICAL		NO_EOF_MSG		! No output of message on EOF
C
C Functions
C
	LOGICAL		READBLK			! Read tape block
	LOGICAL		FLRLIN			! Read a record
	LOGICAL		FLRSEL			! Select LUN
	LOGICAL		HAVE_I_AN_ARG		! Test if arg present
	LOGICAL		NO_MSG			! Output EOF message
C
C Local Variables
C
	INTEGER*4	STATUS			! Function return error status
	INTEGER*4	OK			! Call success status
	INTEGER*4	IERR			! System error status
	INTEGER*4	I			! Loop counter
	INTEGER*4	LENGTH,LEFTOVER		! For records that span blocks
C
C-------------------------------------------------------------------------------
C
	STATUS = .TRUE.
C
C Most of the time the function will be called with no argument. Therefore
C we need to check if it's missing and assign FALSE to NO_MSG
C
	NO_MSG = .FALSE.
	IF (HAVE_I_AN_ARG(1)) THEN
	   IF ( NO_EOF_MSG ) NO_MSG = .TRUE.
	ENDIF
C
	IF ( MAGTAPE ) THEN
C
C See if we need to read a new block
C
	   IF ( MTBUFPTR.GE.MTBYTES ) THEN
C
C get a new block from tape
C
	      OK = READBLK()
	      IF ( .NOT.OK ) THEN
	         STATUS = OK
	         GOTO 999
	      ENDIF
C
C Reset buffer pointer to start
C
	      MTBUFPTR = 0
C
	   ENDIF
C
C Copy next line of 80 bytes from MTBUF it into TXTBUF
C (MTBYTES need not be a multiple of 80)
C (MTBUFPTR points to the last character read from MTBUF)
C
	   LENGTH = 80
C
	   IF (MOD(MTBYTES,80).NE.0 .AND .MTBUFPTR+80.GT.MTBYTES) THEN
C
C Records span tape blocks. Read part of last line in a block and get rest
C from mext block (unless it is the end)
C
	      LENGTH = MTBYTES - MTBUFPTR
	      DO 100 I = 1,LENGTH
	         TXTBUF(I) = MTBUF(I+MTBUFPTR)
100	      CONTINUE
	      MTBUFPTR = MTBUFPTR + LENGTH
	      IF ( MTBUFPTR.GE.MTBYTES .AND. LAST_BLOCK ) THEN
	         LAST_LINE = .TRUE.
		 GOTO 999
	      ENDIF
C
C get a new block from tape
C
	      OK = READBLK()
	      IF ( .NOT.OK ) THEN
	         STATUS = OK
	         GOTO 999
	      ENDIF
C
C Reset buffer pointer to start
C
	      MTBUFPTR = 0
	      LEFTOVER = 80 - LENGTH
	      DO 200 I = 1,LEFTOVER
	         TXTBUF(LENGTH+I) = MTBUF(I+MTBUFPTR)
200	      CONTINUE
	      TXTPTR = 80
	      MTBUFPTR = MTBUFPTR + LEFTOVER
	      IF ( MTBUFPTR.GE.MTBYTES .AND. LAST_BLOCK ) THEN
		 LAST_LINE = .TRUE.
	      ENDIF
C
	   ELSE
C
	      DO 300 I = 1,LENGTH
	         TXTBUF(I) = MTBUF(I+MTBUFPTR)
300	      CONTINUE
	      TXTPTR = LENGTH
	      MTBUFPTR = MTBUFPTR + LENGTH
	      IF ( MTBUFPTR.GE.MTBYTES .AND. LAST_BLOCK ) THEN
	         LAST_LINE = .TRUE.
	      ENDIF
	   ENDIF
C
	ELSE
C
C Get line from disk file
C
	   CALL FLRSEL(EXPLUN)
C
	   OK = FLRLIN(,,,IERR)
	   IF ( .NOT.OK ) THEN
	      IF ( OK.EQ.LSL__EOF ) THEN
	         IF ( .NOT.NO_MSG ) CALL LSL_PUTMSG( ARC2I__UNEXPEOF )
	         LAST_LINE = .TRUE.
	         OK = LSL__NORMAL
	      ELSE
	         CALL LSL_PUTMSG( ARC2I__RDLNEXP )
	         CALL LSL_ADDMSG( OK )
	         IF ( OK.EQ.LSL__SYSREAD ) CALL LSL_ADDMSG( IERR )
	      ENDIF
	      STATUS = OK
	   ENDIF
	   CALL BSLN
	ENDIF
C
999	GET_EXP_LINE = STATUS
C
	RETURN
	END
