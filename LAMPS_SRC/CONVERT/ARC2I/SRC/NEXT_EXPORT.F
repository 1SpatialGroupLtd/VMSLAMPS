	LOGICAL FUNCTION NEXT_EXPORT
C
CDEC$	IDENT	'28JA91'
C
C
C	Copyright               Laser-Scan Ltd., Cambridge, England.
C
C	Created					ST	20-Dec-1990
C
C Description:
C
C	Module NEXT_EXPORT called by ARC2I in package CONVERT
C	Called to skip or find the next EXPORT file on tape
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
	INCLUDE	'LSL$CMNLSL:CLD.CMN'		! DCL command interpretation
	INCLUDE	'LSL$CMNLSL:FILENAME.CMN'	! LSLLIB filenames
	INCLUDE	'LSL$CMNLSL:MTIVCM.CMN'		! Magtape input
	INCLUDE	'HERE:FILES.CMN'		! ARC2I filenames
	INCLUDE	'HERE:GENERAL.CMN'		! General variables
	INCLUDE	'HERE:COMMANDS.CMN'		! Command line results
C
C Functions
C
	LOGICAL		MTIEOV			! Find end-of-volume
	LOGICAL		MTIBCK			! Space back 1 block
	LOGICAL		MTIRDB			! Read block
C
C Local variables
C
	INTEGER*4	STATUS			! Return status
	INTEGER*4	ERROR			! System error status
	INTEGER*4	OK			! success of a call
C
C-------------------------------------------------------------------------------
C
	EXPBEGIN = .FALSE.
	STATUS = .TRUE.
C
C MTIRDB returns an error when EOF is read but this is OK
C
	IF ( LAST_LINE ) THEN
	   EXPBEGIN = .TRUE.
	ELSE
!	   IF ( HAD_LOG ) CALL WRITEF('Looking for next EXPORT file.')
100	   STATUS = MTIRDB(MTBUF,BLKSIZ,MTBYTES)
C
	   IF ( .NOT.STATUS ) THEN
C
	      IF ( STATUS .EQ. LSL__EOF ) THEN
	         STATUS = LSL__NORMAL
C
!	         IF ( HAD_LOG ) THEN
!	            CALL WRITEF('Tapemark read.')
!	         ENDIF
C
	         STATUS = MTIRDB(MTBUF,BLKSIZ,MTBYTES)
	         IF ( STATUS ) THEN
C
C Read was successful so another file exists on tape. Therefore backspace.
C
	            STATUS = MTIBCK()
	            IF ( .NOT.STATUS ) THEN
	               CALL LSL_ADDMSG( STATUS )
	               IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	               GOTO 999
	            ENDIF
	            EXPBEGIN = .TRUE.
	            GOTO 999		! successfully located head at next file
	         ELSE
	            IF ( STATUS.EQ.LSL__EOF ) THEN
	               CALL WRITEF('End of Tape.')
	               STATUS = ARC2I__NOFILES
	               GOTO 999
	            ELSE
	               CALL LSL_ADDMSG( STATUS )
	               IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	               GOTO 999
	            ENDIF
	         ENDIF
C	      ELSE
	         CALL LSL_ADDMSG( STATUS )
	         IF ( STATUS .EQ. LSL__SYSERR ) CALL LSL_ADDMSG( MTIERR )
	         GOTO 999	
	      ENDIF
	   ELSE
	       GOTO 100				! get next block
	   ENDIF
	ENDIF
C
999	CONTINUE
	NEXT_EXPORT = STATUS
C
	RETURN
	END
