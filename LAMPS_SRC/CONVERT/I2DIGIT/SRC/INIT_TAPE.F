	LOGICAL FUNCTION INIT_TAPE
C
CDEC$	IDENT	'06DE91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	6-Dec-1991
C
C Description:
C
C	Module INIT_TAPE called by I2DIGIT in package CONVERT
C	Initialised tape device specified as input filename
C	
C-----------------------------------------------------------------------------
C
        IMPLICIT NONE
C
C Messages and parameters
C
	INCLUDE	'LSL$CMNLSL:LSLLIBMSG.PAR'	! LSLLIB messages
	INCLUDE	'I2DIGITMSG.PAR'		! I2DIGIT messages
C
C Common blocks
C
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE 'LSL$CMNLSL:MTOVCM.CMN'		! Magtape input
	INCLUDE	'FILES.CMN'			! I2DIGIT filenames
	INCLUDE	'COMMANDS.CMN'			! Command line results
	INCLUDE	'GENERAL.CMN'			! General variables
C
C Functions
C
	LOGICAL*4	MTONIT			! Initialise a tape for write
	LOGICAL*4	MTOEOV			! Find end of volume
	LOGICAL*4	TEST_FOREIGN		! Test if file is magtape
C
C Local Variables
C
	INTEGER*4	STATUS			! Return error status
	INTEGER*4	ERROR			! System error status
	LOGICAL*4	FOREIGN			! True if file is MOUNT/FOREIGN
C
C------------------------------------------------------------------------------
C
	STATUS = TEST_FOREIGN( DEVICENAME,FOREIGN,ERROR )
C
	IF ( STATUS .EQ. LSL__NORMAL .AND. FOREIGN ) THEN
C
C Initialise tape
C
	   IF (HAD_LOG) THEN
	      CALL WRITEF('Initialising tape %S for write - Please wait.',
     &		       DEVICENAME(1:DEVICELEN))
	   ENDIF
C
	   STATUS = MTONIT( DEVICENAME(1:DEVICELEN),,.FALSE., )
	   IF ( .NOT.STATUS ) THEN
	      CALL LSL_PUTMSG(I2DIGIT__ERRINITTAPE,DEVICENAME(1:DEVICELEN))
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	      GOTO 999
	   ENDIF	
C
C If appending to a tape, place tape head between two tape marks
C
	   IF (HAD_APPEND) THEN
	      IF (HAD_LOG) CALL WRITEF('Searching for end of tape mark...')
	      STATUS = MTOEOV()
	      IF (.NOT.STATUS ) THEN
		 CALL LSL_PUTMSG(I2DIGIT__NOEOV)
		 IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
		 GOTO 999
	      ENDIF
	   ENDIF
C
	ELSEIF ( STATUS .EQ. LSL__NORMAL .AND. .NOT.FOREIGN ) THEN
	   IF ( DEVICENAME(1:1) .EQ. 'M' .OR. DEVICENAME(1:1) .EQ. 'm' ) THEN
	      CALL LSL_PUTMSG(I2DIGIT__NOTMNTFOR,DEVICENAME(1:DEVICELEN) )
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	      STATUS = .FALSE.
	      GOTO 999
	   ELSE
C
C Some other error
C
	      STATUS = .FALSE.
	      CALL LSL_PUTMSG(I2DIGIT__ERRINITTAPE,DEVICENAME(1:DEVICELEN))
	      IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTOERR )
	      GOTO 999
	   ENDIF
C
	ELSEIF ( .NOT.STATUS ) THEN
	   CALL LSL_PUTMSG(I2DIGIT__ERRINITTAPE,DEVICENAME(1:DEVICELEN))
	   GOTO 999
	ENDIF
C
999	CONTINUE
	INIT_TAPE = STATUS
C
	RETURN
	END
